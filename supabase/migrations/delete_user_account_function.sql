-- Migration: Create function to safely delete user account and all related data
-- This function will be called when a user wants to delete their account
-- It ensures cascade deletion of all user data in the correct order

-- Create the function to delete user account
CREATE OR REPLACE FUNCTION delete_user_account(user_id_to_delete UUID)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  deleted_notes_count INT;
  deleted_tags_count INT;
  deleted_attachments_count INT;
  result JSON;
BEGIN
  -- Verify that the requesting user is deleting their own account
  -- This is a safety check
  IF auth.uid() != user_id_to_delete THEN
    RAISE EXCEPTION 'Unauthorized: You can only delete your own account';
  END IF;

  -- Start transaction (implicit in function, but making it clear)
  -- Delete in correct order to respect foreign keys

  -- 1. Delete note_tags (junction table)
  DELETE FROM note_tags
  WHERE note_id IN (
    SELECT id FROM notes WHERE user_id = user_id_to_delete
  );

  -- 2. Get count and delete attachments metadata
  SELECT COUNT(*) INTO deleted_attachments_count
  FROM attachments
  WHERE user_id = user_id_to_delete;

  DELETE FROM attachments
  WHERE user_id = user_id_to_delete;

  -- Note: Attachments in storage bucket should be deleted via storage policies
  -- or separately via the app. The storage bucket has RLS that prevents access
  -- after profile is deleted.

  -- 3. Get count and delete notes
  SELECT COUNT(*) INTO deleted_notes_count
  FROM notes
  WHERE user_id = user_id_to_delete;

  DELETE FROM notes
  WHERE user_id = user_id_to_delete;

  -- 4. Get count and delete tags
  SELECT COUNT(*) INTO deleted_tags_count
  FROM tags
  WHERE user_id = user_id_to_delete;

  DELETE FROM tags
  WHERE user_id = user_id_to_delete;

  -- 5. Delete profile
  DELETE FROM profiles
  WHERE id = user_id_to_delete;

  -- 6. Delete auth user (this will cascade to auth-related tables)
  -- Note: This uses auth.users which requires SECURITY DEFINER
  DELETE FROM auth.users
  WHERE id = user_id_to_delete;

  -- Build result JSON
  result := json_build_object(
    'success', true,
    'user_id', user_id_to_delete,
    'deleted_counts', json_build_object(
      'notes', deleted_notes_count,
      'tags', deleted_tags_count,
      'attachments', deleted_attachments_count
    ),
    'message', 'Account and all related data deleted successfully'
  );

  RETURN result;

EXCEPTION
  WHEN OTHERS THEN
    -- Roll back transaction and return error
    RAISE EXCEPTION 'Error deleting account: %', SQLERRM;
END;
$$;

-- Grant execute permission to authenticated users (they can only delete their own account)
GRANT EXECUTE ON FUNCTION delete_user_account(UUID) TO authenticated;

-- Add comment
COMMENT ON FUNCTION delete_user_account IS
'Safely deletes a user account and all related data (notes, tags, attachments, profile).
Users can only delete their own account. Returns JSON with deletion statistics.';
