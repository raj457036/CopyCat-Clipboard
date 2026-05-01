/// <reference types="https://esm.sh/v135/@supabase/functions-js@2.4.1/src/edge-runtime.d.ts" />

import { getSupabaseServiceClient } from "../utils/supabase.ts";
import type { SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2";

const TABLE = "app_activity_directory";
const BUCKET = "app-activity-icons";

// Must match the TTL used at insert time in sync_activity_directory_entry.
const SIGNED_URL_TTL = 31_536_000; // 1 year in seconds

// Renew entries whose signed URL will expire within 7 days.
// modified tracks the last time the URL was generated, so expiry ≈ modified + 1 year.
const RENEW_THRESHOLD_DAYS = 7;
const PAGE_SIZE = 100;

function renewalCutoff(): string {
  const d = new Date();
  d.setFullYear(d.getFullYear() - 1); // 1 year ago
  d.setDate(d.getDate() + RENEW_THRESHOLD_DAYS); // move forward by threshold
  return d.toISOString();
}

async function renewPage(
  client: SupabaseClient,
  cutoff: string,
  offset: number,
): Promise<number> {
  const { data, error } = await client
    .from(TABLE)
    .select("sourceId, os, iconBucketPath")
    .not("iconBucketPath", "is", null)
    .lt("modified", cutoff)
    .range(offset, offset + PAGE_SIZE - 1);

  if (error) {
    console.error("Fetch error:", error.message);
    return 0;
  }

  if (!data || data.length === 0) return 0;

  let renewed = 0;
  for (const row of data) {
    const { data: signedData, error: signError } = await client.storage
      .from(BUCKET)
      .createSignedUrl(row.iconBucketPath, SIGNED_URL_TTL);

    if (signError || !signedData?.signedUrl) {
      console.warn(`Skipping ${row.sourceId}/${row.os}: ${signError?.message}`);
      continue;
    }

    const { error: updateError } = await client
      .from(TABLE)
      .update({ iconRemoteUrl: signedData.signedUrl, modified: new Date().toISOString() })
      .eq("sourceId", row.sourceId)
      .eq("os", row.os);

    if (updateError) {
      console.warn(`Update failed for ${row.sourceId}/${row.os}: ${updateError.message}`);
    } else {
      renewed++;
    }
  }

  return renewed;
}

Deno.serve(async (req) => {
  // Only the Supabase scheduler (POST) should reach this function.
  // JWT verification is enforced at the gateway (verify_jwt = true in config.toml).
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), {
      headers: { "Content-Type": "application/json" },
      status: 405,
    });
  }

  const client = getSupabaseServiceClient();
  const cutoff = renewalCutoff();

  console.log(`Renewing entries with modified < ${cutoff}`);

  let totalRenewed = 0;
  let offset = 0;

  while (true) {
    const count = await renewPage(client, cutoff, offset);
    totalRenewed += count;
    if (count < PAGE_SIZE) break;
    offset += PAGE_SIZE;
  }

  console.log(`Done. Renewed ${totalRenewed} signed URLs.`);

  return new Response(
    JSON.stringify({ renewed: totalRenewed }),
    { headers: { "Content-Type": "application/json" }, status: 200 },
  );
});
