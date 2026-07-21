/// <reference types="https://esm.sh/v135/@supabase/functions-js@2.4.1/src/edge-runtime.d.ts" />

import { SupabaseClient } from "https://esm.sh/v135/@supabase/supabase-js@2.42.4/dist/module/index.js";
import { corsHeaders } from "../utils/cors.ts";
import { getEnv } from "../utils/env.ts";
import {
  revenueCatWebhookSignatureHeader,
  verifyRevenueCatWebhookSignature,
} from "../utils/revenuecat_webhook.ts";
import { getSupabaseServiceClient } from "../utils/supabase.ts";

const planEntitlementId = "pro features";
const maxPasteStackLimit = 2000;
const maxDeviceLimit = 12;

const logPrefix = "[rc_webhook]";

const getEventSummary = (
  // deno-lint-ignore no-explicit-any
  data: any,
) => {
  const event = data?.event ?? {};
  return {
    eventType: event.type ?? null,
    appUserId: event.original_app_user_id ?? event.app_user_id ?? null,
    entitlementId: event.entitlement_id ?? null,
    entitlementIds: event.entitlement_ids ?? null,
    expirationAtMs: event.expiration_at_ms ?? null,
    productId: event.product_id ?? null,
  };
};

const getPlanConfig = (planId: string) => ({
  syncHr: planId == planEntitlementId ? 720 : 24,
  devices: planId == planEntitlementId ? maxDeviceLimit : 2,
  collections: planId == planEntitlementId ? 50 : 3,
  syncInt: planId == planEntitlementId ? 5 : 45,
  pasteStackLimit: planId == planEntitlementId ? maxPasteStackLimit : 10,
});

const updateOrCreateSubscription = async (
  serviceClient: SupabaseClient,
  userId: string,
  expiry: number,
  planId: string
) => {
  const planConfig = getPlanConfig(planId);
  const currentSubscription = await serviceClient
    .from("subscription")
    .select("activeTill")
    .eq("userId", userId)
    .maybeSingle();

  if (currentSubscription.error) {
    console.error(
      `${logPrefix} failed to fetch current subscription`,
      JSON.stringify({
        userId,
        planId,
        error: currentSubscription.error,
      })
    );
    return {
      data: null,
      error: currentSubscription.error,
    };
  }

  const currentExpiry = currentSubscription.data?.activeTill
    ? new Date(currentSubscription.data.activeTill).getTime()
    : null;
  const effectiveExpiry = currentExpiry && currentExpiry > expiry
    ? currentExpiry
    : expiry;

  console.info(
    `${logPrefix} upserting subscription`,
    JSON.stringify({
      userId,
      planId,
      incomingExpiryIso: new Date(expiry).toISOString(),
      currentExpiryIso: currentExpiry ? new Date(currentExpiry).toISOString() : null,
      effectiveExpiryIso: new Date(effectiveExpiry).toISOString(),
    })
  );

  const result = await serviceClient
    .from("subscription")
    .upsert(
      {
        userId: userId,
        activeTill: new Date(effectiveExpiry).toISOString(),
        syncHr: planConfig.syncHr,
        planName: planId,
        subId: "",
        source: "RC_WEBHOOK",
        devices: planConfig.devices,
        ps_limit: planConfig.pasteStackLimit,
        modified: new Date().toISOString(),
        collections: planConfig.collections,
        syncInt: planConfig.syncInt,
      },
      { onConflict: "userId" }
    )
    .select();

  if (result.error) {
    console.error(
      `${logPrefix} subscription upsert failed`,
      JSON.stringify({
        userId,
        planId,
        error: result.error,
      })
    );
  } else {
    console.info(
      `${logPrefix} subscription upsert succeeded`,
      JSON.stringify({
        userId,
        planId,
        rows: result.data?.length ?? 0,
      })
    );
  }

  return result;
};

const processRevenuCatWebhook = async (
  serviceClient: SupabaseClient,
  // deno-lint-ignore no-explicit-any
  data: any
) => {
  const eventSummary = getEventSummary(data);
  console.info(
    `${logPrefix} processing webhook`,
    JSON.stringify(eventSummary)
  );

  const appUserId: string =
    data?.event?.original_app_user_id ?? data?.event?.app_user_id;
  const entitlementId: string | undefined =
    data?.event?.entitlement_id ?? data?.event?.entitlement_ids?.[0];
  const expiry: number | undefined = data?.event?.expiration_at_ms;

  if (!appUserId) {
    console.error(
      `${logPrefix} missing app user id`,
      JSON.stringify(eventSummary)
    );
    return {
      error: "App user id not found",
      status: 400,
    };
  }

  if (!entitlementId) {
    console.error(
      `${logPrefix} entitlement missing from payload`,
      JSON.stringify(eventSummary)
    );
    return {
      error: "Entitlement not found",
      status: 422,
    };
  }

  if (!expiry) {
    console.error(
      `${logPrefix} entitlement expiry missing from payload`,
      JSON.stringify({
        appUserId,
        entitlementId,
        eventType: data?.event?.type ?? null,
      })
    );
    return {
      error: "Entitlement expiry not found",
      status: 422,
    };
  }

  console.info(
    `${logPrefix} matched entitlement from payload`,
    JSON.stringify({
      appUserId,
      entitlementId,
      productIdentifier: data?.event?.product_id ?? null,
      expiryIso: new Date(expiry).toISOString(),
      store: data?.event?.store ?? null,
      periodType: data?.event?.period_type ?? null,
    })
  );

  const result = await updateOrCreateSubscription(
    serviceClient,
    appUserId,
    expiry,
    entitlementId
  );

  if (result.error) {
    return {
      error: result.error.message,
      status: 500,
    };
  }

  return {
    data: result.data,
    status: 200,
  };
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

  const webhookSecret = getEnv("REVENUECAT_WEBHOOK_SECRET");
  if (!webhookSecret) {
    console.error(`${logPrefix} webhook secret not configured`);
    return new Response(
      JSON.stringify({
        error: "Webhook secret not configured",
      }),
      {
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
        status: 500,
      }
    );
  }

  const signatureHeader = req.headers.get(revenueCatWebhookSignatureHeader);
  if (!signatureHeader) {
    console.error(`${logPrefix} webhook signature header missing`);
    return new Response(
      JSON.stringify({
        error: "Webhook signature missing",
      }),
      {
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
        status: 401,
      }
    );
  }

  const rawBody = await req.text();
  const signatureCheck = await verifyRevenueCatWebhookSignature(
    rawBody,
    signatureHeader,
    webhookSecret,
  );
  if (!signatureCheck.ok) {
    console.error(
      `${logPrefix} webhook signature verification failed`,
      JSON.stringify({ reason: signatureCheck.error })
    );
    return new Response(
      JSON.stringify({
        error: signatureCheck.error,
      }),
      {
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
        status: signatureCheck.status,
      }
    );
  }

  const serviceClient = getSupabaseServiceClient();

  const data = JSON.parse(rawBody);
  console.info(
    `${logPrefix} request received`,
    JSON.stringify(getEventSummary(data))
  );

  const result = await processRevenuCatWebhook(serviceClient, data);

  console.info(
    `${logPrefix} request completed`,
    JSON.stringify({ status: result.status })
  );

  return new Response(JSON.stringify(result), {
    headers: {
      ...corsHeaders,
      "Content-Type": "application/json",
    },
    status: result.status,
  });
});
