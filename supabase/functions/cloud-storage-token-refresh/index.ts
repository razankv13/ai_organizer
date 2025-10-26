// Supabase Edge Function - runs on Deno runtime
// TypeScript errors in IDE are expected; code works correctly when deployed
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.0'

/**
 * Supabase Edge Function: Cloud Storage Token Refresh
 *
 * This function handles OAuth token refresh for cloud storage providers
 * (Dropbox, Google Drive). It receives requests to refresh expired tokens
 * and returns new access tokens.
 *
 * Setup Instructions:
 * 1. Deploy this function: supabase functions deploy cloud-storage-token-refresh
 * 2. Set environment variables in Supabase dashboard:
 *    - SUPABASE_URL
 *    - SUPABASE_SERVICE_ROLE_KEY
 *    - GOOGLE_DRIVE_CLIENT_ID
 *    - GOOGLE_DRIVE_CLIENT_SECRET
 *    - DROPBOX_APP_KEY
 *    - DROPBOX_APP_SECRET
 */

interface TokenRefreshRequest {
  provider: 'dropbox' | 'google_drive'
  refreshToken: string
  connectionId: string
}

interface TokenRefreshResponse {
  accessToken: string
  refreshToken?: string
  expiresIn?: number
  expiresAt?: string
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

/**
 * Refresh Google Drive access token
 */
async function refreshGoogleDriveToken(refreshToken: string): Promise<TokenRefreshResponse> {
  const clientId = getRequiredEnv('GOOGLE_DRIVE_CLIENT_ID')
  const clientSecret = getRequiredEnv('GOOGLE_DRIVE_CLIENT_SECRET')

  const response = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: new URLSearchParams({
      client_id: clientId,
      client_secret: clientSecret,
      refresh_token: refreshToken,
      grant_type: 'refresh_token',
    }).toString(),
  })

  if (!response.ok) {
    const error = await response.text()
    throw new Error(`Google Drive token refresh failed: ${error}`)
  }

  const data = await response.json()

  const expiresAt = new Date()
  expiresAt.setSeconds(expiresAt.getSeconds() + data.expires_in)

  return {
    accessToken: data.access_token,
    refreshToken: data.refresh_token, // Google may return a new refresh token
    expiresIn: data.expires_in,
    expiresAt: expiresAt.toISOString(),
  }
}

/**
 * Refresh Dropbox access token
 */
async function refreshDropboxToken(refreshToken: string): Promise<TokenRefreshResponse> {
  const appKey = getRequiredEnv('DROPBOX_APP_KEY')
  const appSecret = getRequiredEnv('DROPBOX_APP_SECRET')

  // Dropbox requires Basic Auth with app_key:app_secret
  const basicAuth = btoa(`${appKey}:${appSecret}`)

  const response = await fetch('https://api.dropboxapi.com/oauth2/token', {
    method: 'POST',
    headers: {
      'Authorization': `Basic ${basicAuth}`,
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: new URLSearchParams({
      grant_type: 'refresh_token',
      refresh_token: refreshToken,
    }).toString(),
  })

  if (!response.ok) {
    const error = await response.text()
    throw new Error(`Dropbox token refresh failed: ${error}`)
  }

  const data = await response.json()

  const expiresAt = new Date()
  expiresAt.setSeconds(expiresAt.getSeconds() + data.expires_in)

  return {
    accessToken: data.access_token,
    expiresIn: data.expires_in,
    expiresAt: expiresAt.toISOString(),
  }
}

/**
 * Update connection in database with new tokens
 */
async function updateConnection(
  supabase: any,
  connectionId: string,
  tokens: TokenRefreshResponse
): Promise<void> {
  const updates: any = {
    access_token: tokens.accessToken,
    token_expiry: tokens.expiresAt,
    updated_at: new Date().toISOString(),
  }

  // Update refresh token if provider returned a new one (Google Drive)
  if (tokens.refreshToken) {
    updates.refresh_token = tokens.refreshToken
  }

  const { error } = await supabase
    .from('cloud_storage_connections')
    .update(updates)
    .eq('id', connectionId)

  if (error) {
    throw new Error(`Failed to update connection: ${error.message}`)
  }
}

serve(async (req) => {
  // CORS headers
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  }

  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Parse request body
    const { provider, refreshToken, connectionId }: TokenRefreshRequest = await req.json()

    if (!provider || !refreshToken || !connectionId) {
      return new Response(
        JSON.stringify({ error: 'Missing required fields: provider, refreshToken, connectionId' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Validate provider
    if (provider !== 'dropbox' && provider !== 'google_drive') {
      return new Response(
        JSON.stringify({ error: 'Invalid provider. Must be dropbox or google_drive' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Refresh token based on provider
    let tokens: TokenRefreshResponse
    if (provider === 'google_drive') {
      tokens = await refreshGoogleDriveToken(refreshToken)
    } else {
      tokens = await refreshDropboxToken(refreshToken)
    }

    // Initialize Supabase client with service role key
    const supabaseUrl = getRequiredEnv('SUPABASE_URL')
    const supabaseServiceKey = getRequiredEnv('SUPABASE_SERVICE_ROLE_KEY')
    const supabase = createClient(supabaseUrl, supabaseServiceKey)

    // Update connection in database
    await updateConnection(supabase, connectionId, tokens)

    // Return new tokens
    return new Response(
      JSON.stringify({
        success: true,
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
        expiresAt: tokens.expiresAt,
      }),
      {
        status: 200,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      }
    )
  } catch (error) {
    console.error('Token refresh error:', error)
    return new Response(
      JSON.stringify({
        error: error.message || 'Internal server error',
      }),
      {
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      }
    )
  }
})
