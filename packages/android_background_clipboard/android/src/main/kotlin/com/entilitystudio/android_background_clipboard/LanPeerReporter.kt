package com.entilitystudio.android_background_clipboard

import android.os.Handler
import android.os.Looper
import java.util.concurrent.ConcurrentHashMap

/**
 * Singleton that tracks NSD-discovered LAN peers and notifies Flutter listeners.
 */
class LanPeerReporter private constructor() {

    companion object {
        @Volatile
        private var instance: LanPeerReporter? = null

        fun getInstance(): LanPeerReporter =
            instance ?: synchronized(this) {
                instance ?: LanPeerReporter().also { instance = it }
            }
    }

    private val mainHandler = Handler(Looper.getMainLooper())
    private val listeners = LinkedHashSet<(List<Map<String, String>>) -> Unit>()

    // Thread-safe peer map: deviceId → {deviceId, host, port}
    private val peers = ConcurrentHashMap<String, Map<String, String>>()

    /** Returns a consistent snapshot of the current peer list. */
    fun snapshot(): List<Map<String, String>> = peers.values.toList()

    /**
     * Called when NSD resolves a new peer.
     */
    fun addPeer(deviceId: String, host: String, port: Int) {
        peers[deviceId] = mapOf(
            "deviceId" to deviceId,
            "host" to host,
            "port" to port.toString(),
        )
        notifyListeners()
    }

    /**
     * Called when NSD reports a peer has gone away.
     */
    fun removePeer(deviceId: String) {
        if (peers.remove(deviceId) != null) {
            notifyListeners()
        }
    }

    /**
     * Clears all peers — called when the LAN sync service stops.
     */
    fun clear() {
        peers.clear()
        notifyListeners()
    }

    /**
     * Subscribe to peer-list updates. Immediately delivers the current snapshot
     * on the main thread, then delivers future updates as they arrive.
     */
    fun addListener(listener: (List<Map<String, String>>) -> Unit) {
        listeners.add(listener)
        mainHandler.post { listener(snapshot()) }
    }

    fun removeListener(listener: (List<Map<String, String>>) -> Unit) {
        listeners.remove(listener)
    }

    private fun notifyListeners() {
        val payload = snapshot()
        mainHandler.post {
            listeners.toList().forEach { it(payload) }
        }
    }
}
