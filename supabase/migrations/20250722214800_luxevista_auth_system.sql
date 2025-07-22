-- LuxeVista Resort Authentication System Migration
-- Location: supabase/migrations/20250722214800_luxevista_auth_system.sql

-- 1. Custom Types
CREATE TYPE public.user_role AS ENUM ('guest', 'premium_guest', 'admin');

-- 2. User Profiles Table (Critical intermediary for auth relationships)
CREATE TABLE public.user_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL UNIQUE,
    full_name TEXT NOT NULL,
    phone TEXT,
    role public.user_role DEFAULT 'guest'::public.user_role,
    preferences JSONB DEFAULT '{
        "language": "en",
        "currency": "USD",
        "notifications": {
            "email": true,
            "push": true,
            "sms": false
        },
        "dietary_restrictions": [],
        "special_requests": []
    }'::jsonb,
    travel_dates JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 3. Essential Indexes
CREATE INDEX idx_user_profiles_email ON public.user_profiles(email);
CREATE INDEX idx_user_profiles_role ON public.user_profiles(role);

-- 4. Enable RLS
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

-- 5. Helper Functions for RLS
CREATE OR REPLACE FUNCTION public.is_profile_owner(profile_user_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT profile_user_id = auth.uid()
$$;

CREATE OR REPLACE FUNCTION public.has_admin_role()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.user_profiles up
    WHERE up.id = auth.uid() AND up.role = 'admin'::public.user_role
)
$$;

-- 6. RLS Policies
CREATE POLICY "users_manage_own_profile"
ON public.user_profiles
FOR ALL
TO authenticated
USING (public.is_profile_owner(id))
WITH CHECK (public.is_profile_owner(id));

CREATE POLICY "admins_view_all_profiles"
ON public.user_profiles
FOR SELECT
TO authenticated
USING (public.has_admin_role());

-- 7. Automatic Profile Creation Function
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.user_profiles (id, email, full_name, role)
    VALUES (
        NEW.id, 
        NEW.email, 
        COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
        COALESCE((NEW.raw_user_meta_data->>'role')::public.user_role, 'guest'::public.user_role)
    );
    RETURN NEW;
END;
$$;

-- 8. Trigger for Automatic Profile Creation
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 9. Update Timestamp Function
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

-- 10. Trigger for Updated At
CREATE TRIGGER update_user_profiles_updated_at
    BEFORE UPDATE ON public.user_profiles
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

-- 11. Mock Data for Development
DO $$
DECLARE
    demo_guest_id UUID := gen_random_uuid();
    demo_admin_id UUID := gen_random_uuid();
BEGIN
    -- Create demo auth users with complete field structure
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
        created_at, updated_at, raw_user_meta_data, raw_app_meta_data,
        is_sso_user, is_anonymous, confirmation_token, confirmation_sent_at,
        recovery_token, recovery_sent_at, email_change_token_new, email_change,
        email_change_sent_at, email_change_token_current, email_change_confirm_status,
        reauthentication_token, reauthentication_sent_at, phone, phone_change,
        phone_change_token, phone_change_sent_at
    ) VALUES
        (demo_guest_id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'guest@luxevista.com', crypt('password123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Sarah Johnson", "role": "guest"}'::jsonb, 
         '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, '+1234567890', '', '', null),
        (demo_admin_id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'admin@luxevista.com', crypt('admin123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Michael Chen", "role": "admin"}'::jsonb,
         '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, '+1987654321', '', '', null);

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Foreign key error during mock data creation: %', SQLERRM;
    WHEN unique_violation THEN
        RAISE NOTICE 'Unique constraint error during mock data creation: %', SQLERRM;
    WHEN OTHERS THEN
        RAISE NOTICE 'Unexpected error during mock data creation: %', SQLERRM;
END $$;

-- 12. Cleanup Function for Development
CREATE OR REPLACE FUNCTION public.cleanup_demo_users()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    demo_user_ids UUID[];
BEGIN
    -- Get demo user IDs
    SELECT ARRAY_AGG(id) INTO demo_user_ids
    FROM auth.users
    WHERE email LIKE '%@luxevista.com';

    -- Delete user profiles first (dependency order)
    DELETE FROM public.user_profiles WHERE id = ANY(demo_user_ids);
    
    -- Delete auth users last
    DELETE FROM auth.users WHERE id = ANY(demo_user_ids);
    
    RAISE NOTICE 'Cleaned up % demo users', array_length(demo_user_ids, 1);
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Foreign key constraint prevents deletion: %', SQLERRM;
    WHEN OTHERS THEN
        RAISE NOTICE 'Cleanup failed: %', SQLERRM;
END;
$$;