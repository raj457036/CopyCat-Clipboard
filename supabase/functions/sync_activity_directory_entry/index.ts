/// <reference types="https://esm.sh/v135/@supabase/functions-js@2.4.1/src/edge-runtime.d.ts" />

import { corsHeaders } from "../utils/cors.ts";
import {
  getSupabaseClient,
  getSupabaseServiceClient,
} from "../utils/supabase.ts";
import type { SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2";

const TABLE = "app_activity_directory";
const BUCKET = "app-activity-icons";
// 1 year in seconds — signed URL TTL; a cron job renews near-expiry rows server-side.
const SIGNED_URL_TTL = 365 * 24 * 60 * 60;

type Payload = {
  sourceId: string;
  os: string;
  appName?: string;
  // Base64-encoded PNG bytes (≤200 KB after encoding).
  iconBase64?: string;
};

function jsonResponse(body: unknown, status: number): Response {
  return new Response(JSON.stringify(body), {
    headers: { ...corsHeaders, "Content-Type": "application/json" },
    status,
  });
}

async function getAuthenticatedUser(req: Request) {
  const authToken = req.headers.get("Authorization");
  const { data: { user }, error } = await getSupabaseClient(authToken).auth.getUser();
  return error ? null : user;
}

async function parsePayload(req: Request): Promise<Payload | null> {
  try {
    return await req.json();
  } catch {
    return null;
  }
}

/** Returns the existing stored signed URL if the entry already exists, or null. */
async function findExisting(
  client: SupabaseClient,
  sourceId: string,
  os: string,
): Promise<{ found: true; iconRemoteUrl: string | null } | { found: false; error?: string }> {
  const { data, error } = await client
    .from(TABLE)
    .select("iconRemoteUrl")
    .eq("sourceId", sourceId)
    .eq("os", os)
    .maybeSingle();

  if (error) return { found: false, error: error.message };
  if (data !== null) return { found: true, iconRemoteUrl: data.iconRemoteUrl ?? null };
  return { found: false };
}

/** Uploads the icon and returns { bucketPath, remoteUrl }. Both null on failure. */
async function uploadIcon(
  client: SupabaseClient,
  sourceId: string,
  os: string,
  iconBase64: string,
): Promise<{ bucketPath: string | null; remoteUrl: string | null }> {
  try {
    const iconBytes = Uint8Array.from(atob(iconBase64), (c) => c.charCodeAt(0));
    const bucketPath = `${os}/${sourceId.replace(/[^a-zA-Z0-9_\-]/g, "_")}.png`;

    const { error: uploadError } = await client.storage.from(BUCKET).upload(
      bucketPath,
      iconBytes,
      { contentType: "image/png", upsert: false, cacheControl: "max-age=1209600" },
    );

    if (uploadError && !uploadError.message?.includes("already exists")) {
      console.warn("Icon upload skipped:", uploadError.message);
      return { bucketPath: null, remoteUrl: null };
    }

    const { data: signedData } = await client.storage
      .from(BUCKET)
      .createSignedUrl(bucketPath, SIGNED_URL_TTL);

    return { bucketPath, remoteUrl: signedData?.signedUrl ?? null };
  } catch (e) {
    console.warn("Icon decode/upload failed:", e);
    return { bucketPath: null, remoteUrl: null };
  }
}

async function insertEntry(
  client: SupabaseClient,
  sourceId: string,
  os: string,
  appName: string | null,
  iconBucketPath: string | null,
  iconRemoteUrl: string | null,
): Promise<{ error: { code?: string; message: string } | null }> {
  const now = new Date().toISOString();
  const { error } = await client.from(TABLE).insert({
    sourceId,
    os,
    appName,
    iconBucketPath,
    iconRemoteUrl,
    created: now,
    modified: now,
  });
  return { error };
}

async function updateEntryIcon(
  client: SupabaseClient,
  sourceId: string,
  os: string,
  iconBucketPath: string | null,
  iconRemoteUrl: string | null,
): Promise<{ error: { code?: string; message: string } | null }> {
  const { error } = await client.from(TABLE).update({
    iconBucketPath,
    iconRemoteUrl,
    modified: new Date().toISOString(),
  })
    .eq("sourceId", sourceId)
    .eq("os", os);

  return { error };
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });
  if (req.method !== "POST") return jsonResponse({ error: "Method not supported" }, 405);

  const user = await getAuthenticatedUser(req);
  if (!user) return jsonResponse({ error: "Unauthorized" }, 401);

  const body = await parsePayload(req);
  if (!body) return jsonResponse({ error: "Invalid JSON body" }, 400);

  const { sourceId, os, appName, iconBase64 } = body;
  if (!sourceId || !os) return jsonResponse({ error: "sourceId and os are required" }, 400);

  // All DB/storage writes bypass RLS via the service-role client.
  const serviceClient = getSupabaseServiceClient();

  const existing = await findExisting(serviceClient, sourceId, os);
  if ("error" in existing && existing.error) {
    console.error("Directory fetch error:", existing.error);
    return jsonResponse({ error: "Internal error" }, 500);
  }
  if (existing.found) {
    // Backfill icon for existing entries that were previously saved without one.
    if (existing.iconRemoteUrl == null && iconBase64) {
      const { bucketPath, remoteUrl } = await uploadIcon(
        serviceClient,
        sourceId,
        os,
        iconBase64,
      );

      if (bucketPath && remoteUrl) {
        const { error: updateError } = await updateEntryIcon(
          serviceClient,
          sourceId,
          os,
          bucketPath,
          remoteUrl,
        );

        if (!updateError) {
          return jsonResponse({ created: false, iconRemotePath: remoteUrl }, 200);
        }

        console.warn("Directory icon backfill update failed:", updateError);
      }
    }

    // Return the same stored URL every time for CDN cache hits.
    return jsonResponse({ created: false, iconRemotePath: existing.iconRemoteUrl }, 200);
  }

  const { bucketPath, remoteUrl } = iconBase64
    ? await uploadIcon(serviceClient, sourceId, os, iconBase64)
    : { bucketPath: null, remoteUrl: null };

  const { error: insertError } = await insertEntry(
    serviceClient,
    sourceId,
    os,
    appName ?? null,
    bucketPath,
    remoteUrl,
  );

  if (insertError) {
    if (insertError.code === "23505") {
      // Concurrent insert from another device — not an error.
      const existingAfterConflict = await findExisting(serviceClient, sourceId, os);
      if ("found" in existingAfterConflict && existingAfterConflict.found) {
        return jsonResponse(
          { created: false, iconRemotePath: existingAfterConflict.iconRemoteUrl },
          200,
        );
      }
      return jsonResponse({ created: false, iconRemotePath: null }, 200);
    }
    console.error("Directory insert error:", insertError);
    return jsonResponse({ error: "Internal error" }, 500);
  }

  return jsonResponse({ created: true, iconRemotePath: remoteUrl }, 201);
});
