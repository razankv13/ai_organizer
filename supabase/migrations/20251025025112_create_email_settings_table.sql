-- Create email_settings table for managing user email integration preferences
CREATE TABLE IF NOT EXISTS email_settings (
  id TEXT PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  unique_email TEXT NOT NULL UNIQUE,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  is_enabled BOOLEAN NOT NULL DEFAULT true,
  gmail_connected BOOLEAN NOT NULL DEFAULT false,
  gmail_email TEXT,
  gmail_refresh_token TEXT,
  last_gmail_sync TIMESTAMP WITH TIME ZONE,
  preferences JSONB DEFAULT '{}'::jsonb
);

-- Create index on user_id for faster lookups
CREATE INDEX idx_email_settings_user_id ON email_settings(user_id);

-- Create index on unique_email for email-to-note lookups
CREATE INDEX idx_email_settings_unique_email ON email_settings(unique_email);

-- Enable Row Level Security
ALTER TABLE email_settings ENABLE ROW LEVEL SECURITY;

-- Create policy: Users can view their own email settings
CREATE POLICY "Users can view their own email settings"
  ON email_settings
  FOR SELECT
  USING (auth.uid() = user_id);

-- Create policy: Users can insert their own email settings
CREATE POLICY "Users can insert their own email settings"
  ON email_settings
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Create policy: Users can update their own email settings
CREATE POLICY "Users can update their own email settings"
  ON email_settings
  FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Create policy: Users can delete their own email settings
CREATE POLICY "Users can delete their own email settings"
  ON email_settings
  FOR DELETE
  USING (auth.uid() = user_id);

-- Create function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_email_settings_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to auto-update updated_at
CREATE TRIGGER trigger_email_settings_updated_at
  BEFORE UPDATE ON email_settings
  FOR EACH ROW
  EXECUTE FUNCTION update_email_settings_updated_at();

-- Add comment to table
COMMENT ON TABLE email_settings IS 'Stores user email integration settings including unique email addresses for email-to-note and Gmail OAuth tokens';
