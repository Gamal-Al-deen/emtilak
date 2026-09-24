-- ============================================================
-- Emtilak — ترحيل الملفات الشخصية إلى هوية Firebase
--
-- يُنفَّذ مرة واحدة على القاعدة الموجودة (التي شغّلت سكربت sqi.sql
-- القديم ذات البنية uuid + FK إلى auth.users + trigger).
-- آمن بالكامل: لا يحذف ولا يعدّل أي بيانات — البنية والسياسات فقط.
--
-- بعد النشر، يصبح:
--   * profiles.id = Firebase UID (نص)
--   * لا trigger ولا دالة handle_new_user (الإنشاء من التطبيق بـ upsert)
--   * RLS يقارن نص sub في الـ JWT الصادر من Edge Function firebase-session
-- ============================================================

-- 1) إيقاف الإنشاء التلقائي من Supabase Auth (لم يعد مصدر الهوية)
drop trigger if exists on_auth_user_created on auth.users;
drop function if exists public.handle_new_user();

-- 2) المعرّف: من uuid (معرّف Supabase Auth) إلى نص = Firebase UID
alter table public.profiles drop constraint if exists profiles_id_fkey;
alter table public.profiles alter column id type text using id::text;

-- 3) RLS: المقارنة بنص sub في الـ JWT — دالة auth.uid() القديمة كانت
--    تُلقي sub إلى uuid وتفشل مع Firebase UID (رغم أنها كانت تُحجب كل شيء
--    أصلًا لغياب جلسة Supabase Auth).
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

-- 4) التخزين: مجلد المستخدم الأول = Firebase UID (نص)
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

-- سياسة القراءة العامة avatars_public_read لا تعتمد على الهوية — تبقى كما هي.
-- أي صفوف قديمة (بمعرّفات uuid من العهد السابق) تبقى دون حذف إطلاقًا؛
-- أصحابها لن يصلوا إليها بعد الترحيل، ويمكن تمييزها لاحقًا عند الحاجة.
