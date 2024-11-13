package com.entilitystudio.android_background_clipboard

import android.content.Context
import android.content.Context.MODE_PRIVATE
import android.util.Log

enum class ClipType {
    text,
    url,
    fileUrl
}

class CopyCatSharedStorage(private val applicationContext: Context) {
    private val sp = applicationContext.getSharedPreferences("FlutterSharedPreferences", MODE_PRIVATE)
    private lateinit var sharedAccessKey: String
    private var syncEnabled: Boolean = false
    private lateinit var deviceId: String
    private var endId: Int = -1

    init {
        readConfig()
    }

    private fun readConfig() {
        // Will be used to sync with the copycat servers
        sharedAccessKey = sp.getString("sharedAccessKey", "").toString()

        // is the sync enabled?
        syncEnabled = sp.getBoolean("syncEnabled", false)

        // This device unique id
        deviceId = sp.getString("deviceId", "").toString()

        endId = sp.getInt("endId", -1)
    }

    private fun getNextId(): String {
        return "Clip-${endId + 1}"
    }

    fun writeTextClip(text: String, type: ClipType) {
        val nextId = getNextId()
        endId += 1  // Update endId for next usage
        val editor = sp.edit()
        editor.putString(nextId, text)
        editor.putString("$nextId-meta", "$type :: ")
        editor.putInt("endId", endId) // Persist updated endId in SharedPreferences
        editor.apply()
        writeTextClipToServer(text, type)
    }

    private fun writeTextClipToServer(text: String, type: ClipType) {
        Log.d("CopyCatSharedStorage", "Writing text clip to server")
    }
}