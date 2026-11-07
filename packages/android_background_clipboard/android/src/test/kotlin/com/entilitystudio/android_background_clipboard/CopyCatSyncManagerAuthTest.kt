package com.entilitystudio.android_background_clipboard

import android.content.Context
import android.content.IntentFilter
import android.content.SharedPreferences
import android.content.pm.ApplicationInfo
import android.util.Log
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.buildJsonObject
import kotlinx.serialization.json.jsonObject
import kotlinx.serialization.json.jsonPrimitive
import kotlinx.serialization.json.long
import kotlinx.serialization.json.put
import okhttp3.OkHttpClient
import okhttp3.Protocol
import okhttp3.Request
import okhttp3.Response
import okhttp3.ResponseBody.Companion.toResponseBody
import okhttp3.WebSocket
import org.json.JSONObject
import org.junit.jupiter.api.AfterEach
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.mockito.ArgumentCaptor
import org.mockito.ArgumentMatchers.anyString
import org.mockito.ArgumentMatchers.eq
import org.mockito.MockedConstruction
import org.mockito.MockedStatic
import org.mockito.Mockito
import java.util.concurrent.atomic.AtomicReference
import kotlin.test.assertEquals
import kotlin.test.assertFalse
import kotlin.test.assertNull
import kotlin.test.assertTrue

class CopyCatSyncManagerAuthTest {
    private val tokenKey = "flutter.sb-test-project-auth-token"
    private val context = Mockito.mock(Context::class.java)
    private val preferences = Mockito.mock(SharedPreferences::class.java)
    private val editor = Mockito.mock(SharedPreferences.Editor::class.java)
    private val persistedSession = AtomicReference("{}")
    private val pendingSession = AtomicReference<String>()
    private val requests = mutableListOf<Request>()
    private lateinit var logs: MockedStatic<Log>
    private lateinit var jsonObjects: MockedConstruction<JSONObject>
    private lateinit var intentFilters: MockedConstruction<IntentFilter>

    @BeforeEach
    fun setUp() {
        logs = Mockito.mockStatic(Log::class.java)
        jsonObjects = Mockito.mockConstruction(JSONObject::class.java) { json, construction ->
            if (construction.arguments().isEmpty()) {
                Mockito.`when`(json.toString()).thenReturn("{}")
            } else {
                val value = Json.parseToJsonElement(construction.arguments()[0] as String).jsonObject
                Mockito.`when`(json.optString("refresh_token"))
                    .thenReturn(value["refresh_token"]?.jsonPrimitive?.content ?: "")
                value["access_token"]?.let {
                    Mockito.`when`(json.getString("access_token")).thenReturn(it.jsonPrimitive.content)
                }
                value["refresh_token"]?.let {
                    Mockito.`when`(json.getString("refresh_token")).thenReturn(it.jsonPrimitive.content)
                }
                value["expires_at"]?.let {
                    Mockito.`when`(json.getLong("expires_at")).thenReturn(it.jsonPrimitive.long)
                }
                value["user"]?.let {
                    val user = Mockito.mock(JSONObject::class.java)
                    Mockito.`when`(user.getString("id")).thenReturn(it.jsonObject["id"]!!.jsonPrimitive.content)
                    Mockito.`when`(json.getJSONObject("user")).thenReturn(user)
                }
            }
        }
        intentFilters = Mockito.mockConstruction(IntentFilter::class.java)
        Mockito.`when`(context.applicationContext).thenReturn(context)
        Mockito.`when`(
            context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE),
        ).thenReturn(preferences)
        Mockito.`when`(context.applicationInfo)
            .thenReturn(Mockito.mock(ApplicationInfo::class.java))
        Mockito.`when`(preferences.getString(eq(tokenKey), anyString()))
            .thenAnswer { persistedSession.get() }
        Mockito.`when`(preferences.edit()).thenReturn(editor)
        Mockito.`when`(editor.putString(eq(tokenKey), anyString())).thenAnswer {
            pendingSession.set(it.getArgument(1))
            editor
        }
        Mockito.`when`(editor.commit()).thenAnswer {
            persistedSession.set(pendingSession.get())
            true
        }
    }

    @AfterEach
    fun tearDown() {
        intentFilters.close()
        jsonObjects.close()
        logs.close()
    }

    @Test
    fun `background refresh persists its result when the session is unchanged`() {
        persistedSession.set(session("old", expiresInSeconds = -60))
        val manager = manager()

        assertEquals(1L, manager.writeClipboardItem("text", ClipType.Text, false))
        assertEquals("native-refresh", storedRefreshToken())
        assertEquals("Bearer access-native-refresh", requests.last().header("Authorization"))
        Mockito.verify(editor).commit()
    }

    @Test
    fun `background refresh keeps a newer session written during the request`() {
        persistedSession.set(session("old", expiresInSeconds = -60))
        val manager = manager {
            persistedSession.set(session("flutter-refresh"))
        }

        assertEquals(1L, manager.writeClipboardItem("text", ClipType.Text, false))
        assertEquals("flutter-refresh", storedRefreshToken())
        assertEquals("Bearer access-flutter-refresh", requests.last().header("Authorization"))
        Mockito.verify(preferences, Mockito.never()).edit()
    }

    @Test
    fun `background refresh does not restore a session removed during the request`() {
        persistedSession.set(session("old", expiresInSeconds = -60))
        val manager = manager {
            persistedSession.set("{}")
        }

        assertEquals(-1L, manager.writeClipboardItem("text", ClipType.Text, false))
        assertEquals("{}", persistedSession.get())
        assertTrue(manager.isStopped)
        assertNull(manager.currentUserId)
        assertEquals(listOf("/auth/v1/token"), requests.map { it.url.encodedPath })
        Mockito.verify(preferences, Mockito.never()).edit()
    }

    @Test
    fun `session listener clears credentials on logout and resumes on sign in`() {
        persistedSession.set(session("old"))
        val socket = Mockito.mock(WebSocket::class.java)
        val client = Mockito.mock(OkHttpClient::class.java) {
            if (it.method.name == "newWebSocket") socket else Mockito.RETURNS_DEFAULTS.answer(it)
        }
        val manager = manager(client = client, realtime = true)
        val listener = ArgumentCaptor.forClass(
            SharedPreferences.OnSharedPreferenceChangeListener::class.java,
        )
        Mockito.verify(preferences).registerOnSharedPreferenceChangeListener(listener.capture())

        assertEquals(1, websocketOpens(client))
        persistedSession.set(session("rotated"))
        listener.value.onSharedPreferenceChanged(preferences, tokenKey)
        assertEquals(1, websocketOpens(client))

        persistedSession.set("{}")
        listener.value.onSharedPreferenceChanged(preferences, tokenKey)
        assertTrue(manager.isStopped)
        assertNull(manager.currentUserId)
        Mockito.verify(socket).close(1000, "stopped")

        persistedSession.set(session("signed-in"))
        listener.value.onSharedPreferenceChanged(preferences, tokenKey)
        assertFalse(manager.isStopped)
        assertEquals("user-1", manager.currentUserId)
        assertEquals(2, websocketOpens(client))
    }

    private fun manager(
        client: OkHttpClient? = null,
        realtime: Boolean = false,
        onRefresh: () -> Unit = {},
    ): CopyCatSyncManager {
        val httpClient = client ?: OkHttpClient.Builder()
            .addInterceptor { chain ->
                val request = chain.request()
                requests.add(request)
                val isRefresh = request.url.encodedPath == "/auth/v1/token"
                if (isRefresh) onRefresh()
                Response.Builder()
                    .request(request)
                    .protocol(Protocol.HTTP_1_1)
                    .code(if (isRefresh) 200 else 201)
                    .message("OK")
                    .body((if (isRefresh) session("native-refresh") else "").toResponseBody())
                    .build()
            }
            .build()

        return CopyCatSyncManager(context, {}, httpClient).apply {
            projectKey = "test-project"
            projectApiKey = "test-key"
            deviceId = "test-device"
            syncEnabled = true
            autoWriteOnReceive = realtime
            syncSpeed = if (realtime) "realtime" else "balanced"
            syncIntervalSeconds = if (realtime) 1 else 45
            start()
        }
    }

    private fun websocketOpens(client: OkHttpClient): Int =
        Mockito.mockingDetails(client).invocations.count { it.method.name == "newWebSocket" }

    private fun session(refreshToken: String, expiresInSeconds: Long = 3600): String =
        buildJsonObject {
            put("access_token", "access-$refreshToken")
            put("refresh_token", refreshToken)
            put("expires_at", System.currentTimeMillis() / 1000 + expiresInSeconds)
            put("user", buildJsonObject { put("id", "user-1") })
        }.toString()

    private fun storedRefreshToken(): String =
        Json.parseToJsonElement(persistedSession.get())
            .jsonObject["refresh_token"]!!.jsonPrimitive.content
}
