-- Fix Home Solution schema. Run in Supabase SQL Editor.
create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  phone text,
  role text not null default 'customer' check (role in ('customer','admin')),
  created_at timestamptz not null default now()
);

create table if not exists public.bookings (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete set null,
  customer_name text not null,
  phone text not null,
  service_name text not null,
  booking_date date not null,
  booking_time text not null default '',
  address text not null,
  notes text not null default '',
  status text not null default 'pending'
    check (status in ('pending','confirmed','in_progress','completed','cancelled')),
  created_at timestamptz not null default now()
);

create index if not exists bookings_user_id_idx on public.bookings(user_id);
create index if not exists bookings_created_at_idx on public.bookings(created_at desc);
create index if not exists bookings_date_idx on public.bookings(booking_date);

alter table public.profiles enable row level security;
alter table public.bookings enable row level security;

create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path = public
as $$
  select exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin');
$$;

drop policy if exists "profiles read own or admin" on public.profiles;
create policy "profiles read own or admin" on public.profiles for select to authenticated
using (id = auth.uid() or public.is_admin());

drop policy if exists "profiles insert own" on public.profiles;
create policy "profiles insert own" on public.profiles for insert to authenticated
with check (id = auth.uid() and role = 'customer');

-- No customer profile update policy is enabled by default. This prevents
-- customers from changing their own role to admin through the public API.
-- Add a narrowly-scoped profile update policy only if the app later needs it.

drop policy if exists "customers read own bookings; admins read all" on public.bookings;
create policy "customers read own bookings; admins read all" on public.bookings for select to authenticated
using (user_id = auth.uid() or public.is_admin());

drop policy if exists "signed-in customer creates own booking" on public.bookings;
create policy "signed-in customer creates own booking" on public.bookings for insert to authenticated
with check (user_id = auth.uid());

drop policy if exists "admin updates bookings" on public.bookings;
create policy "admin updates bookings" on public.bookings for update to authenticated
using (public.is_admin()) with check (public.is_admin());

-- Automatically create customer profile on signup.
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public
as $$
begin
  insert into public.profiles (id, full_name, role)
  values (new.id, coalesce(new.raw_user_meta_data->>'full_name',''), 'customer')
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();
