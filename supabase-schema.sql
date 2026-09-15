-- ============================================================
-- Resgate Animais — estrutura do banco (Supabase / PostgreSQL)
-- Cole este arquivo inteiro no SQL Editor do Supabase e rode.
-- ============================================================

create extension if not exists "pgcrypto";

-- ------------------------------------------------------------
-- Tabela principal
-- ------------------------------------------------------------
create table if not exists public.animais (
  id                uuid primary key default gen_random_uuid(),
  nome              text not null,
  especie           text,
  sexo              text,
  porte             text,
  idade             text,
  cor               text,
  castrado          boolean not null default false,
  vacinado          boolean not null default false,
  microchip         text,
  data_resgate      date,
  local_resgate     text,
  condicao_saude    text,
  observacoes       text,
  status            text not null default 'disponivel',
  adotante_nome     text,
  adotante_contato  text,
  adotante_documento text,
  data_adocao       date,
  castracao_avisado_em date,
  termo_path        text,
  termo_nome        text,
  fotos             jsonb not null default '[]'::jsonb,
  criado_por        uuid default auth.uid(),
  criado_em         timestamptz not null default now(),
  atualizado_em     timestamptz not null default now()
);

-- para quem já criou a tabela numa versão anterior deste arquivo
alter table public.animais add column if not exists castracao_avisado_em date;

create index if not exists animais_status_idx on public.animais (status);
create index if not exists animais_castrado_idx on public.animais (castrado) where castrado = false;
create index if not exists animais_criado_em_idx on public.animais (criado_em desc);

-- ------------------------------------------------------------
-- Row Level Security: só quem está logado enxerga e mexe
-- ------------------------------------------------------------
alter table public.animais enable row level security;

drop policy if exists "animais_select" on public.animais;
drop policy if exists "animais_insert" on public.animais;
drop policy if exists "animais_update" on public.animais;
drop policy if exists "animais_delete" on public.animais;

create policy "animais_select" on public.animais
  for select to authenticated using (true);
create policy "animais_insert" on public.animais
  for insert to authenticated with check (true);
create policy "animais_update" on public.animais
  for update to authenticated using (true) with check (true);
create policy "animais_delete" on public.animais
  for delete to authenticated using (true);

-- ------------------------------------------------------------
-- Storage: bucket privado para fotos e termos de adoção
-- (privado porque o termo tem dados pessoais do adotante)
-- ------------------------------------------------------------
insert into storage.buckets (id, name, public)
values ('animais', 'animais', false)
on conflict (id) do nothing;

drop policy if exists "animais_files_select" on storage.objects;
drop policy if exists "animais_files_insert" on storage.objects;
drop policy if exists "animais_files_update" on storage.objects;
drop policy if exists "animais_files_delete" on storage.objects;

create policy "animais_files_select" on storage.objects
  for select to authenticated using (bucket_id = 'animais');
create policy "animais_files_insert" on storage.objects
  for insert to authenticated with check (bucket_id = 'animais');
create policy "animais_files_update" on storage.objects
  for update to authenticated using (bucket_id = 'animais');
create policy "animais_files_delete" on storage.objects
  for delete to authenticated using (bucket_id = 'animais');
