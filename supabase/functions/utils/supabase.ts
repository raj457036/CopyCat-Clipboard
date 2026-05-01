import { createClient } from "https://esm.sh/@supabase/supabase-js@2.42.4";
import { getEnv } from "./env.ts";

function readKeyDictionary(envName: string): Record<string, string> | null {
  const raw = Deno.env.get(envName);
  if (!raw) return null;

  try {
    const parsed = JSON.parse(raw);
    if (!parsed || typeof parsed !== "object") return null;
    return parsed as Record<string, string>;
  } catch {
    return null;
  }
}

function pickKey(
  dictionary: Record<string, string> | null,
  preferredKeys: string[],
): string | null {
  if (!dictionary) return null;

  for (const key of preferredKeys) {
    const value = dictionary[key];
    if (typeof value === "string" && value.length > 0) {
      return value;
    }
  }

  for (const value of Object.values(dictionary)) {
    if (typeof value === "string" && value.length > 0) {
      return value;
    }
  }

  return null;
}

export function getSupabaseClient(authToken: string | null = null) {
  const headers: Record<string, string> = {};
  const publishableKeys = readKeyDictionary("SUPABASE_PUBLISHABLE_KEYS");

  if (authToken) {
    headers["Authorization"] = authToken;
  }
  const supabaseUrl = getEnv("SU_URL", "SUPABASE_URL") ?? "";
  const supabaseKey =
    pickKey(publishableKeys, ["default", "anon", "publishable"]) ??
    getEnv("SUPABASE_ANON_KEY", "ANON_KEY") ??
    "";

  // Create a Supabase client with the Auth context of the logged in user.
  const supabaseClient = createClient(
    // Supabase API URL - env var exported by default.
    // Deno.env.get("SUPABASE_URL") ?? "",
    supabaseUrl,
    // Supabase API ANON key - env var exported by default.
    // Deno.env.get("SUPABASE_ANON_KEY") ?? "",
    supabaseKey,
    // Create client with Auth context of the user that called the function.
    // This way your row-level-security (RLS) policies are applied.
    {
      global: {
        headers: headers,
      },
    },
  );
  return supabaseClient;
}

export function getSupabaseServiceClient() {
  const supabaseUrl = getEnv("SU_URL", "SUPABASE_URL") ?? "";
  const secretKeys = readKeyDictionary("SUPABASE_SECRET_KEYS");
  const serviceRoleKey =
    pickKey(secretKeys, ["default", "service_role", "secret"]) ??
    getEnv("SUPABASE_SERVICE_ROLE_KEY", "SERVICE_KEY") ??
    "";

  if (!serviceRoleKey) {
    throw new Error(
      "Missing Supabase secret key. Set SUPABASE_SECRET_KEYS or fall back to SERVICE_KEY / SUPABASE_SERVICE_ROLE_KEY for edge functions that write to the database.",
    );
  }

  // Create a service-role client for privileged DB/storage access.
  const supabaseClient = createClient(
    supabaseUrl,
    serviceRoleKey,
    {
      auth: {
        autoRefreshToken: false,
        persistSession: false,
      },
    },
  );
  return supabaseClient;
}
