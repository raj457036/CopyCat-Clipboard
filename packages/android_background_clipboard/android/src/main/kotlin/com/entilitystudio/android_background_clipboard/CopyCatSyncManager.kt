package com.entilitystudio.android_background_clipboard

import android.content.Context
import android.content.BroadcastReceiver
import android.content.Intent
import android.content.IntentFilter
import android.content.SharedPreferences
import android.content.pm.ApplicationInfo
import android.os.Build
import android.os.PowerManager
import android.util.Log
import okhttp3.ConnectionPool
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.Response
import okhttp3.WebSocket
import okhttp3.WebSocketListener
import okhttp3.logging.HttpLoggingInterceptor
import org.json.JSONArray
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.Timer
import java.util.TimerTask
import java.util.TimeZone
import java.util.concurrent.TimeUnit
import java.util.concurrent.atomic.AtomicBoolean
import kotlin.concurrent.thread

data class RemoteClipPayload(
    val serverId: Long,
    val content: String,
    val type: ClipType,
    val label: String? = null,
    val encrypted: Boolean = false,
    val iv: String? = null,
    val encMode: String? = null,
    val userId: String? = null,
    val modifiedAt: Long = System.currentTimeMillis(),
    val originId: String? = null,
)

object ListeningMode {
    const val PUSH = "push"
    const val SYNC = "sync"
}

class CopyCatSyncManager(
    applicationContext: Context,
    private val onRemoteClipUpsert: (RemoteClipPayload) -> Unit,
) {
    private val appContext: Context = applicationContext.applicationContext
    private val logTag = "CopyCatSyncManager"
    private var listening = false
    private val regex = "\\d+".toRegex()
    private val contentType = "application/json"
    private val reconnectDelayMs = 5_000L
    private val heartbeatMs = 30_000L
    private val screenOnRefreshCooldownMs = 60_000L
    private val maxAuthRecoveryAttempts = 3
    private val loggingInterceptor = HttpLoggingInterceptor()

    // Configure OkHttp with memory-efficient settings
    private val client = OkHttpClient.Builder()
        .addInterceptor(loggingInterceptor)
        .connectionPool(ConnectionPool(5, 5, TimeUnit.MINUTES)) // Limit connection pool
        .connectTimeout(10, TimeUnit.SECONDS)
        .readTimeout(10, TimeUnit.SECONDS)
        .writeTimeout(10, TimeUnit.SECONDS)
        .build()
        
    private val sp = appContext.getSharedPreferences(
        "FlutterSharedPreferences",
        Context.MODE_PRIVATE
    )

    var projectKey: String = ""
    var projectApiKey: String = ""
    var deviceId: String = ""
    var syncEnabled: Boolean = false
    var listeningMode: String = ListeningMode.PUSH
    var syncSpeed: String = "balanced"
    var syncIntervalSeconds: Int = 45
    var autoWriteOnReceive: Boolean = false

    private var token = "{}"
    private var accessToken: String? = null
    private var refreshToken: String? = null
    private var expireAt: Long? = null
    private var userId: String? = null
    private var reconnectTimer: Timer? = null
    private var heartbeatTimer: Timer? = null
    private var realtimeSocket: WebSocket? = null
    private var realtimeConnected = false
    private var wsRef = 1
    private var isScreenOn: Boolean = true
    private var screenStateReceiverRegistered = false
    @Volatile
    private var lastScreenOnRefreshAtMs: Long = 0L
    private val screenOnRefreshInFlight = AtomicBoolean(false)
    private val authRefreshLock = Any()
    @Volatile
    private var lastWriteAuthFailure: Boolean = false
    var isStopped = false

    private val screenStateReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            when (intent?.action) {
                Intent.ACTION_SCREEN_OFF -> {
                    isScreenOn = false
                    Log.i(logTag, "Screen OFF detected: pausing realtime background sync")
                    reconfigureConnections()
                }

                Intent.ACTION_SCREEN_ON -> {
                    isScreenOn = true
                    Log.i(logTag, "Screen ON detected: resuming realtime background sync")
                    preflightAuthRefreshOnScreenOn()
                    reconfigureConnections()
                }
            }
        }
    }


    private val listener =
        SharedPreferences.OnSharedPreferenceChangeListener { sharedPreferences, key ->
            if (key == tokenKey) {
                token = sharedPreferences.getString(key, "{}")!!
                load()
            }
        }

    private val isExpired: Boolean
        get() {
            if (expireAt == null) return true
            val refreshBefore = (System.currentTimeMillis() / 1000) + 240
            return refreshBefore >= expireAt!!
        }

    val currentUserId: String?
        get() = userId

    fun consumeLastWriteAuthFailure(): Boolean {
        val failed = lastWriteAuthFailure
        lastWriteAuthFailure = false
        return failed
    }

    private val isReady: Boolean
        get() = projectKey.isNotBlank() && projectApiKey.isNotBlank() && deviceId.isNotBlank()

    private val url
        get() = "https://$projectKey.supabase.co"

    private val tokenKey
        get() = "flutter.sb-$projectKey-auth-token"

    private val realtimeEnabled: Boolean
        get() =
            syncEnabled &&
                autoWriteOnReceive &&
                syncSpeed == "realtime" &&
                syncIntervalSeconds < 10 &&
                isScreenOn

    private fun readScreenInteractiveState(): Boolean {
        val pm = appContext.getSystemService(Context.POWER_SERVICE) as? PowerManager
        return pm?.isInteractive ?: true
    }

    private fun registerScreenStateReceiver() {
        if (screenStateReceiverRegistered) return
        val filter = IntentFilter().apply {
            addAction(Intent.ACTION_SCREEN_ON)
            addAction(Intent.ACTION_SCREEN_OFF)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            appContext.registerReceiver(
                screenStateReceiver,
                filter,
                Context.RECEIVER_NOT_EXPORTED,
            )
        } else {
            appContext.registerReceiver(screenStateReceiver, filter)
        }
        screenStateReceiverRegistered = true
    }

    private fun unregisterScreenStateReceiver() {
        if (!screenStateReceiverRegistered) return
        try {
            appContext.unregisterReceiver(screenStateReceiver)
        } catch (_: Exception) {
        }
        screenStateReceiverRegistered = false
    }


    fun start() {
        if (!listening) {
            sp.registerOnSharedPreferenceChangeListener(listener)
            listening = true
        }
        isScreenOn = readScreenInteractiveState()
        registerScreenStateReceiver()

        debugLog(logTag) { "Configuring CopyCat Sync" }
        token = sp.getString(tokenKey, "{}")!!
        load()
        loggingInterceptor.redactHeader("Authorization")
        loggingInterceptor.redactHeader("apikey")
        val isDebuggable = (appContext.applicationInfo.flags and ApplicationInfo.FLAG_DEBUGGABLE) != 0
        if (isDebuggable) {
            // Enable temporarily when debugging wire traffic:
            // loggingInterceptor.level = HttpLoggingInterceptor.Level.BODY
            loggingInterceptor.level = HttpLoggingInterceptor.Level.NONE
        } else {
            loggingInterceptor.level = HttpLoggingInterceptor.Level.NONE
        }

        Log.i(
            logTag,
            "start() ready=$isReady syncEnabled=$syncEnabled listeningMode=$listeningMode syncSpeed=$syncSpeed syncIntervalSeconds=$syncIntervalSeconds realtimeEnabled=$realtimeEnabled hasAccessToken=${!accessToken.isNullOrBlank()} userIdPresent=${!userId.isNullOrBlank()}"
        )

        reconfigureConnections()
    }

    fun stop() {
        if (listening) {
            sp.unregisterOnSharedPreferenceChangeListener(listener)
            listening = false
        }
        unregisterScreenStateReceiver()

        stopRealtime()
        reconnectTimer?.cancel()
        reconnectTimer = null

        debugLog(logTag) { "Stopped" }
    }

    fun reconfigureConnections() {
        Log.i(
            logTag,
            "reconfigureConnections() listening=$listening isStopped=$isStopped syncEnabled=$syncEnabled listeningMode=$listeningMode syncSpeed=$syncSpeed syncIntervalSeconds=$syncIntervalSeconds realtimeEnabled=$realtimeEnabled ready=$isReady"
        )

        if (!listening || isStopped || !syncEnabled) {
            Log.i(logTag, "Realtime disabled by guard; stopping socket")
            stopRealtime()
            return
        }

        if (realtimeEnabled) {
            Log.i(logTag, "Realtime eligible; starting websocket")
            startRealtime()
        } else {
            Log.i(logTag, "Realtime not eligible; websocket stopped")
            stopRealtime()
        }
    }

    private fun load() {
        if (token == "{}") {
            debugLog(logTag) { "Load failed, token = {}" }
            isStopped = true
            return
        }
        val parsed = JSONObject(token)
        accessToken = parsed.getString("access_token")
        refreshToken = parsed.getString("refresh_token")
        expireAt = parsed.getLong("expires_at")
        userId = parsed.getJSONObject("user").getString("id")
        isStopped = false
    }

    private fun reloadTokenFromSharedPreferences(): Boolean {
        val latestToken = sp.getString(tokenKey, "{}") ?: "{}"
        if (latestToken == "{}") return false

        return try {
            token = latestToken
            load()
            !accessToken.isNullOrBlank()
        } catch (e: Exception) {
            Log.e(logTag, "Failed to reload token from preferences: ${e.message}")
            false
        }
    }

    private fun writeToSp(key: String, value: String): Boolean {
        return sp.edit().putString(key, value).commit()
    }

    private fun doRefreshToken(): Boolean {
        if (refreshToken == null || !isReady) return false
        val url = "$url/auth/v1/token?grant_type=refresh_token"
        val refreshTokenBody = """{"refresh_token": "$refreshToken"}"""

        val requestBody = refreshTokenBody.toRequestBody(contentType.toMediaTypeOrNull())

        val request = Request.Builder()
            .url(url)
            .addHeader("apikey", projectApiKey)
            .addHeader("Content-type", contentType)
            .post(requestBody)
            .build()

        return try {
            client.newCall(request).execute().use { response ->
                if (response.code == 200) {
                    val refreshedToken = response.body.string()
                    token = refreshedToken
                    load()
                    writeToSp(tokenKey, refreshedToken)
                } else {
                    false
                }
            }
        } catch (e: Exception) {
            Log.e(logTag, "Error refreshing token: ${e.message}")
            false
        }
    }

    private fun recoverAuthWithRetries(forceRefresh: Boolean = false): Boolean =
        synchronized(authRefreshLock) {
            val reloaded = reloadTokenFromSharedPreferences()
            if (!forceRefresh && reloaded && !isExpired && !accessToken.isNullOrBlank()) {
                return@synchronized true
            }

            for (attempt in 1..maxAuthRecoveryAttempts) {
                val refreshed = doRefreshToken()
                if (refreshed && !isExpired && !accessToken.isNullOrBlank()) {
                    return@synchronized true
                }

                reloadTokenFromSharedPreferences()
                if (!isExpired && !accessToken.isNullOrBlank()) {
                    return@synchronized true
                }

                Log.w(logTag, "Auth recovery attempt $attempt/$maxAuthRecoveryAttempts failed")
            }

            false
        }

    private fun preflightAuthRefreshOnScreenOn() {
        if (!syncEnabled || !isReady || refreshToken.isNullOrBlank()) {
            return
        }

        if (!isExpired) {
            return
        }

        val now = System.currentTimeMillis()
        if (now - lastScreenOnRefreshAtMs < screenOnRefreshCooldownMs) {
            return
        }

        if (!screenOnRefreshInFlight.compareAndSet(false, true)) {
            return
        }

        lastScreenOnRefreshAtMs = now
        thread(start = true, name = "copycat-screen-on-auth-refresh") {
            try {
                val recovered = recoverAuthWithRetries()
                if (recovered) {
                    Log.i(logTag, "Screen-on auth preflight succeeded")
                } else {
                    Log.w(logTag, "Screen-on auth preflight failed")
                }
            } finally {
                screenOnRefreshInFlight.set(false)
            }
        }
    }

    private fun currentTime(): String {
        val dateFormat = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", Locale.getDefault())
        dateFormat.timeZone = TimeZone.getTimeZone("UTC")
        return dateFormat.format(Date())
    }

    private fun parseIsoToMillis(value: String?): Long {
        if (value.isNullOrBlank()) return System.currentTimeMillis()
        return try {
            val dateFormat = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", Locale.getDefault())
            dateFormat.timeZone = TimeZone.getTimeZone("UTC")
            dateFormat.parse(value)?.time ?: System.currentTimeMillis()
        } catch (_: Exception) {
            System.currentTimeMillis()
        }
    }

    private fun startRealtime() {
        if (!realtimeEnabled || realtimeConnected || accessToken.isNullOrBlank() || !isReady) {
            Log.i(
                logTag,
                "startRealtime() skipped realtimeEnabled=$realtimeEnabled realtimeConnected=$realtimeConnected accessTokenMissing=${accessToken.isNullOrBlank()} ready=$isReady"
            )
            return
        }

        val wsUrl = "wss://$projectKey.supabase.co/realtime/v1/websocket?apikey=$projectApiKey&vsn=1.0.0"
        Log.i(logTag, "Opening realtime websocket to Supabase")
        val request = Request.Builder().url(wsUrl).build()
        realtimeSocket = client.newWebSocket(request, object : WebSocketListener() {
            override fun onOpen(webSocket: WebSocket, response: Response) {
                Log.i(logTag, "Realtime websocket opened code=${response.code}")
                realtimeConnected = true
                sendRealtimeJoin()
                startHeartbeat()
            }

            override fun onMessage(webSocket: WebSocket, text: String) {
                handleRealtimeMessage(text)
            }

            override fun onClosed(webSocket: WebSocket, code: Int, reason: String) {
                Log.i(logTag, "Realtime websocket closed code=$code reason=$reason")
                realtimeConnected = false
                stopHeartbeat()
                scheduleRealtimeReconnect()
            }

            override fun onFailure(webSocket: WebSocket, t: Throwable, response: Response?) {
                Log.w(logTag, "Realtime socket failed: ${t.message}")
                realtimeConnected = false
                stopHeartbeat()
                scheduleRealtimeReconnect()
            }
        })
    }

    private fun stopRealtime() {
        stopHeartbeat()
        realtimeConnected = false
        Log.i(logTag, "Closing realtime websocket")
        realtimeSocket?.close(1000, "stopped")
        realtimeSocket = null
    }

    private fun startHeartbeat() {
        stopHeartbeat()
        heartbeatTimer = Timer("copycat-bg-heartbeat", true)
        heartbeatTimer?.scheduleAtFixedRate(object : TimerTask() {
            override fun run() {
                sendRealtimeHeartbeat()
            }
        }, heartbeatMs, heartbeatMs)
    }

    private fun stopHeartbeat() {
        heartbeatTimer?.cancel()
        heartbeatTimer = null
    }

    private fun scheduleRealtimeReconnect() {
        if (!realtimeEnabled) return
        Log.i(logTag, "Scheduling realtime reconnect in ${reconnectDelayMs}ms")
        reconnectTimer?.cancel()
        reconnectTimer = Timer("copycat-bg-reconnect", true)
        reconnectTimer?.schedule(object : TimerTask() {
            override fun run() {
                if (realtimeEnabled && !realtimeConnected) {
                    if (isExpired) {
                        recoverAuthWithRetries()
                    }
                    Log.i(logTag, "Attempting realtime reconnect")
                    startRealtime()
                }
            }
        }, reconnectDelayMs)
    }

    private fun nextRef(): String = (wsRef++).toString()

    private fun sendRealtimeJoin() {
        Log.i(logTag, "Sending realtime join for clipboard_items with device filter deviceId=neq.$deviceId")
        val joinPayload = JSONObject().apply {
            put("topic", "realtime:public:clipboard_items")
            put("event", "phx_join")
            put("payload", JSONObject().apply {
                put("config", JSONObject().apply {
                    put("postgres_changes", JSONArray().put(JSONObject().apply {
                        put("event", "*")
                        put("schema", "public")
                        put("table", "clipboard_items")
                        put("filter", "deviceId=neq.$deviceId")
                    }))
                })
                put("access_token", accessToken)
            })
            put("ref", nextRef())
        }

        realtimeSocket?.send(joinPayload.toString())
    }

    private fun sendRealtimeHeartbeat() {
        debugLog(logTag) { "Sending realtime heartbeat" }
        val heartbeatPayload = JSONObject().apply {
            put("topic", "phoenix")
            put("event", "phx_heartbeat")
            put("payload", JSONObject())
            put("ref", nextRef())
        }
        realtimeSocket?.send(heartbeatPayload.toString())
    }

    private fun handleRealtimeMessage(text: String) {
        try {
            val msg = JSONObject(text)
            val event = msg.optString(JsonKey.EVENT)
            if (event == "phx_reply") {
                Log.i(logTag, "Realtime join reply received")
            }
            if (event != "postgres_changes") return

            val payload = msg.optJSONObject(JsonKey.PAYLOAD) ?: return
            val data = payload.optJSONObject(JsonKey.DATA) ?: return
            val eventType = data.optString(JsonKey.TYPE)
            Log.i(logTag, "Realtime postgres_changes event=$eventType")

            when (eventType) {
                "INSERT", "UPDATE" -> {
                    val record = data.optJSONObject(JsonKey.RECORD) ?: return
                    debugLog(logTag) {
                        "[CC] [debug] Received realtime event: ($eventType, $record)"
                    }
                    processRemoteRecord(record)
                }
            }
        } catch (e: Exception) {
            Log.w(logTag, "Failed to parse realtime message: ${e.message}")
        }
    }

    private fun processRemoteRecord(record: JSONObject) {
        val serverId = record.optLong(JsonKey.ID, -1L)
        if (serverId <= 0) return

        val typeRaw = (record.optNonBlank(JsonKey.TYPE) ?: "text").lowercase()
        val textCategory = (record.optNonBlank(JsonKey.TEXT_CATEGORY) ?: "").lowercase()
        val originId = record.optNonBlank(JsonKey.ORIGIN_ID)

        // Non-text clips (media/file) are handled by LAN binary sync. Ignore
        // realtime upserts here to avoid creating text placeholder entries.
        if (typeRaw == "media" || typeRaw == "file") {
            Log.i(
                logTag,
                "Remote upsert ignored serverId=$serverId typeRaw=$typeRaw originId=$originId reason=non-text"
            )
            return
        }

        val clipType = when {
            typeRaw == "url" -> ClipType.Url
            textCategory == "email" -> ClipType.Email
            textCategory == "phone" -> ClipType.Phone
            else -> ClipType.Text
        }

        val content = when (clipType) {
            ClipType.Url -> record.optNonBlank(JsonKey.URL) ?: ""
            else -> record.optNonBlank(JsonKey.TEXT) ?: ""
        }

        if (content.isBlank()) {
            Log.i(
                logTag,
                "Remote upsert skipped serverId=$serverId typeRaw=$typeRaw mappedType=$clipType reason=blank-content"
            )
            return
        }

        val payload = RemoteClipPayload(
            serverId = serverId,
            content = content,
            type = clipType,
            label = record.optNonBlank(JsonKey.TITLE),
            encrypted = record.optBoolean(JsonKey.ENCRYPTED, false),
            iv = record.optNonBlank(JsonKey.IV),
            encMode = record.optNonBlank(JsonKey.ENC_MODE_SNAKE),
            userId = record.optNonBlank(JsonKey.USER_ID),
            modifiedAt = parseIsoToMillis(record.optString(JsonKey.MODIFIED)),
            originId = originId,
        )

        Log.i(
            logTag,
            "Remote upsert parsed serverId=$serverId typeRaw=$typeRaw type=$clipType encrypted=${payload.encrypted} encMode=${payload.encMode} contentLen=${payload.content.length}"
        )

        onRemoteClipUpsert(payload)
    }

    fun writeClipboardItem(
        clip: String,
        type: ClipType,
        encrypted: Boolean,
        label: String? = null,
        iv: String? = null,
        encMode: String? = null,
        originId: String? = null,
        sourceId: String? = null,
        sourceApp: String? = null,
    ): Long {
        lastWriteAuthFailure = false
        Log.i(logTag, "Writing to remote clipboard")
        if (userId == null || !isReady) {
            Log.w(
                logTag,
                "Failed to write to remote clipboard, service not ready or user not found."
            )
            return -1
        }
        if (isExpired) {
            Log.w(logTag, "Token expired, starting auth recovery.")
            val recovered = recoverAuthWithRetries()
            if (!recovered) {
                lastWriteAuthFailure = true
                return -1
            }
            Log.i(logTag, "Auth recovery succeeded for expired token")
        }
        val url = "$url/rest/v1/clipboard_items"
        val normalizedSourceId = sourceId?.trim()?.ifEmpty { null }
        val normalizedSourceApp = sourceApp?.trim()?.ifEmpty { null }
        val payload = JSONObject().apply {
            putIfNotBlank(JsonKey.TITLE, label)
            putIfNotBlank(JsonKey.DESCRIPTION, label)
            put(JsonKey.USER_ID, userId!!)
            put(JsonKey.MODIFIED, currentTime())
            put(JsonKey.OS, "android")
            put(JsonKey.DEVICE_ID, deviceId)
            put(JsonKey.ENCRYPTED, encrypted)
            putIfNotBlank(JsonKey.ORIGIN_ID, originId)
            putIfNotBlank(JsonKey.SOURCE_ID, normalizedSourceId)
            putIfNotBlank(JsonKey.SOURCE_APP, normalizedSourceApp)

            if (encrypted) {
                putIfNotBlank(JsonKey.IV, iv)
                putIfNotBlank(JsonKey.ENC_MODE_SNAKE, encMode)
            }

            when (type) {
                ClipType.Text -> {
                    put(JsonKey.TEXT, clip)
                    put(JsonKey.TYPE, "text")
                }
                ClipType.Email -> {
                    put(JsonKey.TEXT, clip)
                    put(JsonKey.TYPE, "text")
                    put(JsonKey.TEXT_CATEGORY, "email")
                }
                ClipType.Phone -> {
                    put(JsonKey.TEXT, clip)
                    put(JsonKey.TYPE, "text")
                    put(JsonKey.TEXT_CATEGORY, "phone")
                }
                ClipType.Url -> {
                    put(JsonKey.URL, clip)
                    put(JsonKey.TYPE, "url")
                }
                else -> {
                    put(JsonKey.TEXT, clip)
                    put(JsonKey.TYPE, "text")
                }
            }
        }

        val jsonPayload = payload.toString()
        Log.i(
            logTag,
            "Remote payload metadata: type=${type.name} sourceId=$normalizedSourceId sourceApp=$normalizedSourceApp originId=$originId",
        )
        val requestBody = jsonPayload.toRequestBody(contentType.toMediaTypeOrNull())

        val request = Request.Builder()
            .url(url)
            .addHeader("apikey", projectApiKey)
            .addHeader("Content-type", contentType)
            .addHeader("Authorization", "Bearer $accessToken")
            .addHeader("Prefer", "return=headers-only")
            .post(requestBody)
            .build()

        fun executeRequest(req: Request): Pair<Long, Int> {
            return client.newCall(req).execute().use { response ->
                if (response.code == 201) {
                    Log.i(
                        logTag,
                        "Remote write accepted (201). sourceId=$normalizedSourceId sourceApp=$normalizedSourceApp",
                    )
                    val location = response.header("location") ?: return Pair(-1, 201)
                    val match = regex.find(location) ?: return Pair(-1, 201)
                    Pair(match.value.toLong(), 201)
                } else {
                    val responseBody = response.body?.string()?.takeIf { it.isNotBlank() }
                    Log.w(
                        logTag,
                        "Failed to write clipboard item. code=${response.code} sourceId=$normalizedSourceId sourceApp=$normalizedSourceApp body=${responseBody ?: "<empty>"}",
                    )
                    Pair(-1, response.code)
                }
            }
        }

        return try {
            val (firstResult, firstCode) = executeRequest(request)
            if (firstResult > 0) {
                return firstResult
            }

            if (firstCode == 401 || firstCode == 403) {
                Log.w(logTag, "Auth rejected write ($firstCode). Starting auth recovery.")
                val recovered = recoverAuthWithRetries(forceRefresh = true)
                if (recovered) {
                    val retryRequest = Request.Builder()
                        .url(url)
                        .addHeader("apikey", projectApiKey)
                        .addHeader("Content-type", contentType)
                        .addHeader("Authorization", "Bearer $accessToken")
                        .addHeader("Prefer", "return=headers-only")
                        .post(requestBody)
                        .build()

                    val (retryResult, retryCode) = executeRequest(retryRequest)
                    if (retryResult > 0) {
                        return retryResult
                    }

                    if (retryCode == 401 || retryCode == 403) {
                        lastWriteAuthFailure = true
                    }
                } else {
                    lastWriteAuthFailure = true
                }
            }

            -1
        } catch (e: Exception) {
            Log.e(
                logTag,
                "Error writing clipboard item for sourceId=$normalizedSourceId sourceApp=$normalizedSourceApp: ${e.message}",
            )
            -1
        }
    }

}