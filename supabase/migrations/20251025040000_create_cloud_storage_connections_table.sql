-- Create cloud_storage_connections table for managing OAuth connections to cloud storage providers
CREATE TABLE IF NOT EXISTS cloud_storage_connections (
  id TEXT PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  provider TEXT NOT NULL CHECK (provider IN ('dropbox', 'google_drive')),
  access_token TEXT NOT NULL,
  refresh_token TEXT,
  token_expiry TIMESTAMP WITH TIME ZONE,
  user_email TEXT,
  user_name TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  UNIQUE(user_id, provider) -- Only one connection per user per provider
);

-- Create index on user_id for faster lookups
CREATE INDEX idx_cloud_storage_connections_user_id ON cloud_storage_connections(user_id);

-- Create index on provider for filtering by storage provider
CREATE INDEX idx_cloud_storage_connections_provider ON cloud_storage_connections(provider);

-- Create composite index for user_id + provider (common query pattern)
CREATE INDEX idx_cloud_storage_connections_user_provider ON cloud_storage_connections(user_id, provider);

-- Enable Row Level Security
ALTER TABLE cloud_storage_connections ENABLE ROW LEVEL SECURITY;

-- Create policy: Users can view their own cloud storage connections
CREATE POLICY "Users can view their own cloud storage connections"
  ON cloud_storage_connections
  FOR SELECT
  USING (auth.uid() = user_id);

-- Create policy: Users can insert their own cloud storage connections
CREATE POLICY "Users can insert their own cloud storage connections"
  ON cloud_storage_connections
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Create policy: Users can update their own cloud storage connections
CREATE POLICY "Users can update their own cloud storage connections"
  ON cloud_storage_connections
  FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Create policy: Users can delete their own cloud storage connections
CREATE POLICY "Users can delete their own cloud storage connections"
  ON cloud_storage_connections
  FOR DELETE
  USING (auth.uid() = user_id);

-- Create function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_cloud_storage_connections_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to auto-update updated_at
CREATE TRIGGER trigger_cloud_storage_connections_updated_at
  BEFORE UPDATE ON cloud_storage_connections
  FOR EACH ROW
  EXECUTE FUNCTION update_cloud_storage_connections_updated_at();

-- Add comment to table
COMMENT ON TABLE cloud_storage_connections IS 'Stores OAuth credentials and connection details for cloud storage providers (Dropbox, Google Drive)';
