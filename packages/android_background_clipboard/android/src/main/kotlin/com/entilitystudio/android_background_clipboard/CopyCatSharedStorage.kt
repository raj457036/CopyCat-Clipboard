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
    private var endId: Int = -1
    private var syncManager: CopyCatSyncManager = CopyCatSyncManager(
        appContext,
        onRemoteClipUpsert = ::ingestRemoteClip,
        onRemoteClipDelete = ::deleteRemoteClip,
    )
    private var lanSyncManager: CopyCatLanSyncManager = CopyCatLanSyncManager(
        appContext,
        onLanClipReceived = ::ingestLanClip,
        markCaptured = ::markCapturedByOriginId,
    )
    private var encryptor: CopyCatEncryptor? = null
    private val mainHandler = Handler(Looper.getMainLooper())
    private val reconfigureRunnable = Runnable {
        syncManager.reconfigureConnections()
    }
    private val persistEndIdRunnable = Runnable {
        sp.edit().putInt("endId", endId).apply()
    }
    
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

    val keystore: CopyCatKeyStore
        get() = CopyCatKeyStore.getInstance()

    private fun scheduleReconfigureConnections() {
        mainHandler.removeCallbacks(reconfigureRunnable)
        mainHandler.postDelayed(reconfigureRunnable, 300)
    }

    private fun schedulePersistEndId() {
        mainHandler.removeCallbacks(persistEndIdRunnable)
        mainHandler.postDelayed(persistEndIdRunnable, 300)
    }

    private fun commitEndId(nextEndId: Int) {
        endId = nextEndId
        schedulePersistEndId()
    }

    private fun flushPersistEndId() {
        mainHandler.removeCallbacks(persistEndIdRunnable)
        sp.edit().putInt("endId", endId).apply()
    }

    private val listener = OnSharedPreferenceChangeListener { sharedPreferences, key ->
        if (key == "endId") {
            val spEndId = sharedPreferences.getInt(key, -1)
            // When Flutter resets endId (e.g. after syncStates()), sync the
            // in-memory value and cancel any pending deferred write so it
            // cannot overwrite the reset and cause stale clip-range reads.
            if (spEndId < endId) {
                mainHandler.removeCallbacks(persistEndIdRunnable)
                endId = spEndId
            }
        }
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
        }
        if (key == "serviceEnabled") {
            serviceEnabled = sharedPreferences.getBoolean(key, false)
        }
        if (key == "syncEnabled") {
            syncEnabled = sharedPreferences.getBoolean(key, false)
            syncManager.syncEnabled = syncEnabled
            scheduleReconfigureConnections()
        }
        if (key == "listeningMode") {
            listeningMode =
                sharedPreferences.getString(key, ListeningMode.PUSH) ?: ListeningMode.PUSH
            syncManager.listeningMode = listeningMode
            scheduleReconfigureConnections()
        }
        if (key == "lanInstantSync") {
            lanSyncEnabled = sharedPreferences.getBoolean(key, false)
            lanSyncManager.lanSyncEnabled = lanSyncEnabled
            lanSyncManager.reconfigure()
        }
        if (key == "autoWriteOnReceive") {
            autoWriteOnReceive = sharedPreferences.getBoolean(key, false)
            lanSyncManager.autoWriteOnReceive = autoWriteOnReceive
            syncManager.autoWriteOnReceive = autoWriteOnReceive
            scheduleReconfigureConnections()
        }
        if (key == "dontCopyOver") {
            dontCopyOverBytes = sharedPreferences.getInt(key, DEFAULT_DONT_COPY_OVER_BYTES)
            lanSyncManager.maxAutoCopyBytes = dontCopyOverBytes
            debugLog(logTag) { "dontCopyOver updated to $dontCopyOverBytes bytes" }
        }
        if (key == "syncSpeed") {
            syncSpeed = sharedPreferences.getString(key, "balanced") ?: "balanced"
            syncManager.syncSpeed = syncSpeed
            scheduleReconfigureConnections()
        }
        if (key == "syncInterval") {
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
        if (key == "projectKey") {
            readSecure(key)?.let {
                syncManager.projectKey = it
                scheduleReconfigureConnections()
            }
        }
        if (key == "projectApiKey") {
            readSecure(key)?.let {
                syncManager.projectApiKey = it
                scheduleReconfigureConnections()
            }
        }
        if (key == "deviceId") {
            deviceId = sharedPreferences.getString("deviceId", "").toString()
            syncManager.deviceId = deviceId
            lanSyncManager.deviceId = deviceId
            scheduleReconfigureConnections()
        }

        if (key == "e2e_key") {
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
        readConfig()
        syncManager.start()
        // syncManager.start() loads auth token/userId; re-apply to LAN auth key
        // before accepting incoming LAN clips.
        lanSyncManager.userId = syncManager.currentUserId ?: ""
        lanSyncManager.start()
        sp.registerOnSharedPreferenceChangeListener(listener)
        Log.i(logTag, "Storage started")
    }

    fun readSecure(key: String): String? {
        debugLog(logTag) { "Reading $key from secure storage" }
        val encrypted = sp.getString(key, "").toString()
        if (encrypted.isNotBlank()) {
            val decoded = Base64.decode(encrypted, Base64.DEFAULT)
            return keystore.decryptData(decoded)
        }
        debugLog(logTag) { "$key not found in secure storage" }
        return null
    }

    fun clear() {
        debugLog(logTag) { "Clearing storage" }
        mainHandler.removeCallbacks(reconfigureRunnable)
        mainHandler.removeCallbacks(persistEndIdRunnable)
        fileStorage.clearAll()
        sp.edit().clear().apply()
        endId = -1
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
        syncEnabled = sp.getBoolean("syncEnabled", false)
        listeningMode = sp.getString("listeningMode", ListeningMode.PUSH) ?: ListeningMode.PUSH
        syncSpeed = sp.getString("syncSpeed", "balanced") ?: "balanced"
        syncIntervalSeconds = sp.getInt("syncInterval", 45)
        deviceId = sp.getString("deviceId", "").toString()
        endId = maxOf(sp.getInt("endId", -1), fileStorage.getMaxClipIndex())

        excludedPackages = sp.getStringSet("excludedPackages", emptySet())!!
        strictCheck = sp.getBoolean("strictCheck", true)
        autoCopyOtp = sp.getBoolean("autoCopyOtp", false)
        showAckToast = sp.getBoolean("showAckToast", true)
        serviceEnabled = sp.getBoolean("serviceEnabled", false)
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

        readSecure("projectKey")?.let {
            syncManager.projectKey = it
        }
        readSecure("projectApiKey")?.let {
            syncManager.projectApiKey = it
        }
        readSecure("e2e_key")?.let {
            setupEncryptor(it)
        }

        syncManager.deviceId = deviceId
        syncManager.syncEnabled = syncEnabled
        syncManager.listeningMode = listeningMode
        syncManager.syncSpeed = syncSpeed
        syncManager.syncIntervalSeconds = syncIntervalSeconds

        lanSyncEnabled = sp.getBoolean("lanInstantSync", false)
        lanSyncManager.lanSyncEnabled = lanSyncEnabled
        lanSyncManager.deviceId = deviceId
        // userId is available after token is loaded; set it lazily in ingestLanClip too
        lanSyncManager.userId = syncManager.currentUserId ?: ""

        autoWriteOnReceive = sp.getBoolean("autoWriteOnReceive", false)
        lanSyncManager.autoWriteOnReceive = autoWriteOnReceive
        syncManager.autoWriteOnReceive = autoWriteOnReceive

        dontCopyOverBytes = sp.getInt("dontCopyOver", DEFAULT_DONT_COPY_OVER_BYTES)
        lanSyncManager.maxAutoCopyBytes = dontCopyOverBytes
    }
    
    private fun getNextId(): String {
        return "Clip-${endId + 1}"
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

    fun readClipBatch(startInclusive: Int, endInclusive: Int): List<CopyCatFileStorage.ClipData> {
        if (startInclusive > endInclusive) return emptyList()

        val clips = mutableListOf<CopyCatFileStorage.ClipData>()
        for (index in startInclusive..endInclusive) {
            val clipId = "Clip-$index"
            val clip = fileStorage.readClipItem(clipId)
            if (clip != null) {
                clips.add(clip)
            }
        }

        return clips
    }

    fun writeTextClip(
        text: String,
        type: ClipType,
        label: String = "",
        sourceId: String = "",
        sourceApp: String? = null,
    ) {
        if (!serviceEnabled) return

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
        
        // Get next clip ID (e.g., "Clip-1") for local file storage.
        val nextId = getNextId()
        // Globally unique 8-char ID for LAN/Supabase dedup — separate from the file storage ID.
        val originId = generateOriginId()
        
        // Write to file storage instead of SharedPreferences to avoid memory bloat
        val success = fileStorage.writeClipItem(
            nextId,
            contentToPersist,
            type,
            label,
            encrypted,
            iv,
            encMode,
            sourceId = sourceId,
            sourceApp = sourceApp ?: "",
        )
        
        if (!success) {
            Log.e(logTag, "Failed to write clip to file storage")
            return
        }
        commitEndId(endId + 1)
        
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
                return
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
    ) {
        if (!serviceEnabled) return

        val originId = generateOriginId()

        // Persist bytes to a per-clip cache file so localPath survives across
        // app restarts (the file is small enough that cache eviction is rare).
        val cacheDir = java.io.File(appContext.cacheDir, "media_clips").also { it.mkdirs() }
        val cacheFile = java.io.File(cacheDir, "$originId.$ext")
        try {
            cacheFile.writeBytes(data)
        } catch (e: Exception) {
            Log.e(logTag, "writeBinaryClip: failed to write cache file — ${e.message}")
            return
        }

        val nextId = getNextId()

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
            return
        }
        commitEndId(endId + 1)

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
        flushPersistEndId()
        mainHandler.removeCallbacks(reconfigureRunnable)
        syncManager.stop()
        lanSyncManager.stop()
        sp.unregisterOnSharedPreferenceChangeListener(listener)
        
        // Clear references to help GC
        encryptor = null
        remoteClipApplier = null
        
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

        // If a LAN clip with the same originId was already persisted, skip to
        // avoid a duplicate entry in history. The serverId lookup handles the
        // normal case where this device itself triggered the remote upsert.
        val existingByOriginId = clip.originId?.takeIf { it.isNotBlank() }
            ?.let { fileStorage.findClipIdByOriginId(it) }
        if (existingByOriginId != null) {
            Log.d(logTag, "Skipping duplicate remote clip originId=${clip.originId} serverId=${clip.serverId} existingClipId=$existingByOriginId")
            return
        }

        val existingClipId = fileStorage.findClipIdByServerId(clip.serverId)
        val clipId = if (existingClipId != null) {
            existingClipId
        } else {
            val next = getNextId()
            endId += 1
            schedulePersistEndId()
            next
        }

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
        )

        val decryptedContent = decryptRemoteContent(clip) ?: return
        Log.i(logTag, "Applying remote clip to system clipboard")
        remoteClipApplier?.invoke(decryptedContent)
    }

    private fun deleteRemoteClip(serverId: Long) {
        Log.i(logTag, "deleteRemoteClip serverId=$serverId")
        fileStorage.deleteClipByServerId(serverId)
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

        val nextId = getNextId()

        val writeOutcome = if (payload.localFilePath != null) {
            // File / media clip: store the cached file path as the text field so
            // the Flutter layer can resolve it to a ClipboardItem with localPath.
            fileStorage.writeClipItemIfOriginMissing(
                clipId = nextId,
                text = payload.localFilePath,
                type = payload.type,
                label = payload.fileName ?: payload.label,
                encrypted = false,
                iv = null,
                encMode = null,
                serverId = payload.serverId ?: -1,
                userId = payload.userId ?: "",
                timestamp = payload.timestamp,
                originId = payload.originId,
                sourceId = payload.sourceId ?: "",
                sourceApp = payload.sourceApp ?: "",
            )
        } else {
            fileStorage.writeClipItemIfOriginMissing(
                clipId = nextId,
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
            )
        }

        when (writeOutcome) {
            is CopyCatFileStorage.ClipWriteOutcome.Written -> {
                endId += 1
                // Write endId synchronously before signalling Flutter so:
                // 1. Flutter can read the correct value immediately via the stream.
                // 2. syncStates() on lifecycle resume also finds this clip if the
                //    stream event was missed while the app was in the background.
                mainHandler.removeCallbacks(persistEndIdRunnable)
                sp.edit().putInt("endId", endId).apply()
                LanClipReceivedReporter.getInstance().signal(nextId)
            }
            is CopyCatFileStorage.ClipWriteOutcome.Duplicate -> debugLog(logTag) {
                "Skipping duplicate LAN clip originId=${payload.originId} existingClipId=${writeOutcome.clipId}"
            }
            is CopyCatFileStorage.ClipWriteOutcome.Failed -> {
                Log.e(logTag, "Failed to persist LAN clip originId=${payload.originId}")
            }
        }
    }

    /**
     * Suppresses re-capture of a clip that LAN sync just wrote to the clipboard.
     * The [originId] is stored so the detection strategy can skip the next
     * matching clipboard read.
     */
    private fun markCapturedByOriginId(originId: String) {
        // Store in SharedPreferences so detection strategies can check it.
        sp.edit().putString("lan_last_written_origin", originId).apply()
    }
}