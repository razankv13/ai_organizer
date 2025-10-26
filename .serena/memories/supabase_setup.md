# Supabase Setup Information

## Project Configuration

- **Project Name**: AI-organizer
- **Project ID**: thuqxygpjqmkfjxzqjbl
- **Region**: ap-southeast-1 (Singapore)
- **Database**: PostgreSQL 17.6.1.025
- **Project URL**: https://thuqxygpjqmkfjxzqjbl.supabase.co

## Environment Variables

Credentials are stored in `.env` file:
- `SUPABASE_URL`: Project URL
- `SUPABASE_ANON_KEY`: Anonymous/public API key
- `.env` is in `.gitignore` to prevent credential leakage

## Database Schema

### Tables
1. **notes** - Core note entity with user_id, title, content, timestamps, flags (pinned, archived, favorite), folder_id, color
2. **tags** - Reusable tags with user_id, name, color, use_count (auto-incremented), description
3. **attachments** - File references with user_id, note_id, file metadata, type enum, thumbnails
4. **note_tags** - Junction table for many-to-many notes-tags relationship
5. **profiles** - User profile information with full_name, avatar_url, bio, preferences (JSONB)

### Applied Migrations
1. `create_initial_schema` - Created tables, indexes, triggers, and full-text search
2. `enable_row_level_security` - Enabled RLS and created user-scoped policies
3. `optimize_rls_and_functions_v2` - Performance and security optimizations
4. `create_profiles_table` (2025-10-26) - Created profiles table with auto-creation on signup, backfilled existing users

### Storage
- **attachments** bucket: 50MB limit, private access, organized by user_id
- Supports images, documents, audio, video, text files
- RLS policies ensure users can only access their own files

## Security

- All tables have Row Level Security (RLS) enabled
- Optimized RLS policies with `(select auth.uid())` pattern
- Functions use `SECURITY DEFINER` with `SET search_path = public`
- All security and performance advisors resolved

## Code Integration

- Config: `lib/config/supabase_config.dart` - uses environment variables
- Initialization: Called in `main.dart` after loading `.env`
- Client access: `Supabase.instance.client`
- Authentication: Managed by Supabase Auth with automatic RLS scoping
- Profile Management: `lib/providers/auth_provider.dart` - getUserProfile() and updateUserProfile()

## Full-Text Search

Enabled on notes table:
- `idx_notes_title_search` - Title search using PostgreSQL tsvector
- `idx_notes_content_search` - Content search using PostgreSQL tsvector

## Auto-Incrementing Features

- `updated_at` on notes and profiles tables auto-updates via trigger
- Tag `use_count` auto-increments/decrements when tags are applied/removed
- Profile auto-created for new users via trigger on auth.users

## Documentation

Comprehensive setup guide available in `SUPABASE_SETUP.md` at project root.
