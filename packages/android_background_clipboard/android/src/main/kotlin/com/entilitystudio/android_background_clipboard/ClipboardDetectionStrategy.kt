package com.entilitystudio.android_background_clipboard

import android.view.accessibility.AccessibilityEvent

/**
 * Callback interface for clipboard detection events
 */
interface ClipboardDetectionCallback {
    fun onCopyDetected(packageName: String)
    fun onTestAckDetected()
}

/**
 * Abstract interface for clipboard detection strategies.
 * Each strategy encapsulates a different heuristic for detecting copy events.
 */
abstract class ClipboardDetectionStrategy {
    abstract val mode: ClipboardDetectionMode

    /**
     * Called when an accessibility event is received.
     * Strategy decides whether this event represents a copy action.
     *
     * @param event The accessibility event
     * @param packageName Current foreground app package name
     * @param isScreenOn Whether the screen is currently on
     * @param isAppInForeground Whether CopyCat app is in foreground
     * @param callback Callback to invoke on copy detection
     */
    abstract fun onAccessibilityEvent(
        event: AccessibilityEvent?,
        packageName: String,
        isScreenOn: Boolean,
        isAppInForeground: Boolean,
        callback: ClipboardDetectionCallback
    )

    /**
     * Called to initiate the detection test (if applicable).
     * Some strategies may need to record baseline data.
     *
     * @param callback Callback when the test acknowledgement is detected
     */
    abstract fun startDetectionTest(callback: ClipboardDetectionCallback)

    /**
     * Called when detection test acknowledgement is detected.
     */
    abstract fun completeDetectionTest()

    /**
     * Reset any internal state (e.g., timers, temporary data).
     */
    abstract fun reset()

    /**
     * Release resources before shutdown.
     */
    abstract fun shutdown()
}
