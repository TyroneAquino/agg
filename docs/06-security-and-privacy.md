# Security and privacy

This repository is public. Fill this in honestly and date it; it is checked as
part of grading.

**Last checked:** 2026-10-09

## What this app stores

A.GG has no sign-up form. On first launch it creates an **anonymous Supabase user** (a random ID). No name, email, phone number or password is collected.

| Data | Where it lives | Who can see it |
| --- | --- | --- |
| Anonymous user ID and login session token | On the device (browser storage on web, app storage on mobile, managed by `supabase_flutter`) and in Supabase Auth | The player's own device; the project owner in the Supabase dashboard |
| Player stats (puzzles played and solved, guess totals, one-shots, streaks, last puzzle played) in `player_stats` | Supabase Postgres | The player (own row only, via RLS); the project owner |
| Today's daily progress (names of guessed titles, attempt counts, completed flags, date) in `player_progress` | Supabase Postgres | The player (own row only, via RLS); the project owner |
| Device-transfer codes in `device_transfer_codes`: SHA-256 hash of the code, the user ID that created it, expiry time, used time. The code itself is never stored | Supabase Postgres | Nobody through the app. RLS is on with no policies; only the Edge Function (service role) can read or write it |
| Game content (`anime`, `character`, `soundtrack`, `daily_answers`) | Supabase Postgres | Everyone. It is public game data, not personal data |

## Secrets

- Values my app needs at run time: `SUPABASE_URL` and `SUPABASE_PUBLISHABLE_KEY` (read with `String.fromEnvironment`, passed in with `--dart-define` at build time).
- Where they live locally: `.env`, which is git-ignored. `.env.example` (names only, no values) is committed.
- Where the deploy workflow gets them: GitHub repository secrets (Settings > Secrets and variables > Actions).
- The Edge Function `device-transfer` needs the project URL and the **service role key**. Supabase injects both into the function automatically. They are never in this repository or in the app.
- Anything my deployed web build carries that a visitor could read: the Supabase project URL and the **publishable (anon) key**. This is acceptable because that key is designed to be public: it only identifies the project and gives the access that RLS and grants allow. The **service role key is not** in the build.

## What protects the data on the service side

Row Level Security (RLS) is enabled on every table. Schema, policies and grants are in `docs/schema.sql`.

- **Content tables** (`anime`, `character`, `soundtrack`, `daily_answers`): read-only (`SELECT`) for the app; no insert, update or delete policy.
- **`player_stats` and `player_progress`**: a player can insert, read and update only the row where `auth.uid() = user_id`. There is no delete policy.
- **`device_transfer_codes`**: RLS on, no policies. Only the service role (the Edge Function) can touch it.
- **Device switching (Edge Function `device-transfer`)**: requires a valid login token. A code is 8 characters from a 32-character alphabet, generated with a cryptographic random source, stored only as a SHA-256 hash, valid for 10 minutes and single-use (claimed atomically, so two simultaneous requests cannot both redeem it). A successful transfer moves the stats and progress to the new device and clears them from the old one.

## Checklist

- [✓] `.env` (or `env.json`) is in `.gitignore`, and `.env.example` is committed
- [✓] `git log -p | grep -i "api_key\|secret\|password\|token"` finds nothing real
- [✓] No service account file, keystore or `service_role` key anywhere in the repo
- [✓] Security rules or RLS policies written and tested, not left open
- [✓] No real personal data in sample data, screenshots or the video
- [✓] No course or university credentials anywhere
- [✓] Anyone whose data appears in a test was asked first

