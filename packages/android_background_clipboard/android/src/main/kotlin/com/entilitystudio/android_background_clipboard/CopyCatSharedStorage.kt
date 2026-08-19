package com.entilitystudio.android_background_clipboard

import android.content.Context
import android.content.Context.MODE_PRIVATE
import android.content.SharedPreferences.OnSharedPreferenceChangeListener
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Base64
import android.util.Log
import android.widget.Toast
import java.security.MessageDigest


class CopyCatSharedStorage private constructor(applicationContext: Context) {
    companion object {
        private const val DEFAULT_DONT_COPY_OVER_BYTES = 10 * 1024 * 1024
        private const val MODE1_ACK_TEXT_KEY = "mode1AckText"
        private const val NOTIFICATION_PAUSED_KEY = "notificationPaused"

        @Volatile
        private var instance: CopyCatSharedStorage? = null
        fun getInstance(applicationContext: Context): CopyCatSharedStorage {
            return instance ?: synchronized(this) {
                instance ?: CopyCatSharedStorage(applicationContext).also { instance = it }
            }
        }
    }

    private val appContext: Context = applicationContext
    private val logTag = "CopyCatSharedStorage"
    private val sp =
        applicationContext.getSharedPreferences("CopyCatSharedPreferences", MODE_PRIVATE)
    private var syncEnabled: Boolean = false
    private var listeningMode: String = ListeningMode.PUSH
    private var syncSpeed: String = "balanced"
    private var syncIntervalSeconds: Int = 45
    private var lanSyncEnabled: Boolean = false
    private var autoWriteOnReceive: Boolean = false
    private var dontCopyOverBytes: Int = DEFAULT_DONT_COPY_OVER_BYTES
    private lateinit var deviceId: String
    private var syncManager: CopyCatSyncManager = CopyCatSyncManager(
        appContext,
        onRemoteClipUpsert = ::ingestRemoteClip,
    )
    private var lanSyncManager: CopyCatLanSyncManager = CopyCatLanSyncManager(
        appContext,
        onLanClipReceived = ::ingestLanClip,
        onBeforeClipboardWrite = ::markClipboardWrite,
        decryptContent = ::decryptLanContent,
    )
    private var encryptor: CopyCatEncryptor? = null
    private val authSyncFailureTracker = CopyCatAuthSyncFailureTracker(appContext)
    private val mainHandler = Handler(Looper.getMainLooper())
    private val reconfigureRunnable = Runnable {
        syncManager.reconfigureConnections()
    }
    private var started: Boolean = false
    
    // Use file-based storage for clipboard items to avoid loading everything into memory
    private val fileStorage: CopyCatFileStorage = CopyCatFileStorage(appContext)
    
    val passwordManagers: Set<String> = setOf(
        "com.x8bit.bitwarden",
        "proton.android.pass",
        "com.lastpass.lpandroid",
        "com.onepassword.android",
    )

    var excludedPackages: Set<String> = emptySet()
    var strictCheck = true
    var showAckToast = true
    var clipboardFeedbackMode: String = "toast"
    var serviceEnabled: Boolean = false
    var excludePasswordManagers: Boolean = false
    var excludeEmail: Boolean = false
    var excludePhone: Boolean = false
    var useEncryptionNonce: Boolean = false
    var notificationPaused: Boolean = false
    var detectionMode: ClipboardDetectionMode = ClipboardDetectionMode.default()
    private var mode1AckText: String? = null
    private val detectionModeListeners = linkedSetOf<(ClipboardDetectionMode) -> Unit>()
    private val notificationPausedListeners = linkedSetOf<(Boolean) -> Unit>()
    private var remoteClipApplier: ((String) -> Unit)? = null
//    For Future Use
    var autoCopyOtp: Boolean = false

    private val latestClipLock = Any()
    private var lastClipHash: String? = null
    private val clipIdLock = Any()
    private var lastClipIdMs: Long = 0L

    /** Every capture is bytes; identical consecutive bytes are the same clip. */
    private fun contentHash(bytes: ByteArray): String =
        MessageDigest.getInstance("SHA-256").digest(bytes)
            .joinToString("") { "%02x".format(it) }

    /**
     * Records content this app is about to place on the OS clipboard so the
     * detection strategies treat the resulting change as already-captured
     * instead of a fresh user copy.
     */
    fun markClipboardWrite(bytes: ByteArray) {
        synchronized(latestClipLock) {
            lastClipHash = contentHash(bytes)
        }
    }

    val keystore: CopyCatKeyStore
        get() = CopyCatKeyStore.getInstance()

    private fun scheduleReconfigureConnections() {
        mainHandler.removeCallbacks(reconfigureRunnable)
        mainHandler.postDelayed(reconfigureRunnable, 300)
    }

    private val listener = OnSharedPreferenceChangeListener { sharedPreferences, key ->
        if (key == "excludedPackages") {
            excludedPackages = sharedPreferences.getStringSet(key, emptySet())!!
        }
        if (key == "strictCheck") {
            strictCheck = sharedPreferences.getBoolean(key, true)
        }
        if (key == "autoCopyOtp") {
            autoCopyOtp = sharedPreferences.getBoolean(key, false)
        }
        if (key == "showAckToast") {
            showAckToast = sharedPreferences.getBoolean(key, true)
            if (!sharedPreferences.contains("clipboardFeedbackMode")) {
                clipboardFeedbackMode = if (showAckToast) "toast" else "disabled"
            }
        }
        if (key == "clipboardFeedbackMode") {
            clipboardFeedbackMode = sharedPreferences.getString(key, "toast") ?: "toast"
        }
        if (key == BgPrefKey.SERVICE_ENABLED) {
            serviceEnabled = sharedPreferences.getBoolean(key, false)
        }
        if (key == BgPrefKey.SYNC_ENABLED) {
            syncEnabled = sharedPreferences.getBoolean(key, false)
            syncManager.syncEnabled = syncEnabled
            scheduleReconfigureConnections()
        }
        if (key == BgPrefKey.LISTENING_MODE) {
            listeningMode =
                sharedPreferences.getString(key, ListeningMode.PUSH) ?: ListeningMode.PUSH
            syncManager.listeningMode = listeningMode
            scheduleReconfigureConnections()
        }
        if (key == BgPrefKey.LAN_INSTANT_SYNC) {
            lanSyncEnabled = sharedPreferences.getBoolean(key, false)
            lanSyncManager.lanSyncEnabled = lanSyncEnabled
            lanSyncManager.reconfigure()
        }
        if (key == BgPrefKey.AUTO_WRITE_ON_RECEIVE) {
            autoWriteOnReceive = sharedPreferences.getBoolean(key, false)
            lanSyncManager.autoWriteOnReceive = autoWriteOnReceive
            syncManager.autoWriteOnReceive = autoWriteOnReceive
            scheduleReconfigureConnections()
        }
        if (key == BgPrefKey.DONT_COPY_OVER) {
            dontCopyOverBytes = sharedPreferences.getInt(key, DEFAULT_DONT_COPY_OVER_BYTES)
            lanSyncManager.maxAutoCopyBytes = dontCopyOverBytes
            debugLog(logTag) { "dontCopyOver updated to $dontCopyOverBytes bytes" }
        }
        if (key == BgPrefKey.SYNC_SPEED) {
            syncSpeed = sharedPreferences.getString(key, "balanced") ?: "balanced"
            syncManager.syncSpeed = syncSpeed
            scheduleReconfigureConnections()
        }
        if (key == BgPrefKey.SYNC_INTERVAL) {
            syncIntervalSeconds = sharedPreferences.getInt(key, 45)
            syncManager.syncIntervalSeconds = syncIntervalSeconds
            scheduleReconfigureConnections()
        }
        if (key == "exclude-pass-mgr") {
            excludePasswordManagers = sharedPreferences.getBoolean(key, false)
        }
        if (key == "exclude-email") {
            excludeEmail = sharedPreferences.getBoolean(key, false)
        }
        if (key == "exclude-phone") {
            excludePhone = sharedPreferences.getBoolean(key, false)
        }
        if (key == "useEncryptionNonce") {
            useEncryptionNonce = sharedPreferences.getBoolean(key, false)
        }
        if (key == NOTIFICATION_PAUSED_KEY) {
            notificationPaused = sharedPreferences.getBoolean(key, false)
            notifyNotificationPausedChanged()
        }
        if (key == "detectionMode") {
            val previousMode = detectionMode
            val modeValue = sharedPreferences.getString(key, ClipboardDetectionMode.default().value) ?: ClipboardDetectionMode.default().value
            detectionMode = ClipboardDetectionMode.fromString(modeValue) ?: ClipboardDetectionMode.default()
            maybeResetMode1Calibration(previousMode, detectionMode)
            debugLog(logTag) { "Detection mode changed to: ${detectionMode.value}" }
            notifyDetectionModeChanged()
        }
        if (key == MODE1_ACK_TEXT_KEY) {
            mode1AckText = sharedPreferences.getString(key, null)?.trim()?.takeIf { it.isNotEmpty() }
        }
        if (key == BgPrefKey.PROJECT_KEY) {
            readSecure(key)?.let {
                syncManager.projectKey = it
                scheduleReconfigureConnections()
            }
        }
        if (key == BgPrefKey.PROJECT_API_KEY) {
            readSecure(key)?.let {
                syncManager.projectApiKey = it
                scheduleReconfigureConnections()
            }
        }
        if (key == BgPrefKey.DEVICE_ID) {
            deviceId = sharedPreferences.getString(BgPrefKey.DEVICE_ID, "").toString()
            syncManager.deviceId = deviceId
            lanSyncManager.deviceId = deviceId
            scheduleReconfigureConnections()
        }

        if (key == BgPrefKey.E2E_KEY) {
            readSecure(key)?.let {
                setupEncryptor(it)
            }
        }
    }
    private fun setupEncryptor(key: String) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            try {
                val items = key.split("-+-", limit = 2)
                if (items.size != 2) {
                    throw IllegalArgumentException("Invalid e2e key format")
                }
                val secret = items[0]
                val iv = items[1]
                encryptor = CopyCatEncryptor(secret, iv)
            } catch (e: Exception) {
                Log.e(logTag, "Failed to initialize copycat encryptor. Warning: ")
                Log.e(logTag, e.toString())
                Toast.makeText(appContext, "Background Encryption Setup Failed", Toast.LENGTH_SHORT)
                    .show()
            }
        }
    }

    fun start() {
        if (started) {
            Log.i(logTag, "Storage already started; skipping duplicate start")
            return
        }
        readConfig()
        syncManager.start()
        // syncManager.start() loads auth token/userId; re-apply to LAN auth key
        // before accepting incoming LAN clips.
        lanSyncManager.userId = syncManager.currentUserId ?: ""
        lanSyncManager.start()
        sp.registerOnSharedPreferenceChangeListener(listener)
        started = true
        Log.i(logTag, "Storage started")
    }

    fun readSecure(key: String): String? {
        debugLog(logTag) { "Reading $key from secure storage" }
        val encrypted = sp.getString(key, "").toString()
        if (encrypted.isNotBlank()) {
            val decoded = Base64.decode(encrypted, Base64.DEFAULT)
            return try {
                keystore.decryptData(decoded)
            } catch (e: Exception) {
                Log.e(logTag, "KeyStore decryption failed for '$key' — key may require user auth or is corrupt: ${e.message}")
                null
            }
        }
        debugLog(logTag) { "$key not found in secure storage" }
        return null
    }

    fun clear() {
        debugLog(logTag) { "Clearing storage" }
        mainHandler.removeCallbacks(reconfigureRunnable)
        fileStorage.clearAll()
        sp.edit().clear().apply()
    }

    fun writeSecure(key: String, value: String) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            debugLog(logTag) { "Writing $key to secure storage" }
            val encrypted = keystore.encryptData(value)
            val encoded = Base64.encodeToString(encrypted, Base64.DEFAULT)
            val editor = sp.edit()
            editor.putString(key, encoded)
            editor.apply()
        }
    }

    private fun readConfig() {
        debugLog(logTag) { "Reading initial setup configs" }
        syncEnabled = sp.getBoolean(BgPrefKey.SYNC_ENABLED, false)
        listeningMode = sp.getString(BgPrefKey.LISTENING_MODE, ListeningMode.PUSH) ?: ListeningMode.PUSH
        syncSpeed = sp.getString(BgPrefKey.SYNC_SPEED, "balanced") ?: "balanced"
        syncIntervalSeconds = sp.getInt(BgPrefKey.SYNC_INTERVAL, 45)
        deviceId = sp.getString(BgPrefKey.DEVICE_ID, "").toString()

        excludedPackages = sp.getStringSet("excludedPackages", emptySet())!!
        strictCheck = sp.getBoolean("strictCheck", true)
        autoCopyOtp = sp.getBoolean("autoCopyOtp", false)
        showAckToast = sp.getBoolean("showAckToast", true)
        clipboardFeedbackMode = sp.getString("clipboardFeedbackMode", null)
            ?.takeIf { it.isNotBlank() }
            ?: if (showAckToast) "toast" else "disabled"
        serviceEnabled = sp.getBoolean(BgPrefKey.SERVICE_ENABLED, false)
        excludePasswordManagers = sp.getBoolean("exclude-pass-mgr", false)
        excludeEmail = sp.getBoolean("exclude-email", false)
        excludePhone = sp.getBoolean("exclude-phone", false)
        useEncryptionNonce = sp.getBoolean("useEncryptionNonce", false)
        notificationPaused = sp.getBoolean(NOTIFICATION_PAUSED_KEY, false)
        mode1AckText = sp.getString(MODE1_ACK_TEXT_KEY, null)?.trim()?.takeIf { it.isNotEmpty() }
        
        val modeValue = sp.getString("detectionMode", ClipboardDetectionMode.default().value) ?: ClipboardDetectionMode.default().value
        detectionMode = ClipboardDetectionMode.fromString(modeValue) ?: ClipboardDetectionMode.default()
        if (detectionMode == ClipboardDetectionMode.MODE_INACTIVE && notificationPaused) {
            notificationPaused = false
            sp.edit().putBoolean(NOTIFICATION_PAUSED_KEY, false).apply()
        }

        readSecure(BgPrefKey.PROJECT_KEY)?.let {
            syncManager.projectKey = it
        }
        readSecure(BgPrefKey.PROJECT_API_KEY)?.let {
            syncManager.projectApiKey = it
        }
        readSecure(BgPrefKey.E2E_KEY)?.let {
            setupEncryptor(it)
        }

        syncManager.deviceId = deviceId
        syncManager.syncEnabled = syncEnabled
        syncManager.listeningMode = listeningMode
        syncManager.syncSpeed = syncSpeed
        syncManager.syncIntervalSeconds = syncIntervalSeconds

        lanSyncEnabled = sp.getBoolean(BgPrefKey.LAN_INSTANT_SYNC, false)
        lanSyncManager.lanSyncEnabled = lanSyncEnabled
        lanSyncManager.deviceId = deviceId
        // userId is available after token is loaded; set it lazily in ingestLanClip too
        lanSyncManager.userId = syncManager.currentUserId ?: ""

        autoWriteOnReceive = sp.getBoolean(BgPrefKey.AUTO_WRITE_ON_RECEIVE, false)
        lanSyncManager.autoWriteOnReceive = autoWriteOnReceive
        syncManager.autoWriteOnReceive = autoWriteOnReceive

        dontCopyOverBytes = sp.getInt(BgPrefKey.DONT_COPY_OVER, DEFAULT_DONT_COPY_OVER_BYTES)
        lanSyncManager.maxAutoCopyBytes = dontCopyOverBytes
    }
    
    /**
     * Allocates a clip ID from the wall clock, stepping forward by 1ms when the
     * clock has not advanced so bursts and clock skew still produce unique IDs.
     */
    private fun getNextId(): String {
        synchronized(clipIdLock) {
            val now = System.currentTimeMillis()
            lastClipIdMs = if (now > lastClipIdMs) now else lastClipIdMs + 1
            return "Clip-$lastClipIdMs"
        }
    }

    fun write(key: String, value: Any) {
        debugLog(logTag) { "Writing $key = $value to storage" }
        if (key == "detectionMode" && value is String) {
            val previousMode = ClipboardDetectionMode.fromString(
                sp.getString(key, detectionMode.value) ?: detectionMode.value,
            ) ?: detectionMode
            val nextMode = ClipboardDetectionMode.fromString(value) ?: ClipboardDetectionMode.default()
            maybeResetMode1Calibration(previousMode, nextMode)
            if (nextMode == ClipboardDetectionMode.MODE_INACTIVE && notificationPaused) {
                updateNotificationPaused(false)
            }
        }
        if (key == "clipboardFeedbackMode" && value is String) {
            clipboardFeedbackMode = value
        }
        val editor = sp.edit()
        when (value) {
            is String -> {
                if (key.startsWith("<set>")) {
                    editor.putStringSet(key.substring(5), value.split(",").toSet())
                } else {
                    editor.putString(key, value)
                }
            }

            is Int -> {
                editor.putInt(key, value)
            }

            is Boolean -> {
                editor.putBoolean(key, value)
            }
        }
        editor.apply()
    }

    fun addDetectionModeListener(listener: (ClipboardDetectionMode) -> Unit) {
        detectionModeListeners.add(listener)
    }

    fun addNotificationPausedListener(listener: (Boolean) -> Unit) {
        notificationPausedListeners.add(listener)
    }

    fun getMode1AckText(): String? = mode1AckText

    fun writeMode1AckText(value: String) {
        val normalizedValue = value.trim()
        if (normalizedValue.isEmpty()) {
            return
        }

        mode1AckText = normalizedValue
        write(MODE1_ACK_TEXT_KEY, normalizedValue)
    }

    fun updateNotificationPaused(value: Boolean) {
        if (notificationPaused == value && sp.contains(NOTIFICATION_PAUSED_KEY)) {
            return
        }

        notificationPaused = value
        write(NOTIFICATION_PAUSED_KEY, value)
    }

    private fun maybeResetMode1Calibration(
        previousMode: ClipboardDetectionMode,
        nextMode: ClipboardDetectionMode,
    ) {
        if (
            previousMode == ClipboardDetectionMode.MODE_1_ACK_TEXT &&
            nextMode == ClipboardDetectionMode.MODE_INACTIVE
        ) {
            clearMode1AckText()
        }
    }

    fun clearMode1AckText() {
        if (mode1AckText == null && !sp.contains(MODE1_ACK_TEXT_KEY)) {
            return
        }

        mode1AckText = null
        sp.edit().remove(MODE1_ACK_TEXT_KEY).apply()
    }

    fun removeDetectionModeListener(listener: (ClipboardDetectionMode) -> Unit) {
        detectionModeListeners.remove(listener)
    }

    fun removeNotificationPausedListener(listener: (Boolean) -> Unit) {
        notificationPausedListeners.remove(listener)
    }

    private fun notifyDetectionModeChanged() {
        detectionModeListeners.toList().forEach { listener ->
            listener(detectionMode)
        }
    }

    private fun notifyNotificationPausedChanged() {
        notificationPausedListeners.toList().forEach { listener ->
            listener(notificationPaused)
        }
    }

    fun read(key: String, type: String): Any? {
        debugLog(logTag) { "Reading $key of type $type from storage" }
        return when (type) {
            "string" -> sp.getString(key, "")
            "int" -> sp.getInt(key, 0)
            "bool" -> if (sp.contains(key)) sp.getBoolean(key, false) else null
            "set" -> sp.getStringSet(key, emptySet<String>())
            else -> null
        }
    }

    fun delete(keys: Iterable<String>) {
        val editor = sp.edit()
        for (key in keys) {
            if (key.startsWith("Clip-")) {
                fileStorage.deleteClipItem(key)
            } else {
                editor.remove(key)
            }
        }
        editor.apply()
    }

    fun readClip(key: String): CopyCatFileStorage.ClipData? {
        debugLog(logTag) { "Reading clip $key from file storage" }
        return fileStorage.readClipItem(key)
    }

    fun readAllClips(): List<CopyCatFileStorage.ClipData> {
        return fileStorage.readAllClips()
    }

    fun writeTextClip(
        text: String,
        type: ClipType,
        label: String = "",
        sourceId: String = "",
        sourceApp: String? = null,
    ) {
        writeTextClipIfLatestMissing(
            text = text,
            type = type,
            label = label,
            sourceId = sourceId,
            sourceApp = sourceApp,
        )
    }

    fun writeTextClipIfLatestMissing(
        text: String,
        type: ClipType,
        label: String = "",
        sourceId: String = "",
        sourceApp: String? = null,
    ): CopyCatFileStorage.ClipWriteOutcome {
        if (!serviceEnabled) return CopyCatFileStorage.ClipWriteOutcome.Failed

        var contentToPersist = text
        var encrypted = false
        var iv: String? = null
        var encMode: String? = null

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && encryptor != null) {
            val result = encryptor?.encrypt(
                text,
                if (useEncryptionNonce) EncryptionMode.GCM else EncryptionMode.CFB,
            )
            if (result != null) {
                contentToPersist = result.content
                encrypted = true
                iv = result.iv
                encMode = result.mode
            }
        }
        
        val rawHash = contentHash(text.toByteArray())
        var nextId = ""
        var originId = ""

        val writeResult = synchronized(latestClipLock) {
            if (lastClipHash == rawHash) {
                return@synchronized CopyCatFileStorage.ClipWriteOutcome.Duplicate
            }

            nextId = getNextId()
            originId = generateOriginId()

            val success = fileStorage.writeClipItem(
                clipId = nextId,
                text = contentToPersist,
                type = type,
                label = label,
                encrypted = encrypted,
                iv = iv,
                encMode = encMode,
                originId = originId,
                sourceId = sourceId,
                sourceApp = sourceApp ?: "",
            )

            if (!success) {
                Log.e(logTag, "Failed to write clip to file storage")
                return@synchronized CopyCatFileStorage.ClipWriteOutcome.Failed
            }

            lastClipHash = rawHash
            CopyCatFileStorage.ClipWriteOutcome.Written(nextId)
        }

        if (writeResult is CopyCatFileStorage.ClipWriteOutcome.Duplicate) {
            debugLog(logTag) { "Skipping duplicate latest clip" }
            return writeResult
        }

        if (writeResult is CopyCatFileStorage.ClipWriteOutcome.Failed) {
            return writeResult
        }

        debugLog(logTag) { "Wrote $nextId to file storage (${contentToPersist.length} bytes)" }
        
        // Broadcast to LAN peers
        // Lazily sync userId in case the token loaded after start().
        if (lanSyncManager.userId.isBlank()) {
            val uid = syncManager.currentUserId ?: ""
            if (uid.isNotBlank()) lanSyncManager.userId = uid
        }
        lanSyncManager.broadcastTextClip(
            originId = originId,
            type = type,
            content = contentToPersist,
            label = label,
            encrypted = encrypted,
            iv = iv,
            encMode = encMode,
            sourceId = sourceId,
            sourceApp = sourceApp,
        )

        // Sync to server if enabled
        if (syncEnabled) {
            writeTextClipToServer(
                text = contentToPersist,
                type = type,
                clipId = nextId,
                encrypted = encrypted,
                label = label,
                iv = iv,
                encMode = encMode,
                originId = originId,
                sourceId = sourceId,
                sourceApp = sourceApp,
            )
        }
        return writeResult
    }
    
    private fun writeTextClipToServer(
        text: String,
        type: ClipType,
        clipId: String,
        encrypted: Boolean,
        label: String? = null,
        iv: String? = null,
        encMode: String? = null,
        originId: String? = null,
        sourceId: String? = null,
        sourceApp: String? = null,
    ) {
        Log.i(logTag, "Writing text clip to server")
        if (!syncEnabled || !serviceEnabled) {
            Log.i(logTag, "Sync Disabled or Service is not enabled.")
            return
        }

        if (syncManager.isStopped) {
            Log.w(logTag, "Sync service not running, trying to restart it.")

            syncManager.start()

            if (syncManager.isStopped) {
                Log.e(logTag, "Sync Service cannot start.")
                return
            }
        }

        try {
            val serverId = syncManager.writeClipboardItem(
                clip = text,
                type = type,
                encrypted = encrypted,
                label = label,
                iv = iv,
                encMode = encMode,
                originId = originId,
                sourceId = sourceId,
                sourceApp = sourceApp,
            )
            if (serverId != (-1).toLong()) {
                debugLog(logTag) { "Synced $clipId to server with ID $serverId" }
                // Update the file metadata with server ID and user ID
                fileStorage.updateServerMetadata(clipId, serverId, syncManager.currentUserId ?: "")
                authSyncFailureTracker.onSyncSuccess()
                return
            }
            if (syncManager.consumeLastWriteAuthFailure()) {
                authSyncFailureTracker.onAuthFailure()
            }
            Log.w(logTag, "Syncing failed")
        } catch (e: Exception) {
            Log.e(logTag, "Error while syncing clip $e")
        }
    }

    /**
     * Saves [data] to a cache file, persists a file-type clip entry to file
     * storage, and broadcasts the binary to LAN peers.  Call this when the
     * Android clipboard service captures a media/file item from the OS
     * clipboard so it is visible in the CopyCat history and synced over LAN.
     */
    fun writeBinaryClip(
        data: ByteArray,
        mimeType: String,
        ext: String,
        fileName: String,
        sourceId: String = "",
        sourceApp: String? = null,
    ): CopyCatFileStorage.ClipWriteOutcome {
        if (!serviceEnabled) return CopyCatFileStorage.ClipWriteOutcome.Failed

        val rawHash = contentHash(data)
        var originId = ""
        var nextId = ""

        val writeResult = synchronized(latestClipLock) {
            if (lastClipHash == rawHash) {
                return@synchronized CopyCatFileStorage.ClipWriteOutcome.Duplicate
            }

            originId = generateOriginId()

            // Persist bytes to a per-clip cache file so localPath survives across
            // app restarts (the file is small enough that cache eviction is rare).
            val cacheDir = java.io.File(appContext.cacheDir, "media_clips").also { it.mkdirs() }
            val cacheFile = java.io.File(cacheDir, "$originId.$ext")
            try {
                cacheFile.writeBytes(data)
            } catch (e: Exception) {
                Log.e(logTag, "writeBinaryClip: failed to write cache file — ${e.message}")
                return@synchronized CopyCatFileStorage.ClipWriteOutcome.Failed
            }

            nextId = getNextId()

            val success = fileStorage.writeClipItem(
                clipId = nextId,
                text = cacheFile.absolutePath,
                type = ClipType.FileUrl,
                label = fileName,
                encrypted = false,
                originId = originId,
                sourceId = sourceId,
                sourceApp = sourceApp ?: "",
            )
            if (!success) {
                Log.e(logTag, "writeBinaryClip: failed to persist to file storage")
                return@synchronized CopyCatFileStorage.ClipWriteOutcome.Failed
            }

            lastClipHash = rawHash
            CopyCatFileStorage.ClipWriteOutcome.Written(nextId)
        }

        when (writeResult) {
            is CopyCatFileStorage.ClipWriteOutcome.Duplicate -> {
                debugLog(logTag) { "writeBinaryClip: skipping duplicate latest clip" }
                return writeResult
            }

            is CopyCatFileStorage.ClipWriteOutcome.Failed -> return writeResult

            is CopyCatFileStorage.ClipWriteOutcome.Written -> Unit
        }

        // Lazily sync userId
        if (lanSyncManager.userId.isBlank()) {
            val uid = syncManager.currentUserId ?: ""
            if (uid.isNotBlank()) lanSyncManager.userId = uid
        }
        lanSyncManager.broadcastBinaryClip(
            originId = originId,
            type = ClipType.FileUrl,
            data = data,
            mimeType = mimeType,
            ext = ext,
            fileName = fileName,
            sourceId = sourceId,
            sourceApp = sourceApp,
        )

        debugLog(logTag) { "writeBinaryClip: persisted $nextId and broadcast $mimeType clip (${ data.size } bytes)" }
        return writeResult
    }

    /**
     * Broadcasts a foreground-captured clip to LAN peers by routing directly
     * through the already-running [CopyCatLanSyncManager].
     *
     * Called from Flutter (foreground app) via method channel so that Android
     * foreground clips participate in instant-LAN-sync without needing to go
     * through the background service's capture pipeline.
     *
     * [data] keys: originId, type (text|url|media|file), content, label,
     * encrypted, iv?, encMode?, sourceId?, sourceApp?,
     * localPath? (for media/file), fileMimeType?, fileExtension?, fileName?
     */
    fun broadcastForegroundClip(data: Map<String, Any?>) {
        val typeStr = data["type"] as? String ?: return
        val originId = data["originId"] as? String ?: return
        val label = data["label"] as? String ?: ""
        val encrypted = data["encrypted"] as? Boolean ?: false
        val iv = data["iv"] as? String
        val encMode = data["encMode"] as? String
        val sourceId = data["sourceId"] as? String
        val sourceApp = data["sourceApp"] as? String

        // Lazily propagate userId in case the token loaded after service start.
        if (lanSyncManager.userId.isBlank()) {
            val uid = syncManager.currentUserId ?: ""
            if (uid.isNotBlank()) lanSyncManager.userId = uid
        }

        when (typeStr) {
            "text", "url" -> {
                val content = data["content"] as? String ?: return
                val type = if (typeStr == "url") ClipType.Url else ClipType.Text
                lanSyncManager.broadcastTextClip(
                    originId = originId,
                    type = type,
                    content = content,
                    label = label,
                    encrypted = encrypted,
                    iv = iv,
                    encMode = encMode,
                    sourceId = sourceId,
                    sourceApp = sourceApp,
                )
            }
            "media", "file" -> {
                val localPath = data["localPath"] as? String ?: return
                val mimeType = data["fileMimeType"] as? String ?: "*/*"
                val ext = data["fileExtension"] as? String ?: ""
                val fileName = data["fileName"] as? String ?: ""
                val fileBytes = try {
                    java.io.File(localPath).readBytes()
                } catch (e: Exception) {
                    Log.w(logTag, "broadcastForegroundClip: cannot read $localPath: ${e.message}")
                    return
                }
                lanSyncManager.broadcastBinaryClip(
                    originId = originId,
                    type = ClipType.FileUrl,
                    data = fileBytes,
                    mimeType = mimeType,
                    ext = ext,
                    fileName = fileName,
                    sourceId = sourceId,
                    sourceApp = sourceApp,
                )
            }
        }
    }

    fun clean() {
        if (!started) {
            Log.i(logTag, "Storage already cleaned; skipping duplicate clean")
            return
        }
        mainHandler.removeCallbacks(reconfigureRunnable)
        syncManager.stop()
        lanSyncManager.stop()
        sp.unregisterOnSharedPreferenceChangeListener(listener)
        
        // Clear references to help GC
        encryptor = null
        remoteClipApplier = null
        started = false
        
        Log.i(logTag, "Storage cleaned up")
    }

    fun setRemoteClipApplier(applier: ((String) -> Unit)?) {
        remoteClipApplier = applier
    }

    fun getDetectionStrategy(): ClipboardDetectionStrategy {
        return when (detectionMode) {
            ClipboardDetectionMode.MODE_INACTIVE -> ModeInactiveStrategy()
            ClipboardDetectionMode.MODE_1_ACK_TEXT ->
                Mode1AckTextStrategy(initialAckText = mode1AckText)
            ClipboardDetectionMode.MODE_2_AGGRESSIVE -> Mode2AggressiveStrategy()
        }
    }

    private fun decryptRemoteContent(clip: RemoteClipPayload): String? {
        if (!clip.encrypted) return clip.content
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O || encryptor == null) {
            Log.w(logTag, "Encrypted remote clip skipped: encryptor unavailable")
            return null
        }

        return try {
            encryptor?.decrypt(
                clip.content,
                clip.encMode ?: EncryptionMode.CFB,
                clip.iv,
            )
        } catch (e: Exception) {
            Log.w(logTag, "Failed to decrypt remote clip: ${e.message}")
            null
        }
    }

    private fun decryptLanContent(content: String, encMode: String?, iv: String?): String? {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O || encryptor == null) {
            Log.w(logTag, "Encrypted LAN clip cannot be written to clipboard: encryptor unavailable")
            mainHandler.post {
                Toast.makeText(appContext, "CopyCat: Encryption key not ready - clip not copied", Toast.LENGTH_SHORT).show()
            }
            return null
        }
        return try {
            encryptor?.decrypt(content, encMode ?: EncryptionMode.CFB, iv)
        } catch (e: Exception) {
            Log.w(logTag, "Failed to decrypt LAN clip: ${e.message}")
            mainHandler.post {
                Toast.makeText(appContext, "CopyCat: Failed to decrypt clip - not copied to clipboard", Toast.LENGTH_SHORT).show()
            }
            null
        }
    }

    private fun ingestRemoteClip(clip: RemoteClipPayload) {
        if (!serviceEnabled || !syncEnabled) return

        if (clip.type == ClipType.FileUrl) {
            // Binary clips should arrive through LAN binary sync, not the text
            // realtime channel. Skip to avoid persisting invalid text payloads.
            Log.i(logTag, "Skipping remote file/media upsert serverId=${clip.serverId}")
            return
        }

        Log.i(
            logTag,
            "ingestRemoteClip serverId=${clip.serverId} type=${clip.type} encrypted=${clip.encrypted} hasApplier=${remoteClipApplier != null}"
        )

        // originId is the durable identity; legacy rows without one are
        // reconciled by serverId in the Flutter layer.
        val clipId = clip.originId?.takeIf { it.isNotBlank() }
            ?.let { fileStorage.findClipIdByOriginId(it) }
            ?: getNextId()

        fileStorage.writeClipItem(
            clipId = clipId,
            text = clip.content,
            type = clip.type,
            label = clip.label ?: "",
            encrypted = clip.encrypted,
            iv = clip.iv,
            encMode = clip.encMode,
            serverId = clip.serverId,
            userId = clip.userId ?: "",
            timestamp = clip.modifiedAt,
            originId = clip.originId ?: "",
        )

        val decryptedContent = decryptRemoteContent(clip) ?: return
        Log.i(logTag, "Applying remote clip to system clipboard")
        remoteClipApplier?.invoke(decryptedContent)
    }

    /** Called by [CopyCatLanSyncManager] when a clip arrives from a LAN peer. */
    private fun ingestLanClip(payload: LanClipPayload) {
        if (!serviceEnabled) return

        // Lazily sync userId into CopyCatLanSyncManager once the token is loaded.
        val uid = syncManager.currentUserId ?: ""
        if (lanSyncManager.userId.isBlank() && uid.isNotBlank()) {
            lanSyncManager.userId = uid
        }

        debugLog(logTag) {
            "LAN: processed clip from ${payload.fromDeviceId} with originId ${payload.originId} and type ${payload.type.name.lowercase()}"
        }

        val existingClipId = payload.originId.takeIf { it.isNotBlank() }
            ?.let { fileStorage.findClipIdByOriginId(it) }

        if (payload.deleted) {
            val targetClipId = existingClipId ?: getNextId()
            val tombstoneTimestamp = payload.deletedAtMs ?: payload.timestamp
            val writeSuccess = fileStorage.writeClipItem(
                clipId = targetClipId,
                text = payload.content,
                type = payload.type,
                label = payload.label,
                encrypted = payload.encrypted,
                iv = payload.iv,
                encMode = payload.encMode,
                serverId = payload.serverId ?: -1,
                userId = payload.userId ?: "",
                timestamp = payload.timestamp,
                originId = payload.originId,
                sourceId = payload.sourceId ?: "",
                sourceApp = payload.sourceApp ?: "",
                deletedAt = tombstoneTimestamp,
            )

            if (writeSuccess) {
                LanClipReceivedReporter.getInstance().signal(targetClipId)
                debugLog(logTag) {
                    "LAN: tombstoned clip originId=${payload.originId} serverId=${payload.serverId} clipId=$targetClipId"
                }
            } else {
                Log.e(logTag, "Failed to persist LAN tombstone originId=${payload.originId}")
            }
            return
        }

        val clipId = existingClipId ?: getNextId()

        // Media/file mutations (title edits etc.) arrive with neither a path nor
        // content; keep whatever is already stored so the clip stays playable.
        val text = payload.localFilePath
            ?: payload.content.takeIf { it.isNotBlank() }
            ?: existingClipId?.let { fileStorage.readClipItem(it)?.text }
            ?: ""
        val isFileClip = payload.localFilePath != null ||
            (payload.content.isBlank() && text.isNotBlank())

        val written = fileStorage.writeClipItem(
            clipId = clipId,
            text = text,
            type = payload.type,
            label = if (isFileClip) {
                payload.fileName?.takeIf { it.isNotBlank() } ?: payload.label
            } else {
                payload.label
            },
            encrypted = if (isFileClip) false else payload.encrypted,
            iv = if (isFileClip) null else payload.iv,
            encMode = if (isFileClip) null else payload.encMode,
            serverId = payload.serverId ?: -1,
            userId = payload.userId ?: "",
            timestamp = payload.timestamp,
            originId = payload.originId,
            sourceId = payload.sourceId ?: "",
            sourceApp = payload.sourceApp ?: "",
            deletedAt = null,
        )

        if (written) {
            LanClipReceivedReporter.getInstance().signal(clipId)
        } else {
            Log.e(logTag, "Failed to persist LAN clip originId=${payload.originId}")
        }
    }
}