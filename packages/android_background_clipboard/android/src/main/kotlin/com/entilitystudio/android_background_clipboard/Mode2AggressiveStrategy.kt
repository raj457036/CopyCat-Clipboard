package com.entilitystudio.android_background_clipboard

import android.os.SystemClock
import android.util.Log
import android.view.accessibility.AccessibilityEvent

/**
 * Mode 2: Aggressive clipboard detection.
 * 
 * Detects copy events by combining text selection changes, standalone view
 * clicks, and copy-like announcements and notifications.
 * 
 * Higher battery overhead but more robust detection.
 */
class Mode2AggressiveStrategy : ClipboardDetectionStrategy() {
    override val mode: ClipboardDetectionMode = ClipboardDetectionMode.MODE_2_AGGRESSIVE

    private val logTag = "Mode2AggressiveStrategy"
    private val duplicateSuppressionWindowMs = 1700L
    private val clickReadDebounceWindowMs = 900L
    private val selectionArmingWindowMs = 2500L
    private var lastCopyDetectedAtMs: Long = 0L
    private var lastClickReadTriggeredAtMs: Long = 0L
    private var lastSelectionArmedAtMs: Long = 0L
    private var lastSelectionPackageName: String = ""

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
            debugLog(logTag) { "Ignoring event: screen=$isScreenOn, appInFg=$isAppInForeground" }
            return
        }

        // Handle aggressive detection logic
        when (event.eventType) {
            AccessibilityEvent.TYPE_VIEW_TEXT_SELECTION_CHANGED -> {
                handleTextSelectionChangedEvent(event, packageName)
            }
            AccessibilityEvent.TYPE_VIEW_CLICKED -> {
                handleViewClickedEvent(event, packageName, callback)
            }
            AccessibilityEvent.TYPE_NOTIFICATION_STATE_CHANGED -> {
                handleCopiedSignalEvent(event, packageName, callback, "notification")
            }
            AccessibilityEvent.TYPE_ANNOUNCEMENT -> {
                handleCopiedSignalEvent(event, packageName, callback, "announcement")
            }
            else -> {
                // Ignore other event types
            }
        }
    }

    override fun startDetectionTest(probeText: String, callback: ClipboardDetectionCallback) {
        debugLog(logTag) { "Detection test not applicable for aggressive mode" }
    }

    override fun completeDetectionTest() {
        debugLog(logTag) { "Detection test not applicable for aggressive mode" }
    }

    override fun reset() {
        debugLog(logTag) { "Resetting aggressive strategy state" }
        lastCopyDetectedAtMs = 0L
        clearSelectionArm()
    }

    override fun shutdown() {
        reset()
    }

    // MARK: Private helpers

    private fun handleTextSelectionChangedEvent(
        event: AccessibilityEvent,
        currentForegroundPackage: String,
    ) {
        if (!event.hasActiveSelection()) {
            return
        }

        val candidatePackage = resolveSelectionPackage(
            currentForegroundPackage = currentForegroundPackage,
            eventPackage = event.packageName?.toString().orEmpty(),
        )
        if (candidatePackage.isBlank()) {
            return
        }

        lastSelectionArmedAtMs = SystemClock.elapsedRealtime()
        lastSelectionPackageName = candidatePackage
        debugLog(logTag) { "Armed selection heuristic for package=$candidatePackage" }
    }

    private fun handleViewClickedEvent(
        event: AccessibilityEvent,
        currentForegroundPackage: String,
        callback: ClipboardDetectionCallback,
    ) {
        if (!event.hasSemanticClickPayload()) {
            return
        }

        if (!shouldTriggerClickRead()) {
            return
        }

        val targetPackage = resolveSelectionPackage(
            currentForegroundPackage = currentForegroundPackage,
            eventPackage = event.packageName?.toString().orEmpty(),
        )
        if (targetPackage.isBlank()) {
            return
        }

        debugLog(logTag) { "Triggering clipboard read via clicked view package=$targetPackage" }
        callback.onCopyDetected(targetPackage)
    }

    private fun handleCopiedSignalEvent(
        event: AccessibilityEvent,
        currentForegroundPackage: String,
        callback: ClipboardDetectionCallback,
        source: String,
    ) {
        if (!containsCopiedKeyword(event)) {
            return
        }

        val targetPackage = resolveCopyPackage(
            currentForegroundPackage = currentForegroundPackage,
            eventPackage = event.packageName?.toString().orEmpty(),
        )

        if (!shouldEmitCopy()) {
            return
        }

        debugLog(logTag) { "Copy detected via $source package=$targetPackage" }
        clearSelectionArm()
        callback.onCopyDetected(targetPackage)
    }

    private fun shouldTriggerClickRead(): Boolean {
        val now = SystemClock.elapsedRealtime()
        if (now - lastClickReadTriggeredAtMs < clickReadDebounceWindowMs) {
            debugLog(logTag) { "Suppressing debounced standalone click read" }
            return false
        }

        lastClickReadTriggeredAtMs = now
        return true
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

    private fun containsCopiedKeyword(event: AccessibilityEvent): Boolean {
        for (entry in event.text) {
            val value = entry?.toString() ?: continue
            if (value.contains("copied", ignoreCase = true)) {
                return true
            }
        }

        return false
    }

    private fun resolveSelectionPackage(
        currentForegroundPackage: String,
        eventPackage: String,
    ): String {
        val foregroundPackage = normalizePackageName(currentForegroundPackage)
        if (foregroundPackage.isNotBlank()) {
            return foregroundPackage
        }

        return normalizePackageName(eventPackage)
    }

    private fun resolveCopyPackage(
        currentForegroundPackage: String,
        eventPackage: String,
    ): String {
        val recentSelectionPackage = recentSelectionPackage()
        if (recentSelectionPackage.isNotBlank()) {
            return recentSelectionPackage
        }

        val foregroundPackage = normalizePackageName(currentForegroundPackage)
        if (foregroundPackage.isNotBlank()) {
            return foregroundPackage
        }

        return normalizePackageName(eventPackage)
    }

    private fun recentSelectionPackage(): String {
        val now = SystemClock.elapsedRealtime()
        if (lastSelectionPackageName.isBlank() ||
            now - lastSelectionArmedAtMs > selectionArmingWindowMs
        ) {
            clearSelectionArm()
            return ""
        }

        return lastSelectionPackageName
    }

    private fun normalizePackageName(packageName: String): String {
        return when (packageName.trim()) {
            "", "android", "com.android.systemui" -> ""
            else -> packageName.trim()
        }
    }

    private fun clearSelectionArm() {
        lastSelectionArmedAtMs = 0L
        lastSelectionPackageName = ""
    }

    private fun AccessibilityEvent.hasSemanticClickPayload(): Boolean {
        if (!contentDescription.isNullOrBlank()) {
            return true
        }

        for (entry in text) {
            val value = entry?.toString() ?: continue
            if (value.isNotBlank()) {
                return true
            }
        }

        return false
    }

    private fun AccessibilityEvent.hasActiveSelection(): Boolean {
        return fromIndex >= 0 && toIndex > fromIndex
    }
}