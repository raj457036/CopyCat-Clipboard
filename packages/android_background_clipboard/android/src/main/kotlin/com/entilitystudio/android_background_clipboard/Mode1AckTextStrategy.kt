package com.entilitystudio.android_background_clipboard

import android.os.SystemClock
import android.util.Log
import android.view.accessibility.AccessibilityEvent

/**
 * Mode 1: Ack-text based clipboard detection.
 * 
 * Detects copy events by monitoring for OS acknowledgement toast/announcement text.
 * During initial setup, simulates a copy to record the ack text, then matches that text
 * on subsequent accessibility events.
 * 
 * Low battery overhead but depends on OEM providing standard copy feedback.
 */
class Mode1AckTextStrategy : ClipboardDetectionStrategy() {
    override val mode: ClipboardDetectionMode = ClipboardDetectionMode.MODE_1_ACK_TEXT

    private val logTag = "Mode1AckTextStrategy"
    private val duplicateSuppressionWindowMs = 900L
    private var notificationAckText: String = "[Copied]"
    private var isInDetectionTest: Boolean = false
    private var currentCallback: ClipboardDetectionCallback? = null
    private var lastCopyDetectedAtMs: Long = 0L

    override fun onAccessibilityEvent(
        event: AccessibilityEvent?,
        packageName: String,
        isScreenOn: Boolean,
        isAppInForeground: Boolean,
        callback: ClipboardDetectionCallback
    ) {
        if (event == null) return

        // Early exit if screen is off or CopyCat is in foreground
        if (!isScreenOn || isAppInForeground) {
            Log.d(logTag, "Ignoring event: screen=$isScreenOn, appInFg=$isAppInForeground")
            return
        }

        // Handle detection test acknowledgement events
        if (isInDetectionTest) {
            // Use the callback passed to startDetectionTest so service can complete setup.
            handleTestAckEvent(event, currentCallback ?: callback)
            return
        }

        // Handle normal copy detection events
        when (event.eventType) {
            AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED -> {
                handleWindowStateChangedEvent(event, packageName, callback)
            }
            AccessibilityEvent.TYPE_ANNOUNCEMENT -> {
                handleAnnouncementEvent(event, callback)
            }
            AccessibilityEvent.TYPE_NOTIFICATION_STATE_CHANGED -> {
                handleNotificationStateChangedEvent(event, callback)
            }
            else -> {
                // Ignore other event types
            }
        }
    }

    override fun startDetectionTest(callback: ClipboardDetectionCallback) {
        Log.d(logTag, "Starting detection test")
        isInDetectionTest = true
        currentCallback = callback
    }

    override fun completeDetectionTest() {
        Log.d(logTag, "Completed detection test. Ack text: '$notificationAckText'")
        isInDetectionTest = false
        currentCallback = null
    }

    override fun reset() {
        isInDetectionTest = false
        currentCallback = null
        lastCopyDetectedAtMs = 0L
    }

    override fun shutdown() {
        reset()
    }

    // MARK: Private helpers
    
    private fun handleWindowStateChangedEvent(
        event: AccessibilityEvent,
        packageName: String,
        callback: ClipboardDetectionCallback
    ) {
        // Skip systemui announcements unless we're in detection test
        if ((event.packageName != "com.android.systemui" || 
             event.className.toString() != "android.widget.FrameLayout") || 
            event.text.isEmpty()) {
            return
        }

        val ackTextSplit = event.text.toString().split(",")
        Log.d(logTag, "Ack TEXT: ${event.text} | $ackTextSplit")

        if (ackTextSplit.size > 1 || notificationAckText.isBlank()) {
            val ackText = ackTextSplit.last()

            val copyDetected = ackText == notificationAckText || notificationAckText.isBlank()
            if (copyDetected && shouldEmitCopy()) {
                Log.d(logTag, "Copy detected via window state change")
                callback.onCopyDetected(packageName)
            }
        }
    }

    private fun handleAnnouncementEvent(
        event: AccessibilityEvent,
        callback: ClipboardDetectionCallback
    ) {
        val ackText = event.text.toString()
        val copyDetected = ackText == notificationAckText

        if (copyDetected && shouldEmitCopy()) {
            Log.d(logTag, "Copy detected via announcement")
            callback.onCopyDetected(event.packageName?.toString() ?: "")
        }
    }

    private fun handleNotificationStateChangedEvent(
        event: AccessibilityEvent,
        callback: ClipboardDetectionCallback
    ) {
        if (event.className != "android.widget.Toast") return

        Log.d(logTag, "Toast Event: $event")
        val ackText = event.text.toString()
        val copyDetected = ackText == notificationAckText

        if (copyDetected && event.packageName.toString().contains("android") && shouldEmitCopy()) {
            Log.d(logTag, "Copy detected via toast notification")
            callback.onCopyDetected(event.packageName?.toString() ?: "")
        }
    }

    private fun handleTestAckEvent(event: AccessibilityEvent, callback: ClipboardDetectionCallback) {
        val eventText = event.text.joinToString(" ")
        if (eventText.isBlank()) return

        when (event.eventType) {
            AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED -> {
                // Check if this is the detection text (defined in CopyCatAccessibilityService)
                if (eventText.contains(DetectionText)) {
                    val ackTextSplit = eventText.split(",")
                    if (ackTextSplit.size > 1) {
                        notificationAckText = ackTextSplit.last()
                        Log.d(logTag, "Detected ack text: '$notificationAckText'")
                        callback.onTestAckDetected()
                    }
                }
            }
            AccessibilityEvent.TYPE_ANNOUNCEMENT -> {
                if (eventText.isNotEmpty()) {
                    notificationAckText = eventText
                    Log.d(logTag, "Detected ack text via announcement: '$notificationAckText'")
                    callback.onTestAckDetected()
                }
            }
            AccessibilityEvent.TYPE_NOTIFICATION_STATE_CHANGED -> {
                if (event.className == "android.widget.Toast" && eventText.isNotEmpty()) {
                    notificationAckText = eventText
                    Log.d(logTag, "Detected ack text via toast: '$notificationAckText'")
                    callback.onTestAckDetected()
                }
            }
            else -> {}
        }
    }

    private fun shouldEmitCopy(): Boolean {
        val now = SystemClock.elapsedRealtime()
        if (now - lastCopyDetectedAtMs < duplicateSuppressionWindowMs) {
            Log.d(logTag, "Suppressing duplicate copy detection")
            return false
        }

        lastCopyDetectedAtMs = now
        return true
    }
}
