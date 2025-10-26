# Supabase Deployment Guide

This guide covers deploying and managing your Supabase project for the AI Organizer app.

## Prerequisites

1. **Supabase CLI** installed:
   ```bash
   # macOS
   brew install supabase/tap/supabase

   # Other platforms
   npm install -g supabase
   ```

2. **Supabase Account**: Sign up at [supabase.com](https://supabase.com)

3. **Supabase Project**: Create a new project in the Supabase dashboard

## Initial Setup

### 1. Link Your Local Project to Supabase

```bash
# Navigate to your project directory
cd /path/to/ai_organizer

# Login to Supabase
supabase login

# Link to your remote project
supabase link --project-ref your-project-ref

# Get your project ref from: https://app.supabase.com/project/YOUR_PROJECT_REF/settings/general
```

### 2. Set Environment Variables

Edge Functions require environment variables. Set them using Supabase secrets:

```bash
# Set the Supabase URL (automatically available in most cases)
supabase secrets set SUPABASE_URL=https://your-project-ref.supabase.co

# Set the service role key (get from Project Settings > API > service_role)
supabase secrets set SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_here

# Verify secrets are set
supabase secrets list
```

### 3. Run Database Migrations

Apply the database schema to your remote Supabase project:

```bash
# Push all migrations to the remote database
supabase db push

# Or push specific migration
supabase db push --dry-run  # Preview changes first
supabase db push
```

Migrations included:
- `20251025021810_create_backlinks_table.sql` - Creates backlinks table for note references
- `20251025025112_create_email_settings_table.sql` - Creates email settings table for email-to-note feature

## Deploying Edge Functions

### Deploy Email-to-Note Function

```bash
# Deploy the email-to-note edge function
supabase functions deploy email-to-note

# Verify deployment
supabase functions list

# Check logs
supabase functions logs email-to-note --follow
```

### Function Configuration

The `email-to-note` function:
- **Path**: `/supabase/functions/email-to-note`
- **Endpoint**: `https://your-project-ref.supabase.co/functions/v1/email-to-note`
- **Method**: POST
- **Authentication**: None (handles SendGrid webhooks)
- **Required Secrets**: `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`

### Testing the Edge Function

Test the deployed function with curl:

```bash
# Replace with your actual project URL
curl -X POST https://your-project-ref.supabase.co/functions/v1/email-to-note \
  -H "Content-Type: application/json" \
  -d '{
    "to": "test@notes.aiorganizer.app",
    "from": "sender@example.com",
    "subject": "Test Email",
    "text": "This is a test email",
    "date": "2024-01-01T12:00:00Z"
  }'
```

Expected response:
```json
{
  "success": true,
  "noteId": "uuid-here"
}
```

## Local Development

### 1. Start Supabase Locally

```bash
# Start local Supabase instance (Docker required)
supabase start

# This will start:
# - PostgreSQL database (port 54322)
# - Studio UI (port 54323)
# - API Gateway (port 54321)
# - Email testing (Inbucket on port 54324)
```

### 2. Run Edge Function Locally

```bash
# Serve edge function locally
supabase functions serve email-to-note

# Or serve with environment variables
supabase functions serve email-to-note --env-file supabase/functions/.env

# Function will be available at:
# http://localhost:54321/functions/v1/email-to-note
```

### 3. Create Local .env File

```bash
# Copy example env file
cp supabase/functions/.env.example supabase/functions/.env

# Edit .env with your local values
# For local development, use the local Supabase instance URLs
```

Example `.env` for local development:
```env
SUPABASE_URL=http://localhost:54321
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 4. Test Locally

```bash
# Test the local function
curl -X POST http://localhost:54321/functions/v1/email-to-note \
  -H "Content-Type: application/json" \
  -d '{
    "to": "test@notes.aiorganizer.app",
    "from": "sender@example.com",
    "subject": "Local Test",
    "text": "Testing locally"
  }'

# View logs
supabase functions logs email-to-note
```

## Database Management

### View Database Schema

```bash
# Inspect remote database
supabase db diff --linked

# Generate a new migration from schema changes
supabase db diff --schema public -f new_migration_name
```

### Reset Local Database

```bash
# Reset local database to clean state
supabase db reset

# This will:
# 1. Drop the database
# 2. Recreate it
# 3. Apply all migrations
# 4. Seed data (if seed.sql exists)
```

### Backup Database

```bash
# Dump remote database
supabase db dump --db-url "postgresql://postgres:password@db.your-project-ref.supabase.co:5432/postgres" > backup.sql

# Or use the Supabase dashboard:
# Project Settings > Database > Backups
```

## Monitoring and Debugging

### View Logs

```bash
# Edge function logs
supabase functions logs email-to-note --follow

# Postgres logs
supabase logs postgres

# All services
supabase logs
```

### Check Function Status

```bash
# List all functions
supabase functions list

# Get function details
supabase functions describe email-to-note
```

### Debug Edge Function

Add console.log statements in your function code:

```typescript
console.log('Received email:', email)
console.error('Error creating note:', error)
```

View them in logs:
```bash
supabase functions logs email-to-note --follow
```

## Updating Deployments

### Update Edge Function

```bash
# Make changes to the function code
# Then redeploy
supabase functions deploy email-to-note

# Verify the update
supabase functions logs email-to-note --follow
```

### Update Database Schema

```bash
# Create a new migration
supabase migration new add_new_column

# Edit the migration file in supabase/migrations/
# Then push to remote
supabase db push
```

### Update Environment Variables

```bash
# Update a secret
supabase secrets set VARIABLE_NAME=new_value

# Remove a secret
supabase secrets unset VARIABLE_NAME

# List all secrets (values are hidden)
supabase secrets list
```

## Production Checklist

Before going to production, ensure:

- [ ] All migrations are pushed to remote database
- [ ] Edge functions are deployed and tested
- [ ] Environment variables/secrets are set correctly
- [ ] Row Level Security (RLS) policies are enabled and tested
- [ ] Storage buckets are created with correct policies
- [ ] Email service (SendGrid) is configured and tested
- [ ] DNS records are configured (for email-to-note)
- [ ] Backup strategy is in place
- [ ] Monitoring/alerting is set up

## SendGrid Configuration (Email-to-Note)

### 1. Set Up SendGrid Inbound Parse

See detailed instructions in `/supabase/functions/email-to-note/README.md`

Quick steps:
1. Sign up for SendGrid
2. Configure Inbound Parse webhook URL: `https://your-project-ref.supabase.co/functions/v1/email-to-note`
3. Add MX records to your domain DNS
4. Test by sending an email

### 2. Verify Configuration

```bash
# Check DNS MX records
dig MX notes.aiorganizer.app

# Should show: mx.sendgrid.net

# Test the webhook
curl -X POST https://your-project-ref.supabase.co/functions/v1/email-to-note \
  -H "Content-Type: application/json" \
  -d @test-email.json
```

## Troubleshooting

### Function Not Deploying

```bash
# Check for syntax errors
deno check supabase/functions/email-to-note/index.ts

# Verify you're logged in
supabase login

# Verify project is linked
supabase projects list
```

### Function Failing in Production

```bash
# Check logs
supabase functions logs email-to-note --follow

# Common issues:
# 1. Missing environment variables
supabase secrets list

# 2. Database connection issues
# Check if SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are set

# 3. RLS policies blocking access
# Verify service role key is being used (bypasses RLS)
```

### Database Migration Fails

```bash
# Check current migration status
supabase migration list

# Try dry run first
supabase db push --dry-run

# If stuck, you may need to manually fix the database
# Then mark migration as applied
```

## Useful Commands Reference

```bash
# Project Management
supabase login
supabase projects list
supabase link --project-ref your-ref
supabase status

# Local Development
supabase start
supabase stop
supabase db reset

# Database
supabase db push
supabase db diff
supabase migration new name
supabase db dump

# Edge Functions
supabase functions deploy function-name
supabase functions serve function-name
supabase functions list
supabase functions logs function-name

# Secrets
supabase secrets set KEY=value
supabase secrets list
supabase secrets unset KEY

# Storage
supabase storage ls
supabase storage cp local-file bucket-name/path

# Logs
supabase logs postgres
supabase logs functions
```

## Additional Resources

- [Supabase CLI Reference](https://supabase.com/docs/reference/cli)
- [Edge Functions Docs](https://supabase.com/docs/guides/functions)
- [Database Migrations](https://supabase.com/docs/guides/cli/local-development#database-migrations)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)

## Support

If you encounter issues:
1. Check the [Supabase Discord](https://discord.supabase.com)
2. Search [Supabase GitHub Issues](https://github.com/supabase/supabase/issues)
3. Review function logs for error details
4. Verify all environment variables are set correctly
