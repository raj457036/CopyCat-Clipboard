/// <reference types="https://esm.sh/v135/@supabase/functions-js@2.4.1/src/edge-runtime.d.ts" />

import { SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2.42.4";
import { batchDeleteDriveFiles, refreshGoogleToken } from "../utils/google.ts";
import { getSupabaseClient } from "../utils/supabase.ts";

async function cleanExpiredClipCollections(client: SupabaseClient) {
  const currentDate = new Date();

  // Subtract 30 days from the current date
  currentDate.setDate(currentDate.getDate() - 30);

  await client.from("clip_collections").delete().lt("deletedAt", currentDate);
}

async function cleanExpiredMediaClips(client: SupabaseClient) {
  // current account query offset
  let aqOffset = 0;
  while (true) {
    const accounts = await client.rpc(
      "get_user_clipboard_sync_duration",
      {
        grace_period: 3,
        free_hr: 24,
      },
    )
      .select("*").range(aqOffset, aqOffset + 100);

    if (!accounts.data) {
      console.info("No accounts found!");
      break;
    }

    for (const row of accounts.data) {
      const { id, syncHr } = row;

      console.info("Running cleanup for User Id: ", id);

      // refresh the google auth token if available
      const result = await refreshGoogleToken(client, id);
      const accessToken = result.status === 200 ? result.access_token : null;

      let ciOffset = 0;
      while (true) {
        // get already expired media/file type clipboard items
        const clips = await client.rpc(
          "get_expired_media_clipboard_item",
          {
            user_id: id,
            sync_hr: syncHr,
          },
        )
          .select("*").range(ciOffset, ciOffset + 100);

        if (!clips.data || clips.data.length === 0) {
          console.info(
            "No media/file clips found for the user, skipping further operations.",
          );
          break;
        }

        const gdriveFileIds = clips.data
          .map((c) => c.file_id as string)
          .filter((fileId: string) => fileId && !fileId.startsWith("webdav:"));

        const clipIds = clips.data.map((c) => c.id);

        if (gdriveFileIds.length > 0 && accessToken) {
          await batchDeleteDriveFiles(gdriveFileIds, accessToken);
        }

        if (clipIds.length > 0) {
          await client.from("clipboard_items").delete().in("id", clipIds);
        }

        console.info("Finished cleanup for User Id: ", id);

        // break when no more data is available
        if (!clips.data || clips.data.length < 100) {
          break;
        }
        ciOffset += 100;
      }
    }

    // break when no more data is available
    if (!accounts.data || accounts.data.length < 100) {
      break;
    }
    aqOffset += 100;
  }
}

async function cleanClipboards(
  client: SupabaseClient,
) {
  await cleanExpiredMediaClips(client);
  await cleanExpiredClipCollections(client);
}

Deno.serve(async (req) => {
  const authToken = req.headers.get("Authorization");
  const supabaseClient = getSupabaseClient(authToken);

  await cleanClipboards(supabaseClient);

  return new Response(
    JSON.stringify({ "done": true }),
    { headers: { "Content-Type": "application/json" } },
  );
});
