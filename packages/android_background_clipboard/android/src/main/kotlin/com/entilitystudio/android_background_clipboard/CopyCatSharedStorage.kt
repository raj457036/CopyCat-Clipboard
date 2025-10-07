package com.entilitystudio.android_background_clipboard

import android.content.Context
import android.content.Context.MODE_PRIVATE
import android.content.SharedPreferences.OnSharedPreferenceChangeListener
import android.os.Build
import android.util.Base64
import android.util.Log
import android.widget.Toast


class CopyCatSharedStorage private constructor(applicationContext: Context) {
    private val appContext: Context = applicationContext
    private val logTag = "CopyCatSharedStorage"
    private val sp =
        applicationContext.getSharedPreferences("CopyCatSharedPreferences", MODE_PRIVATE)
    private var syncEnabled: Boolean = false
    private lateinit var deviceId: String
    private var endId: Int = -1
    private var syncManager: CopyCatSyncManager = CopyCatSyncManager(appContext)
    private var encryptor: CopyCatEncryptor? = null
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
//    For Future Use
    var autoCopyOtp: Boolean = false

    val keystore: CopyCatKeyStore
        get() = CopyCatKeyStore.getInstance()

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
        }
        if (key == "serviceEnabled") {
            serviceEnabled = sharedPreferences.getBoolean(key, false)
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
        if (key == "projectKey") {
            readSecure(key)?.let {
                syncManager.projectKey = it
            }
        }
        if (key == "projectApiKey") {
            readSecure(key)?.let {
                syncManager.projectApiKey = it
            }
        }
        if (key == "deviceId") {
            deviceId = sharedPreferences.getString("deviceId", "").toString()
            syncManager.deviceId = deviceId
        }

        if (key == "e2e_key") {
            readSecure(key)?.let {
                setupEncryptor(it)
            }
        }
    }


    companion object {
        @Volatile
        private var instance: CopyCatSharedStorage? = null
        fun getInstance(applicationContext: Context): CopyCatSharedStorage {
            return instance ?: synchronized(this) {
                instance ?: CopyCatSharedStorage(applicationContext).also { instance = it }
            }
        }
    }

    private fun setupEncryptor(key: String) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            try {
                val items = key.split("-+-", limit = 2)
                val secret = items[0]
                val iv = items[1]
                encryptor = CopyCatEncryptor(secret, iv)
            } catch (e: Error) {
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
        sp.registerOnSharedPreferenceChangeListener(listener)
        Log.i(logTag, "Storage started")
    }

    fun readSecure(key: String): String? {
        Log.d(logTag, "Reading $key from secure storage")
        val encrypted = sp.getString(key, "").toString()
        if (encrypted.isNotBlank()) {
            val decoded = Base64.decode(encrypted, Base64.DEFAULT)
            return keystore.decryptData(decoded)
        }
        Log.d(logTag, "$key not found in secure storage")
        return null
    }

    fun clear() {
        Log.d(logTag, "Clearing storage")
        sp.edit().clear().apply()
    }

    fun writeSecure(key: String, value: String) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Log.d(logTag, "Writing $key to secure storage")
            val encrypted = keystore.encryptData(value)
            val encoded = Base64.encodeToString(encrypted, Base64.DEFAULT)
            val editor = sp.edit()
            editor.putString(key, encoded)
            editor.apply()
        }
    }

    private fun readConfig() {
        Log.d(logTag, "Reading initial setup configs")
        syncEnabled = sp.getBoolean("syncEnabled", false)
        deviceId = sp.getString("deviceId", "").toString()
        endId = sp.getInt("endId", -1)

        excludedPackages = sp.getStringSet("excludedPackages", emptySet())!!
        strictCheck = sp.getBoolean("strictCheck", true)
        autoCopyOtp = sp.getBoolean("autoCopyOtp", false)
        showAckToast = sp.getBoolean("showAckToast", true)
        serviceEnabled = sp.getBoolean("serviceEnabled", false)
        excludePasswordManagers = sp.getBoolean("exclude-pass-mgr", false)
        excludeEmail = sp.getBoolean("exclude-email", false)
        excludePhone = sp.getBoolean("exclude-phone", false)

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
    }

    private fun getNextId(): String {
        return "Clip-${endId + 1}"
    }

    fun write(key: String, value: Any) {
        Log.d(logTag, "Writing $key = $value to storage")
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

    fun read(key: String, type: String): Any? {
        Log.d(logTag, "Reading $key of type $type from storage")
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
            editor.remove(key)
        }
        editor.apply()
    }

    fun writeTextClip(text: String, type: ClipType, label: String = "") {
        if (!serviceEnabled) return
        val nextId = getNextId()
        endId += 1  // Update endId for next usage
        val editor = sp.edit()
        editor.putString(nextId, text)
        // type::description::serverId::userid
        editor.putString("$nextId-meta", "$type::$label::-::-")
        editor.putInt("endId", endId)
        editor.apply()

        // Encrypt clip
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && encryptor != null) {
            val encryptedText = encryptor?.encrypt(text).toString()
            writeTextClipToServer(encryptedText, type, "$nextId-meta", true, label)
        } else {
            writeTextClipToServer(text, type, "$nextId-meta", false, label)
        }
    }

    private fun updateClipId(key: String, id: Long, userId: String) {
        var meta = sp.getString(key, "")!!
        if (meta.isBlank()) return
        val parts = meta.split("::").toMutableList()
        parts[2] = id.toString()
        parts[3] = userId
        meta = parts.joinToString("::")
        sp.edit().putString(key, meta).apply()
    }

    private fun writeTextClipToServer(
        text: String,
        type: ClipType,
        metaKey: String,
        encrypted: Boolean,
        label: String? = null
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
            val id = syncManager.writeClipboardItem(text, type, encrypted, label)
            if (id != (-1).toLong()) {
                updateClipId(metaKey, id, syncManager.currentUserId!!)
                return
            }
            Log.w(logTag, "Syncing failed")
        } catch (e: Exception) {
            Log.e(logTag, "Error while syncing clip $e")
        }
    }

    fun clean() {
        syncManager.stop()
        sp.unregisterOnSharedPreferenceChangeListener(listener)
        
        // Clear references to help GC
        encryptor = null
        
        Log.i(logTag, "Storage cleaned up")
    }
}