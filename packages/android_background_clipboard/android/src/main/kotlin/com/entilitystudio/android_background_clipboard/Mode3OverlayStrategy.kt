package com.entilitystudio.android_background_clipboard

import android.view.accessibility.AccessibilityEvent

/**
 * Mode 3: Persistent-overlay clipboard detection.
 *
 * Clipboard capture is expected to come from the direct primary clip listener
 * while the accessibility service keeps a tiny overlay alive. Accessibility
 * events are intentionally ignored in this mode.
 */
class Mode3OverlayStrategy : ClipboardDetectionStrategy() {
    override val mode: ClipboardDetectionMode = ClipboardDetectionMode.MODE_3_OVERLAY

    override fun onAccessibilityEvent(
        event: AccessibilityEvent?,
        packageName: String,
        isScreenOn: Boolean,
        isAppInForeground: Boolean,
        callback: ClipboardDetectionCallback
    ) {
        // No-op: direct clipboard callbacks should handle capture in overlay mode.
    }

    override fun startDetectionTest(probeText: String, callback: ClipboardDetectionCallback) {
        // No learning/setup required for overlay mode.
    }

    override fun completeDetectionTest() {
        // No-op.
    }

    override fun reset() {
        // No-op.
    }

    override fun shutdown() {
        reset()
    }
}