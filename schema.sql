-- ════════════════════════════════════════════════════════════
-- Home Budget App — Supabase Schema
-- Run this in: Supabase Dashboard → SQL Editor → New Query
-- ════════════════════════════════════════════════════════════

-- Transactions
create table if not exists public.transactions (
  id               uuid primary key default gen_random_uuid(),
  user_id          uuid references auth.users(id) on delete cascade not null,
  name             text not null,
  amount           numeric(10,2) not null,
  category         text not null,
  type             text not null check (type in ('income','expense')),
  date             date not null,
  payment_method   text check (payment_method in ('credit','cash','bank','loan')),
  credit_group_id  text,
  credit_current   integer,
  credit_total     integer,
  credit_last4     varchar(4),
  recurring_id     uuid,
  created_at       timestamptz default now()
);

-- Monthly budget limits (one row per user per category)
create table if not exists public.budgets (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid references auth.users(id) on delete cascade not null,
  category     text not null,
  limit_amount numeric(10,2) not null,
  unique(user_id, category)
);

-- Recurring transactions
create table if not exists public.recurring (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid references auth.users(id) on delete cascade not null,
  name       text not null,
  amount     numeric(10,2) not null,
  category   text not null,
  type       text not null check (type in ('income','expense')),
  freq       text not null default 'monthly' check (freq in ('monthly','weekly','yearly')),
  day        integer default 1 check (day between 1 and 31),
  created_at timestamptz default now()
);

-- Bank accounts
create table if not exists public.bank_accounts (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid references auth.users(id) on delete cascade not null,
  name        text not null,
  account_id  text,
  balance     numeric(12,2) not null default 0,
  frame_limit numeric(12,2) not null default 0,
  created_at  timestamptz default now()
);

-- ── Row Level Security (each user sees only their own data) ──

alter table public.transactions  enable row level security;
alter table public.budgets       enable row level security;
alter table public.recurring     enable row level security;
alter table public.bank_accounts enable row level security;

create policy "own_transactions" on public.transactions
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "own_budgets" on public.budgets
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "own_recurring" on public.recurring
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "own_bank_accounts" on public.bank_accounts
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- ── Indexes for query performance ────────────────────────────

create index if not exists idx_transactions_user_date on public.transactions(user_id, date desc);
create index if not exists idx_transactions_recurring  on public.transactions(recurring_id);
create index if not exists idx_recurring_user          on public.recurring(user_id);
