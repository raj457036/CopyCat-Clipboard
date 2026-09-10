package com.entilitystudio.android_background_clipboard

import android.content.Context
import android.os.Build

/**
 * Provides system-level localized keywords for clipboard actions (copy, cut)
 * in the device's currently active language, along with matching utilities.
 */
object ClipboardLocalizationHelper {
    private var cachedLocaleTag: String = ""
    private var cachedKeywords: Set<String> = emptySet()

    /**
     * Returns a set of localized lowercase keywords associated with clipboard copy and cut actions.
     */
    fun getActionKeywords(context: Context, extraLearnedAck: String? = null): Set<String> {
        val currentLocaleTag = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            context.resources.configuration.locales.toLanguageTags()
        } else {
            @Suppress("DEPRECATION")
            context.resources.configuration.locale.toLanguageTag()
        }

        if (currentLocaleTag != cachedLocaleTag || cachedKeywords.isEmpty()) {
            val keywords = mutableSetOf<String>()

            // 1. Public Android SDK string resources (localized in all Android languages)
            runCatching {
                val copy = context.getString(android.R.string.copy).trim().lowercase()
                if (copy.isNotEmpty()) keywords.add(copy)
            }
            runCatching {
                val cut = context.getString(android.R.string.cut).trim().lowercase()
                if (cut.isNotEmpty()) keywords.add(cut)
            }
            runCatching {
                val copyUrl = context.getString(android.R.string.copyUrl).trim().lowercase()
                if (copyUrl.isNotEmpty()) keywords.add(copyUrl)
            }

            // 2. Framework internal strings (AOSP clipboard toast strings)
            val res = context.resources
            val frameworkKeys = listOf(
                "clipboard_content_copied",
                "text_copied",
                "copied",
                "copy_to_clipboard"
            )
            for (key in frameworkKeys) {
                val id = res.getIdentifier(key, "string", "android")
                if (id != 0) {
                    runCatching {
                        val text = res.getString(id).trim().lowercase()
                        if (text.isNotEmpty()) keywords.add(text)
                    }
                }
            }

            // 3. Universal English fallbacks
            keywords.add("copy")
            keywords.add("copied")
            keywords.add("cut")

            cachedLocaleTag = currentLocaleTag
            cachedKeywords = keywords.filter { it.isNotBlank() }.toSet()
        }

        val learnedNormalized = extraLearnedAck?.trim()?.lowercase()
        return if (!learnedNormalized.isNullOrBlank()) {
            cachedKeywords + learnedNormalized
        } else {
            cachedKeywords
        }
    }

    /**
     * Checks whether the provided text or list of texts contains any of the action keywords.
     * Uses word boundaries for pure ASCII keywords (preventing false matches on words like 'shortcut'),
     * and substring matching for non-ASCII scripts (such as Devanagari/Hindi or CJK).
     */
    fun containsActionKeyword(text: CharSequence?, keywords: Set<String>): Boolean {
        if (text.isNullOrBlank()) return false
        val lower = text.toString().lowercase()

        for (kw in keywords) {
            if (kw.isBlank()) continue

            val matched = if (kw.all { it.isLetter() && it.code < 128 }) {
                // Word boundary check for ASCII terms
                Regex("\\b" + Regex.escape(kw) + "\\b", RegexOption.IGNORE_CASE).containsMatchIn(lower)
            } else {
                // Direct containment for scripts and phrases
                lower.contains(kw)
            }

            if (matched) {
                return true
            }
        }

        return false
    }

    /**
     * Checks whether any item in the event's text list contains any of the action keywords.
     */
    fun containsActionKeyword(texts: List<CharSequence?>, keywords: Set<String>): Boolean {
        for (item in texts) {
            if (containsActionKeyword(item, keywords)) {
                return true
            }
        }
        return false
    }
}
