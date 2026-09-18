-- ============================================================
-- VisaFlowPro — Cloud sync schema (OPTIONAL)
-- Paste this whole file into: Supabase Dashboard → SQL Editor → Run
-- It creates the user_content table used by the app to sync
-- favorites and checklists per account, protected by RLS so
-- each user can only ever read/write their own row.
-- ============================================================

create table if not exists public.user_content (
  user_id uuid primary key references auth.users (id) on delete cascade,
  favorites jsonb not null default '[]'::jsonb,
  checklist jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.user_content enable row level security;

drop policy if exists "users select own content" on public.user_content;
drop policy if exists "users insert own content" on public.user_content;
drop policy if exists "users update own content" on public.user_content;

create policy "users select own content" on public.user_content
  for select using (auth.uid() = user_id);

create policy "users insert own content" on public.user_content
  for insert with check (auth.uid() = user_id);

create policy "users update own content" on public.user_content
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Recommended for smooth sign-up (no email confirmation loop):
-- Dashboard → Authentication → Providers → Email:
--   turn OFF "Confirm email" (or keep it ON and confirm via inbox).
