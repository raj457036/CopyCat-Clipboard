package com.entilitystudio.android_background_clipboard

import android.content.Context
import android.os.SystemClock
import android.util.Log
import android.view.accessibility.AccessibilityEvent

/**
 * Mode 2: Aggressive clipboard detection.
 * 
 * Extends Mode1AckTextStrategy with aggressive event heuristics:
 * - Inherits calibrated ack-text detection, toast, and announcement matching from Mode 1.
 * - Adds text selection tracking and selection-collapse heuristics for Cut detection.
 * - Evaluates standalone toolbar/menu click events and localized fallback signals.
 */
class Mode2AggressiveStrategy(
    context: Context,
    initialAckText: String? = null,
    onAckTextLearned: ((String) -> Unit)? = null,
    private val activeImePackageProvider: (() -> String)? = null,
) : Mode1AckTextStrategy(context, initialAckText, onAckTextLearned) {
    override val mode: ClipboardDetectionMode = ClipboardDetectionMode.MODE_2_AGGRESSIVE

    override val logTag: String = "Mode2AggressiveStrategy"
    override val duplicateSuppressionWindowMs: Long = 1700L
    private val clickReadDebounceWindowMs = 900L
    private val selectionArmingWindowMs = 2500L
    private val selectionCollapseWindowMs = 800L

    private var lastClickReadTriggeredAtMs: Long = 0L
    private var lastSelectionArmedAtMs: Long = 0L
    private var lastSelectionPackageName: String = ""
    private var lastSelectionCollapsedAtMs: Long = 0L
    private var lastCollapsedPackageName: String = ""

    override fun onAccessibilityEvent(
        event: AccessibilityEvent?,
        packageName: String,
        isScreenOn: Boolean,
        isAppInForeground: Boolean,
        callback: ClipboardDetectionCallback
    ) {
        if (event == null) return

        // If in detection test during initial calibration, Mode 1 handles it
        if (isInDetectionTest) {
            super.onAccessibilityEvent(event, packageName, isScreenOn, isAppInForeground, callback)
            return
        }

        // Early exit if screen is off or CopyCat is in foreground
        if (!isScreenOn || isAppInForeground) {
            debugLog(logTag) { "Ignoring event: screen=$isScreenOn, appInFg=$isAppInForeground" }
            return
        }

        // Step 1: Pre-process selection events to track active selection or selection collapse
        if (event.eventType == AccessibilityEvent.TYPE_VIEW_TEXT_SELECTION_CHANGED) {
            handleTextSelectionChangedEvent(event, packageName)
        }

        // Step 2: Delegate to Mode 1 base logic first (catches exact ack text, announcements, toasts)
        var detectedByBase = false
        val delegatingCallback = object : ClipboardDetectionCallback {
            override fun onCopyDetected(packageName: String) {
                detectedByBase = true
                clearSelectionArm()
                callback.onCopyDetected(packageName)
            }

            override fun onTestAckCandidate(ackText: String) {
                callback.onTestAckCandidate(ackText)
            }
        }

        super.onAccessibilityEvent(event, packageName, isScreenOn, isAppInForeground, delegatingCallback)
        if (detectedByBase) {
            return
        }

        // Step 3: If not detected by Mode 1, apply Mode 2 aggressive heuristics
        when (event.eventType) {
            AccessibilityEvent.TYPE_VIEW_CLICKED -> {
                handleViewClickedEvent(event, packageName, callback)
            }
            AccessibilityEvent.TYPE_NOTIFICATION_STATE_CHANGED -> {
                handleAggressiveSignalEvent(event, packageName, callback, "notification")
            }
            AccessibilityEvent.TYPE_ANNOUNCEMENT -> {
                handleAggressiveSignalEvent(event, packageName, callback, "announcement")
            }
            else -> {
                // Ignore other event types
            }
        }
    }

    override fun reset() {
        super.reset()
        debugLog(logTag) { "Resetting aggressive strategy state" }
        clearSelectionArm()
    }

    // MARK: Private helpers

    private fun handleTextSelectionChangedEvent(
        event: AccessibilityEvent,
        currentForegroundPackage: String,
    ) {
        val candidatePackage = resolveSelectionPackage(
            currentForegroundPackage = currentForegroundPackage,
            eventPackage = event.packageName?.toString().orEmpty(),
        )

        val hasSelection = event.hasActiveSelection()
        val isSelectionCollapsed = event.fromIndex >= 0 && event.fromIndex == event.toIndex

        if (hasSelection) {
            // User selected text (toIndex > fromIndex)
            lastSelectionArmedAtMs = SystemClock.elapsedRealtime()
            lastSelectionPackageName = candidatePackage
            debugLog(logTag) { "Armed selection heuristic for package=$candidatePackage [${event.fromIndex}..${event.toIndex}]" }
        } else if (isSelectionCollapsed && isRecentSelectionArmed(candidatePackage)) {
            // User had text selected, and now cursor collapsed to a single point (fromIndex == toIndex)
            // Typical signature of Cut (or Deselect) in an EditText
            lastSelectionCollapsedAtMs = SystemClock.elapsedRealtime()
            lastCollapsedPackageName = candidatePackage
            debugLog(logTag) { "Recorded selection collapse in package=$candidatePackage at index ${event.fromIndex}" }
        }
    }

    private fun isRecentSelectionArmed(candidatePackage: String): Boolean {
        val now = SystemClock.elapsedRealtime()
        return lastSelectionArmedAtMs > 0L &&
            (now - lastSelectionArmedAtMs < selectionArmingWindowMs) &&
            (lastSelectionPackageName.isBlank() || candidatePackage.isBlank() || lastSelectionPackageName == candidatePackage)
    }

    private fun isRecentSelectionCollapsed(candidatePackage: String): Boolean {
        val now = SystemClock.elapsedRealtime()
        return lastSelectionCollapsedAtMs > 0L &&
            (now - lastSelectionCollapsedAtMs < selectionCollapseWindowMs) &&
            (lastCollapsedPackageName.isBlank() || candidatePackage.isBlank() || lastCollapsedPackageName == candidatePackage)
    }

    private fun handleViewClickedEvent(
        event: AccessibilityEvent,
        currentForegroundPackage: String,
        callback: ClipboardDetectionCallback,
    ) {
        val eventPackage = event.packageName?.toString().orEmpty()

        val activeImePackage = activeImePackageProvider?.invoke()?.trim().orEmpty()
        if (activeImePackage.isNotEmpty() && eventPackage == activeImePackage) {
            debugLog(logTag) { "Ignoring active IME click event package=$eventPackage" }
            return
        }

        if (isImePackage(eventPackage)) {
            debugLog(logTag) { "Ignoring IME click event package=$eventPackage" }
            return
        }

        if (!event.hasSemanticClickPayload()) {
            return
        }

        if (!shouldTriggerClickRead()) {
            return
        }

        if (!shouldEmitCopy()) {
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
        clearSelectionArm()
        callback.onCopyDetected(targetPackage)
    }

    private fun handleAggressiveSignalEvent(
        event: AccessibilityEvent,
        currentForegroundPackage: String,
        callback: ClipboardDetectionCallback,
        source: String,
    ) {
        val keywords = getActionKeywords()
        val matchesKeywords = ClipboardLocalizationHelper.containsActionKeyword(event.text, keywords) ||
            ClipboardLocalizationHelper.containsActionKeyword(event.contentDescription, keywords)

        val targetPackage = resolveCopyPackage(
            currentForegroundPackage = currentForegroundPackage,
            eventPackage = event.packageName?.toString().orEmpty(),
        )

        val recentCollapsed = isRecentSelectionCollapsed(targetPackage)

        // Aggressive detection: either matched localized keywords, or event occurred right after a selection collapse in the target package
        if (!matchesKeywords && !recentCollapsed) {
            return
        }

        if (!shouldEmitCopy()) {
            return
        }

        debugLog(logTag) { "Copy/Cut detected via $source package=$targetPackage (keywordMatched=$matchesKeywords, recentCollapsed=$recentCollapsed)" }
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
        if (lastCollapsedPackageName.isNotBlank()) {
            val collapsedPkg = lastCollapsedPackageName
            return collapsedPkg
        }

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

    private fun isImePackage(packageName: String): Boolean {
        val normalized = packageName.trim().lowercase()
        if (normalized.isBlank()) return false

        return normalized.contains("inputmethod") ||
            normalized.contains("keyboard") ||
            normalized.startsWith("com.google.android.inputmethod") ||
            normalized.startsWith("com.samsung.android.honeyboard") ||
            normalized.startsWith("com.touchtype.swiftkey")
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
        lastSelectionCollapsedAtMs = 0L
        lastCollapsedPackageName = ""
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