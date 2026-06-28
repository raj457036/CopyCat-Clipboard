/// <reference types="https://esm.sh/v135/@supabase/functions-js@2.4.1/src/edge-runtime.d.ts" />

import { SupabaseClient } from "https://esm.sh/v135/@supabase/supabase-js@2.42.4/dist/module/index.js";
import { corsHeaders } from "../utils/cors.ts";
import RevenueCat from "../utils/revenuecat.ts";
import { getSupabaseServiceClient } from "../utils/supabase.ts";

const planEntitlementId = "pro features";
const maxPasteStackLimit = 2000;

const updateOrCreateSubscription = async (
  serviceClient: SupabaseClient,
  userId: string,
  expiry: number,
  planId: string
) => {
  const result = await serviceClient
    .from("subscription")
    .upsert(
      {
        userId: userId,
        activeTill: new Date(expiry).toISOString(),
        syncHr: planId == planEntitlementId ? 720 : 24,
        planName: planEntitlementId,
        subId: "",
        source: "RC",
        devices: planId == planEntitlementId ? 5 : 2,
        // cers: planId == planEntitlementId,
        // ps_limit: planId == planEntitlementId ? maxPasteStackLimit : 10,
        modified: new Date().toISOString(),
        collections: planId == planEntitlementId ? 50 : 3,
        syncInt: planId == planEntitlementId ? 5 : 45,
      },
      { onConflict: "userId" }
    )
    .select();
  return result;
};

const processRevenuCatWebhook = async (
  rc: RevenueCat,
  serviceClient: SupabaseClient,
  // deno-lint-ignore no-explicit-any
  data: any
) => {
  const appUserId: string =
    data.event.original_app_user_id ?? data.event.app_user_id;
  const customer = await rc.getCustomerInfo(appUserId);
  if (customer) {
    const entitlement = customer.subscriber.entitlements[planEntitlementId];
    if (entitlement) {
      const expiry = new Date(entitlement.expires_date).getTime();
      const result = await updateOrCreateSubscription(
        serviceClient,
        appUserId,
        expiry,
        planEntitlementId
      );
      return {
        data: result,
        status: 200,
      };
    }
    return {
      error: "Customer not found",
      status: 404,
    };
  } else {
    return {
      error: "Customer not found",
      status: 404,
    };
  }
};

Deno.serve(async (req) => {
  if (req.method !== "POST") {
    return new Response(
      JSON.stringify({
        error: "Method not supported",
      }),
      {
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
        status: 405,
      }
    );
  }

  const serviceClient = getSupabaseServiceClient();

  const data = await req.json();

  const rc = RevenueCat.fromEnv();

  const result = await processRevenuCatWebhook(rc, serviceClient, data);

  return new Response(JSON.stringify(result), {
    headers: {
      ...corsHeaders,
      "Content-Type": "application/json",
    },
    status: result.status,
  });
});
