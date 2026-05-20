package com.entilitystudio.android_background_clipboard

import android.content.ClipData as AndroidClipData
import android.content.ClipboardManager
import android.content.Context
import android.net.nsd.NsdManager
import android.net.nsd.NsdServiceInfo
import android.util.Log
import androidx.core.content.FileProvider
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import org.json.JSONObject
import java.io.File
import java.io.IOException
import java.net.InetAddress
import java.net.ServerSocket
import java.net.Socket
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.TimeUnit
import javax.crypto.Mac
import javax.crypto.spec.SecretKeySpec

/** Payload delivered to the host when a LAN clip is received and should be persisted. */
data class LanClipPayload(
    val originId: String,
    val fromDeviceId: String,
    val type: ClipType,
    val content: String,
    val label: String,
    val timestamp: Long,
    val encrypted: Boolean,
    val iv: String?,
    val encMode: String?,
)

private data class PeerAddress(val host: String, val port: Int)

/**
 * Lightweight LAN clipboard sync for Android.
 *
 * – Runs a bare [ServerSocket] on a daemon thread (zero CPU when idle).
 * – Registers and discovers `_copycat._tcp` via [NsdManager].
 * – Authenticates with HMAC-SHA256(body + timestamp, userId).
 * – Text/URL clips → [onLanClipReceived] for persistent storage.
 * – Media/file clips (when auto-write is enabled) → written to cacheDir and
 *   placed directly on the Android clipboard via [ClipboardManager].
 */
class CopyCatLanSyncManager(
    private val appContext: Context,
    private val onLanClipReceived: (LanClipPayload) -> Unit,
    private val markCaptured: (String) -> Unit,
) {
    companion object {
        private const val SERVICE_TYPE = "_copycat._tcp."
        private const val LOG_TAG = "CopyCatLanSyncManager"
        private const val REPLAY_WINDOW_MS = 10_000L
        private const val HMAC_ALGO = "HmacSHA256"
        private const val LAN_RECV_DIR = "lan_recv"
    }

    // ── mutable config (set by CopyCatSharedStorage before start()) ──────────
    var lanSyncEnabled: Boolean = false
    var deviceId: String = ""
    var userId: String = ""
    /** When true, received binary clips are written to the Android clipboard. */
    var autoWrite: Boolean = false

    // ── runtime state ─────────────────────────────────────────────────────────
    private var serverSocket: ServerSocket? = null
    private var serverThread: Thread? = null
    private var serverPort: Int = 0
    private var nsdManager: NsdManager? = null
    private var registrationListener: NsdManager.RegistrationListener? = null
    private var discoveryListener: NsdManager.DiscoveryListener? = null
    private val peers = ConcurrentHashMap<String, PeerAddress>() // key = deviceId
    private var started = false

    private val httpClient = OkHttpClient.Builder()
        .connectTimeout(3, TimeUnit.SECONDS)
        .readTimeout(5, TimeUnit.SECONDS)
        .writeTimeout(5, TimeUnit.SECONDS)
        .build()

    // ── lifecycle ─────────────────────────────────────────────────────────────

    fun start() {
        if (started || !lanSyncEnabled) return
        started = true
        startServer()
        registerNsd()
        discoverPeers()
        Log.i(LOG_TAG, "LAN sync started on port $serverPort")
    }

    fun stop() {
        if (!started) return
        started = false
        stopDiscovery()
        unregisterNsd()
        serverThread?.interrupt()
        serverSocket?.close()
        serverSocket = null
        peers.clear()
        Log.i(LOG_TAG, "LAN sync stopped")
    }

    fun reconfigure() {
        if (lanSyncEnabled && !started) {
            start()
        } else if (!lanSyncEnabled && started) {
            stop()
        }
    }

    // ── HTTP server ───────────────────────────────────────────────────────────

    private fun startServer() {
        val ss = ServerSocket(0) // OS assigns an ephemeral port
        serverSocket = ss
        serverPort = ss.localPort

        serverThread = Thread({
            Log.d(LOG_TAG, "Server listening on port $serverPort")
            while (!Thread.currentThread().isInterrupted) {
                val clientSocket: Socket = try {
                    ss.accept()
                } catch (_: IOException) {
                    break // socket closed → stop
                }
                Thread({ handleConnection(clientSocket) }, "lan-recv-worker").also {
                    it.isDaemon = true
                    it.start()
                }
            }
            Log.d(LOG_TAG, "Server thread exiting")
        }, "lan-server").also {
            it.isDaemon = true
            it.start()
        }
    }

    private fun handleConnection(socket: Socket) {
        try {
            socket.use { s ->
                val input = s.getInputStream().bufferedReader()
                // Minimal HTTP/1.1 request parsing
                val requestLine = input.readLine() ?: return
                if (!requestLine.startsWith("POST /clip")) return

                val headers = mutableMapOf<String, String>()
                while (true) {
                    val line = input.readLine() ?: break
                    if (line.isEmpty()) break
                    val colon = line.indexOf(':')
                    if (colon > 0) {
                        headers[line.substring(0, colon).trim().lowercase()] =
                            line.substring(colon + 1).trim()
                    }
                }

                val fromDeviceId = headers["x-cc-did"] ?: return
                if (fromDeviceId == deviceId) return // don't receive own broadcasts

                val originId = headers["x-cc-oid"] ?: return
                val typeStr = headers["x-cc-type"] ?: return
                val hmacHeader = headers["x-cc-hmac"] ?: return
                val contentLength = headers["content-length"]?.toIntOrNull() ?: return

                val bodyBytes = ByteArray(contentLength)
                var offset = 0
                val rawStream = s.getInputStream()
                while (offset < contentLength) {
                    val read = rawStream.read(bodyBytes, offset, contentLength - offset)
                    if (read == -1) break
                    offset += read
                }

                if (!verifyHmac(bodyBytes, hmacHeader)) {
                    Log.w(LOG_TAG, "HMAC verification failed from $fromDeviceId")
                    return
                }

                val clipType = try {
                    ClipType.valueOf(typeStr.uppercase())
                } catch (_: IllegalArgumentException) {
                    Log.w(LOG_TAG, "Unknown clip type: $typeStr")
                    return
                }

                when (clipType) {
                    ClipType.text, ClipType.url -> handleTextClip(
                        bodyBytes, fromDeviceId, originId, clipType
                    )
                    ClipType.media, ClipType.file -> handleBinaryClip(
                        bodyBytes, fromDeviceId, originId, clipType,
                        headers["content-type"] ?: "application/octet-stream",
                        headers["x-cc-ext"] ?: "bin",
                        headers["x-cc-name"] ?: originId,
                    )
                }

                // Send minimal HTTP 200 response
                s.getOutputStream().write("HTTP/1.1 200 OK\r\nContent-Length: 0\r\n\r\n".toByteArray())
            }
        } catch (e: Exception) {
            Log.e(LOG_TAG, "Error handling connection: ${e.message}")
        }
    }

    private fun handleTextClip(
        body: ByteArray,
        fromDeviceId: String,
        originId: String,
        type: ClipType,
    ) {
        val json = try {
            JSONObject(String(body, Charsets.UTF_8))
        } catch (e: Exception) {
            Log.w(LOG_TAG, "Malformed JSON text clip: ${e.message}")
            return
        }

        val timestamp = json.optLong("ts", System.currentTimeMillis())
        if (System.currentTimeMillis() - timestamp > REPLAY_WINDOW_MS) {
            Log.w(LOG_TAG, "Replay detected, dropping clip from $fromDeviceId")
            return
        }

        val payload = LanClipPayload(
            originId = originId,
            fromDeviceId = fromDeviceId,
            type = type,
            content = json.optString("content", ""),
            label = json.optString("label", ""),
            timestamp = timestamp,
            encrypted = json.optBoolean("encrypted", false),
            iv = json.optString("iv").takeIf { it.isNotEmpty() },
            encMode = json.optString("encMode").takeIf { it.isNotEmpty() },
        )

        onLanClipReceived(payload)

        if (autoWrite && payload.content.isNotBlank()) {
            writeTextToClipboard(payload.content, payload.label)
        }
    }

    private fun handleBinaryClip(
        body: ByteArray,
        fromDeviceId: String,
        originId: String,
        type: ClipType,
        mimeType: String,
        ext: String,
        fileName: String,
    ) {
        if (!autoWrite) return // binary clips only written to clipboard when auto-write is on

        try {
            val recvDir = File(appContext.cacheDir, LAN_RECV_DIR).also { it.mkdirs() }
            val tempFile = File(recvDir, "$originId.$ext")
            tempFile.writeBytes(body)

            val uri = FileProvider.getUriForFile(
                appContext,
                "${appContext.packageName}.fileprovider",
                tempFile,
            )

            val clipData = AndroidClipData.newUri(appContext.contentResolver, fileName, uri)
            val cm = appContext.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager

            // Suppress re-capture of this write
            markCaptured(originId)
            cm.setPrimaryClip(clipData)
            Log.d(LOG_TAG, "Binary clip ($mimeType) written to clipboard from $fromDeviceId")
        } catch (e: Exception) {
            Log.e(LOG_TAG, "Failed to write binary clip: ${e.message}")
        }
    }

    private fun writeTextToClipboard(text: String, label: String) {
        try {
            val cm = appContext.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
            val clip = AndroidClipData.newPlainText(label.ifBlank { "CopyCat" }, text)
            cm.setPrimaryClip(clip)
        } catch (e: Exception) {
            Log.e(LOG_TAG, "Failed to write text to clipboard: ${e.message}")
        }
    }

    // ── NSD registration ──────────────────────────────────────────────────────

    private fun registerNsd() {
        val nsd = appContext.getSystemService(Context.NSD_SERVICE) as NsdManager
        nsdManager = nsd

        val info = NsdServiceInfo().apply {
            serviceName = "copycat-$deviceId"
            serviceType = SERVICE_TYPE
            port = serverPort
            setAttribute("did", deviceId)
        }

        val listener = object : NsdManager.RegistrationListener {
            override fun onServiceRegistered(info: NsdServiceInfo) {
                Log.d(LOG_TAG, "NSD registered: ${info.serviceName} port=$serverPort")
            }
            override fun onRegistrationFailed(info: NsdServiceInfo, errorCode: Int) {
                Log.w(LOG_TAG, "NSD registration failed: $errorCode")
            }
            override fun onServiceUnregistered(info: NsdServiceInfo) {
                Log.d(LOG_TAG, "NSD unregistered")
            }
            override fun onUnregistrationFailed(info: NsdServiceInfo, errorCode: Int) {
                Log.w(LOG_TAG, "NSD unregistration failed: $errorCode")
            }
        }
        registrationListener = listener
        nsd.registerService(info, NsdManager.PROTOCOL_DNS_SD, listener)
    }

    private fun unregisterNsd() {
        try {
            registrationListener?.let { nsdManager?.unregisterService(it) }
        } catch (_: Exception) {}
        registrationListener = null
    }

    // ── NSD discovery ─────────────────────────────────────────────────────────

    private fun discoverPeers() {
        val nsd = nsdManager ?: return
        val listener = object : NsdManager.DiscoveryListener {
            override fun onDiscoveryStarted(serviceType: String) {
                Log.d(LOG_TAG, "NSD discovery started")
            }
            override fun onDiscoveryStopped(serviceType: String) {
                Log.d(LOG_TAG, "NSD discovery stopped")
            }
            override fun onStartDiscoveryFailed(serviceType: String, errorCode: Int) {
                Log.w(LOG_TAG, "NSD discovery start failed: $errorCode")
            }
            override fun onStopDiscoveryFailed(serviceType: String, errorCode: Int) {
                Log.w(LOG_TAG, "NSD discovery stop failed: $errorCode")
            }
            override fun onServiceFound(info: NsdServiceInfo) {
                if (info.serviceType != SERVICE_TYPE) return
                // Resolve to get host + port
                nsd.resolveService(info, makeResolveListener())
            }
            override fun onServiceLost(info: NsdServiceInfo) {
                // Remove by service name — we track by deviceId from the TXT record
                val key = peers.entries.firstOrNull { it.key == peerKeyFromServiceName(info.serviceName) }?.key
                if (key != null) {
                    peers.remove(key)
                    Log.d(LOG_TAG, "Peer lost: $key")
                }
            }
        }
        discoveryListener = listener
        nsd.discoverServices(SERVICE_TYPE, NsdManager.PROTOCOL_DNS_SD, listener)
    }

    private fun stopDiscovery() {
        try {
            discoveryListener?.let { nsdManager?.stopServiceDiscovery(it) }
        } catch (_: Exception) {}
        discoveryListener = null
    }

    private fun makeResolveListener(): NsdManager.ResolveListener =
        object : NsdManager.ResolveListener {
            override fun onResolveFailed(info: NsdServiceInfo, errorCode: Int) {
                Log.w(LOG_TAG, "NSD resolve failed: $errorCode for ${info.serviceName}")
            }
            override fun onServiceResolved(info: NsdServiceInfo) {
                val did = peerKeyFromServiceName(info.serviceName)
                if (did == deviceId) return // self
                val host = info.host?.hostAddress ?: return
                peers[did] = PeerAddress(host, info.port)
                Log.d(LOG_TAG, "Peer resolved: $did @ $host:${info.port}")
            }
        }

    private fun peerKeyFromServiceName(name: String): String =
        name.removePrefix("copycat-")

    // ── sending ───────────────────────────────────────────────────────────────

    /**
     * Broadcast a text/URL clip to all discovered peers.
     * Called from the clipboard-capture pipeline (background thread is fine).
     */
    fun broadcastTextClip(
        originId: String,
        type: ClipType,
        content: String,
        label: String,
        encrypted: Boolean = false,
        iv: String? = null,
        encMode: String? = null,
    ) {
        if (!started || peers.isEmpty()) return

        val timestamp = System.currentTimeMillis()
        val bodyJson = JSONObject().apply {
            put("content", content)
            put("label", label)
            put("ts", timestamp)
            put("encrypted", encrypted)
            if (iv != null) put("iv", iv)
            if (encMode != null) put("encMode", encMode)
        }
        val bodyBytes = bodyJson.toString().toByteArray(Charsets.UTF_8)
        val hmac = computeHmac(bodyBytes)

        peers.values.forEach { peer ->
            sendToPeer(peer, originId, type.name.lowercase(), bodyBytes, hmac,
                "application/json", null, null)
        }
    }

    /**
     * Broadcast a binary clip (media/file) to all discovered peers.
     */
    fun broadcastBinaryClip(
        originId: String,
        type: ClipType,
        data: ByteArray,
        mimeType: String,
        ext: String,
        fileName: String,
    ) {
        if (!started || peers.isEmpty()) return
        val hmac = computeHmac(data)
        peers.values.forEach { peer ->
            sendToPeer(peer, originId, type.name.lowercase(), data, hmac, mimeType, ext, fileName)
        }
    }

    private fun sendToPeer(
        peer: PeerAddress,
        originId: String,
        typeStr: String,
        body: ByteArray,
        hmac: String,
        contentType: String,
        ext: String?,
        fileName: String?,
    ) {
        try {
            val requestBuilder = Request.Builder()
                .url("http://${peer.host}:${peer.port}/clip")
                .addHeader("X-CC-DID", deviceId)
                .addHeader("X-CC-OID", originId)
                .addHeader("X-CC-TYPE", typeStr)
                .addHeader("X-CC-HMAC", hmac)
            if (ext != null) requestBuilder.addHeader("X-CC-EXT", ext)
            if (fileName != null) requestBuilder.addHeader("X-CC-NAME", fileName)

            val request = requestBuilder
                .post(body.toRequestBody(contentType.toMediaTypeOrNull()))
                .build()

            httpClient.newCall(request).execute().use { response ->
                if (!response.isSuccessful) {
                    Log.w(LOG_TAG, "Peer ${peer.host}:${peer.port} returned ${response.code}")
                }
            }
        } catch (e: Exception) {
            Log.d(LOG_TAG, "Could not reach peer ${peer.host}:${peer.port}: ${e.message}")
        }
    }

    // ── auth ──────────────────────────────────────────────────────────────────

    private fun computeHmac(body: ByteArray): String {
        val key = userId.toByteArray(Charsets.UTF_8)
        val mac = Mac.getInstance(HMAC_ALGO)
        mac.init(SecretKeySpec(key, HMAC_ALGO))
        val digest = mac.doFinal(body)
        return digest.joinToString("") { "%02x".format(it) }
    }

    private fun verifyHmac(body: ByteArray, expected: String): Boolean {
        if (userId.isBlank()) return false
        return computeHmac(body) == expected
    }
}
