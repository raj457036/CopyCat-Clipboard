package com.entilitystudio.android_background_clipboard

import kotlinx.serialization.Serializable
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import java.time.Instant

@Serializable
data class LanClipItem(
    val id: Long? = null,
    val originId: String? = null,
    val text: String? = null,
    val url: String? = null,
    val title: String? = null,
    val description: String? = null,
    val type: String? = null,
    val format: String? = null,
    val created: String? = null,
    val modified: String? = null,
    val deletedAt: String? = null,
    val sourceId: String? = null,
    val sourceApp: String? = null,
    val userId: String? = null,
    val deviceId: String? = null,
    val encrypted: Boolean = false,
    val locked: Boolean = false,
    val iv: String? = null,
    val encMode: String? = null,
    val localPath: String? = null,
    val fileName: String? = null,
    val fileExtension: String? = null,
    val fileMimeType: String? = null,
    val fileSize: Long? = null,
    val os: String? = "android",
)

@Serializable
data class LanClipEnvelope(
    val originId: String? = null,
    val content: String = "",
    val label: String = "",
    val title: String? = null,
    val description: String? = null,
    val ts: Long = 0L,
    val created: String? = null,
    val modified: String? = null,
    val os: String? = null,
    val encrypted: Boolean = false,
    val locked: Boolean = false,
    val iv: String? = null,
    val encMode: String? = null,
    val sourceId: String? = null,
    val sourceApp: String? = null,
    val deletedAt: String? = null,
    val item: LanClipItem? = null,
) {
    val isDeleted: Boolean
        get() {
            val del = item?.deletedAt ?: deletedAt
            return !del.isNullOrBlank() && !del.equals("null", ignoreCase = true)
        }

    val deletedAtEpochMs: Long?
        get() = parseIsoToEpochMs(item?.deletedAt ?: deletedAt)

    fun toLanClipPayload(
        fromDeviceId: String,
        fallbackOriginId: String,
        defaultType: ClipType,
    ): LanClipPayload {
        val resolvedOriginId = item?.originId?.takeIf { it.isNotBlank() }
            ?: originId?.takeIf { it.isNotBlank() }
            ?: fallbackOriginId

        val resolvedType = item?.type?.lowercase()?.let { raw ->
            when (raw) {
                "url" -> ClipType.Url
                "text" -> ClipType.Text
                "media", "file", "fileurl" -> ClipType.FileUrl
                else -> defaultType
            }
        } ?: defaultType

        val fallbackContent = when (resolvedType) {
            ClipType.Url -> item?.url ?: ""
            else -> item?.text ?: ""
        }
        val resolvedContent = content.ifBlank { fallbackContent }

        val resolvedTitle = title?.takeIf { it.isNotBlank() }
            ?: item?.title?.takeIf { it.isNotBlank() }
            ?: label.takeIf { it.isNotBlank() }
            ?: item?.fileName

        val resolvedLabel = label.ifBlank { resolvedTitle ?: "" }

        return LanClipPayload(
            originId = resolvedOriginId,
            fromDeviceId = fromDeviceId,
            type = resolvedType,
            content = resolvedContent,
            label = resolvedLabel,
            timestamp = ts.takeIf { it > 0L } ?: System.currentTimeMillis(),
            encrypted = encrypted || (item?.encrypted == true),
            locked = locked || (item?.locked == true),
            iv = iv ?: item?.iv,
            encMode = encMode ?: item?.encMode,
            userId = item?.userId,
            serverId = item?.id?.takeIf { it > 0L },
            sourceId = sourceId ?: item?.sourceId,
            sourceApp = sourceApp ?: item?.sourceApp,
            deleted = isDeleted,
            deletedAtMs = deletedAtEpochMs,
            title = resolvedTitle,
            description = description ?: item?.description,
            localFilePath = item?.localPath,
            fileMimeType = item?.fileMimeType,
            fileExtension = item?.fileExtension,
            fileName = item?.fileName,
            fileSize = item?.fileSize,
        )
    }

    companion object {
        val json = Json {
            ignoreUnknownKeys = true
            isLenient = true
            coerceInputValues = true
            encodeDefaults = true
        }

        fun parseIsoToEpochMs(isoStr: String?): Long? {
            if (isoStr.isNullOrBlank() || isoStr.equals("null", ignoreCase = true)) return null
            return try {
                Instant.parse(isoStr).toEpochMilli()
            } catch (_: Exception) {
                null
            }
        }

        fun fromItem(
            item: LanClipItem,
            deviceId: String,
            os: String = "android",
            localPath: String? = null,
        ): LanClipEnvelope {
            val nowIso = Instant.now().toString()
            val nowMs = System.currentTimeMillis()
            val content = item.text ?: item.url ?: ""
            val label = item.title ?: item.fileName ?: ""
            val itemCreated = item.created?.takeIf { it.isNotBlank() && !it.equals("null", ignoreCase = true) } ?: nowIso
            val itemModified = item.modified?.takeIf { it.isNotBlank() && !it.equals("null", ignoreCase = true) } ?: nowIso
            val itemDeletedAt = item.deletedAt?.takeIf { it.isNotBlank() && !it.equals("null", ignoreCase = true) }

            val enrichedItem = item.copy(
                created = itemCreated,
                modified = itemModified,
                deletedAt = itemDeletedAt,
                os = item.os ?: os,
                deviceId = item.deviceId ?: deviceId,
                localPath = if (localPath != null && item.localPath.isNullOrBlank()) localPath else item.localPath,
            )

            return LanClipEnvelope(
                originId = item.originId,
                content = content,
                label = label,
                title = item.title,
                description = item.description,
                ts = nowMs,
                created = itemCreated,
                modified = itemModified,
                os = os,
                encrypted = item.encrypted,
                locked = item.locked,
                iv = item.iv,
                encMode = item.encMode,
                sourceId = item.sourceId,
                sourceApp = item.sourceApp,
                deletedAt = itemDeletedAt,
                item = enrichedItem,
            )
        }
    }
}
