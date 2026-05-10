package com.entilitystudio.android_background_clipboard

/**
 * Clipboard detection modes for different OEM behaviors and detection strategies.
 * Each mode represents a different heuristic for detecting copy events.
 */
enum class ClipboardDetectionMode(val value: String) {
    /**
     * Detection is inactive until the user explicitly selects a mode.
     */
    MODE_INACTIVE("inactive"),

    /**
     * Mode 1: Ack-text based detection
     * Relies on detecting OS acknowledgement toast/announcement text when a copy happens.
     * Works on most OEMs with standard copy feedback. Low battery overhead.
     */
    MODE_1_ACK_TEXT("mode_1_ack_text"),

    /**
     * Mode 2: Aggressive event monitoring
     * Monitors all accessibility events with debouncing to catch copies.
     * More battery overhead but broader compatibility.
     */
    MODE_2_AGGRESSIVE("mode_2_aggressive"),

    /**
     * Mode 3: Persistent overlay.
     * Keeps a 1x1 pixel accessibility overlay active so direct clipboard
     * callbacks are more likely to fire without toast/announcement heuristics.
     */
    MODE_3_OVERLAY("mode_3_overlay");

    companion object {
        fun fromString(value: String): ClipboardDetectionMode? =
            values().firstOrNull { it.value == value }

        fun default(): ClipboardDetectionMode = MODE_INACTIVE
    }
}
