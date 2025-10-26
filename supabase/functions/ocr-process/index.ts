// Supabase Edge Function - OCR Processing using Google Gemini API
// TypeScript errors in IDE are expected; code works correctly when deployed
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.0'

/**
 * Supabase Edge Function: OCR Process
 *
 * This function performs server-side image text extraction using Google Gemini API.
 * It accepts an image (as base64 or storage path) and returns extracted text, summary,
 * tags, and category information.
 *
 * Benefits of server-side processing:
 * - Centralized API key management (no exposure in client apps)
 * - Batch processing capability for multiple images
 * - Consistent processing across all platforms
 * - Easier monitoring and cost management
 *
 * Environment variables required:
 * - GEMINI_API_KEY (Google Gemini API key)
 * - SUPABASE_URL
 * - SUPABASE_SERVICE_ROLE_KEY (for storage access)
 */

interface OCRRequest {
  // Either provide image as base64 string
  imageBase64?: string
  mimeType?: string
  // Or provide storage path (relative to attachments bucket)
  storagePath?: string
  // Optional: Attachment ID to update metadata after processing
  attachmentId?: string
  // Optional: User ID for RLS
  userId?: string
}

interface OCRResponse {
  success: boolean
  text: string
  summary: string
  tags: string[]
  category: string
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
 * Fetch image from Supabase Storage
 */
async function fetchImageFromStorage(storagePath: string): Promise<{
  data: Uint8Array
  mimeType: string
} | null> {
  try {
    const { data, error } = await supabase.storage
      .from('attachments')
      .download(storagePath)

    if (error || !data) {
      console.error('Error fetching image from storage:', error)
      return null
    }

    // Convert Blob to Uint8Array
    const arrayBuffer = await data.arrayBuffer()
    const uint8Array = new Uint8Array(arrayBuffer)

    // Determine MIME type from file extension
    const extension = storagePath.split('.').pop()?.toLowerCase()
    let mimeType = 'image/jpeg'

    if (extension === 'png') mimeType = 'image/png'
    else if (extension === 'webp') mimeType = 'image/webp'
    else if (extension === 'gif') mimeType = 'image/gif'

    return { data: uint8Array, mimeType }
  } catch (error) {
    console.error('Error in fetchImageFromStorage:', error)
    return null
  }
}

/**
 * Process image with Gemini API for OCR and analysis
 */
async function processImageWithGemini(
  imageData: string,
  mimeType: string
): Promise<OCRResponse> {
  try {
    const prompt = `Analyze this image and extract ALL visible text with high accuracy. Then provide:
1. Full text extraction (verbatim, maintain formatting where possible)
2. A brief 2-3 sentence summary of the image content
3. 3-5 relevant tags for categorization
4. A single primary category

Format your response as JSON with these exact keys: text, summary, tags (array of strings), category (string).
For OCR, prioritize accuracy and completeness. Extract ALL text visible in the image.`

    const requestBody = {
      contents: [
        {
          parts: [
            { text: prompt },
            {
              inline_data: {
                mime_type: mimeType,
                data: imageData,
              },
            },
          ],
        },
      ],
      generationConfig: {
        temperature: 0.2, // Lower temperature for more consistent OCR
        maxOutputTokens: 2048,
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
    const responseText =
      result.candidates?.[0]?.content?.parts?.[0]?.text || ''

    if (!responseText) {
      return {
        success: false,
        text: '',
        summary: '',
        tags: [],
        category: 'unknown',
        error: 'No response from Gemini API',
      }
    }

    // Parse JSON response
    try {
      // Extract JSON from markdown code blocks if present
      let jsonText = responseText
      const jsonMatch = responseText.match(/```json\s*([\s\S]*?)\s*```/)
      if (jsonMatch) {
        jsonText = jsonMatch[1]
      } else {
        // Try to find JSON object in the response
        const objectMatch = responseText.match(/\{[\s\S]*\}/)
        if (objectMatch) {
          jsonText = objectMatch[0]
        }
      }

      const parsed = JSON.parse(jsonText)

      return {
        success: true,
        text: parsed.text || '',
        summary: parsed.summary || 'No summary available',
        tags: Array.isArray(parsed.tags) ? parsed.tags : [],
        category: parsed.category || 'uncategorized',
      }
    } catch (parseError) {
      console.error('Error parsing Gemini response:', parseError)
      // Return raw text as fallback
      return {
        success: true,
        text: responseText,
        summary: 'Text extraction completed',
        tags: [],
        category: 'document',
      }
    }
  } catch (error) {
    console.error('Error in processImageWithGemini:', error)
    return {
      success: false,
      text: '',
      summary: '',
      tags: [],
      category: 'error',
      error: String(error),
    }
  }
}

/**
 * Update attachment metadata with OCR results
 */
async function updateAttachmentMetadata(
  attachmentId: string,
  ocrResult: OCRResponse
): Promise<boolean> {
  try {
    const metadata = {
      extractedText: ocrResult.text,
      summary: ocrResult.summary,
      tags: ocrResult.tags,
      category: ocrResult.category,
      processedAt: new Date().toISOString(),
    }

    const { error } = await supabase
      .from('attachments')
      .update({ metadata })
      .eq('id', attachmentId)

    if (error) {
      console.error('Error updating attachment metadata:', error)
      return false
    }

    return true
  } catch (error) {
    console.error('Error in updateAttachmentMetadata:', error)
    return false
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
    const request: OCRRequest = await req.json()

    let imageBase64: string
    let mimeType: string

    // Get image data either from base64 or storage
    if (request.imageBase64 && request.mimeType) {
      imageBase64 = request.imageBase64
      mimeType = request.mimeType
    } else if (request.storagePath) {
      const imageData = await fetchImageFromStorage(request.storagePath)
      if (!imageData) {
        return new Response(
          JSON.stringify({
            success: false,
            error: 'Failed to fetch image from storage',
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

      // Convert Uint8Array to base64
      const base64String = btoa(
        String.fromCharCode.apply(null, Array.from(imageData.data))
      )
      imageBase64 = base64String
      mimeType = imageData.mimeType
    } else {
      return new Response(
        JSON.stringify({
          success: false,
          error: 'Either imageBase64 or storagePath must be provided',
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

    // Process image with Gemini
    const ocrResult = await processImageWithGemini(imageBase64, mimeType)

    // If attachmentId provided, update metadata
    if (request.attachmentId && ocrResult.success) {
      await updateAttachmentMetadata(request.attachmentId, ocrResult)
    }

    return new Response(JSON.stringify(ocrResult), {
      status: 200,
      headers: {
        'Content-Type': 'application/json',
        ...corsHeaders,
      },
    })
  } catch (error) {
    console.error('Error processing OCR request:', error)
    return new Response(
      JSON.stringify({
        success: false,
        error: String(error),
        text: '',
        summary: '',
        tags: [],
        category: 'error',
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
