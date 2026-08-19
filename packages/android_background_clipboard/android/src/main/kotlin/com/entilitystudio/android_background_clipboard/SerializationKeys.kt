package com.entilitystudio.android_background_clipboard

import org.json.JSONObject

object BgPrefKey {
    const val SYNC_ENABLED = "syncEnabled"
    const val LISTENING_MODE = "listeningMode"
    const val SYNC_SPEED = "syncSpeed"
    const val SYNC_INTERVAL = "syncInterval"
    const val LAN_INSTANT_SYNC = "lanInstantSync"
    const val AUTO_WRITE_ON_RECEIVE = "autoWriteOnReceive"
    const val DONT_COPY_OVER = "dontCopyOver"
    const val PROJECT_KEY = "projectKey"
    const val PROJECT_API_KEY = "projectApiKey"
    const val DEVICE_ID = "deviceId"
    const val E2E_KEY = "e2e_key"
    const val SERVICE_ENABLED = "serviceEnabled"
}

object JsonKey {
    const val EVENT = "event"
    const val PAYLOAD = "payload"
    const val DATA = "data"
    const val TYPE = "type"
    const val RECORD = "record"

    const val ID = "id"
    const val ORIGIN_ID = "origin_id"
    const val TEXT_CATEGORY = "textCategory"
    const val TEXT = "text"
    const val URL = "url"
    const val TITLE = "title"
    const val USER_ID = "userId"
    const val MODIFIED = "modified"

    const val CONTENT = "content"
    const val LABEL = "label"
    const val TS = "ts"
    const val CREATED = "created"
    const val OS = "os"
    const val ENCRYPTED = "encrypted"
    const val IV = "iv"
    const val ENC_MODE = "encMode"
    const val ENC_MODE_SNAKE = "enc_mode"
    const val ITEM = "item"

    const val SOURCE_ID = "sourceId"
    const val SOURCE_APP = "sourceApp"

    const val DESCRIPTION = "description"
    const val DEVICE_ID = "deviceId"

    const val DELETED_AT = "deletedAt"
}

fun JSONObject.putIfNotBlank(key: String, value: String?) {
    if (!value.isNullOrBlank()) {
        put(key, value)
    }
}

fun JSONObject.optNonBlank(key: String): String? {
    val raw = optString(key, "").trim()
    return if (raw.isEmpty() || raw.equals("null", ignoreCase = true)) {
        null
    } else {
        raw
    }
}
