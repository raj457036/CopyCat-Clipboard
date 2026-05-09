package com.entilitystudio.android_background_clipboard

import android.os.SystemClock
import android.util.Log
import android.view.accessibility.AccessibilityEvent

/**
 * Mode 2: Aggressive clipboard detection.
 * 
 * Detects copy events by monitoring a wide range of accessibility events,
 * including text changes, notifications, and announcements.
 * 
 * Higher battery overhead but more robust detection.
 */
class Mode2AggressiveStrategy : ClipboardDetectionStrategy() {
    override val mode: ClipboardDetectionMode = ClipboardDetectionMode.MODE_2_AGGRESSIVE

    private val logTag = "Mode2AggressiveStrategy"
    private val duplicateSuppressionWindowMs = 1700L
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

        // Handle aggressive detection logic
        when (event.eventType) {
            AccessibilityEvent.TYPE_VIEW_TEXT_CHANGED -> {
                handleTextChangedEvent(event, packageName, callback)
            }
            AccessibilityEvent.TYPE_NOTIFICATION_STATE_CHANGED -> {
                handleNotificationStateChangedEvent(event, callback)
            }
            AccessibilityEvent.TYPE_ANNOUNCEMENT -> {
                handleAnnouncementEvent(event, callback)
            }
            else -> {
                // Ignore other event types
            }
        }
    }

    override fun startDetectionTest(callback: ClipboardDetectionCallback) {
        Log.d(logTag, "Detection test not applicable for aggressive mode")
    }

    override fun completeDetectionTest() {
        Log.d(logTag, "Detection test not applicable for aggressive mode")
    }

    override fun reset() {
        Log.d(logTag, "Resetting aggressive strategy state")
        lastCopyDetectedAtMs = 0L
    }

    override fun shutdown() {
        reset()
    }

    // MARK: Private helpers

    private fun handleTextChangedEvent(
        event: AccessibilityEvent,
        packageName: String,
        callback: ClipboardDetectionCallback
    ) {
        val text = event.text.joinToString(" ")
        Log.d(logTag, "Text changed: $text")
        if (text.contains("copied", ignoreCase = true) && shouldEmitCopy()) {
            Log.d(logTag, "Copy detected via text change")
            callback.onCopyDetected(packageName)
        }
    }

    private fun handleNotificationStateChangedEvent(
        event: AccessibilityEvent,
        callback: ClipboardDetectionCallback
    ) {
        val notificationText = event.text.joinToString(" ")
        Log.d(logTag, "Notification state changed: $notificationText")
        if (notificationText.contains("copied", ignoreCase = true) && shouldEmitCopy()) {
            Log.d(logTag, "Copy detected via notification")
            callback.onCopyDetected(event.packageName.toString())
        }
    }

    private fun handleAnnouncementEvent(
        event: AccessibilityEvent,
        callback: ClipboardDetectionCallback
    ) {
        val announcementText = event.text.joinToString(" ")
        Log.d(logTag, "Announcement: $announcementText")
        if (announcementText.contains("copied", ignoreCase = true) && shouldEmitCopy()) {
            Log.d(logTag, "Copy detected via announcement")
            callback.onCopyDetected(event.packageName.toString())
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