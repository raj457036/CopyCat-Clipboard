package com.entilitystudio.android_background_clipboard

import org.junit.jupiter.api.Test
import kotlin.test.assertEquals
import kotlin.test.assertFalse
import kotlin.test.assertNotNull
import kotlin.test.assertTrue

class LanClipEnvelopeTest {

    @Test
    fun testDecodeStandardTextClip() {
        val jsonStr = """
            {
                "originId": "orig-123",
                "content": "Hello World",
                "label": "My Title",
                "ts": 1700000000000,
                "created": "2026-09-14T12:00:00.000Z",
                "modified": "2026-09-14T12:00:00.000Z",
                "os": "macos",
                "encrypted": false,
                "item": {
                    "originId": "orig-123",
                    "text": "Hello World",
                    "title": "My Title",
                    "type": "text",
                    "created": "2026-09-14T12:00:00.000Z",
                    "modified": "2026-09-14T12:00:00.000Z"
                }
            }
        """.trimIndent()

        val envelope = LanClipEnvelope.json.decodeFromString<LanClipEnvelope>(jsonStr)
        assertEquals("orig-123", envelope.originId)
        assertEquals("Hello World", envelope.content)
        assertFalse(envelope.isDeleted)

        val payload = envelope.toLanClipPayload(
            fromDeviceId = "device-mac",
            fallbackOriginId = "fallback",
            defaultType = ClipType.Text,
        )
        assertEquals("orig-123", payload.originId)
        assertEquals("device-mac", payload.fromDeviceId)
        assertEquals(ClipType.Text, payload.type)
        assertEquals("Hello World", payload.content)
        assertEquals("My Title", payload.label)
        assertFalse(payload.deleted)
    }

    @Test
    fun testDecodeDeletedClipWithIsoStringInItem() {
        val jsonStr = """
            {
                "originId": "del-123",
                "content": "",
                "label": "Deleted Clip",
                "ts": 1700000000000,
                "item": {
                    "originId": "del-123",
                    "type": "text",
                    "deletedAt": "2026-09-14T12:00:00.000Z"
                }
            }
        """.trimIndent()

        val envelope = LanClipEnvelope.json.decodeFromString<LanClipEnvelope>(jsonStr)
        assertTrue(envelope.isDeleted)
        assertNotNull(envelope.deletedAtEpochMs)

        val payload = envelope.toLanClipPayload(
            fromDeviceId = "device-mac",
            fallbackOriginId = "del-123",
            defaultType = ClipType.Text,
        )
        assertTrue(payload.deleted)
        assertEquals(envelope.deletedAtEpochMs, payload.deletedAtMs)
    }

    @Test
    fun testDecodeDeletedClipWithTopLevelIso() {
        val jsonStr = """
            {
                "originId": "del-456",
                "content": "",
                "label": "Deleted Clip",
                "ts": 1700000000000,
                "deletedAt": "2026-09-14T12:00:00.000Z",
                "item": {
                    "originId": "del-456",
                    "type": "text"
                }
            }
        """.trimIndent()

        val envelope = LanClipEnvelope.json.decodeFromString<LanClipEnvelope>(jsonStr)
        assertTrue(envelope.isDeleted)
        assertNotNull(envelope.deletedAtEpochMs)

        val payload = envelope.toLanClipPayload(
            fromDeviceId = "device-mac",
            fallbackOriginId = "del-456",
            defaultType = ClipType.Text,
        )
        assertTrue(payload.deleted)
        assertEquals(envelope.deletedAtEpochMs, payload.deletedAtMs)
    }

    @Test
    fun testFromItemAndRoundtrip() {
        val item = LanClipItem(
            originId = "rt-789",
            text = "Roundtrip Test",
            title = "Test Label",
            type = "text",
            created = "2026-09-14T12:00:00.000Z",
            modified = "2026-09-14T12:00:00.000Z",
            encrypted = true,
            iv = "my-iv",
            encMode = "aes-gcm",
        )

        val envelope = LanClipEnvelope.fromItem(
            item = item,
            deviceId = "test-device",
            os = "android",
        )

        val encoded = LanClipEnvelope.json.encodeToString(LanClipEnvelope.serializer(), envelope)
        val decoded = LanClipEnvelope.json.decodeFromString<LanClipEnvelope>(encoded)

        assertEquals("rt-789", decoded.originId)
        assertEquals("Roundtrip Test", decoded.content)
        assertEquals("Test Label", decoded.label)
        assertTrue(decoded.encrypted)
        assertEquals("my-iv", decoded.iv)
        assertEquals("aes-gcm", decoded.encMode)

        val payload = decoded.toLanClipPayload("peer-1", "fallback", ClipType.Text)
        assertEquals("Roundtrip Test", payload.content)
        assertTrue(payload.encrypted)
        assertEquals("my-iv", payload.iv)
    }
}
