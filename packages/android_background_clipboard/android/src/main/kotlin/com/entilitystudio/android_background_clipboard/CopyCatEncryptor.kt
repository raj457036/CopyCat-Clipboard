package com.entilitystudio.android_background_clipboard

import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi
import java.util.Base64
import javax.crypto.Cipher
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.SecretKeySpec


@RequiresApi(Build.VERSION_CODES.O)
class CopyCatEncryptor(key: String, iv: String) {
    private val cipher: Cipher
    private val secretKeySpec: SecretKeySpec
    private val ivParameterSpec: IvParameterSpec
    private val base64Encoder: Base64.Encoder = Base64.getEncoder()
    private val base64Decoder: Base64.Decoder = Base64.getDecoder()

    init {
        // Log the raw key and IV
        Log.d("CopyCatEncryptor", "Raw Key: $key")
        Log.d("CopyCatEncryptor", "Raw IV (Base64): $iv")

        val keyBytes = key.toByteArray(Charsets.UTF_8)
        val ivBytes = base64Decoder.decode(iv)

        // Log the decoded key and IV in byte form
        Log.d("CopyCatEncryptor", "Key Bytes: ${keyBytes.contentToString()}")
        Log.d("CopyCatEncryptor", "IV Bytes: ${ivBytes.contentToString()}")

        require(keyBytes.size == 32) {
            "Invalid AES key size. Key must 32 bytes."
        }

        // Initialize the cipher, key spec, and IV spec
        cipher = Cipher.getInstance("AES/CFB64/PKCS5Padding")
        secretKeySpec = SecretKeySpec(keyBytes, "AES")
        ivParameterSpec = IvParameterSpec(ivBytes)
    }

    fun encrypt(data: String): String {
        Log.d("CopyCatEncryptor", "Encrypting Data: $data")

        cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec, ivParameterSpec)
        val encryptedBytes = cipher.doFinal(data.toByteArray(Charsets.UTF_8))

        // Log intermediate encryption results
        Log.d("CopyCatEncryptor", "Encrypted Bytes: ${encryptedBytes.contentToString()}")

        val base64Encrypted = base64Encoder.encodeToString(encryptedBytes)
        Log.d("CopyCatEncryptor", "Base64 Encrypted Data: $base64Encrypted")

        return base64Encrypted
    }

    fun decrypt(encryptedData: String): String {
        Log.d("CopyCatEncryptor", "Decrypting Data: $encryptedData")

        cipher.init(Cipher.DECRYPT_MODE, secretKeySpec, ivParameterSpec)
        val encryptedBytes = base64Decoder.decode(encryptedData)

        // Log intermediate decryption results
        Log.d("CopyCatEncryptor", "Decoded Encrypted Bytes: ${encryptedBytes.contentToString()}")

        val decryptedBytes = cipher.doFinal(encryptedBytes)
        val decryptedString = String(decryptedBytes, Charsets.UTF_8)

        // Log the final decrypted string
        Log.d("CopyCatEncryptor", "Decrypted String: $decryptedString")

        return decryptedString
    }
}
