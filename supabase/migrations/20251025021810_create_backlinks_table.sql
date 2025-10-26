-- Create backlinks table for wiki-style note linking
CREATE TABLE IF NOT EXISTS public.backlinks (
    id TEXT PRIMARY KEY,
    source_note_id TEXT NOT NULL REFERENCES public.notes(id) ON DELETE CASCADE,
    target_note_id TEXT NOT NULL REFERENCES public.notes(id) ON DELETE CASCADE,
    target_text TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_backlinks_source_note_id ON public.backlinks(source_note_id);
CREATE INDEX IF NOT EXISTS idx_backlinks_target_note_id ON public.backlinks(target_note_id);
CREATE INDEX IF NOT EXISTS idx_backlinks_user_id ON public.backlinks(user_id);

-- Enable Row Level Security
ALTER TABLE public.backlinks ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
-- Users can only see their own backlinks
CREATE POLICY "Users can view their own backlinks"
    ON public.backlinks
    FOR SELECT
    USING (auth.uid() = user_id);

-- Users can insert their own backlinks
CREATE POLICY "Users can insert their own backlinks"
    ON public.backlinks
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Users can update their own backlinks
CREATE POLICY "Users can update their own backlinks"
    ON public.backlinks
    FOR UPDATE
    USING (auth.uid() = user_id);

-- Users can delete their own backlinks
CREATE POLICY "Users can delete their own backlinks"
    ON public.backlinks
    FOR DELETE
    USING (auth.uid() = user_id);

-- Create a function to automatically update backlinks when notes are updated
-- This would be called from the application layer, not as a trigger
