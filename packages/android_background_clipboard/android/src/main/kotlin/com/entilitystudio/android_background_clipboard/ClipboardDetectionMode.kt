package com.entilitystudio.android_background_clipboard

/**
 * Clipboard detection modes for different OEM behaviors and detection strategies.
 * Each mode represents a different heuristic for detecting copy events.
 */
enum class ClipboardDetectionMode(val value: String) {
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
     * Mode 3: Sequence-based detection (future)
     * Records the sequence of accessibility events during initial detection test,
     * then matches that sequence on subsequent copies. More robust to OEM variations.
     */
    MODE_3_SEQUENCE("mode_3_sequence"),

    /**
     * Mode 4: Persistent overlay
     * Keeps a 1x1 pixel transparent overlay in foreground so the clipboard
     * listener fires directly without needing heuristics.
     */
    MODE_4_OVERLAY("mode_4_overlay");

    companion object {
        fun fromString(value: String): ClipboardDetectionMode? =
            values().firstOrNull { it.value == value }

        fun default(): ClipboardDetectionMode = MODE_1_ACK_TEXT
    }
}
