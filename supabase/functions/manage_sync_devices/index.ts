/// <reference types="https://esm.sh/v135/@supabase/functions-js@2.4.1/src/edge-runtime.d.ts" />

import { corsHeaders } from "../utils/cors.ts";
import {
  getSupabaseClient,
  getSupabaseServiceClient,
} from "../utils/supabase.ts";
import type { SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2";

type Action = "register" | "revoke";

type Payload = {
  action?: Action;
  deviceId?: string;
  platform?: string;
  appVersion?: string;
};

const DEVICE_ACTIVITY_WINDOW_DAYS = 30;
const SUBSCRIPTION_TABLE = "subscription";
const DEVICES_TABLE = "user_devices";
const DEFAULT_DEVICE_LIMIT = 2;

function jsonResponse(body: unknown, status = 200): Response {
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

async function getPlanDeviceLimit(
  client: SupabaseClient,
  userId: string,
): Promise<number> {
  const { data } = await client
    .from(SUBSCRIPTION_TABLE)
    .select("devices")
    .eq("userId", userId)
    .maybeSingle();

  const configuredLimit = Number(data?.devices);
  if (!Number.isFinite(configuredLimit) || configuredLimit <= 0) {
    return DEFAULT_DEVICE_LIMIT;
  }

  return Math.max(1, Math.floor(configuredLimit));
}

async function getActiveDevices(
  client: SupabaseClient,
  userId: string,
) {
  const activeSince = new Date(
    Date.now() - DEVICE_ACTIVITY_WINDOW_DAYS * 24 * 60 * 60 * 1000,
  ).toISOString();

  const { data, error } = await client
    .from(DEVICES_TABLE)
    .select("deviceId, platform, appVersion, isRevoked, last_seen_at")
    .eq("userId", userId)
    .eq("isRevoked", false)
    .gte("last_seen_at", activeSince)
    .order("last_seen_at", { ascending: false });

  if (error) throw new Error(error.message);
  return data ?? [];
}

function normalizeDevices(devices: Array<Record<string, unknown>>) {
  return devices.map((d) => ({
    deviceId: String(d.deviceId ?? ""),
    platform: String(d.platform ?? "unknown"),
    appVersion: (d.appVersion as string | null) ?? null,
    isRevoked: Boolean(d.isRevoked),
    lastSeenAt: String(d.last_seen_at ?? new Date(0).toISOString()),
  }));
}

async function registerDevice(
  client: SupabaseClient,
  userId: string,
  payload: Payload,
) {
  const now = new Date().toISOString();
  const deviceId = payload.deviceId?.trim();
  const platform = payload.platform?.trim() || "unknown";
  const appVersion = payload.appVersion?.trim() || null;

  if (!deviceId) {
    return jsonResponse({ error: "deviceId is required for register" }, 400);
  }

  const [limit, activeDevices] = await Promise.all([
    getPlanDeviceLimit(client, userId),
    getActiveDevices(client, userId),
  ]);

  const otherActiveDevices = activeDevices.filter((d) => d.deviceId !== deviceId);

  if (otherActiveDevices.length >= limit) {
    return jsonResponse({
      allowed: false,
      limit,
      activeCount: activeDevices.length,
      devices: normalizeDevices(activeDevices),
    });
  }

  const { error: upsertError } = await client
    .from(DEVICES_TABLE)
    .upsert(
      {
        userId,
        deviceId,
        platform,
        appVersion,
        isRevoked: false,
        last_seen_at: now,
      },
      { onConflict: "userId,deviceId" },
    );

  if (upsertError) {
    console.error("register device upsert error:", upsertError.message);
    return jsonResponse({ error: "Internal error" }, 500);
  }

  const refreshedDevices = await getActiveDevices(client, userId);

  return jsonResponse({
    allowed: true,
    limit,
    activeCount: refreshedDevices.length,
    devices: normalizeDevices(refreshedDevices),
  });
}

async function revokeDevice(
  client: SupabaseClient,
  userId: string,
  payload: Payload,
) {
  const deviceId = payload.deviceId?.trim();
  if (!deviceId) {
    return jsonResponse({ error: "deviceId is required for revoke" }, 400);
  }

  const { error } = await client
    .from(DEVICES_TABLE)
    .update({ isRevoked: true })
    .eq("userId", userId)
    .eq("deviceId", deviceId);

  if (error) {
    console.error("revoke device error:", error.message);
    return jsonResponse({ error: "Internal error" }, 500);
  }

  return jsonResponse({ success: true });
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (req.method !== "POST") {
    return jsonResponse({ error: "Method not supported" }, 405);
  }

  const user = await getAuthenticatedUser(req);
  if (!user) {
    return jsonResponse({ error: "Unauthorized" }, 401);
  }

  let payload: Payload | null = null;
  try {
    payload = await req.json();
  } catch {
    return jsonResponse({ error: "Invalid JSON body" }, 400);
  }

  const action = payload?.action;
  const serviceClient = getSupabaseServiceClient();

  try {
    if (action === "register") {
      return await registerDevice(serviceClient, user.id, payload);
    }

    if (action === "revoke") {
      return await revokeDevice(serviceClient, user.id, payload);
    }

    return jsonResponse({ error: "Invalid action" }, 400);
  } catch (error) {
    console.error("manage_sync_devices error:", error);
    return jsonResponse({ error: "Internal error" }, 500);
  }
});
