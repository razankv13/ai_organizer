# Supabase Setup Documentation

## Overview

This document outlines the complete Supabase setup for the AI Organizer project, including database schema, security policies, and integration details.

## Project Details

- **Project Name**: AI-organizer
- **Project ID**: thuqxygpjqmkfjxzqjbl
- **Region**: ap-southeast-1 (Singapore)
- **Database Version**: PostgreSQL 17.6.1.025
- **Project URL**: https://thuqxygpjqmkfjxzqjbl.supabase.co

## Environment Configuration

### Required Environment Variables

Create a `.env` file in the project root with the following variables:

```env
# Supabase Configuration
SUPABASE_URL=https://thuqxygpjqmkfjxzqjbl.supabase.co
SUPABASE_ANON_KEY=your_supabase_anon_key_here

# AI API Keys
GEMINI_API_KEY=your_gemini_api_key_here
```

**Important**:
- The `.env` file is already added to `.gitignore` to prevent credential leakage
- Never commit the `.env` file to version control
- Use `.env.example` as a template for new developers

## Database Schema

### Applied Migrations

1. **create_initial_schema** (2025-10-25)
   - Created all core tables (notes, tags, attachments, note_tags)
   - Set up foreign key relationships
   - Added indexes for performance
   - Created triggers for auto-updating timestamps and tag counts
   - Enabled full-text search on notes

2. **enable_row_level_security** (2025-10-25)
   - Enabled RLS on all tables
   - Created user-scoped security policies
   - Set up storage bucket policies

3. **optimize_rls_and_functions_v2** (2025-10-25)
   - Optimized RLS policies with `(select auth.uid())` pattern for better performance
   - Fixed function security with `SECURITY DEFINER` and `SET search_path`
   - Resolved all security and performance advisors

### Tables

#### notes
Stores user notes with metadata and flags.

| Column | Type | Description |
|--------|------|-------------|
| id | TEXT (PK) | UUID identifier |
| user_id | UUID (FK) | References auth.users |
| title | TEXT | Note title |
| content | TEXT | Note body/content (nullable) |
| created_at | TIMESTAMPTZ | Creation timestamp |
| updated_at | TIMESTAMPTZ | Last update timestamp (auto-updated) |
| is_pinned | BOOLEAN | Pin to top flag |
| is_archived | BOOLEAN | Archive status |
| is_favorite | BOOLEAN | Favorite flag |
| folder_id | TEXT | Parent folder reference (nullable) |
| color | TEXT | Note color code (nullable) |

**Indexes**:
- `idx_notes_user_id` - User lookup
- `idx_notes_created_at` - Chronological sorting
- `idx_notes_updated_at` - Recent updates
- `idx_notes_is_pinned` - Pinned notes filter
- `idx_notes_is_favorite` - Favorite notes filter
- `idx_notes_is_archived` - Archived notes filter
- `idx_notes_folder_id` - Folder organization
- `idx_notes_title_search` - Full-text search on titles
- `idx_notes_content_search` - Full-text search on content

#### tags
Reusable tags for categorizing notes.

| Column | Type | Description |
|--------|------|-------------|
| id | TEXT (PK) | UUID identifier |
| user_id | UUID (FK) | References auth.users |
| name | TEXT | Tag name |
| created_at | TIMESTAMPTZ | Creation timestamp |
| color | TEXT | Tag color (nullable) |
| use_count | INTEGER | Usage frequency (auto-incremented) |
| description | TEXT | Tag description (nullable) |

**Indexes**:
- `idx_tags_user_id` - User lookup
- `idx_tags_name` - Tag name search
- `idx_tags_use_count` - Popular tags sorting

#### attachments
File attachments linked to notes.

| Column | Type | Description |
|--------|------|-------------|
| id | TEXT (PK) | UUID identifier |
| user_id | UUID (FK) | References auth.users |
| note_id | TEXT (FK) | References notes.id |
| file_name | TEXT | Original file name |
| file_path | TEXT | Storage path |
| type | TEXT | Attachment type (image, document, audio, video, other) |
| file_size | INTEGER | Size in bytes (nullable) |
| created_at | TIMESTAMPTZ | Upload timestamp |
| mime_type | TEXT | MIME type (nullable) |
| thumbnail_path | TEXT | Thumbnail path (nullable) |
| metadata | JSONB | Additional metadata (nullable) |

**Indexes**:
- `idx_attachments_user_id` - User lookup
- `idx_attachments_note_id` - Note attachments
- `idx_attachments_type` - Type filtering

#### note_tags
Junction table for many-to-many notes-tags relationship.

| Column | Type | Description |
|--------|------|-------------|
| note_id | TEXT (PK, FK) | References notes.id |
| tag_id | TEXT (PK, FK) | References tags.id |
| created_at | TIMESTAMPTZ | Association timestamp |

**Indexes**:
- `idx_note_tags_note_id` - Tags for a note
- `idx_note_tags_tag_id` - Notes with a tag

### Database Functions

#### update_updated_at_column()
Trigger function that automatically updates the `updated_at` timestamp on notes table updates.

#### increment_tag_use_count()
Trigger function that increments the `use_count` when a tag is applied to a note.

#### decrement_tag_use_count()
Trigger function that decrements the `use_count` when a tag is removed from a note.

All functions use `SECURITY DEFINER` with `SET search_path = public` for security.

## Storage

### Buckets

#### attachments
User file storage with the following configuration:
- **Access**: Private (requires authentication)
- **File Size Limit**: 50MB per file
- **Allowed MIME Types**:
  - Images: jpeg, png, gif, webp, svg+xml
  - Documents: pdf, msword, docx, excel, xlsx
  - Audio: mpeg, wav, ogg, webm
  - Video: mp4, webm, quicktime
  - Text: plain, markdown

**Storage Structure**: Files are organized by user ID: `{user_id}/{file_name}`

## Row Level Security (RLS)

All tables have RLS enabled with optimized policies using `(select auth.uid())` pattern for better performance.

### Notes Policies
- **View**: Users can view their own notes (`user_id = auth.uid()`)
- **Insert**: Users can create notes under their account
- **Update**: Users can update their own notes
- **Delete**: Users can delete their own notes

### Tags Policies
- **View**: Users can view their own tags
- **Insert**: Users can create tags under their account
- **Update**: Users can update their own tags
- **Delete**: Users can delete their own tags

### Attachments Policies
- **View**: Users can view their own attachments
- **Insert**: Users can upload attachments under their account
- **Update**: Users can update their own attachments
- **Delete**: Users can delete their own attachments

### Note Tags Policies
- **View**: Users can view tag associations for their notes
- **Insert**: Users can tag their own notes
- **Delete**: Users can remove tags from their notes

### Storage Policies
- **Upload**: Users can upload files to their own folder (`{user_id}/`)
- **View**: Users can view their own files
- **Update**: Users can update their own files
- **Delete**: Users can delete their own files

## Authentication

Supabase Auth is configured to handle user authentication. The app uses:
- Email/password authentication
- User sessions managed by Supabase client
- All database operations are automatically scoped to authenticated users via RLS

## Code Integration

### Configuration

The `SupabaseConfig` class (`lib/config/supabase_config.dart`) handles initialization:
- Loads credentials from `.env` file via `flutter_dotenv`
- Initializes Supabase client on app startup
- Configured with debug mode in development

### Initialization Flow

1. `main.dart` loads environment variables with `dotenv.load()`
2. `SupabaseConfig.initialize()` is called to set up Supabase client
3. Supabase client is available globally via `Supabase.instance.client`

### Usage Example

```dart
// Get current Supabase client
final supabase = Supabase.instance.client;

// Query notes
final notes = await supabase
    .from('notes')
    .select()
    .order('created_at', ascending: false);

// Insert a note
await supabase.from('notes').insert({
  'id': uuid.v4(),
  'user_id': supabase.auth.currentUser!.id,
  'title': 'My Note',
  'content': 'Note content...',
});

// Upload a file
await supabase.storage
    .from('attachments')
    .upload('${userId}/myfile.jpg', file);
```

## TypeScript Type Definitions

TypeScript types for the database schema have been generated and are available in the Supabase dashboard. These can be used for any TypeScript-based integrations or edge functions.

## Maintenance

### Monitoring
- Check [Supabase Dashboard](https://supabase.com/dashboard/project/thuqxygpjqmkfjxzqjbl) for:
  - Database health and performance
  - Storage usage
  - API usage metrics
  - Security advisors

### Performance
All performance advisors have been resolved:
- RLS policies optimized with `(select auth.uid())` pattern
- Functions secured with proper search paths
- Appropriate indexes created for common queries

### Security
All security advisors have been resolved:
- Functions use `SECURITY DEFINER` with explicit search paths
- RLS enabled on all tables
- Storage bucket policies properly configured

## Development Workflow

### Making Schema Changes

To modify the database schema:

1. Use Supabase MCP tools via Claude Code:
   ```
   mcp__supabase__apply_migration with SQL changes
   ```

2. Or use Supabase Dashboard SQL Editor

3. Always check advisors after changes:
   ```
   mcp__supabase__get_advisors for security and performance
   ```

### Testing Locally

1. Ensure `.env` file is configured
2. Run `flutter run` - Supabase will initialize automatically
3. Check console for "Supabase initialized successfully" message

## Troubleshooting

### Connection Issues
- Verify `.env` file exists and contains correct credentials
- Check internet connectivity
- Verify project is not paused in Supabase dashboard

### RLS Policy Issues
- Ensure user is authenticated before querying
- Check that `user_id` matches `auth.uid()`
- Review policy definitions in Supabase dashboard

### Storage Issues
- Verify file size is under 50MB limit
- Check MIME type is in allowed list
- Ensure user is authenticated
- Verify file path follows `{user_id}/` pattern

## Next Steps

1. ✅ Database schema created and optimized
2. ✅ RLS policies configured and tested
3. ✅ Storage bucket set up
4. ✅ Environment variables configured
5. 🔲 Implement sync logic in `sync_provider.dart`
6. 🔲 Add realtime subscriptions for live updates
7. 🔲 Set up Edge Functions for server-side operations (optional)
8. 🔲 Configure email templates for auth workflows

## Support

For issues or questions:
- [Supabase Documentation](https://supabase.com/docs)
- [Supabase Discord](https://discord.supabase.com)
- Project-specific issues: See development team
