import { createClient } from "https://esm.sh/@supabase/supabase-js@2.49.8";
import { SignJWT, importPKCS8 } from "npm:jose@5.9.6";

type PushPayload = {
  user_id?: string | null;
  order_id?: string | null;
  status?: string | null;
  type?: string | null;
  title_ar?: string | null;
  message_ar?: string | null;
  target?: string | null;
};

type FailedSend = {
  token: string;
  status: number;
  error: string;
};

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

const fcmProjectId = Deno.env.get("FCM_PROJECT_ID") ?? "";
const fcmClientEmail = Deno.env.get("FCM_CLIENT_EMAIL") ?? "";
const fcmPrivateKeyRaw = Deno.env.get("FCM_PRIVATE_KEY") ?? "";

const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
const supabaseServiceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";

if (!supabaseUrl || !supabaseServiceRoleKey) {
  throw new Error("SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY is missing.");
}

const supabase = createClient(supabaseUrl, supabaseServiceRoleKey, {
  auth: { persistSession: false, autoRefreshToken: false },
});

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (req.method !== "POST") {
    return jsonResponse(
      {
        success: false,
        message: "Method not allowed. Use POST.",
      },
      405,
    );
  }

  if (!fcmProjectId || !fcmClientEmail || !fcmPrivateKeyRaw) {
    return jsonResponse(
      {
        success: false,
        message:
          "Missing FCM secrets. Required: FCM_PROJECT_ID, FCM_CLIENT_EMAIL, FCM_PRIVATE_KEY",
      },
      500,
    );
  }

  let payload: PushPayload;
  try {
    payload = (await req.json()) as PushPayload;
  } catch (_) {
    return jsonResponse(
      {
        success: false,
        message: "Invalid JSON payload.",
      },
      400,
    );
  }

  const title = (payload.title_ar ?? "").toString().trim();
  const message = (payload.message_ar ?? "").toString().trim();
  const userId = (payload.user_id ?? "").toString().trim();
  const orderId = (payload.order_id ?? "").toString().trim();
  const status = (payload.status ?? "").toString().trim();
  const type = (payload.type ?? "").toString().trim();

  if (!title || !message) {
    return jsonResponse(
      {
        success: false,
        message: "title_ar and message_ar are required.",
      },
      400,
    );
  }

  
  
  
  let tokensQuery = supabase
    .from("user_devices")
    .select("device_token, user_id")
    .not("device_token", "is", null);

  if (userId) {
    tokensQuery = tokensQuery.eq("user_id", userId);
  }

  const { data: rows, error: tokensError } = await tokensQuery;
  if (tokensError) {
    return jsonResponse(
      {
        success: false,
        message: "Failed to fetch device tokens.",
        error: tokensError.message,
      },
      500,
    );
  }

  const tokens = (rows ?? [])
    .map((row) => (row.device_token ?? "").toString().trim())
    .where((token) => token.length > 0);

  if (tokens.length === 0) {
    return jsonResponse(
      {
        success: false,
        message: "No tokens found",
        tokens_count: 0,
      },
      200,
    );
  }

  let accessToken: string;
  try {
    accessToken = await getGoogleAccessToken({
      clientEmail: fcmClientEmail,
      privateKey: fcmPrivateKeyRaw,
    });
  } catch (error) {
    return jsonResponse(
      {
        success: false,
        message: "Failed to generate Google OAuth access token.",
        error: String(error),
      },
      500,
    );
  }

  const fcmUrl =
    `https://fcm.googleapis.com/v1/projects/${fcmProjectId}/messages:send`;

  const failed: FailedSend[] = [];
  let sentCount = 0;

  for (const token of tokens) {
    const fcmBody = {
      message: {
        token,
        notification: {
          title,
          body: message,
        },
        data: {
          order_id: orderId,
          status,
          type,
        },
      },
    };

    const response = await fetch(fcmUrl, {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${accessToken}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify(fcmBody),
    });

    if (response.ok) {
      sentCount++;
      continue;
    }

    const errorText = await response.text();
    failed.push({
      token,
      status: response.status,
      error: errorText,
    });
  }

  return jsonResponse(
    {
      success: failed.length === 0,
      tokens_count: tokens.length,
      sent_count: sentCount,
      failed_count: failed.length,
      failed_tokens: failed.map((item) => item.token),
      failures: failed,
      title,
      message,
    },
    200,
  );
});

async function getGoogleAccessToken(params: {
  clientEmail: string;
  privateKey: string;
}): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  const privateKey = params.privateKey.replace(/\\n/g, "\n");
  const scope = "https://www.googleapis.com/auth/firebase.messaging";
  const audience = "https://oauth2.googleapis.com/token";

  const cryptoKey = await importPKCS8(privateKey, "RS256");

  const assertion = await new SignJWT({ scope })
    .setProtectedHeader({ alg: "RS256", typ: "JWT" })
    .setIssuer(params.clientEmail)
    .setAudience(audience)
    .setIssuedAt(now)
    .setExpirationTime(now + 3600)
    .sign(cryptoKey);

  const tokenResponse = await fetch(audience, {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion,
    }),
  });

  if (!tokenResponse.ok) {
    throw new Error(await tokenResponse.text());
  }

  const tokenJson = await tokenResponse.json();
  const accessToken = (tokenJson.access_token ?? "").toString();
  if (!accessToken) {
    throw new Error("Google OAuth token response missing access_token.");
  }
  return accessToken;
}

function jsonResponse(body: Record<string, unknown>, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      ...corsHeaders,
      "Content-Type": "application/json",
    },
  });
}
