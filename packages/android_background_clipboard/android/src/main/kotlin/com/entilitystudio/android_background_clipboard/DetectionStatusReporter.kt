package com.entilitystudio.android_background_clipboard

import android.os.Handler
import android.os.Looper

class DetectionStatusReporter private constructor() {
    companion object {
        @Volatile
        private var instance: DetectionStatusReporter? = null

        fun getInstance(): DetectionStatusReporter {
            return instance ?: synchronized(this) {
                instance ?: DetectionStatusReporter().also { instance = it }
            }
        }
    }

    private val mainHandler = Handler(Looper.getMainLooper())
    private val listeners = LinkedHashSet<(Map<String, String>) -> Unit>()

    private var state: String = "inactive"
    private var outcome: String = "none"

    fun snapshot(): Map<String, String> {
        return mapOf(
            "state" to state,
            "outcome" to outcome,
        )
    }

    fun update(state: String, outcome: String = this.outcome) {
        if (this.state == state && this.outcome == outcome) {
            return
        }

        this.state = state
        this.outcome = outcome
        notifyListeners()
    }

    fun addListener(listener: (Map<String, String>) -> Unit) {
        listeners.add(listener)
        mainHandler.post {
            listener(snapshot())
        }
    }

    fun removeListener(listener: (Map<String, String>) -> Unit) {
        listeners.remove(listener)
    }

    private fun notifyListeners() {
        val payload = snapshot()
        mainHandler.post {
            listeners.toList().forEach { listener ->
                listener(payload)
            }
        }
    }
}
