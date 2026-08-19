package com.entilitystudio.android_background_clipboard

import android.content.Context
import android.util.Log
import java.io.File
import java.util.concurrent.locks.ReentrantReadWriteLock
import kotlin.concurrent.read
import kotlin.concurrent.write

/**
 * File-based clipboard storage to avoid keeping all clipboard items in memory.
 * Each clip is stored in a file named Clip-N.txt with metadata and content.
 */
class CopyCatFileStorage(private val context: Context) {
    private val logTag = "CopyCatFileStorage"
    private val maxCachedClips = 1000
    private val storageDir: File
    private val lock = ReentrantReadWriteLock()
    private var serverIdIndex: MutableMap<Long, String>? = null
    private var originIdIndex: MutableMap<String, String>? = null
    
    init {
        // Create storage directory in app's private storage
        storageDir = File(context.filesDir, "clipboard_cache")
        if (!storageDir.exists()) {
            storageDir.mkdirs()
            debugLog(logTag) { "Created clipboard storage directory: ${storageDir.absolutePath}" }
        }
    }

    private fun ensureServerIdIndexLoaded() {
        if (serverIdIndex != null) return

        val index = mutableMapOf<Long, String>()
        val clipFiles = storageDir.listFiles { file ->
            file.name.startsWith("Clip-") && file.name.endsWith(".txt")
        } ?: emptyArray()

        for (clipFile in clipFiles) {
            val clipId = clipFile.nameWithoutExtension
            val lines = clipFile.readLines()
            if (lines.size < 5) continue
            val serverId = lines[4].toLongOrNull() ?: -1L
            if (serverId > 0) {
                index[serverId] = clipId
            }
        }

        serverIdIndex = index
    }

    private fun ensureOriginIdIndexLoaded() {
        if (originIdIndex != null) return

        val index = mutableMapOf<String, String>()
        val clipFiles = storageDir.listFiles { file ->
            file.name.startsWith("Clip-") && file.name.endsWith(".txt")
        } ?: emptyArray()

        for (clipFile in clipFiles) {
            val clipId = clipFile.nameWithoutExtension
            val lines = clipFile.readLines()
            val separatorIndex = lines.indexOfFirst { it == "---|---|---" }
            if (separatorIndex < 10) continue
            val originId = lines[9].trim()
            if (originId.isNotEmpty()) {
                index[originId] = clipId
            }
        }

        originIdIndex = index
    }

    private fun pruneOldClipsLocked() {
        val clipFiles = storageDir.listFiles { file ->
            file.name.startsWith("Clip-") && file.name.endsWith(".txt")
        } ?: return

        if (clipFiles.size <= maxCachedClips) return

        val clipsByTimestamp = clipFiles.mapNotNull { clipFile ->
            val lines = try {
                clipFile.readLines()
            } catch (_: Exception) {
                return@mapNotNull null
            }
            val timestamp = lines.getOrNull(3)?.toLongOrNull() ?: Long.MAX_VALUE
            Triple(clipFile, timestamp, clipFile.nameWithoutExtension)
        }.sortedBy { it.second }

        val pruneCount = clipsByTimestamp.size - maxCachedClips
        clipsByTimestamp.take(pruneCount).forEach { (clipFile, _, clipId) ->
            ensureServerIdIndexLoaded()
            ensureOriginIdIndexLoaded()
            removeServerIdForClipId(clipId)
            removeOriginIdForClipId(clipId)
            if (!clipFile.delete()) {
                Log.w(logTag, "Failed to prune clip file $clipId")
            }
        }
    }

    private fun removeServerIdForClipId(clipId: String) {
        val iterator = serverIdIndex?.entries?.iterator() ?: return
        while (iterator.hasNext()) {
            if (iterator.next().value == clipId) {
                iterator.remove()
            }
        }
    }

    private fun removeOriginIdForClipId(clipId: String) {
        val iterator = originIdIndex?.entries?.iterator() ?: return
        while (iterator.hasNext()) {
            if (iterator.next().value == clipId) {
                iterator.remove()
            }
        }
    }
    
    /**
     * Write a clipboard item to disk
     * Format:
     * Line 0: id
     * Line 1: type
     * Line 2: label
     * Line 3: timestamp
     * Line 4: serverId (or -1 if not synced)
     * Line 5: userId (or empty if not synced)
     * Line 6: encrypted (true/false)
     * Line 7: iv (base64, empty when not applicable)
     * Line 8: encMode (CFB/GCM, empty when not applicable)
    * Line 9: originId (base62, empty for old-format clips)
    * Line 10: sourceId/packageName (empty when unknown)
    * Line 11: sourceApp/appName (empty when unknown)
    * Line 12: deletedAt timestamp millis (empty when not deleted)
    * Line 13: ---|---|---
    * Line 14+: clip content
     */
    fun writeClipItem(
        clipId: String,
        text: String,
        type: ClipType,
        label: String = "",
        encrypted: Boolean = false,
        iv: String? = null,
        encMode: String? = null,
        serverId: Long = -1,
        userId: String = "",
        timestamp: Long = System.currentTimeMillis(),
        originId: String = "",
        sourceId: String = "",
        sourceApp: String = "",
        deletedAt: Long? = null,
    ): Boolean = lock.write {
        try {
            writeClipItemLocked(
                clipId = clipId,
                text = text,
                type = type,
                label = label,
                encrypted = encrypted,
                iv = iv,
                encMode = encMode,
                serverId = serverId,
                userId = userId,
                timestamp = timestamp,
                originId = originId,
                sourceId = sourceId,
                sourceApp = sourceApp,
                deletedAt = deletedAt,
            )
            debugLog(logTag) { "Wrote $clipId to disk (${text.length} bytes)" }
            return true
        } catch (e: Exception) {
            Log.e(logTag, "Error writing clip item: ${e.message}", e)
            return false
        }
    }

    fun writeClipItemIfOriginMissing(
        clipId: String,
        text: String,
        type: ClipType,
        label: String = "",
        encrypted: Boolean = false,
        iv: String? = null,
        encMode: String? = null,
        serverId: Long = -1,
        userId: String = "",
        timestamp: Long = System.currentTimeMillis(),
        originId: String = "",
        sourceId: String = "",
        sourceApp: String = "",
        deletedAt: Long? = null,
    ): ClipWriteOutcome = lock.write {
        try {
            val normalizedOriginId = originId.trim()
            ensureOriginIdIndexLoaded()
            if (normalizedOriginId.isNotEmpty()) {
                val existingClipId = originIdIndex?.get(normalizedOriginId)
                if (existingClipId != null) {
                    return ClipWriteOutcome.Duplicate(existingClipId)
                }
            }

            writeClipItemLocked(
                clipId = clipId,
                text = text,
                type = type,
                label = label,
                encrypted = encrypted,
                iv = iv,
                encMode = encMode,
                serverId = serverId,
                userId = userId,
                timestamp = timestamp,
                originId = normalizedOriginId,
                sourceId = sourceId,
                sourceApp = sourceApp,
                deletedAt = deletedAt,
            )
            debugLog(logTag) { "Wrote $clipId to disk (${text.length} bytes)" }
            ClipWriteOutcome.Written(clipId)
        } catch (e: Exception) {
            Log.e(logTag, "Error writing clip item: ${e.message}", e)
            ClipWriteOutcome.Failed
        }
    }

    private fun writeClipItemLocked(
        clipId: String,
        text: String,
        type: ClipType,
        label: String,
        encrypted: Boolean,
        iv: String?,
        encMode: String?,
        serverId: Long,
        userId: String,
        timestamp: Long,
        originId: String,
        sourceId: String,
        sourceApp: String,
        deletedAt: Long?,
    ) {
        val clipFile = File(storageDir, "$clipId.txt")
        clipFile.bufferedWriter().use { writer ->
            writer.write("$clipId\n")
            writer.write("$type\n")
            writer.write("$label\n")
            writer.write("$timestamp\n")
            writer.write("$serverId\n")
            writer.write("$userId\n")
            writer.write("$encrypted\n")
            writer.write("${iv ?: ""}\n")
            writer.write("${encMode ?: ""}\n")
            writer.write("$originId\n")
            writer.write("$sourceId\n")
            writer.write("$sourceApp\n")
            writer.write("${deletedAt ?: ""}\n")
            writer.write("---|---|---\n")
            writer.write(text)
        }

        ensureServerIdIndexLoaded()
        ensureOriginIdIndexLoaded()
        if (serverId > 0) {
            serverIdIndex?.put(serverId, clipId)
        }
        if (originId.isNotBlank()) {
            originIdIndex?.put(originId, clipId)
        }
        pruneOldClipsLocked()
    }
    
    /**
     * Update server metadata after successful sync
     */
    fun updateServerMetadata(clipId: String, serverId: Long, userId: String): Boolean = lock.write {
        try {
            val clipFile = File(storageDir, "$clipId.txt")
            if (!clipFile.exists()) {
                Log.w(logTag, "Clip file $clipId does not exist")
                return false
            }
            
            // Read the entire file
            val lines = clipFile.readLines().toMutableList()
            
            if (lines.size < 7) {
                Log.w(logTag, "Invalid clip file format for $clipId")
                return false
            }
            
            val oldServerId = lines[4].toLongOrNull() ?: -1L
            val oldOriginId = lines.getOrNull(9)?.trim()?.takeIf { it.isNotEmpty() }
            // Update serverId (line 4) and userId (line 5)
            lines[4] = serverId.toString()
            lines[5] = userId
            
            // Write back to file
            clipFile.writeText(lines.joinToString("\n"))

            ensureServerIdIndexLoaded()
            ensureOriginIdIndexLoaded()
            if (oldServerId > 0 && oldServerId != serverId) {
                serverIdIndex?.remove(oldServerId)
            }
            if (serverId > 0) {
                serverIdIndex?.put(serverId, clipId)
            }
            if (oldOriginId != null) {
                originIdIndex?.put(oldOriginId, clipId)
            }
            
            debugLog(logTag) { "Updated $clipId with server ID $serverId" }
            return true
        } catch (e: Exception) {
            Log.e(logTag, "Error updating server metadata: ${e.message}", e)
            return false
        }
    }

    fun deleteClipItem(clipId: String): Boolean = lock.write {
        try {
            val clipFile = File(storageDir, "$clipId.txt")
            if (clipFile.exists()) {
                ensureServerIdIndexLoaded()
                ensureOriginIdIndexLoaded()
                removeServerIdForClipId(clipId)
                removeOriginIdForClipId(clipId)
                val deleted = clipFile.delete()
                if (deleted) {
                    debugLog(logTag) { "Deleted clip file $clipId" }
                } else {
                    Log.w(logTag, "Failed to delete clip file $clipId")
                }
                return deleted
            } else {
                Log.w(logTag, "Clip file $clipId does not exist")
                return false
            }
        } catch (e: Exception) {
            Log.e(logTag, "Error deleting clip item: ${e.message}", e)
            return false
        }
    }

    fun findClipIdByServerId(serverId: Long): String? = lock.read {
        try {
            ensureServerIdIndexLoaded()
            return serverIdIndex?.get(serverId)
        } catch (e: Exception) {
            Log.e(logTag, "Error finding clip by server ID $serverId: ${e.message}")
            return null
        }
    }

    fun findClipIdByOriginId(originId: String): String? = lock.read {
        try {
            if (originId.isBlank()) return null
            ensureOriginIdIndexLoaded()
            return originIdIndex?.get(originId.trim())
        } catch (e: Exception) {
            Log.e(logTag, "Error finding clip by originId $originId: ${e.message}")
            return null
        }
    }

    fun deleteClipByServerId(serverId: Long): Boolean = lock.write {
        val clipId = findClipIdByServerId(serverId) ?: return false
        return deleteClipItem(clipId)
    }
    
    /**
     * Read a single clipboard item by ID
     */
    fun readClipItem(clipId: String): ClipData? = lock.read {
        try {
            val clipFile = File(storageDir, "$clipId.txt")
            if (!clipFile.exists()) {
                return null
            }
            
            val lines = clipFile.readLines()
            if (lines.size < 7) {
                Log.w(logTag, "Invalid clip file format for $clipId")
                return null
            }

            val separatorIndex = lines.indexOfFirst { it == "---|---|---" }
            if (separatorIndex == -1) {
                Log.w(logTag, "Missing separator for $clipId")
                return null
            }
            
            val id = lines[0]
            val type = ClipType.valueOf(lines[1])
            val label = lines[2]
            val timestamp = lines[3].toLongOrNull() ?: 0L
            val serverId = lines[4].toLongOrNull() ?: -1L
            val userId = lines[5]

            val hasEncryptionMetadata = separatorIndex >= 9 && lines.size >= 10
            val encrypted = if (hasEncryptionMetadata) {
                lines[6].toBooleanStrictOrNull() ?: false
            } else {
                false
            }
            val iv = if (hasEncryptionMetadata) lines[7].ifBlank { null } else null
            val encMode = if (hasEncryptionMetadata) lines[8].ifBlank { null } else null
            // Line 9 is originId in new format (separator was at 9 in old format)
            val originId = if (separatorIndex >= 10) lines[9].ifBlank { null } else null
            val sourceId = if (separatorIndex >= 11) lines[10].ifBlank { null } else null
            val sourceApp = if (separatorIndex >= 12) lines[11].ifBlank { null } else null
            val deletedAt = when {
                separatorIndex >= 13 -> lines[12].toLongOrNull()
                else -> null
            }
            
            val text = if (separatorIndex != -1 && separatorIndex < lines.size - 1) {
                lines.subList(separatorIndex + 1, lines.size).joinToString("\n")
            } else {
                ""
            }
            
            return ClipData(
                id,
                text,
                type,
                label,
                timestamp,
                serverId,
                userId,
                encrypted,
                iv,
                encMode,
                originId,
                sourceId,
                sourceApp,
                deletedAt,
            )
        } catch (e: Exception) {
            Log.e(logTag, "Error reading clip $clipId: ${e.message}")
            return null
        }
    }
    
    /**
     * Read all clipboard items (called when app opens)
     */
    fun readAllClips(): List<ClipData> = lock.read {
        try {
            val clips = mutableListOf<ClipData>()
            
            val clipFiles = storageDir.listFiles { file ->
                file.name.startsWith("Clip-") && file.name.endsWith(".txt")
            } ?: return emptyList()
            
            for (clipFile in clipFiles) {
                val clipId = clipFile.nameWithoutExtension
                readClipItem(clipId)?.let { clips.add(it) }
            }
            
            // Sort by timestamp (oldest first)
            clips.sortBy { it.timestamp }
            
            debugLog(logTag) { "Read ${clips.size} clips from disk" }
            return clips
        } catch (e: Exception) {
            Log.e(logTag, "Error reading clips: ${e.message}", e)
            return emptyList()
        }
    }
    
    /**
     * Clear all clipboard storage (called when app opens)
     */
    fun clearAll() {
        lock.write {
            try {
                val deleted = storageDir.listFiles()?.count { file ->
                    if (file.name.startsWith("Clip-") && file.name.endsWith(".txt")) {
                        file.delete()
                    } else {
                        false
                    }
                } ?: 0
                serverIdIndex = mutableMapOf()
                originIdIndex = mutableMapOf()
                
                debugLog(logTag) { "Cleared $deleted clipboard files" }
            } catch (e: Exception) {
                Log.e(logTag, "Error clearing storage: ${e.message}", e)
            }
        }
    }
    
    /**
     * Get storage statistics
     */
    fun getStorageStats(): StorageStats {
        return lock.read {
            try {
                val clipFiles = storageDir.listFiles { file ->
                    file.name.startsWith("Clip-") && file.name.endsWith(".txt")
                } ?: emptyArray()
                
                val clipCount = clipFiles.size
                val totalSize = clipFiles.sumOf { it.length() }
                
                StorageStats(clipCount, totalSize)
            } catch (e: Exception) {
                Log.e(logTag, "Error getting storage stats: ${e.message}")
                StorageStats(0, 0L)
            }
        }
    }

    data class ClipData(
        val id: String,
        val text: String,
        val type: ClipType,
        val label: String,
        val timestamp: Long,
        val serverId: Long = -1,
        val userId: String = "",
        val encrypted: Boolean = false,
        val iv: String? = null,
        val encMode: String? = null,
        val originId: String? = null,
        val sourceId: String? = null,
        val sourceApp: String? = null,
        val deletedAt: Long? = null,
    ) {
        fun toMap(): Map<String, Any?> {
            return mapOf(
                "id" to id,
                "text" to text,
                "type" to type.name, // assuming ClipType is an enum
                "label" to label,
                "timestamp" to timestamp,
                "serverId" to serverId,
                "userId" to userId,
                "encrypted" to encrypted,
                "iv" to iv,
                "encMode" to encMode,
                "originId" to originId,
                "sourceId" to sourceId,
                "sourceApp" to sourceApp,
                "deletedAt" to deletedAt,
            )
        }
    }


    data class StorageStats(
        val clipCount: Int,
        val totalBytes: Long
    ) {
        val totalMB: Float get() = totalBytes / (1024f * 1024f)
    }

    sealed class ClipWriteOutcome {
        data class Written(val clipId: String) : ClipWriteOutcome()
        data class Duplicate(val clipId: String) : ClipWriteOutcome()
        data object Failed : ClipWriteOutcome()
    }
}
