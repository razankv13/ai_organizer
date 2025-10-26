// Supabase Edge Function - AI-powered Tag Generation using Google Gemini API
// TypeScript errors in IDE are expected; code works correctly when deployed
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.0'

/**
 * Supabase Edge Function: AI Tag Generation
 *
 * This function generates intelligent tags for notes using Google Gemini API.
 * Supports both single note and batch processing for efficient tag generation.
 *
 * Benefits of server-side processing:
 * - Centralized API key management (no exposure in client apps)
 * - Batch processing capability for multiple notes
 * - Consistent tagging across all platforms
 * - Easier monitoring and cost management
 * - Can automatically create and link tags to notes
 *
 * Environment variables required:
 * - GEMINI_API_KEY (Google Gemini API key)
 * - SUPABASE_URL
 * - SUPABASE_SERVICE_ROLE_KEY (for database access)
 */

interface TagRequest {
  // Single note tagging
  noteId?: string
  title?: string
  content?: string

  // Batch processing
  notes?: Array<{
    noteId: string
    title: string
    content?: string
  }>

  // Options
  maxTags?: number // Maximum number of tags per note (default: 5)
  autoLink?: boolean // Automatically create and link tags to notes (default: false)
  userId?: string // User ID for RLS (required if autoLink is true)
}

interface TagResult {
  noteId?: string
  tags: string[]
  error?: string
}

interface TagResponse {
  success: boolean
  results: TagResult[]
  error?: string
}

/**
 * Get required environment variable or throw error
 */
function getRequiredEnv(key: string): string {
  const value = Deno.env.get(key)
  if (!value) {
    throw new Error(`Missing required environment variable: ${key}`)
  }
  return value
}

const geminiApiKey = getRequiredEnv('GEMINI_API_KEY')
const supabaseUrl = getRequiredEnv('SUPABASE_URL')
const supabaseServiceKey = getRequiredEnv('SUPABASE_SERVICE_ROLE_KEY')

const supabase = createClient(supabaseUrl, supabaseServiceKey)

/**
 * Generate tags for a single note using Gemini API
 */
async function generateTagsWithGemini(
  title: string,
  content: string,
  maxTags: number = 5
): Promise<string[]> {
  try {
    // Truncate content if too long (to avoid token limits)
    const maxContentLength = 3000
    const truncatedContent = content.length > maxContentLength
      ? content.substring(0, maxContentLength) + '...'
      : content

    const prompt = `Analyze this note and suggest ${maxTags} relevant tags for categorization and search.

Title: "${title}"
Content: "${truncatedContent}"

Requirements:
- Generate ${maxTags} specific, relevant tags
- Tags should be concise (1-2 words each)
- Tags should help with categorization and findability
- Consider the content's topic, type, and purpose
- Use lowercase for consistency
- Avoid generic tags like "note" or "text"

Return ONLY a JSON array of tag strings, for example: ["meeting", "project-x", "urgent", "todo", "client-work"]`

    const requestBody = {
      contents: [
        {
          parts: [
            { text: prompt },
          ],
        },
      ],
      generationConfig: {
        temperature: 0.7,
        maxOutputTokens: 256,
      },
    }

    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${geminiApiKey}`,
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(requestBody),
      }
    )

    if (!response.ok) {
      const errorText = await response.text()
      console.error('Gemini API error:', response.status, errorText)
      throw new Error(`Gemini API error: ${response.status}`)
    }

    const result = await response.json()

    // Extract text from Gemini response
    const responseText = result.candidates?.[0]?.content?.parts?.[0]?.text || ''

    if (!responseText) {
      console.error('No response text from Gemini')
      return []
    }

    // Parse JSON response
    try {
      // Extract JSON from markdown code blocks if present
      let jsonText = responseText
      const jsonMatch = responseText.match(/```(?:json)?\s*([\s\S]*?)\s*```/)
      if (jsonMatch) {
        jsonText = jsonMatch[1]
      } else {
        // Try to find JSON array in the response
        const arrayMatch = responseText.match(/\[[\s\S]*?\]/)
        if (arrayMatch) {
          jsonText = arrayMatch[0]
        }
      }

      const tags = JSON.parse(jsonText)

      if (Array.isArray(tags)) {
        return tags.slice(0, maxTags).map(tag => String(tag).toLowerCase().trim())
      }

      return []
    } catch (parseError) {
      console.error('Error parsing Gemini response:', parseError)
      console.error('Response text:', responseText)
      return []
    }
  } catch (error) {
    console.error('Error in generateTagsWithGemini:', error)
    return []
  }
}

/**
 * Create or get existing tag and link it to a note
 */
async function linkTagToNote(
  noteId: string,
  tagName: string,
  userId: string
): Promise<boolean> {
  try {
    const now = new Date().toISOString()

    // Check if tag exists
    const { data: existingTag } = await supabase
      .from('tags')
      .select('id, use_count')
      .eq('name', tagName)
      .maybeSingle()

    let tagId: string

    if (existingTag) {
      tagId = existingTag.id
      // Increment use count
      await supabase
        .from('tags')
        .update({ use_count: (existingTag.use_count || 0) + 1 })
        .eq('id', tagId)
    } else {
      // Create new tag
      tagId = crypto.randomUUID()
      const { error: tagError } = await supabase
        .from('tags')
        .insert({
          id: tagId,
          name: tagName,
          created_at: now,
          color: null,
          use_count: 1,
          description: null,
        })

      if (tagError) {
        console.error('Error creating tag:', tagError)
        return false
      }
    }

    // Check if note-tag relationship already exists
    const { data: existingLink } = await supabase
      .from('note_tags')
      .select('note_id')
      .eq('note_id', noteId)
      .eq('tag_id', tagId)
      .maybeSingle()

    if (!existingLink) {
      // Create note-tag link
      const { error: linkError } = await supabase
        .from('note_tags')
        .insert({
          note_id: noteId,
          tag_id: tagId,
          created_at: now,
        })

      if (linkError) {
        console.error('Error linking tag to note:', linkError)
        return false
      }
    }

    return true
  } catch (error) {
    console.error('Error in linkTagToNote:', error)
    return false
  }
}

/**
 * Process single or batch tag generation
 */
async function processTagGeneration(
  request: TagRequest
): Promise<TagResponse> {
  const results: TagResult[] = []
  const maxTags = request.maxTags || 5

  try {
    // Single note processing
    if (request.noteId && request.title !== undefined) {
      const tags = await generateTagsWithGemini(
        request.title,
        request.content || '',
        maxTags
      )

      // Auto-link tags if requested
      if (request.autoLink && request.userId && tags.length > 0) {
        for (const tag of tags) {
          await linkTagToNote(request.noteId, tag, request.userId)
        }
      }

      results.push({
        noteId: request.noteId,
        tags,
      })
    }
    // Batch processing
    else if (request.notes && request.notes.length > 0) {
      // Process notes in batches of 5 to avoid rate limits
      const batchSize = 5
      for (let i = 0; i < request.notes.length; i += batchSize) {
        const batch = request.notes.slice(i, i + batchSize)

        // Process batch in parallel
        const batchPromises = batch.map(async (note) => {
          const tags = await generateTagsWithGemini(
            note.title,
            note.content || '',
            maxTags
          )

          // Auto-link tags if requested
          if (request.autoLink && request.userId && tags.length > 0) {
            for (const tag of tags) {
              await linkTagToNote(note.noteId, tag, request.userId)
            }
          }

          return {
            noteId: note.noteId,
            tags,
          }
        })

        const batchResults = await Promise.all(batchPromises)
        results.push(...batchResults)

        // Add a small delay between batches to respect rate limits
        if (i + batchSize < request.notes.length) {
          await new Promise(resolve => setTimeout(resolve, 1000))
        }
      }
    } else {
      return {
        success: false,
        results: [],
        error: 'Either noteId+title or notes array must be provided',
      }
    }

    return {
      success: true,
      results,
    }
  } catch (error) {
    console.error('Error in processTagGeneration:', error)
    return {
      success: false,
      results,
      error: String(error),
    }
  }
}

// CORS headers
const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
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
    const request: TagRequest = await req.json()

    // Validate request
    if (!request.noteId && !request.notes) {
      return new Response(
        JSON.stringify({
          success: false,
          results: [],
          error: 'Either noteId or notes array must be provided',
        }),
        {
          status: 400,
          headers: {
            'Content-Type': 'application/json',
            ...corsHeaders,
          },
        }
      )
    }

    if (request.autoLink && !request.userId) {
      return new Response(
        JSON.stringify({
          success: false,
          results: [],
          error: 'userId is required when autoLink is true',
        }),
        {
          status: 400,
          headers: {
            'Content-Type': 'application/json',
            ...corsHeaders,
          },
        }
      )
    }

    // Process tag generation
    const response = await processTagGeneration(request)

    return new Response(JSON.stringify(response), {
      status: 200,
      headers: {
        'Content-Type': 'application/json',
        ...corsHeaders,
      },
    })
  } catch (error) {
    console.error('Error processing tag request:', error)
    return new Response(
      JSON.stringify({
        success: false,
        results: [],
        error: String(error),
      }),
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
