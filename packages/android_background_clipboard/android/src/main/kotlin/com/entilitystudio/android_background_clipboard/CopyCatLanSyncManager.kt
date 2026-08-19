package com.entilitystudio.android_background_clipboard

import android.content.BroadcastReceiver
import android.content.ClipData as AndroidClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.os.PowerManager
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
import java.io.FileOutputStream
import java.io.IOException
import java.net.InetAddress
import java.net.ServerSocket
import java.net.Socket
import java.text.SimpleDateFormat
import java.util.concurrent.ArrayBlockingQueue
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.Executors
import java.util.concurrent.RejectedExecutionException
import java.util.concurrent.RejectedExecutionHandler
import java.util.Date
import java.util.Locale
import java.util.concurrent.TimeUnit
import java.util.concurrent.ThreadPoolExecutor
import java.util.TimeZone
import java.time.Instant
import java.security.MessageDigest
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
    val userId: String? = null,
    val serverId: Long? = null,
    // File / media fields — null for text/url clips.
    val localFilePath: String? = null,
    val fileMimeType: String? = null,
    val fileExtension: String? = null,
    val fileName: String? = null,
    val sourceId: String? = null,
    val sourceApp: String? = null,
    val deleted: Boolean = false,
    val deletedAtMs: Long? = null,
)

private data class PeerAddress(val host: String, val port: Int)

/**
 * CopyCat LAN sync for Android.
 *
 * – Runs a bare [ServerSocket] on a daemon thread.
 * – Registers and discovers `_copycat._tcp` via [NsdManager].
 * – Authenticates with HMAC-SHA256(body + timestamp, userId).
 * – Text/URL clips -> [onLanClipReceived] for persistent storage.
 * – Media/file clips (when auto-write is enabled) -> written to cacheDir and
 *   placed directly on the Android clipboard via [ClipboardManager].
 */
class CopyCatLanSyncManager(
    private val appContext: Context,
    private val onLanClipReceived: (LanClipPayload) -> Unit,
    private val markCaptured: (String) -> Unit,
    private val onBeforeClipboardWrite: () -> Unit = {},
    private val decryptContent: ((content: String, encMode: String?, iv: String?) -> String?)? = null,
) {
    companion object {
        private const val LOG_TAG = "CopyCatLanSyncManager"
        private const val REPLAY_WINDOW_MS = 10_000L
        private const val MAX_HEADER_LINE_BYTES = 8 * 1024
        private const val MAX_BODY_BYTES = 100 * 1024 * 1024
        private const val MAX_TEXT_BODY_BYTES = 512 * 1024
        private const val HMAC_ALGO = "HmacSHA256"
        private const val LAN_RECV_DIR = "lan_recv"
        private const val STREAM_BUFFER_BYTES = 64 * 1024
        private const val DISCOVERY_REFRESH_EMPTY_MS = 15_000L
        private const val DISCOVERY_REFRESH_STABLE_MS = 60_000L
        private const val DISCOVERY_POST_REGISTER_DELAY_MS = 1_200L
    }

    private val serviceType: String
        get() {
            if (userId.isEmpty()) return "_copycat._tcp."
            val hash = MessageDigest.getInstance("SHA-256").digest(userId.toByteArray(Charsets.UTF_8))
            val fp = hash.joinToString("") { "%02x".format(it) }.substring(0, 8)
            return "_cc-$fp._tcp."
        }

    // MARK: - Mutable Config
    var lanSyncEnabled: Boolean = false
    var deviceId: String = ""
    var userId: String = ""
    var autoWriteOnReceive: Boolean = false
    var maxAutoCopyBytes: Int = 10 * 1024 * 1024

    // MARK: - Runtime State
    private var serverSocket: ServerSocket? = null
    private var serverThread: Thread? = null
    private var serverPort: Int = 0
    private var nsdManager: NsdManager? = null
    private var registrationListener: NsdManager.RegistrationListener? = null
    private var discoveryListener: NsdManager.DiscoveryListener? = null
    private val peers = ConcurrentHashMap<String, PeerAddress>() // key = deviceId
    // Tracks which mDNS service name resolved to which deviceId.
    // A single physical device may appear under two service names when mDNS
    // conflict-renames a re-registered service (e.g. "copycat-X (2)").
    private val serviceNameToDeviceId = ConcurrentHashMap<String, String>()
    private var started = false
    private var connectionExecutor: ThreadPoolExecutor? = null
    private val mainHandler = Handler(Looper.getMainLooper())
    private val discoveryRefreshRunnable = object : Runnable {
        override fun run() {
            if (!started || nsdPaused) return
            refreshDiscovery("periodic")
            scheduleDiscoveryRefresh()
        }
    }

    // MARK: - Screen State
    private var isScreenOn: Boolean = true
    private var screenReceiverRegistered: Boolean = false
    private var nsdPaused: Boolean = false

    private val screenStateReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            when (intent?.action) {
                Intent.ACTION_SCREEN_OFF -> {
                    isScreenOn = false
                    if (started) pauseNsd()
                }
                Intent.ACTION_SCREEN_ON -> {
                    isScreenOn = true
                    if (started) resumeNsd()
                }
            }
        }
    }

    private val httpClient = OkHttpClient.Builder()
        .connectTimeout(3, TimeUnit.SECONDS)
        .readTimeout(5, TimeUnit.SECONDS)
        .writeTimeout(5, TimeUnit.SECONDS)
        .build()

    // MARK: - Lifecycle

    fun start() {
        if (started || !lanSyncEnabled) return
        started = true
        isScreenOn = readScreenInteractiveState()
        registerScreenReceiver()
        startServer()
        if (isScreenOn) {
            registerNsd()
            discoverPeers()
            scheduleDiscoveryRefresh()
        } else {
            nsdPaused = true
            Log.i(LOG_TAG, "LAN sync started with mDNS deferred (screen off)")
        }
        Log.i(LOG_TAG, "LAN sync started on port $serverPort")
    }

    fun stop() {
        if (!started) return
        started = false
        mainHandler.removeCallbacks(discoveryRefreshRunnable)
        unregisterScreenReceiver()
        stopDiscovery()
        unregisterNsd()
        serverThread?.interrupt()
        serverSocket?.close()
        connectionExecutor?.shutdownNow()
        connectionExecutor = null
        serverSocket = null
        peers.clear()
        serviceNameToDeviceId.clear()
        nsdPaused = false
        LanPeerReporter.getInstance().clear()
        Log.i(LOG_TAG, "LAN sync stopped")
    }

    private fun readScreenInteractiveState(): Boolean {
        val pm = appContext.getSystemService(Context.POWER_SERVICE) as? PowerManager
        return pm?.isInteractive ?: true
    }

    private fun registerScreenReceiver() {
        if (screenReceiverRegistered) return
        val filter = IntentFilter().apply {
            addAction(Intent.ACTION_SCREEN_ON)
            addAction(Intent.ACTION_SCREEN_OFF)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            appContext.registerReceiver(screenStateReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            @Suppress("UnspecifiedRegisterReceiverFlag")
            appContext.registerReceiver(screenStateReceiver, filter)
        }
        screenReceiverRegistered = true
    }

    private fun unregisterScreenReceiver() {
        if (!screenReceiverRegistered) return
        try { appContext.unregisterReceiver(screenStateReceiver) } catch (_: Exception) {}
        screenReceiverRegistered = false
    }

    fun reconfigure() {
        if (lanSyncEnabled && !started) {
            start()
        } else if (!lanSyncEnabled && started) {
            stop()
        }
    }

    // MARK: - HTTP Server

    private fun startServer() {
        val ss = ServerSocket(0) // OS assigns an ephemeral port
        serverSocket = ss
        serverPort = ss.localPort
        connectionExecutor = ThreadPoolExecutor(
            2,
            4,
            30L,
            TimeUnit.SECONDS,
            ArrayBlockingQueue(8),
            Executors.defaultThreadFactory(),
            RejectedExecutionHandler { runnable, _ ->
                val task = runnable as? ConnectionTask
                if (task != null) {
                    try {
                        task.socket.close()
                    } catch (_: Exception) {
                    }
                    Log.w(LOG_TAG, "LAN receive queue full; rejecting connection")
                }
            },
        ).apply {
            allowCoreThreadTimeOut(true)
        }

        serverThread = Thread({
            Log.d(LOG_TAG, "Server listening on port $serverPort")
            while (!Thread.currentThread().isInterrupted) {
                val clientSocket: Socket = try {
                    ss.accept()
                } catch (_: IOException) {
                    break // socket closed → stop
                }
                try {
                    connectionExecutor?.execute(ConnectionTask(clientSocket))
                } catch (_: RejectedExecutionException) {
                    try {
                        clientSocket.close()
                    } catch (_: Exception) {
                    }
                }
            }
            Log.d(LOG_TAG, "Server thread exiting")
        }, "lan-server").also {
            it.isDaemon = true
            it.start()
        }
    }

    private inner class ConnectionTask(val socket: Socket) : Runnable {
        override fun run() {
            handleConnection(socket)
        }
    }

    private fun handleConnection(socket: Socket) {
        try {
            socket.use { s ->
                s.soTimeout = 5_000
                val rawInput = s.getInputStream()
                // Minimal HTTP/1.1 request parsing
                val requestLine = readAsciiLine(rawInput) ?: return
                // Respond to health-check pings from desktop peers.
                if (requestLine.startsWith("GET /ping")) {
                    val headers = mutableMapOf<String, String>()
                    while (true) {
                        val line = readAsciiLine(rawInput) ?: break
                        if (line.isEmpty()) break
                        val colon = line.indexOf(':')
                        if (colon > 0) {
                            headers[line.substring(0, colon).trim().lowercase()] =
                                line.substring(colon + 1).trim()
                        }
                    }
                    learnPeerFromPing(headers, s.inetAddress)
                    s.getOutputStream().write("HTTP/1.1 200 OK\r\nContent-Length: 0\r\n\r\n".toByteArray())
                    return
                }
                if (!requestLine.startsWith("POST /clip")) return

                val headers = mutableMapOf<String, String>()
                while (true) {
                    val line = readAsciiLine(rawInput) ?: break
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
                if (contentLength !in 1..MAX_BODY_BYTES) {
                    Log.w(LOG_TAG, "Rejecting clip with invalid body size: $contentLength")
                    return
                }

                // Dart peers send "media" or "file" (ClipItemType names); map
                // these to ClipType.FileUrl which triggers the binary handler.
                val clipType: ClipType? = when (typeStr.lowercase()) {
                    "media", "file" -> ClipType.FileUrl
                    else -> ClipType.entries.firstOrNull {
                        it.name.lowercase() == typeStr.lowercase()
                    }
                }
                if (clipType == null) {
                    Log.w(LOG_TAG, "Unknown clip type: $typeStr")
                    return
                }

                when (clipType) {
                    ClipType.Text, ClipType.Url, ClipType.Email, ClipType.Phone -> {
                        if (contentLength > MAX_TEXT_BODY_BYTES) {
                            Log.w(LOG_TAG, "Rejecting oversized text clip: $contentLength bytes")
                            return
                        }
                        val bodyBytes = readBodyBytes(rawInput, contentLength, originId) ?: return
                        if (!verifyHmac(bodyBytes, hmacHeader)) {
                            Log.w(LOG_TAG, "HMAC verification failed from $fromDeviceId")
                            return
                        }
                        handleTextClip(bodyBytes, fromDeviceId, originId, clipType)
                    }
                    ClipType.FileUrl -> handleBinaryClip(
                        rawInput,
                        contentLength,
                        hmacHeader,
                        fromDeviceId,
                        originId,
                        clipType,
                        // Accept X-CC-MIME (Dart) or Content-Type (Android peer)
                        sanitizeMimeType(
                            headers["x-cc-mime"] ?: headers["content-type"]
                        ),
                        sanitizeExt(headers["x-cc-ext"]),
                        sanitizeFileName(headers["x-cc-name"], originId),
                        headers["x-cc-source-id"],
                        headers["x-cc-source-app"],
                    )
                }

                // Send minimal HTTP 200 response
                s.getOutputStream().write("HTTP/1.1 200 OK\r\nContent-Length: 0\r\n\r\n".toByteArray())
            }
        } catch (e: Exception) {
            Log.e(LOG_TAG, "Error handling connection: ${e.message}")
        }
    }

    private fun readBodyBytes(
        input: java.io.InputStream,
        contentLength: Int,
        originId: String,
    ): ByteArray? {
        val bodyBytes = ByteArray(contentLength)
        var offset = 0
        while (offset < contentLength) {
            val read = input.read(bodyBytes, offset, contentLength - offset)
            if (read == -1) break
            offset += read
        }

        if (offset != contentLength) {
            Log.w(LOG_TAG, "Short body for $originId: expected=$contentLength got=$offset")
            return null
        }

        return bodyBytes
    }

    private fun readAsciiLine(input: java.io.InputStream): String? {
        val sb = StringBuilder()
        while (true) {
            val b = input.read()
            if (b == -1) {
                return if (sb.isEmpty()) null else sb.toString()
            }
            if (sb.length >= MAX_HEADER_LINE_BYTES) {
                Log.w(LOG_TAG, "Rejecting oversized HTTP header line")
                return null
            }
            if (b == '\n'.code) break
            if (b != '\r'.code) sb.append(b.toChar())
        }
        return sb.toString()
    }

    private fun learnPeerFromPing(headers: Map<String, String>, remoteAddress: InetAddress) {
        val announcedDeviceId = headers["x-cc-did"]?.takeIf { it.isNotBlank() } ?: return
        val announcedPort = headers["x-cc-port"]?.toIntOrNull()?.takeIf { it in 1..65535 } ?: return
        if (announcedDeviceId == deviceId) return

        val host = remoteAddress.hostAddress ?: return
        peers[announcedDeviceId] = PeerAddress(host, announcedPort)
        LanPeerReporter.getInstance().addPeer(announcedDeviceId, host, announcedPort)
        scheduleDiscoveryRefresh()
        Log.d(LOG_TAG, "Peer learned via ping: $announcedDeviceId @ $host:$announcedPort")
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

        val payload = parseTextClipPayload(
            json = json,
            fromDeviceId = fromDeviceId,
            originId = originId,
            defaultType = type,
            timestamp = timestamp,
        )

        onLanClipReceived(payload)

        if (autoWriteOnReceive && !payload.deleted && payload.content.isNotBlank()) {
            val textToWrite = if (payload.encrypted) {
                decryptContent?.invoke(payload.content, payload.encMode, payload.iv)
            } else {
                payload.content
            }
            if (textToWrite != null) {
                markCaptured(originId)
                onBeforeClipboardWrite()
                writeTextToClipboard(textToWrite, payload.label)
            } else if (payload.encrypted) {
                Log.w(LOG_TAG, "Skipping clipboard write: encrypted LAN clip could not be decrypted")
            }
        }
    }

    private fun hasDeletedMarker(json: JSONObject?): Boolean {
        if (json == null) return false
        val deletedAtCamel = json.optString(JsonKey.DELETED_AT).trim()
        if (deletedAtCamel.isNotEmpty() &&
            !deletedAtCamel.equals("null", ignoreCase = true)) {
            return true
        }
        return false
    }

    private fun parseDeletedAtMillis(json: JSONObject?): Long? {
        if (json == null) return null

        val rawCamel = json.optString(JsonKey.DELETED_AT).trim()
        val raw = when {
            rawCamel.isNotEmpty() && !rawCamel.equals("null", ignoreCase = true) -> rawCamel
            else -> return null
        }

        raw.toLongOrNull()?.let { return it }

        return try {
            Instant.parse(raw).toEpochMilli()
        } catch (_: Exception) {
            null
        }
    }

    private fun parseTextClipPayload(
        json: JSONObject,
        fromDeviceId: String,
        originId: String,
        defaultType: ClipType,
        timestamp: Long,
    ): LanClipPayload {
        val fullItem = json.optJSONObject(JsonKey.ITEM)
        val fallbackContent = when (defaultType) {
            ClipType.Url -> fullItem?.optString(JsonKey.URL, "") ?: ""
            else -> fullItem?.optString(JsonKey.TEXT, "") ?: ""
        }
        val content = json.optString(JsonKey.CONTENT, fallbackContent)
        val label = json.optString(JsonKey.LABEL, fullItem?.optString(JsonKey.TITLE, "") ?: "")
        val encrypted = if (json.has(JsonKey.ENCRYPTED)) {
            json.optBoolean(JsonKey.ENCRYPTED, false)
        } else {
            fullItem?.optBoolean(JsonKey.ENCRYPTED, false) ?: false
        }
        val iv = json.optNonBlank(JsonKey.IV)
            ?: fullItem?.optNonBlank(JsonKey.IV)
        val encMode = json.optNonBlank(JsonKey.ENC_MODE)
            ?: fullItem?.optNonBlank(JsonKey.ENC_MODE_SNAKE)
            ?: fullItem?.optNonBlank(JsonKey.ENC_MODE)
        val sourceId = json.optNonBlank(JsonKey.SOURCE_ID)
            ?: fullItem?.optNonBlank(JsonKey.SOURCE_ID)
        val sourceApp = json.optNonBlank(JsonKey.SOURCE_APP)
            ?: fullItem?.optNonBlank(JsonKey.SOURCE_APP)
        val itemUserId = fullItem?.optNonBlank(JsonKey.USER_ID)
        val itemServerId = fullItem?.optLong(JsonKey.ID)?.takeIf { it > 0L }
        val deleted = hasDeletedMarker(fullItem) || hasDeletedMarker(json)
        val deletedAtMs = parseDeletedAtMillis(fullItem) ?: parseDeletedAtMillis(json)

        val payloadType = fullItem?.optNonBlank(JsonKey.TYPE)
            ?.let { raw ->
                when (raw.lowercase()) {
                    "url" -> ClipType.Url
                    "text" -> ClipType.Text
                    "media", "file", "fileurl" -> ClipType.FileUrl
                    else -> defaultType
                }
            } ?: defaultType

        return LanClipPayload(
            originId = originId,
            fromDeviceId = fromDeviceId,
            type = payloadType,
            content = content,
            label = label,
            timestamp = timestamp,
            encrypted = encrypted,
            iv = iv,
            encMode = encMode,
            userId = itemUserId,
            serverId = itemServerId,
            sourceId = sourceId,
            sourceApp = sourceApp,
            deleted = deleted,
            deletedAtMs = deletedAtMs,
        )
    }

    private fun handleBinaryClip(
        input: java.io.InputStream,
        contentLength: Int,
        expectedHmac: String,
        fromDeviceId: String,
        originId: String,
        type: ClipType,
        mimeType: String,
        ext: String,
        fileName: String,
        sourceId: String?,
        sourceApp: String?,
    ) {
        var tempFile: File? = null
        try {
            val recvDir = File(appContext.cacheDir, LAN_RECV_DIR).also { it.mkdirs() }
            val safeOriginId = originId.replace(Regex("[^a-zA-Z0-9\\-]"), "_")
            tempFile = File(recvDir, "$safeOriginId.$ext")
            val mac = Mac.getInstance(HMAC_ALGO).apply {
                init(SecretKeySpec(userId.toByteArray(Charsets.UTF_8), HMAC_ALGO))
            }
            val buffer = ByteArray(STREAM_BUFFER_BYTES)
            var remaining = contentLength

            FileOutputStream(tempFile).use { output ->
                while (remaining > 0) {
                    val bytesToRead = minOf(buffer.size, remaining)
                    val read = input.read(buffer, 0, bytesToRead)
                    if (read == -1) {
                        Log.w(LOG_TAG, "Short streamed body for $originId: expected=$contentLength got=${contentLength - remaining}")
                        tempFile.delete()
                        return
                    }
                    output.write(buffer, 0, read)
                    mac.update(buffer, 0, read)
                    remaining -= read
                }
                output.flush()
            }

            val expectedBytes = parseHmacHex(expectedHmac)
            if (expectedBytes == null || !MessageDigest.isEqual(mac.doFinal(), expectedBytes)) {
                Log.w(LOG_TAG, "HMAC verification failed from $fromDeviceId")
                tempFile.delete()
                return
            }

            // Always persist to the CopyCat database via the host callback so
            // the clip appears in history even when autoWriteOnReceive is off.
            val payload = LanClipPayload(
                originId = originId,
                fromDeviceId = fromDeviceId,
                type = type,
                content = "",
                label = fileName,
                timestamp = System.currentTimeMillis(),
                encrypted = false,
                iv = null,
                encMode = null,
                localFilePath = tempFile.absolutePath,
                fileMimeType = mimeType,
                fileExtension = ext,
                fileName = fileName,
                sourceId = sourceId,
                sourceApp = sourceApp,
            )
            onLanClipReceived(payload)

            // Optionally also place the file on the OS clipboard.
            if (autoWriteOnReceive) {
                if (contentLength > maxAutoCopyBytes) {
                    Log.i(LOG_TAG, "Binary clip exceeds auto-copy limit ($maxAutoCopyBytes bytes), skipping clipboard write")
                    return
                }
                val uri = FileProvider.getUriForFile(
                    appContext,
                    "${appContext.packageName}.fileProvider",
                    tempFile,
                )
                val clipData = AndroidClipData.newUri(appContext.contentResolver, fileName, uri)
                val cm = appContext.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
                markCaptured(originId)
                onBeforeClipboardWrite()
                cm.setPrimaryClip(clipData)
            }
            Log.d(LOG_TAG, "Binary clip ($mimeType) received from $fromDeviceId — persisted${if (autoWriteOnReceive) " + clipboard" else ""}")
        } catch (e: Exception) {
            Log.e(LOG_TAG, "Failed to handle binary clip: ${e.message}")
            tempFile?.delete()
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

    private fun sanitizeMimeType(raw: String?): String {
        val value = raw?.trim().orEmpty()
        if (value.isEmpty() || value.equals("null", ignoreCase = true)) {
            return "application/octet-stream"
        }
        return value
    }

    private fun sanitizeExt(raw: String?): String {
        val value = raw?.trim()?.lowercase().orEmpty()
            .replace(Regex("[^a-z0-9]"), "")
        return if (value.isEmpty()) "bin" else value
    }

    private fun sanitizeFileName(raw: String?, originId: String): String {
        val value = raw?.trim().orEmpty()
        if (value.isEmpty() || value.equals("null", ignoreCase = true)) return originId
        return value
    }

    // MARK: - NSD Registration

    private fun registerNsd() {
        val nsd = appContext.getSystemService(Context.NSD_SERVICE) as NsdManager
        nsdManager = nsd

        val info = NsdServiceInfo().apply {
            serviceName = "copycat-$deviceId"
            serviceType = this@CopyCatLanSyncManager.serviceType
            port = serverPort
            setAttribute("did", deviceId)
            setAttribute("os", "android")
        }

        val listener = object : NsdManager.RegistrationListener {
            override fun onServiceRegistered(info: NsdServiceInfo) {
                Log.d(LOG_TAG, "NSD registered: ${info.serviceName} port=$serverPort")
                // Re-start discovery shortly after registration to recover from
                // stale NSD sessions where peers are not surfaced until a full
                // off/on toggle.
                mainHandler.postDelayed({
                    if (started) refreshDiscovery("post-register")
                }, DISCOVERY_POST_REGISTER_DELAY_MS)
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

    // MARK: - NSD Discovery

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
                if (started) {
                    mainHandler.postDelayed(
                        { if (started) refreshDiscovery("start-failed:$errorCode") },
                        DISCOVERY_POST_REGISTER_DELAY_MS,
                    )
                }
            }
            override fun onStopDiscoveryFailed(serviceType: String, errorCode: Int) {
                Log.w(LOG_TAG, "NSD discovery stop failed: $errorCode")
                if (started) {
                    mainHandler.postDelayed(
                        { if (started) refreshDiscovery("stop-failed:$errorCode") },
                        DISCOVERY_POST_REGISTER_DELAY_MS,
                    )
                }
            }
            override fun onServiceFound(info: NsdServiceInfo) {
                if (!matchesServiceType(info.serviceType)) {
                    Log.d(LOG_TAG, "Ignoring service ${info.serviceName} of type ${info.serviceType}")
                    return
                }
                // Resolve to get host + port
                nsd.resolveService(info, makeResolveListener())
            }
            override fun onServiceLost(info: NsdServiceInfo) {
                // Look up the deviceId from the service-name map recorded at
                // resolution time; fall back to name parsing for resilience.
                val did = serviceNameToDeviceId.remove(info.serviceName)
                    ?: peerKeyFromServiceName(info.serviceName)
                // Only evict the peer once ALL mDNS service names for this
                // device are gone. When mDNS conflict-renames a re-registered
                // service, two names temporarily map to the same deviceId;
                // losing the stale one must not evict the live peer.
                if (serviceNameToDeviceId.values.none { it == did }) {
                    if (peers.remove(did) != null) {
                        LanPeerReporter.getInstance().removePeer(did)
                        Log.d(LOG_TAG, "Peer lost: $did")
                        scheduleDiscoveryRefresh()
                    }
                }
            }
        }
        discoveryListener = listener
        nsd.discoverServices(serviceType, NsdManager.PROTOCOL_DNS_SD, listener)
    }

    private fun scheduleDiscoveryRefresh() {
        mainHandler.removeCallbacks(discoveryRefreshRunnable)
        val delayMs = if (peers.isEmpty()) {
            DISCOVERY_REFRESH_EMPTY_MS
        } else {
            DISCOVERY_REFRESH_STABLE_MS
        }
        mainHandler.postDelayed(discoveryRefreshRunnable, delayMs)
    }

    private fun pauseNsd() {
        if (nsdPaused) return
        nsdPaused = true
        mainHandler.removeCallbacks(discoveryRefreshRunnable)
        stopDiscovery()
        unregisterNsd()
        peers.clear()
        serviceNameToDeviceId.clear()
        LanPeerReporter.getInstance().clear()
        Log.i(LOG_TAG, "LAN mDNS paused (screen off)")
    }

    private fun resumeNsd() {
        if (!nsdPaused) return
        nsdPaused = false
        registerNsd()
        discoverPeers()
        scheduleDiscoveryRefresh()
        Log.i(LOG_TAG, "LAN mDNS resumed (screen on)")
    }

    private fun refreshDiscovery(reason: String) {
        if (!started || nsdPaused) return
        stopDiscovery()
        discoverPeers()
        Log.d(LOG_TAG, "NSD discovery refreshed ($reason)")
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
                // Prefer the 'did' TXT attribute; fall back to service-name
                // parsing. Reading the attribute is resilient to mDNS conflict-
                // renaming (e.g. "copycat-UUID (2)") that bonsoir may apply on
                // the remote peer when it re-registers after a restart.
                val didBytes = info.attributes["did"]
                val did = if (didBytes != null && didBytes.isNotEmpty()) {
                    String(didBytes, Charsets.UTF_8)
                } else {
                    peerKeyFromServiceName(info.serviceName)
                }
                if (did == deviceId) return // self
                val host = info.host?.hostAddress ?: return
                serviceNameToDeviceId[info.serviceName] = did
                peers[did] = PeerAddress(host, info.port)
                LanPeerReporter.getInstance().addPeer(did, host, info.port)
                scheduleDiscoveryRefresh()
                Log.d(LOG_TAG, "Peer resolved: $did @ $host:${info.port}")
                // Announce our own HTTP server address to the peer immediately
                // so it can broadcast clips back to us without waiting for its
                // own mDNS discovery cycle.
                announceSelfToPeer(PeerAddress(host, info.port))
            }
        }

    private fun peerKeyFromServiceName(name: String): String =
        name.removePrefix("copycat-")

    /**
     * NSD reports the service type inconsistently across OEMs, with or without
     * a trailing dot, and sometimes truncated to just "_tcp.", so compare on a
     * normalized form instead of requiring an exact match.
     */
    private fun matchesServiceType(found: String?): Boolean {
        val normalizedFound = found?.trim()?.trim('.')?.lowercase().orEmpty()
        if (normalizedFound.isEmpty()) return true
        val expected = serviceType.trim('.').lowercase()
        return normalizedFound == expected ||
            expected.endsWith(normalizedFound) ||
            normalizedFound.endsWith(expected)
    }

    // MARK: - Sending

    /**
     * Sends a GET /ping to [peer] with our device ID and HTTP server port so
     * the remote peer can register us for reverse-discovery without waiting for
     * its own mDNS query cycle. Runs on a short-lived daemon thread.
     */
    private fun announceSelfToPeer(peer: PeerAddress) {
        Thread({
            try {
                val request = Request.Builder()
                    .url("http://${peer.host}:${peer.port}/ping")
                    .addHeader("X-CC-DID", deviceId)
                    .addHeader("X-CC-PORT", serverPort.toString())
                    .addHeader("X-CC-OS", "android")
                    .get()
                    .build()
                httpClient.newCall(request).execute().use { /* trigger reverse learning */ }
                Log.d(LOG_TAG, "Announced self to ${peer.host}:${peer.port}")
            } catch (e: Exception) {
                Log.d(LOG_TAG, "Self-announcement failed: ${e.message}")
            }
        }, "lan-hello").also { it.isDaemon = true; it.start() }
    }


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
        sourceId: String? = null,
        sourceApp: String? = null,
    ) {
        if (!started || peers.isEmpty() || userId.isBlank()) return

        val timestamp = System.currentTimeMillis()
        val payloadType = when (type) {
            ClipType.Url -> "url"
            else -> "text"
        }
        val bodyJson = JSONObject().apply {
            put(JsonKey.CONTENT, content)
            put(JsonKey.LABEL, label)
            put(JsonKey.TS, timestamp)
            put(JsonKey.CREATED, timestamp)
            put(JsonKey.MODIFIED, timestamp)
            put(JsonKey.OS, "android")
            put(JsonKey.ENCRYPTED, encrypted)
            putIfNotBlank(JsonKey.IV, iv)
            putIfNotBlank(JsonKey.ENC_MODE, encMode)
            putIfNotBlank(JsonKey.SOURCE_ID, sourceId)
            putIfNotBlank(JsonKey.SOURCE_APP, sourceApp)

            put(JsonKey.ITEM, JSONObject().apply {
                put(JsonKey.TYPE, payloadType)
                put(JsonKey.USER_ID, if (userId.isNotBlank()) userId else "local")
                put(JsonKey.CREATED, toIso8601Utc(timestamp))
                put(JsonKey.MODIFIED, toIso8601Utc(timestamp))
                put(JsonKey.OS, "android")
                put(JsonKey.TITLE, label)
                put(JsonKey.ORIGIN_ID, originId)
                put(JsonKey.ENCRYPTED, encrypted)
                if (payloadType == "url") {
                    put(JsonKey.URL, content)
                } else {
                    put(JsonKey.TEXT, content)
                }
                putIfNotBlank(JsonKey.IV, iv)
                putIfNotBlank(JsonKey.ENC_MODE_SNAKE, encMode)
                putIfNotBlank(JsonKey.SOURCE_ID, sourceId)
                putIfNotBlank(JsonKey.SOURCE_APP, sourceApp)
            })
        }
        val bodyBytes = bodyJson.toString().toByteArray(Charsets.UTF_8)
        val hmac = computeHmac(bodyBytes)

        peers.values.forEach { peer ->
            sendToPeer(peer, originId, type.name.lowercase(), bodyBytes, hmac,
                "application/json", null, null, sourceId, sourceApp)
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
        sourceId: String? = null,
        sourceApp: String? = null,
    ) {
        if (!started || peers.isEmpty() || userId.isBlank()) return
        val hmac = computeHmac(data)
        peers.values.forEach { peer ->
            sendToPeer(
                peer,
                originId,
                type.name.lowercase(),
                data,
                hmac,
                mimeType,
                ext,
                fileName,
                sourceId,
                sourceApp,
            )
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
        sourceId: String?,
        sourceApp: String?,
    ) {
        try {
            val requestBuilder = Request.Builder()
                .url("http://${peer.host}:${peer.port}/clip")
                .addHeader("X-CC-DID", deviceId)
                .addHeader("X-CC-OID", originId)
                .addHeader("X-CC-TYPE", typeStr)
                .addHeader("X-CC-HMAC", hmac)
                .addHeader("X-CC-PORT", serverPort.toString())
            if (ext != null) requestBuilder.addHeader("X-CC-EXT", ext)
            if (fileName != null) requestBuilder.addHeader("X-CC-NAME", fileName)
            if (!sourceId.isNullOrBlank()) {
                requestBuilder.addHeader("X-CC-SOURCE-ID", sourceId)
            }
            if (!sourceApp.isNullOrBlank()) {
                requestBuilder.addHeader("X-CC-SOURCE-APP", sourceApp)
            }

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

    private fun toIso8601Utc(timestampMs: Long): String {
        val formatter = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.US)
        formatter.timeZone = TimeZone.getTimeZone("UTC")
        return formatter.format(Date(timestampMs))
    }

    // MARK: - Auth

    private fun computeHmac(body: ByteArray): String {
        val key = userId.toByteArray(Charsets.UTF_8)
        val mac = Mac.getInstance(HMAC_ALGO)
        mac.init(SecretKeySpec(key, HMAC_ALGO))
        val digest = mac.doFinal(body)
        return digest.joinToString("") { "%02x".format(it) }
    }

    private fun verifyHmac(body: ByteArray, expected: String): Boolean {
        if (userId.isBlank()) return false
        val expectedBytes = parseHmacHex(expected) ?: return false
        val key = userId.toByteArray(Charsets.UTF_8)
        val mac = Mac.getInstance(HMAC_ALGO)
        mac.init(SecretKeySpec(key, HMAC_ALGO))
        return MessageDigest.isEqual(mac.doFinal(body), expectedBytes)
    }

    private fun parseHmacHex(hex: String): ByteArray? {
        if (hex.length != 64) return null
        return try {
            ByteArray(32) { i -> hex.substring(i * 2, i * 2 + 2).toInt(16).toByte() }
        } catch (_: NumberFormatException) {
            null
        }
    }
}
