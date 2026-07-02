import { SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2.42.4";
import { parseJwt } from "./utils.ts";

export type GTokenResponse = {
  access_token: string;
  expires_in: number;
  refresh_token: string;
  scope: string;
  token_type: string;
  id_token: string;
};

export async function refreshGoogleToken(
  client: SupabaseClient,
  userId: string,
) {
  try {
    const { data: cred, error: credError } = await client
      .from("drive_credentials")
      .select("refresh_token")
      .eq("userId", userId)
      .limit(1);

    if (credError) {
      console.error(credError);
      return { status: 400, error: credError };
    }

    if (!cred || !cred[0]) {
      console.error("No credential found!");
      return { status: 400, error: "No credential found!" };
    }

    const refreshToken = cred[0].refresh_token;

    const url = "https://www.googleapis.com/oauth2/v4/token";

    const payload = new URLSearchParams({
      client_id: Deno.env.get("GOOGLE_CLIENT_ID") ?? "",
      client_secret: Deno.env.get("GOOGLE_CLIENT_SECRET") ?? "",
      grant_type: "refresh_token",
      refresh_token: refreshToken,
    });

    const response = await fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: payload.toString(),
    });

    const responseJson = await response.json();

    if (response.status !== 200) {
      return {
        status: response.status,
        data: responseJson,
      };
    }

    const { access_token, expires_in, scope, id_token } =
      responseJson as GTokenResponse;

    const issued_at = new Date().toISOString();
    const id_token_payload = parseJwt(id_token);
    const user_id = id_token_payload.sub;
    const user_email = id_token_payload.email;
    const result = await client
      .from("drive_credentials")
      .update({
        access_token: access_token,
        expires_in: expires_in,
        scopes: scope.split(" "),
        provider: "google-drive",
        account_id: user_id,
        display_text: user_email,
      })
      .eq("userId", userId);

    const { data: _, error: saveError } = result;

    return {
      access_token: access_token,
      expires_in: expires_in,
      issued_at: issued_at,
      scopes: scope.split(" "),
      provider: "google-drive",
      account_id: user_id,
      display_text: user_email,
      error: saveError,
      status: saveError ? 400 : 200,
    };
  } catch (error) {
    return {
      error: error,
      status: 400,
    };
  }
}

export async function deleteDriveFile(fileId: string, accessToken: string) {
  try {
    const url = `https://www.googleapis.com/drive/v3/files/${fileId}?supportsAllDrives=true`;

    const response = await fetch(url, {
      method: "DELETE",
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
    });

    return {
      data: await response.json(),
      status: response.status,
    };
  } catch (error) {
    return {
      error: error,
      status: 400,
    };
  }
}

export async function batchDeleteDriveFiles(
  fileIds: string[],
  accessToken: string,
) {
  const tasks = [];

  for (const id of fileIds) {
    tasks.push(deleteDriveFile(id, accessToken));
  }
  console.log(`Deleting ${fileIds.length} files from drive`);
  await Promise.allSettled(tasks);
  console.log(`Deleted ${fileIds.length} files from drive`);
}
