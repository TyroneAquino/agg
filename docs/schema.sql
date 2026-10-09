-- =====================================================================
-- A.GG database schema
-- Run in: Supabase dashboard -> SQL Editor (safe to re-run).
--
-- Built from the table and policy screenshots in agg_table.docx.
-- Column names, types, keys and policy NAMES come from those screenshots.
-- Things the screenshots could not show are marked VERIFY:
--   * the rule text inside each policy (assumed from the policy names)
--   * default values and the exact foreign-key delete behavior
--   * the policies on daily_answers (not in the document)
-- Row data is NOT included here; export it from the Table Editor
-- (CSV) or with `supabase db dump --data-only` into docs/seed.sql.
-- =====================================================================


-- =====================================================================
-- CONTENT TABLES (read-only for the app)
-- =====================================================================

-- anime ---------------------------------------------------------------
create table if not exists public.anime (
  id          bigint primary key,
  name        text not null unique,      -- character.series and soundtrack.anime point at this
  alt_name    text,
  year        bigint,
  season      text,
  theme       text[],
  genre       text[],
  demographic text,
  studio      text[],
  source      text,
  status      text,
  format      text[],
  synopsis    text
);

-- character -----------------------------------------------------------
create table if not exists public."character" (
  id          bigint primary key,
  name        text not null,
  series      text references public.anime (name),   -- "series references the name of anime"
  eye         text[],
  hair        text[],
  sex         text,
  species     text,
  occupation  text[],
  affiliation text[],
  status      text,
  power       text[],
  signature   text,
  quote       text
);

-- soundtrack ----------------------------------------------------------
create table if not exists public.soundtrack (
  id      bigint primary key,
  title   text not null,
  anime   text references public.anime (name),       -- "anime references the name of anime"
  link    text,
  type    text,
  artist  text,
  support text
);

-- daily_answers -------------------------------------------------------
-- One row per day. date is TEXT in the form 'YYYY-MM-DD' (the app queries it as a string).
-- The three answer columns are ids of the matching content tables.
-- Make sure a row exists for every upcoming date, or that day's puzzle fails to load.
create table if not exists public.daily_answers (
  date              text primary key,
  answer_character  bigint references public."character" (id),
  answer_anime      bigint references public.anime (id),
  answer_soundtrack bigint references public.soundtrack (id)
);


-- =====================================================================
-- PLAYER TABLES (one row per user, owner-only)
-- =====================================================================

-- player_stats --------------------------------------------------------
create table if not exists public.player_stats (
  user_id    uuid primary key references auth.users (id) on delete cascade,  -- VERIFY on delete
  stats      jsonb,
  updated_at timestamptz                                                      -- VERIFY default
);

-- player_progress -----------------------------------------------------
create table if not exists public.player_progress (
  user_id    uuid primary key references auth.users (id) on delete cascade,  -- VERIFY on delete
  progress   jsonb,
  updated_at timestamptz
);


-- =====================================================================
-- DEVICE TRANSFER (touched only by the device-transfer edge function)
-- =====================================================================

create table if not exists public.device_transfer_codes (
  id             uuid primary key default gen_random_uuid(),                 -- VERIFY default
  source_user_id uuid not null references auth.users (id) on delete cascade, -- VERIFY on delete
  code_hash      text not null,                                              -- SHA-256 of the code, hex
  expires_at     timestamptz not null,
  used_at        timestamptz,                                                -- NULL until redeemed
  created_at     timestamptz not null default now()
);

-- The function looks codes up by hash.
create unique index if not exists device_transfer_codes_code_hash_key
  on public.device_transfer_codes (code_hash);


-- =====================================================================
-- ROW LEVEL SECURITY
-- =====================================================================

alter table public.anime                 enable row level security;
alter table public."character"           enable row level security;
alter table public.soundtrack            enable row level security;
alter table public.daily_answers         enable row level security;
alter table public.player_stats          enable row level security;
alter table public.player_progress       enable row level security;
alter table public.device_transfer_codes enable row level security;
-- device_transfer_codes: RLS on and NO policies on purpose. Only the
-- service role (edge function) can read or write it.

-- Content tables: everyone can read ----------------------------------
-- (Anonymous sign-ins use the "authenticated" role, so the policy
--  "Authenticated users can read ..." also covers them.)
drop policy if exists "Allow anonymous read access to anime" on public.anime;
create policy "Allow anonymous read access to anime"
  on public.anime for select to anon using (true);

drop policy if exists "Authenticated users can read anime" on public.anime;
create policy "Authenticated users can read anime"
  on public.anime for select to authenticated using (true);

drop policy if exists "Allow anonymous read access to character" on public."character";
create policy "Allow anonymous read access to character"
  on public."character" for select to anon using (true);

drop policy if exists "Authenticated users can read character" on public."character";
create policy "Authenticated users can read character"
  on public."character" for select to authenticated using (true);

drop policy if exists "Allow anonymous read access to soundtrack" on public.soundtrack;
create policy "Allow anonymous read access to soundtrack"
  on public.soundtrack for select to anon using (true);

drop policy if exists "Authenticated users can read soundtrack" on public.soundtrack;
create policy "Authenticated users can read soundtrack"
  on public.soundtrack for select to authenticated using (true);

-- daily_answers: policies were not in the document. VERIFY / replace with
-- your real ones. The app reads this table when it is signed in.
drop policy if exists "Authenticated users can read daily_answers" on public.daily_answers;
create policy "Authenticated users can read daily_answers"
  on public.daily_answers for select to authenticated using (true);

-- player_stats: owner only --------------------------------------------
drop policy if exists "Users can insert their own stats" on public.player_stats;
create policy "Users can insert their own stats"
  on public.player_stats for insert to authenticated
  with check (auth.uid() = user_id);

drop policy if exists "Users can read their own stats" on public.player_stats;
create policy "Users can read their own stats"
  on public.player_stats for select to authenticated
  using (auth.uid() = user_id);

drop policy if exists "Users can update their own stats" on public.player_stats;
create policy "Users can update their own stats"
  on public.player_stats for update to authenticated
  using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- player_progress: owner only ------------------------------------------
drop policy if exists "Users can insert their own progress" on public.player_progress;
create policy "Users can insert their own progress"
  on public.player_progress for insert to authenticated
  with check (auth.uid() = user_id);

drop policy if exists "Users can view their own progress" on public.player_progress;
create policy "Users can view their own progress"
  on public.player_progress for select to authenticated
  using (auth.uid() = user_id);

drop policy if exists "Users can update their own progress" on public.player_progress;
create policy "Users can update their own progress"
  on public.player_progress for update to authenticated
  using (auth.uid() = user_id) with check (auth.uid() = user_id);


-- =====================================================================
-- GRANTS (the Data API only exposes a table to a role that has a grant;
-- RLS then filters rows. A missing grant is what caused the earlier
-- "API DISABLED" / "Could not read source statistics" errors.)
-- =====================================================================

-- Content tables: read-only for the app.
grant select on public.anime, public."character", public.soundtrack
  to anon, authenticated;
grant select on public.daily_answers to authenticated;

-- Player tables: the app reads and writes its own rows.
grant select, insert, update on public.player_stats    to authenticated;
grant select, insert, update on public.player_progress to authenticated;

-- Edge function (service role): full access to what it uses.
grant all on public.player_stats          to service_role;
grant all on public.player_progress       to service_role;
grant all on public.device_transfer_codes to service_role;

notify pgrst, 'reload schema';
