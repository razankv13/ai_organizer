-- Migration: Create shared_notes table for note sharing and collaboration
-- Description: Implements note sharing with permissions (view/edit) and secure access control
-- Version: 6
-- Date: 2025-10-25

-- Create shared_notes table
CREATE TABLE IF NOT EXISTS shared_notes (
    id TEXT PRIMARY KEY,
    note_id TEXT NOT NULL REFERENCES notes(id) ON DELETE CASCADE,
    owner_id TEXT NOT NULL,
    shared_with_email TEXT NOT NULL,
    shared_with_user_id TEXT,
    permission TEXT NOT NULL CHECK (permission IN ('view', 'edit')),
    share_token TEXT NOT NULL UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_shared_notes_note_id ON shared_notes(note_id);
CREATE INDEX IF NOT EXISTS idx_shared_notes_owner_id ON shared_notes(owner_id);
CREATE INDEX IF NOT EXISTS idx_shared_notes_shared_with_email ON shared_notes(shared_with_email);
CREATE INDEX IF NOT EXISTS idx_shared_notes_shared_with_user_id ON shared_notes(shared_with_user_id);
CREATE INDEX IF NOT EXISTS idx_shared_notes_share_token ON shared_notes(share_token);
CREATE INDEX IF NOT EXISTS idx_shared_notes_is_active ON shared_notes(is_active) WHERE is_active = TRUE;

-- Create composite index for common query patterns
CREATE INDEX IF NOT EXISTS idx_shared_notes_note_email ON shared_notes(note_id, shared_with_email);
CREATE INDEX IF NOT EXISTS idx_shared_notes_note_user ON shared_notes(note_id, shared_with_user_id);

-- Enable Row Level Security
ALTER TABLE shared_notes ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Users can view shares they own (as note owner)
CREATE POLICY "Users can view their own shares"
    ON shared_notes
    FOR SELECT
    USING (auth.uid()::text = owner_id);

-- RLS Policy: Users can view notes shared with them (by email or user ID)
CREATE POLICY "Users can view shares for their email or user ID"
    ON shared_notes
    FOR SELECT
    USING (
        auth.uid()::text = shared_with_user_id
        OR
        auth.email() = shared_with_email
    );

-- RLS Policy: Users can create shares for notes they own
CREATE POLICY "Users can create shares for their notes"
    ON shared_notes
    FOR INSERT
    WITH CHECK (
        auth.uid()::text = owner_id
        AND
        EXISTS (
            SELECT 1 FROM notes
            WHERE notes.id = note_id
            AND notes.user_id = auth.uid()::text
        )
    );

-- RLS Policy: Users can update shares they created
CREATE POLICY "Users can update their own shares"
    ON shared_notes
    FOR UPDATE
    USING (auth.uid()::text = owner_id)
    WITH CHECK (auth.uid()::text = owner_id);

-- RLS Policy: Users can delete shares they created
CREATE POLICY "Users can delete their own shares"
    ON shared_notes
    FOR DELETE
    USING (auth.uid()::text = owner_id);

-- Create trigger to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_shared_notes_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_shared_notes_updated_at
    BEFORE UPDATE ON shared_notes
    FOR EACH ROW
    EXECUTE FUNCTION update_shared_notes_updated_at();

-- Add comments for documentation
COMMENT ON TABLE shared_notes IS 'Stores note sharing relationships with permissions and access control';
COMMENT ON COLUMN shared_notes.id IS 'Unique identifier for the share';
COMMENT ON COLUMN shared_notes.note_id IS 'ID of the note being shared';
COMMENT ON COLUMN shared_notes.owner_id IS 'User ID of the note owner who created the share';
COMMENT ON COLUMN shared_notes.shared_with_email IS 'Email address of the user the note is shared with';
COMMENT ON COLUMN shared_notes.shared_with_user_id IS 'User ID of the recipient (if they have an account)';
COMMENT ON COLUMN shared_notes.permission IS 'Permission level: view or edit';
COMMENT ON COLUMN shared_notes.share_token IS 'Unique token for link-based sharing';
COMMENT ON COLUMN shared_notes.created_at IS 'Timestamp when the share was created';
COMMENT ON COLUMN shared_notes.updated_at IS 'Timestamp when the share was last updated';
COMMENT ON COLUMN shared_notes.expires_at IS 'Optional expiration date for the share';
COMMENT ON COLUMN shared_notes.is_active IS 'Whether the share is currently active';
