package com.entilitystudio.android_background_clipboard

import android.os.Build
import androidx.annotation.RequiresApi
import java.security.SecureRandom
import java.util.Base64
import javax.crypto.Cipher
import javax.crypto.spec.GCMParameterSpec
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.SecretKeySpec

object EncryptionMode {
    const val CFB = "CFB"
    const val GCM = "GCM"
}

data class EncryptionResult(
    val content: String,
    val iv: String? = null,
    val mode: String = EncryptionMode.CFB,
)

@RequiresApi(Build.VERSION_CODES.O)
class CopyCatEncryptor(key: String, iv: String) {
    private val secretKeySpec: SecretKeySpec
    private val defaultIvBytes: ByteArray
    private val base64Encoder: Base64.Encoder = Base64.getEncoder()
    private val base64Decoder: Base64.Decoder = Base64.getDecoder()
    private val random = SecureRandom()

    init {
        val keyBytes = key.toByteArray(Charsets.UTF_8)
        val ivBytes = base64Decoder.decode(iv)

        require(keyBytes.size == 32) {
            "Invalid AES key size. Key must 32 bytes."
        }
        require(ivBytes.isNotEmpty()) {
            "Invalid initialization vector."
        }

        secretKeySpec = SecretKeySpec(keyBytes, "AES")
        defaultIvBytes = ivBytes
    }

    fun encrypt(data: String, mode: String = EncryptionMode.CFB): EncryptionResult {
        return when (mode) {
            EncryptionMode.GCM -> encryptGcm(data)
            else -> encryptCfb(data)
        }
    }

    fun decrypt(
        encryptedData: String,
        mode: String = EncryptionMode.CFB,
        customIv: String? = null,
    ): String {
        return when (mode) {
            EncryptionMode.GCM -> decryptGcm(encryptedData, customIv)
            else -> decryptCfb(encryptedData, customIv)
        }
    }

    private fun encryptCfb(data: String): EncryptionResult {
        val cipher = Cipher.getInstance("AES/CFB64/NoPadding")
        val ivParameterSpec = IvParameterSpec(defaultIvBytes)
        cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec, ivParameterSpec)
        val encryptedBytes = cipher.doFinal(data.toByteArray(Charsets.UTF_8))
        val base64Encrypted = base64Encoder.encodeToString(encryptedBytes)
        return EncryptionResult(content = base64Encrypted, iv = null, mode = EncryptionMode.CFB)
    }

    private fun encryptGcm(data: String): EncryptionResult {
        val ivBytes = ByteArray(12)
        random.nextBytes(ivBytes)
        val spec = GCMParameterSpec(128, ivBytes)
        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec, spec)
        val encryptedBytes = cipher.doFinal(data.toByteArray(Charsets.UTF_8))
        val base64Encrypted = base64Encoder.encodeToString(encryptedBytes)
        val base64Iv = base64Encoder.encodeToString(ivBytes)
        return EncryptionResult(content = base64Encrypted, iv = base64Iv, mode = EncryptionMode.GCM)
    }

    private fun decryptCfb(encryptedData: String, customIv: String?): String {
        val ivBytes = try {
            val decoded = customIv
                ?.takeIf { it.isNotBlank() && it.lowercase() != "null" }
                ?.let { base64Decoder.decode(it) }
            if (decoded != null && decoded.size == 16) decoded else defaultIvBytes
        } catch (_: Exception) {
            defaultIvBytes
        }
        val cipher = Cipher.getInstance("AES/CFB64/NoPadding")
        val ivParameterSpec = IvParameterSpec(ivBytes)
        cipher.init(Cipher.DECRYPT_MODE, secretKeySpec, ivParameterSpec)
        val encryptedBytes = base64Decoder.decode(encryptedData)
        val decryptedBytes = cipher.doFinal(encryptedBytes)
        return String(decryptedBytes, Charsets.UTF_8)
    }

    private fun decryptGcm(encryptedData: String, customIv: String?): String {
        require(!customIv.isNullOrBlank()) {
            "Missing IV for GCM decryption."
        }
        val ivBytes = base64Decoder.decode(customIv)
        val spec = GCMParameterSpec(128, ivBytes)
        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(Cipher.DECRYPT_MODE, secretKeySpec, spec)
        val encryptedBytes = base64Decoder.decode(encryptedData)
        val decryptedBytes = cipher.doFinal(encryptedBytes)
        return String(decryptedBytes, Charsets.UTF_8)
    }
}
