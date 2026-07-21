const encoder = new TextEncoder();

export const revenueCatWebhookSignatureHeader =
  "X-RevenueCat-Webhook-Signature";

export interface SignatureVerificationResult {
  ok: boolean;
  status: number;
  error?: string;
}

interface ParsedSignatureHeader {
  timestamp: number;
  signature: string;
}

const toHex = (bytes: ArrayBuffer) =>
  Array.from(new Uint8Array(bytes))
    .map((byte) => byte.toString(16).padStart(2, "0"))
    .join("");

const constantTimeEqual = (left: string, right: string) => {
  if (left.length !== right.length) {
    return false;
  }

  let diff = 0;
  for (let i = 0; i < left.length; i += 1) {
    diff |= left.charCodeAt(i) ^ right.charCodeAt(i);
  }

  return diff === 0;
};

const parseSignatureHeader = (
  signatureHeader: string,
): ParsedSignatureHeader | null => {
  const parts = signatureHeader.split(",").reduce<Record<string, string>>(
    (accumulator, part) => {
      const [key, value] = part.split("=", 2);
      if (key && value) {
        accumulator[key.trim()] = value.trim();
      }
      return accumulator;
    },
    {},
  );

  const timestamp = Number(parts.t);
  const signature = parts.v1;

  if (!Number.isFinite(timestamp) || !signature) {
    return null;
  }

  return {
    timestamp,
    signature,
  };
};

export const verifyRevenueCatWebhookSignature = async (
  rawBody: string,
  signatureHeader: string,
  secret: string,
  toleranceSeconds = 300,
): Promise<SignatureVerificationResult> => {
  const parsedSignature = parseSignatureHeader(signatureHeader);
  if (!parsedSignature) {
    return {
      ok: false,
      error: "Malformed webhook signature",
      status: 401,
    };
  }

  const nowSeconds = Math.floor(Date.now() / 1000);
  if (Math.abs(nowSeconds - parsedSignature.timestamp) > toleranceSeconds) {
    return {
      ok: false,
      error: "Webhook signature expired",
      status: 401,
    };
  }

  const key = await crypto.subtle.importKey(
    "raw",
    encoder.encode(secret),
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"],
  );

  const signedPayload = `${parsedSignature.timestamp}.${rawBody}`;
  const digest = await crypto.subtle.sign(
    "HMAC",
    key,
    encoder.encode(signedPayload),
  );
  const computedSignature = toHex(digest);

  if (!constantTimeEqual(computedSignature, parsedSignature.signature)) {
    return {
      ok: false,
      error: "Invalid webhook signature",
      status: 401,
    };
  }

  return {
    ok: true,
    status: 200,
  };
};