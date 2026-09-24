-- ============================================================
-- Emtilak — جدول الملفات الشخصية + RLS + تخزين الصور
--
-- المعمارية: Firebase = مصدر المصادقة والهوية الوحيد، وSupabase قاعدة
-- وتخزين فقط (لا يوجد أي مستخدم أو جلسة في Supabase Auth).
--   * `profiles.id` = معرّف Firebase (UID) نصيًا.
--   * العميل يثبّت هويته بـ `auth.jwt()->>'sub'` — الـ JWT يُصدَّر من
--     Edge Function `firebase-session` بعد التحقق من هوية Firebase.
--   * لا توجد كلمة مرور في هذا الجدول إطلاقًا.
--
-- هذا الملف لتثبيت جديد من الصفر. على قاعدة موجودة
-- بالبنية القديمة (uuid + FK + trigger) استخدم:
--   lib/sqi_migration_firebase_uid.sql
-- ============================================================

-- 1) جدول الملفات الشخصية (id = Firebase UID)
create table if not exists public.profiles (
  id          text primary key,
  full_name   text not null default '' check (char_length(full_name) <= 120),
  phone       text check (phone is null or char_length(phone) <= 30),
  email       text check (email is null or char_length(email) <= 254),
  avatar_url  text check (avatar_url is null or char_length(avatar_url) <= 2048),
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create index if not exists profiles_email_idx on public.profiles (email);

-- 2) updated_at تلقائيًا عند أي تعديل
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists profiles_set_updated_at on public.profiles;
create trigger profiles_set_updated_at
  before update on public.profiles
  for each row execute function public.set_updated_at();

-- ملاحظة مقصودة: لا يوجد trigger على auth.users ولا دالة handle_new_user —
-- صف الملف يُنشأ من التطبيق بـ upsert idempotent بمعرّف Firebase نفسه.

-- 3) تفعيل RLS + سياسات المستخدم على ملفه فقط
--    المقارنة: نص `sub` في الـ JWT (Firebase UID) — وليست auth.uid()
--    لأنها تُلقي sub إلى uuid بينما Firebase UID ليس بصيغة uuid.
alter table public.profiles enable row level security;

drop policy if exists "profiles_select_own" on public.profiles;
create policy "profiles_select_own"
  on public.profiles for select
  to authenticated
  using ((select auth.jwt()->>'sub') = id);

drop policy if exists "profiles_insert_own" on public.profiles;
create policy "profiles_insert_own"
  on public.profiles for insert
  to authenticated
  with check ((select auth.jwt()->>'sub') = id);

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own"
  on public.profiles for update
  to authenticated
  using ((select auth.jwt()->>'sub') = id)
  with check ((select auth.jwt()->>'sub') = id);

-- لا توجد سياسة حذف: لا يملك العميل صلاحية حذف ملفه (الحذف إجراء خادمي).

-- 4) التخزين: صورة الملف الشخصي avatars/{firebase_uid}/...
insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true)
on conflict (id) do nothing;

-- قراءة عامة لصور الأفاتار فقط (صور مخصّصة لعرضها، لا ملفات خاصة)
drop policy if exists "avatars_public_read" on storage.objects;
create policy "avatars_public_read"
  on storage.objects for select
  to public
  using (bucket_id = 'avatars');

drop policy if exists "avatars_insert_own" on storage.objects;
create policy "avatars_insert_own"
  on storage.objects for insert
  to authenticated
  with check (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = (select auth.jwt()->>'sub')
  );

drop policy if exists "avatars_update_own" on storage.objects;
create policy "avatars_update_own"
  on storage.objects for update
  to authenticated
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = (select auth.jwt()->>'sub')
  )
  with check (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = (select auth.jwt()->>'sub')
  );

drop policy if exists "avatars_delete_own" on storage.objects;
create policy "avatars_delete_own"
  on storage.objects for delete
  to authenticated
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = (select auth.jwt()->>'sub')
  );
