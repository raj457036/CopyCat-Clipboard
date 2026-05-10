package com.entilitystudio.android_background_clipboard

import android.view.accessibility.AccessibilityEvent

class ModeInactiveStrategy : ClipboardDetectionStrategy() {
    override val mode: ClipboardDetectionMode = ClipboardDetectionMode.MODE_INACTIVE

    override fun onAccessibilityEvent(
        event: AccessibilityEvent?,
        packageName: String,
        isScreenOn: Boolean,
        isAppInForeground: Boolean,
        callback: ClipboardDetectionCallback
    ) {
        // Intentionally inactive.
    }

    override fun startDetectionTest(probeText: String, callback: ClipboardDetectionCallback) = Unit

    override fun completeDetectionTest() = Unit

    override fun reset() = Unit

    override fun shutdown() = Unit
}