// Supabase Edge Function - runs on Deno runtime
// TypeScript errors in IDE are expected; code works correctly when deployed
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.0'

/**
 * Supabase Edge Function: Email-to-Note
 *
 * This function receives webhook notifications from SendGrid (or other email service)
 * when an email is sent to a user's unique address. It parses the email and creates
 * a note in the user's account.
 *
 * Setup Instructions:
 * 1. Configure SendGrid Inbound Parse webhook to point to this edge function
 * 2. Set up DNS MX records for your domain to point to SendGrid
 * 3. Deploy this function: supabase functions deploy email-to-note
 *
 * Environment variables required:
 * - SUPABASE_URL
 * - SUPABASE_SERVICE_ROLE_KEY (for bypassing RLS)
 */

interface EmailAttachment {
  filename: string
  type: string
  content: string // base64 encoded
  size: number
}

interface ParsedEmail {
  to: string
  from: string
  subject: string
  text?: string
  html?: string
  attachments?: EmailAttachment[]
  date: string
}

/**
 * Get required environment variable or throw error
 */
function getRequiredEnv(key: string): string {
  const value = Deno.env.get(key)
  if (!value) {
    throw new Error(`Missing required environment variable: ${key}. Please check your Supabase project secrets.`)
  }
  return value
}

// Create Supabase client with service role key to bypass RLS
const supabaseUrl = getRequiredEnv('SUPABASE_URL')
const supabaseServiceKey = getRequiredEnv('SUPABASE_SERVICE_ROLE_KEY')

const supabase = createClient(supabaseUrl, supabaseServiceKey)

/**
 * Extract the unique email address from the "to" field
 * Format: {unique_id}@notes.aiorganizer.app
 */
function extractUniqueEmail(toAddress: string): string {
  // Handle email in format "Name <email@domain.com>" or just "email@domain.com"
  const emailMatch = toAddress.match(/<(.+?)>/) || [null, toAddress]
  return emailMatch[1]?.toLowerCase().trim() || toAddress.toLowerCase().trim()
}

/**
 * Lookup user ID from unique email address
 */
async function getUserIdFromEmail(uniqueEmail: string): Promise<string | null> {
  const { data, error } = await supabase
    .from('email_settings')
    .select('user_id')
    .eq('unique_email', uniqueEmail)
    .eq('is_enabled', true)
    .maybeSingle()

  if (error || !data) {
    console.error('Error looking up user:', error)
    return null
  }

  return data.user_id
}

/**
 * Upload attachment to Supabase Storage
 */
async function uploadAttachment(
  userId: string,
  filename: string,
  content: string,
  mimeType: string
): Promise<string | null> {
  try {
    // Decode base64 content
    const binaryString = atob(content)
    const bytes = new Uint8Array(binaryString.length)
    for (let i = 0; i < binaryString.length; i++) {
      bytes[i] = binaryString.charCodeAt(i)
    }

    // Generate unique filename
    const timestamp = new Date().getTime()
    const sanitizedFilename = filename.replace(/[^a-zA-Z0-9.-]/g, '_')
    const storagePath = `${userId}/email-attachments/${timestamp}_${sanitizedFilename}`

    // Upload to Supabase Storage
    const { error } = await supabase.storage
      .from('attachments')
      .upload(storagePath, bytes, {
        contentType: mimeType,
        upsert: false,
      })

    if (error) {
      console.error('Error uploading attachment:', error)
      return null
    }

    // Get public URL
    const { data: urlData } = supabase.storage
      .from('attachments')
      .getPublicUrl(storagePath)

    return urlData.publicUrl
  } catch (error) {
    console.error('Error processing attachment:', error)
    return null
  }
}

/**
 * Create a note from the email
 */
async function createNoteFromEmail(
  userId: string,
  email: ParsedEmail
): Promise<{ success: boolean; noteId?: string; error?: string }> {
  try {
    const noteId = crypto.randomUUID()
    const now = new Date().toISOString()

    // Prepare note content
    const content = email.text || email.html || '(No content)'
    const title = email.subject || 'Email from ' + email.from

    // Create the note
    const { error: noteError } = await supabase
      .from('notes')
      .insert({
        id: noteId,
        title: title,
        content: content,
        created_at: email.date || now,
        updated_at: now,
        is_pinned: false,
        is_archived: false,
        is_favorite: false,
        folder_id: null,
        color: null,
      })

    if (noteError) {
      console.error('Error creating note:', noteError)
      return { success: false, error: noteError.message }
    }

    // Add a tag to indicate this came from email
    // First, try to get existing "email" tag
    let emailTagId: string | null = null
    const { data: existingTag } = await supabase
      .from('tags')
      .select('id, use_count')
      .eq('name', 'email')
      .maybeSingle()

    if (existingTag) {
      emailTagId = existingTag.id
      // Increment use count
      await supabase
        .from('tags')
        .update({ use_count: (existingTag.use_count || 0) + 1 })
        .eq('id', emailTagId)
    } else {
      // Create new "email" tag
      emailTagId = crypto.randomUUID()
      const { data: newTag, error: tagError } = await supabase
        .from('tags')
        .insert({
          id: emailTagId,
          name: 'email',
          created_at: now,
          color: '#4A90E2',
          use_count: 1,
          description: 'Notes created from emails',
        })
        .select('id')
        .single()

      if (tagError) {
        console.error('Error creating email tag:', tagError)
        // Continue without tag rather than failing the whole operation
      } else if (newTag) {
        emailTagId = newTag.id
      }
    }

    // Link tag to note if we have a tag ID
    if (emailTagId) {
      const { error: linkError } = await supabase.from('note_tags').insert({
        note_id: noteId,
        tag_id: emailTagId,
        created_at: now,
      })

      if (linkError) {
        console.error('Error linking tag to note:', linkError)
        // Continue without tag link rather than failing the whole operation
      }
    }

    // Handle attachments if present
    if (email.attachments && email.attachments.length > 0) {
      for (const attachment of email.attachments) {
        try {
          const publicUrl = await uploadAttachment(
            userId,
            attachment.filename,
            attachment.content,
            attachment.type
          )

          if (publicUrl) {
            const attachmentId = crypto.randomUUID()
            const { error: attachmentError } = await supabase.from('attachments').insert({
              id: attachmentId,
              note_id: noteId,
              file_name: attachment.filename,
              file_path: publicUrl,
              type: getAttachmentType(attachment.type),
              file_size: attachment.size,
              created_at: now,
              mime_type: attachment.type,
              thumbnail_path: null,
              metadata: null,
            })

            if (attachmentError) {
              console.error('Error saving attachment:', attachmentError)
              // Continue with next attachment rather than failing entire operation
            }
          }
        } catch (attachmentErr) {
          console.error('Error processing attachment:', attachmentErr)
          // Continue with next attachment rather than failing entire operation
        }
      }
    }

    return { success: true, noteId }
  } catch (error) {
    console.error('Error in createNoteFromEmail:', error)
    return { success: false, error: String(error) }
  }
}

/**
 * Determine attachment type from MIME type
 */
function getAttachmentType(mimeType: string): string {
  if (mimeType.startsWith('image/')) return 'image'
  if (mimeType.startsWith('video/')) return 'video'
  if (mimeType.startsWith('audio/')) return 'audio'
  if (mimeType.includes('pdf') || mimeType.includes('document')) return 'document'
  return 'other'
}

// CORS headers
const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

/**
 * Main handler function
 */
serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', {
      headers: {
        ...corsHeaders,
        'Access-Control-Allow-Methods': 'POST, OPTIONS',
      },
    })
  }

  if (req.method !== 'POST') {
    return new Response(JSON.stringify({ error: 'Method not allowed' }), {
      status: 405,
      headers: {
        'Content-Type': 'application/json',
        ...corsHeaders,
      },
    })
  }

  try {
    // Parse incoming email data (SendGrid webhook format)
    const email: ParsedEmail = await req.json()

    console.log('Received email to:', email.to)

    // Validate required fields
    if (!email.to || !email.from) {
      return new Response(
        JSON.stringify({ error: 'Missing required fields: to and from are required' }),
        {
          status: 400,
          headers: {
            'Content-Type': 'application/json',
            ...corsHeaders,
          },
        }
      )
    }

    // Extract unique email address
    const uniqueEmail = extractUniqueEmail(email.to)

    // Look up user
    const userId = await getUserIdFromEmail(uniqueEmail)

    if (!userId) {
      console.error('No user found for email:', uniqueEmail)
      return new Response(
        JSON.stringify({ error: 'User not found or email-to-note disabled' }),
        {
          status: 404,
          headers: {
            'Content-Type': 'application/json',
            ...corsHeaders,
          },
        }
      )
    }

    // Create note from email
    const result = await createNoteFromEmail(userId, email)

    if (!result.success) {
      return new Response(
        JSON.stringify({ error: result.error }),
        {
          status: 500,
          headers: {
            'Content-Type': 'application/json',
            ...corsHeaders,
          },
        }
      )
    }

    console.log('Successfully created note:', result.noteId)

    return new Response(
      JSON.stringify({ success: true, noteId: result.noteId }),
      {
        status: 200,
        headers: {
          'Content-Type': 'application/json',
          ...corsHeaders,
        },
      }
    )
  } catch (error) {
    console.error('Error processing email:', error)
    return new Response(
      JSON.stringify({ error: String(error) }),
      {
        status: 500,
        headers: {
          'Content-Type': 'application/json',
          ...corsHeaders,
        },
      }
    )
  }
})
