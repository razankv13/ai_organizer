-- Migration: Create profiles table for user profile information
-- Description: Implements user profiles with automatic creation on signup
-- Version: 7
-- Date: 2025-10-26

-- Create profiles table
CREATE TABLE IF NOT EXISTS profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name TEXT,
    avatar_url TEXT,
    bio TEXT,
    preferences JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_profiles_full_name ON profiles(full_name);
CREATE INDEX IF NOT EXISTS idx_profiles_updated_at ON profiles(updated_at DESC);

-- Enable Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Users can view their own profile
CREATE POLICY "Users can view their own profile"
    ON profiles
    FOR SELECT
    USING (auth.uid() = id);

-- RLS Policy: Users can update their own profile
CREATE POLICY "Users can update their own profile"
    ON profiles
    FOR UPDATE
    USING (auth.uid() = id)
    WITH CHECK (auth.uid() = id);

-- RLS Policy: Allow profile creation for authenticated users
CREATE POLICY "Users can create their own profile"
    ON profiles
    FOR INSERT
    WITH CHECK (auth.uid() = id);

-- Create trigger to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_profiles_updated_at()
RETURNS TRIGGER
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_profiles_updated_at
    BEFORE UPDATE ON profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_profiles_updated_at();

-- Create function to automatically create profile on user signup
CREATE OR REPLACE FUNCTION create_profile_for_user()
RETURNS TRIGGER
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    INSERT INTO public.profiles (id, full_name, avatar_url)
    VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.raw_user_meta_data->>'name', ''),
        COALESCE(NEW.raw_user_meta_data->>'avatar_url', NEW.raw_user_meta_data->>'picture', '')
    )
    ON CONFLICT (id) DO NOTHING;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to automatically create profile when user signs up
CREATE TRIGGER trigger_create_profile_on_signup
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION create_profile_for_user();

-- Backfill profiles for existing users (if any)
INSERT INTO public.profiles (id, full_name, avatar_url)
SELECT
    id,
    COALESCE(raw_user_meta_data->>'full_name', raw_user_meta_data->>'name', ''),
    COALESCE(raw_user_meta_data->>'avatar_url', raw_user_meta_data->>'picture', '')
FROM auth.users
ON CONFLICT (id) DO NOTHING;

-- Add comments for documentation
COMMENT ON TABLE profiles IS 'Stores user profile information including display name, avatar, and preferences';
COMMENT ON COLUMN profiles.id IS 'User ID (references auth.users)';
COMMENT ON COLUMN profiles.full_name IS 'User''s display name';
COMMENT ON COLUMN profiles.avatar_url IS 'URL to user''s profile picture';
COMMENT ON COLUMN profiles.bio IS 'User biography or description';
COMMENT ON COLUMN profiles.preferences IS 'JSON object storing user preferences and settings';
COMMENT ON COLUMN profiles.created_at IS 'Timestamp when the profile was created';
COMMENT ON COLUMN profiles.updated_at IS 'Timestamp when the profile was last updated';
