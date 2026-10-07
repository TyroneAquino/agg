import { withSupabase } from "npm:@supabase/server@^1";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",       
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

const CODE_LENGTH = 8;
const CODE_EXPIRATION_MINUTES = 10;

const CHARACTERS =
  "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";

function generateCode(): string {
  const values = new Uint32Array(CODE_LENGTH);

  crypto.getRandomValues(values);

  let code = "";

  for (let i = 0; i < CODE_LENGTH; i++) {
    code += CHARACTERS[
      values[i] % CHARACTERS.length
    ];
  }

  return code;
}

async function hashCode(code: string): Promise<string> {
  const data = new TextEncoder().encode(code);

  const hashBuffer =
    await crypto.subtle.digest("SHA-256", data);

  const hashArray =
    Array.from(new Uint8Array(hashBuffer));

  return hashArray
    .map((byte) =>
      byte.toString(16).padStart(2, "0")
    )
    .join("");
}

function formatCode(code: string): string {
  return `${code.substring(0, 4)}-${code.substring(4)}`;
}

export default {
  fetch: withSupabase(
    { auth: "user" },
    async (req, ctx) => {
      if (req.method === "OPTIONS") {
        return new Response("ok", {
          headers: corsHeaders,
        });
      }

      try {
        const body = await req.json();

        const action = body.action;

        const userId = ctx.userClaims?.sub;

        if (!userId) {
          return new Response(
            JSON.stringify({
              error: "Not authenticated.",
            }),
            {
              status: 401,
              headers: {
                ...corsHeaders,
                "Content-Type":
                  "application/json",
              },
            },
          );
        }

        // --------------------------------------------------
        // GENERATE CODE
        // --------------------------------------------------

        if (action === "generate") {
          const code = generateCode();

          const codeHash =
            await hashCode(code);

          const expiresAt = new Date(
            Date.now() +
              CODE_EXPIRATION_MINUTES *
                60 *
                1000,
          ).toISOString();

          const { error } =
            await ctx.supabaseAdmin
              .from("device_transfer_codes")
              .insert({
                source_user_id: userId,
                code_hash: codeHash,
                expires_at: expiresAt,
              });

          if (error) {
            console.error(error);

            return new Response(
              JSON.stringify({
                error:
                  "Could not create transfer code.",
              }),
              {
                status: 500,
                headers: {
                  ...corsHeaders,
                  "Content-Type":
                    "application/json",
                },
              },
            );
          }

          return new Response(
            JSON.stringify({
              code: formatCode(code),
              expiresAt: expiresAt,
            }),
            {
              status: 200,
              headers: {
                ...corsHeaders,
                "Content-Type":
                  "application/json",
              },
            },
          );
        }

        // --------------------------------------------------
        // TRANSFER
        // --------------------------------------------------

        if (action === "transfer") {
          if (typeof body.code !== "string") {
            return new Response(
              JSON.stringify({
                error:
                  "Transfer code is required.",
              }),
              {
                status: 400,
                headers: {
                  ...corsHeaders,
                  "Content-Type":
                    "application/json",
                },
              },
            );
          }

          const code =
            body.code
              .replace(/-/g, "")
              .trim()
              .toUpperCase();

          if (code.length !== CODE_LENGTH) {
            return new Response(
              JSON.stringify({
                error:
                  "Invalid transfer code.",
              }),
              {
                status: 400,
                headers: {
                  ...corsHeaders,
                  "Content-Type":
                    "application/json",
                },
              },
            );
          }

          const codeHash =
            await hashCode(code);

          const { data: transfer,
                  error: transferError } =
            await ctx.supabaseAdmin
              .from("device_transfer_codes")
              .select("*")
              .eq("code_hash", codeHash)
              .is("used_at", null)
              .maybeSingle();

          if (transferError) {
            console.error(transferError);

            return new Response(
              JSON.stringify({
                error:
                  "Could not validate transfer code.",
              }),
              {
                status: 500,
                headers: {
                  ...corsHeaders,
                  "Content-Type":
                    "application/json",
                },
              },
            );
          }

          if (!transfer) {
            return new Response(
              JSON.stringify({
                error:
                  "Invalid or already used transfer code.",
              }),
              {
                status: 400,
                headers: {
                  ...corsHeaders,
                  "Content-Type":
                    "application/json",
                },
              },
            );
          }

          if (
            new Date(transfer.expires_at)
              .getTime() < Date.now()
          ) {
            return new Response(
              JSON.stringify({
                error:
                  "This transfer code has expired.",
              }),
              {
                status: 400,
                headers: {
                  ...corsHeaders,
                  "Content-Type":
                    "application/json",
                },
              },
            );
          }

          const sourceUserId =
            transfer.source_user_id;

          const destinationUserId =
            userId;

          if (
            sourceUserId ===
            destinationUserId
          ) {
            return new Response(
              JSON.stringify({
                error:
                  "You cannot transfer to the same device.",
              }),
              {
                status: 400,
                headers: {
                  ...corsHeaders,
                  "Content-Type":
                    "application/json",
                },
              },
            );
          }

          // -----------------------------------------------
          // GET SOURCE STATS
          // -----------------------------------------------

          const { data: sourceStats,
                  error: statsError } =
            await ctx.supabaseAdmin
              .from("player_stats")
              .select("stats")
              .eq("user_id", sourceUserId)
              .maybeSingle();

          if (statsError) {
            console.error(statsError);

            return new Response(
              JSON.stringify({
                error:
                  "Could not read source statistics.",
              }),
              {
                status: 500,
                headers: {
                  ...corsHeaders,
                  "Content-Type":
                    "application/json",
                },
              },
            );
          }

          // -----------------------------------------------
          // GET SOURCE PROGRESS
          // -----------------------------------------------

          const { data: sourceProgress,
                  error: progressError } =
            await ctx.supabaseAdmin
              .from("player_progress")
              .select("progress")
              .eq("user_id", sourceUserId)
              .maybeSingle();

          if (progressError) {
            console.error(progressError);

            return new Response(
              JSON.stringify({
                error:
                  "Could not read source progress.",
              }),
              {
                status: 500,
                headers: {
                  ...corsHeaders,
                  "Content-Type":
                    "application/json",
                },
              },
            );
          }

          // -----------------------------------------------
          // COPY STATS
          // -----------------------------------------------

          if (sourceStats) {
            const { error } =
              await ctx.supabaseAdmin
                .from("player_stats")
                .upsert({
                  user_id:
                    destinationUserId,
                  stats:
                    sourceStats.stats,
                });

            if (error) {
              console.error(error);

              return new Response(
                JSON.stringify({
                  error:
                    "Could not transfer statistics.",
                }),
                {
                  status: 500,
                  headers: {
                    ...corsHeaders,
                    "Content-Type":
                      "application/json",
                  },
                },
              );
            }
          }

          // -----------------------------------------------
          // COPY PROGRESS
          // -----------------------------------------------

          if (sourceProgress) {
            const { error } =
              await ctx.supabaseAdmin
                .from("player_progress")
                .upsert({
                  user_id:
                    destinationUserId,

                  progress:
                    sourceProgress.progress,

                  updated_at:
                    new Date().toISOString(),
                });

            if (error) {
              console.error(error);

              return new Response(
                JSON.stringify({
                  error:
                    "Could not transfer progress.",
                }),
                {
                  status: 500,
                  headers: {
                    ...corsHeaders,
                    "Content-Type":
                      "application/json",
                  },
                },
              );
            }
          }

          // -----------------------------------------------
          // MARK CODE AS USED
          // -----------------------------------------------

          const { error: usedError } =
            await ctx.supabaseAdmin
              .from("device_transfer_codes")
              .update({
                used_at:
                  new Date().toISOString(),
              })
              .eq("id", transfer.id)
              .is("used_at", null);

          if (usedError) {
            console.error(usedError);

            return new Response(
              JSON.stringify({
                error:
                  "Transfer completed, but the code could not be marked as used.",
              }),
              {
                status: 500,
                headers: {
                  ...corsHeaders,
                  "Content-Type":
                    "application/json",
                },
              },
            );
          }

          return new Response(
            JSON.stringify({
              success: true,
              message:
                "Progress transferred successfully.",
            }),
            {
              status: 200,
              headers: {
                ...corsHeaders,
                "Content-Type":
                  "application/json",
              },
            },
          );
        }

        return new Response(
          JSON.stringify({
            error: "Invalid action.",
          }),
          {
            status: 400,
            headers: {
              ...corsHeaders,
              "Content-Type":
                "application/json",
            },
          },
        );
      } catch (error) {
        console.error(error);

        return new Response(
          JSON.stringify({
            error:
              "Something went wrong.",
          }),
          {
            status: 500,
            headers: {
              ...corsHeaders,
              "Content-Type":
                "application/json",
            },
          },
        );
      }
    },
  ),
};