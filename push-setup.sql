-- ── 웹 푸시 알림 설정 (1회 실행) ─────────────────────────────
-- 실행 위치: Supabase 대시보드 → SQL Editor → Run
-- 기존 데이터에 영향 없음. 여러 번 실행해도 안전.

create table if not exists public.push_subs (
  endpoint text primary key,
  user_id uuid not null,
  sub jsonb not null,
  created_at timestamptz default now()
);

alter table public.push_subs enable row level security;

drop policy if exists "push_own" on public.push_subs;
create policy "push_own" on public.push_subs
  for all to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());

create index if not exists push_subs_user on public.push_subs(user_id);
