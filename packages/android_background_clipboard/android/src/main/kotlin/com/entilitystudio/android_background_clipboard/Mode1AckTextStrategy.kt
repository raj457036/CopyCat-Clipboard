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
class Mode1AckTextStrategy(
    initialAckText: String? = null,
    private val onAckTextLearned: ((String) -> Unit)? = null,
) : ClipboardDetectionStrategy() {
    override val mode: ClipboardDetectionMode = ClipboardDetectionMode.MODE_1_ACK_TEXT

    private val logTag = "Mode1AckTextStrategy"
    private val duplicateSuppressionWindowMs = 900L
    private val defaultAckText = "[Copied]"
    private var notificationAckText: String =
        initialAckText?.trim()?.takeIf { it.isNotEmpty() } ?: defaultAckText
    private var hasLearnedAckText: Boolean = !initialAckText.isNullOrBlank()
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

        // During setup we must process test events even if app is foreground.
        if (isInDetectionTest) {
            // Use the callback passed to startDetectionTest so service can complete setup.
            handleTestAckEvent(event, currentCallback ?: callback)
            return
        }

        // Early exit if screen is off or CopyCat is in foreground
        if (!isScreenOn || isAppInForeground) {
            debugLog(logTag) { "Ignoring event: screen=$isScreenOn, appInFg=$isAppInForeground" }
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

    override fun startDetectionTest(probeText: String, callback: ClipboardDetectionCallback) {
        debugLog(logTag) { "Starting detection test" }
        isInDetectionTest = true
        currentCallback = callback
    }

    override fun acceptDetectionTestAckText(ackText: String) {
        val normalizedAckText = ackText.trim()
        if (normalizedAckText.isEmpty()) {
            return
        }

        notificationAckText = normalizedAckText
        hasLearnedAckText = true
        onAckTextLearned?.invoke(normalizedAckText)
    }

    override fun requiresDetectionTest(): Boolean = !hasLearnedAckText

    override fun completeDetectionTest() {
        debugLog(logTag) { "Completed detection test. Ack text: '$notificationAckText'" }
        clearDetectionTestState()
    }

    override fun reset() {
        clearDetectionTestState()
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

        val fullText = event.text.joinToString(" ")
        debugLog(logTag) { "Ack TEXT: $fullText" }

        val ackTextSplit = fullText.split(",")
        // If the text has multiple parts (e.g. "<content>, Copied"), use the last part.
        // If it's a single part, the text itself is the ack (e.g. real copy fires just "Copied").
        val ackText = if (ackTextSplit.size > 1) ackTextSplit.last().trim() else fullText.trim()

        val copyDetected = (ackText == notificationAckText.trim()) || notificationAckText.isBlank()
        if (copyDetected && shouldEmitCopy()) {
            debugLog(logTag) { "Copy detected via window state change" }
            callback.onCopyDetected(packageName)
        }
    }

    private fun handleAnnouncementEvent(
        event: AccessibilityEvent,
        callback: ClipboardDetectionCallback
    ) {
        val ackText = event.text.joinToString(" ")
        val copyDetected = ackText.trim() == notificationAckText.trim()

        if (copyDetected && shouldEmitCopy()) {
            debugLog(logTag) { "Copy detected via announcement" }
            callback.onCopyDetected(event.packageName?.toString() ?: "")
        }
    }

    private fun handleNotificationStateChangedEvent(
        event: AccessibilityEvent,
        callback: ClipboardDetectionCallback
    ) {
        if (event.className != "android.widget.Toast") return

        debugLog(logTag) { "Toast Event: $event" }
        val ackText = event.text.joinToString(" ")
        val copyDetected = ackText.trim() == notificationAckText.trim()

        if (copyDetected && event.packageName.toString().contains("android") && shouldEmitCopy()) {
            debugLog(logTag) { "Copy detected via toast notification" }
            callback.onCopyDetected(event.packageName?.toString() ?: "")
        }
    }

    private fun handleTestAckEvent(event: AccessibilityEvent, callback: ClipboardDetectionCallback) {
        val eventText = event.text.joinToString(" ").trim()
        if (eventText.isBlank()) return

        val ackCandidate = when (event.eventType) {
            AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED ->
                extractWindowStateAckCandidate(event, eventText)

            AccessibilityEvent.TYPE_ANNOUNCEMENT -> eventText

            AccessibilityEvent.TYPE_NOTIFICATION_STATE_CHANGED -> {
                if (event.className == "android.widget.Toast") {
                    eventText
                } else {
                    null
                }
            }

            else -> null
        } ?: return

        debugLog(logTag) { "Detected ack candidate: '$ackCandidate'" }
        callback.onTestAckCandidate(ackCandidate)
    }

    private fun extractWindowStateAckCandidate(
        event: AccessibilityEvent,
        eventText: String
    ): String? {
        if ((event.packageName != "com.android.systemui" ||
                event.className.toString() != "android.widget.FrameLayout") ||
            event.text.isEmpty()
        ) {
            return null
        }

        val separatorIndex = eventText.lastIndexOf(',')
        val ackText = if (separatorIndex == -1) {
            eventText.trim()
        } else {
            eventText.substring(separatorIndex + 1).trim()
        }

        return ackText.takeIf { it.isNotBlank() }
    }

    private fun clearDetectionTestState() {
        isInDetectionTest = false
        currentCallback = null
    }

    private fun shouldEmitCopy(): Boolean {
        val now = SystemClock.elapsedRealtime()
        if (now - lastCopyDetectedAtMs < duplicateSuppressionWindowMs) {
            debugLog(logTag) { "Suppressing duplicate copy detection" }
            return false
        }

        lastCopyDetectedAtMs = now
        return true
    }
}
