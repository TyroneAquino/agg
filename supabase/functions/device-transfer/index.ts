// TO USE THIS:
// Go to SUPABASE PROJECT -> EDGE FUNCTIONS 
// Click DEPLOY A NEW FUNCTION -> VIA EDITOR
// COPY THE WHOLE THING -> name it as 'device-transfer' -> DEPLOY FUNCTION

// This is used to switch device.

import { withSupabase } from "npm:@supabase/server@^1";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

const CODE_LENGTH = 8;
const CODE_EXPIRATION_MINUTES = 10;

// No I, O, 0, 1 (easy to misread).
const CHARACTERS = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
const CODE_PATTERN = /^[A-HJ-NP-Z2-9]{8}$/;

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

function generateCode(): string {
  const values = new Uint32Array(CODE_LENGTH);
  crypto.getRandomValues(values);

  // 2^32 is divisible by 32, so "% 32" introduces no modulo bias.
  let code = "";
  for (let i = 0; i < CODE_LENGTH; i++) {
    code += CHARACTERS[values[i] % CHARACTERS.length];
  }
  return code;
}

async function hashCode(code: string): Promise<string> {
  const data = new TextEncoder().encode(code);
  const hashBuffer = await crypto.subtle.digest("SHA-256", data);

  return Array.from(new Uint8Array(hashBuffer))
    .map((byte) => byte.toString(16).padStart(2, "0"))
    .join("");
}

function formatCode(code: string): string {
  return `${code.substring(0, 4)}-${code.substring(4)}`;
}

// deno-lint-ignore no-explicit-any
type Ctx = any;

// ------------------------------------------------------------------
// GENERATE
// ------------------------------------------------------------------

async function generate(ctx: Ctx, userId: string): Promise<Response> {
  const admin = ctx.supabaseAdmin;

  // Only one live code per user: invalidate older unused ones.
  const { error: cleanupError } = await admin
    .from("device_transfer_codes")
    .delete()
    .eq("source_user_id", userId)
    .is("used_at", null);

  if (cleanupError) console.error(cleanupError);

  const code = generateCode();
  const codeHash = await hashCode(code);
  const expiresAt = new Date(
    Date.now() + CODE_EXPIRATION_MINUTES * 60 * 1000,
  ).toISOString();

  const { error } = await admin.from("device_transfer_codes").insert({
    source_user_id: userId,
    code_hash: codeHash,
    expires_at: expiresAt,
  });

  if (error) {
    console.error(error);
    return json({ error: "Could not create transfer code." }, 500);
  }

  return json({ code: formatCode(code), expiresAt });
}

// ------------------------------------------------------------------
// TRANSFER
// ------------------------------------------------------------------

async function transfer(
  ctx: Ctx,
  destinationUserId: string,
  rawCode: unknown,
): Promise<Response> {
  if (typeof rawCode !== "string") {
    return json({ error: "Transfer code is required." }, 400);
  }

  const code = rawCode.replace(/[\s-]/g, "").toUpperCase();

  if (!CODE_PATTERN.test(code)) {
    return json({ error: "Invalid transfer code." }, 400);
  }

  const admin = ctx.supabaseAdmin;
  const codeHash = await hashCode(code);
  const nowIso = new Date().toISOString();

  // Claim the code FIRST, in one atomic UPDATE. If two requests race with
  // the same code, only one of them gets a row back. Your own code is
  // never claimed (neq), so it is not burned by a mistaken self-redeem.
  const { data: claimed, error: claimError } = await admin
    .from("device_transfer_codes")
    .update({ used_at: nowIso })
    .eq("code_hash", codeHash)
    .is("used_at", null)
    .gt("expires_at", nowIso)
    .neq("source_user_id", destinationUserId)
    .select("id, source_user_id")
    .maybeSingle();

  if (claimError) {
    console.error(claimError);
    return json({ error: "Could not validate transfer code." }, 500);
  }

  if (!claimed) {
    return json(
      {
        error:
          "Invalid, expired or already used code. (You can't use a code generated on this same device.)",
      },
      400,
    );
  }

  // If anything below fails, give the code back so the user can retry.
  const releaseClaim = async () => {
    const { error } = await admin
      .from("device_transfer_codes")
      .update({ used_at: null })
      .eq("id", claimed.id);
    if (error) console.error("Could not release claimed code:", error);
  };

  const sourceUserId: string = claimed.source_user_id;

  const { data: sourceStats, error: statsError } = await admin
    .from("player_stats")
    .select("stats")
    .eq("user_id", sourceUserId)
    .maybeSingle();

  if (statsError) {
    console.error(statsError);
    await releaseClaim();
    return json({ error: "Could not read source statistics." }, 500);
  }

  const { data: sourceProgress, error: progressError } = await admin
    .from("player_progress")
    .select("progress")
    .eq("user_id", sourceUserId)
    .maybeSingle();

  if (progressError) {
    console.error(progressError);
    await releaseClaim();
    return json({ error: "Could not read source progress." }, 500);
  }

  if (sourceStats) {
    const { error } = await admin.from("player_stats").upsert({
      user_id: destinationUserId,
      stats: sourceStats.stats,
    });

    if (error) {
      console.error(error);
      await releaseClaim();
      return json({ error: "Could not transfer statistics." }, 500);
    }
  }

  if (sourceProgress) {
    const { error } = await admin.from("player_progress").upsert({
      user_id: destinationUserId,
      progress: sourceProgress.progress,
      updated_at: new Date().toISOString(),
    });

    if (error) {
      console.error(error);
      await releaseClaim();
      return json({ error: "Could not transfer progress." }, 500);
    }
  }

  // MOVE, not copy: the data now lives on the new device, so clear it from
  // the old one. This runs only after BOTH copies succeeded. A failure here
  // is logged but does not undo the transfer.
  for (const table of ["player_stats", "player_progress"]) {
    const { error } = await admin
      .from(table)
      .delete()
      .eq("user_id", sourceUserId);

    if (error) console.error(`Could not clear ${table} on old device:`, error);
  }

  return json({ success: true, message: "Progress transferred successfully." });
}

// ------------------------------------------------------------------
// ENTRY POINT
// ------------------------------------------------------------------

const handler = withSupabase({ auth: "user" }, async (req: Request, ctx: Ctx) => {
  // The auth wrapper already verified the JWT. Depending on the package
  // version, the user id is on jwtClaims.sub, userClaims.id or userClaims.sub.
  const userId: string | undefined =
    ctx.jwtClaims?.sub ?? ctx.userClaims?.id ?? ctx.userClaims?.sub;

  if (!userId) {
    console.error(
      "No user id found. userClaims keys:",
      Object.keys(ctx.userClaims ?? {}),
      "jwtClaims keys:",
      Object.keys(ctx.jwtClaims ?? {}),
    );
    return json({ error: "Not authenticated." }, 401);
  }

  let body: { action?: unknown; code?: unknown };
  try {
    body = await req.json();
  } catch {
    return json({ error: "Invalid JSON body." }, 400);
  }

  try {
    if (body.action === "generate") return await generate(ctx, userId);
    if (body.action === "transfer") {
      return await transfer(ctx, userId, body.code);
    }
    return json({ error: "Invalid action." }, 400);
  } catch (error) {
    console.error(error);
    return json({ error: "Something went wrong." }, 500);
  }
});

export default {
  // CORS preflight requests carry no Authorization header, so answer them
  // BEFORE the auth wrapper can reject them. Needed for the Flutter web build.
  fetch: (req: Request, ...rest: unknown[]) => {
    if (req.method === "OPTIONS") {
      // Echo back whatever headers the browser says it will send. Newer
      // supabase clients add extra x-supabase-* headers, and a fixed
      // allow-list makes the browser block the call ("Failed to fetch").
      const requested = req.headers.get("Access-Control-Request-Headers");
      return new Response("ok", {
        headers: {
          ...corsHeaders,
          ...(requested ? { "Access-Control-Allow-Headers": requested } : {}),
          "Access-Control-Max-Age": "86400",
        },
      });
    }
    // deno-lint-ignore no-explicit-any
    return (handler as any)(req, ...rest);
  },
};
