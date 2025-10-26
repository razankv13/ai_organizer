# Email-to-Note Edge Function

This Supabase Edge Function receives incoming emails from SendGrid and automatically creates notes in user accounts.

## How It Works

1. User gets a unique email address (e.g., `abc123def456@notes.aiorganizer.app`)
2. When someone sends an email to that address, SendGrid receives it
3. SendGrid forwards the email to this edge function via webhook
4. The function:
   - Validates required fields (to, from)
   - Looks up the user from the unique email address
   - Verifies email-to-note is enabled for that user
   - Creates a note with the email subject as title and body as content
   - Uploads any attachments to Supabase Storage
   - Tags the note with "email" tag (creates tag if doesn't exist, increments use_count)
   - Returns success response with note ID

## Setup Instructions

### 1. Deploy the Edge Function

```bash
# Deploy to Supabase
supabase functions deploy email-to-note

# Set required environment variables (if not already set)
supabase secrets set SUPABASE_URL=your_supabase_url
supabase secrets set SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
```

### 2. Configure SendGrid

1. Sign up for a [SendGrid account](https://sendgrid.com) (Free tier: 100 emails/day)

2. Go to **Settings > Inbound Parse** in SendGrid dashboard

3. Click **Add Host & URL**

4. Configure:
   - **Hostname**: `notes.aiorganizer.app` (or your custom domain)
   - **URL**: `https://your-project-id.supabase.co/functions/v1/email-to-note`
   - Check: **POST the raw, full MIME message**
   - Check: **Spam Check**

5. Click **Add**

### 3. Configure DNS Records

Add the following MX records to your domain's DNS settings:

```
Type: MX
Host: notes (or your subdomain)
Value: mx.sendgrid.net
Priority: 10
```

### 4. Verify DNS Configuration

After adding MX records, verify they're working:

```bash
dig MX notes.aiorganizer.app
# Should show mx.sendgrid.net
```

### 5. Test the Integration

1. Get your unique email from the app settings
2. Send a test email to that address
3. Check if a note is created in your account

## SendGrid Webhook Payload Format

SendGrid sends emails to the edge function in this format:

```json
{
  "to": "abc123def456@notes.aiorganizer.app",
  "from": "sender@example.com",
  "subject": "Test Email",
  "text": "Plain text body",
  "html": "<p>HTML body</p>",
  "date": "2024-01-01T12:00:00Z",
  "attachments": [
    {
      "filename": "document.pdf",
      "type": "application/pdf",
      "content": "base64_encoded_content",
      "size": 12345
    }
  ]
}
```

## Alternative Email Services

If you prefer a different email service:

### Mailgun

- Free tier: 5,000 emails/month
- Configuration: Similar to SendGrid, configure inbound routes
- Webhook URL: Same edge function URL

### Postmark

- Free tier: 100 emails/month
- Configuration: Set up inbound webhook
- Best for transactional emails

## Troubleshooting

### Emails not creating notes

1. Check edge function logs:
   ```bash
   supabase functions logs email-to-note
   ```

2. Verify MX records are correctly configured:
   ```bash
   nslookup -type=MX notes.aiorganizer.app
   ```

3. Check SendGrid activity logs for webhook delivery status

### Attachments not uploading

1. Ensure Supabase Storage bucket "attachments" exists
2. Check bucket policies allow uploads
3. Verify service role key has storage permissions

## Security Considerations

- Edge function uses service role key to bypass RLS (required for creating notes)
- Only emails sent to valid unique addresses create notes
- Users can disable email-to-note in settings (`is_enabled` flag)
- Consider rate limiting to prevent abuse
- Validate email sender if needed (whitelist/blacklist)

## Cost Estimates

### SendGrid Free Tier
- 100 emails/day
- Sufficient for most personal use

### Supabase Edge Functions
- Free tier: 500K requests/month
- Sufficient for 100s of emails daily

### Supabase Storage
- Free tier: 1GB storage
- Email attachments count toward this limit

## Future Enhancements

- [ ] Email threading (group emails by subject/thread)
- [ ] Sender whitelist/blacklist
- [ ] Auto-tagging based on sender or subject
- [ ] Auto-folder assignment based on rules
- [ ] Email signature removal
- [ ] Smart reply suggestions
