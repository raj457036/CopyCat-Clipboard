package com.entilitystudio.android_background_clipboard

import android.os.Handler
import android.os.Looper

/**
 * Singleton that signals Flutter whenever a LAN clip has been successfully
 * written to shared storage by [CopyCatSharedStorage.ingestLanClip].
 *
 * Listeners are always invoked on the main thread so they can safely post
 * events to an [io.flutter.plugin.common.EventChannel.EventSink].
 */
class LanClipReceivedReporter private constructor() {

    companion object {
        @Volatile
        private var instance: LanClipReceivedReporter? = null

        fun getInstance(): LanClipReceivedReporter =
            instance ?: synchronized(this) {
                instance ?: LanClipReceivedReporter().also { instance = it }
            }
    }

    private val mainHandler = Handler(Looper.getMainLooper())
    private val listeners = LinkedHashSet<(String) -> Unit>()

    fun addListener(listener: (String) -> Unit) {
        listeners.add(listener)
    }

    fun removeListener(listener: (String) -> Unit) {
        listeners.remove(listener)
    }

    /** Called by [CopyCatSharedStorage] when a LAN clip is successfully persisted. */
    fun signal(clipKey: String) {
        mainHandler.post {
            listeners.toList().forEach { it(clipKey) }
        }
    }
}
