-- À exécuter une seule fois dans Supabase: SQL Editor → New query → Run

create table public.profiles (
  id uuid references auth.users on delete cascade primary key,
  username text unique not null,
  email text,
  created_at timestamptz default now()
);
alter table public.profiles enable row level security;
create policy "profiles_select_all" on public.profiles for select using (true);
create policy "profiles_insert_own" on public.profiles for insert with check (auth.uid() = id);
create policy "profiles_update_own" on public.profiles for update using (auth.uid() = id);

create table public.progress (
  user_id uuid references auth.users on delete cascade not null,
  game_key text not null,
  completed boolean default true,
  last_played timestamptz default now(),
  primary key (user_id, game_key)
);
alter table public.progress enable row level security;
create policy "progress_select_own" on public.progress for select using (auth.uid() = user_id);
create policy "progress_insert_own" on public.progress for insert with check (auth.uid() = user_id);
create policy "progress_update_own" on public.progress for update using (auth.uid() = user_id);
