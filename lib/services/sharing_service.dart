import 'package:ai_organizer/data/models/shared_note.dart';
import 'package:ai_organizer/data/models/share_permission.dart';
import 'package:ai_organizer/data/repositories/shared_notes_repository.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for managing note sharing functionality
class SharingService {
  SharingService(this._repository, this._supabase);

  final SharedNotesRepository _repository;
  final SupabaseClient _supabase;

  // Base URL for the app (should be configured based on environment)
  static const String _baseUrl = 'https://aiorganizer.app'; // TODO: Update with actual app URL

  // ===== SHARE CREATION =====

  /// Share a note with a user via email
  Future<SharedNote> shareNoteWithEmail({
    required String noteId,
    required String email,
    required SharePermission permission,
    DateTime? expiresAt,
  }) async {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) {
      throw Exception('User must be authenticated to share notes');
    }

    // Check if note exists and user owns it
    final note = await _supabase
        .from('notes')
        .select()
        .eq('id', noteId)
        .eq('user_id', currentUser.id)
        .single();

    if (note == null) {
      throw Exception('Note not found or you do not have permission to share it');
    }

    // Check if user with this email exists
    String? recipientUserId;
    try {
      final users = await _supabase
          .from('profiles')
          .select('id')
          .eq('email', email)
          .limit(1);

      if (users.isNotEmpty) {
        recipientUserId = users.first['id'] as String?;
      }
    } catch (e) {
      // User doesn't exist yet, that's okay
      recipientUserId = null;
    }

    // Create the share
    final share = await _repository.createShare(
      noteId: noteId,
      ownerId: currentUser.id,
      sharedWithEmail: email,
      sharedWithUserId: recipientUserId,
      permission: permission,
      expiresAt: expiresAt,
    );

    return share;
  }

  /// Generate a shareable link for a note
  Future<String> generateShareLink(String shareId) async {
    final share = await _repository.getShareById(shareId);
    if (share == null) {
      throw Exception('Share not found');
    }

    if (!share.isValid) {
      throw Exception('Share is not active or has expired');
    }

    return '$_baseUrl/share/${share.shareToken}';
  }

  /// Share a note and get a shareable link
  Future<Map<String, dynamic>> createShareLink({
    required String noteId,
    required SharePermission permission,
    DateTime? expiresAt,
  }) async {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) {
      throw Exception('User must be authenticated to share notes');
    }

    // Create a share with a placeholder email (link-based sharing)
    final share = await _repository.createShare(
      noteId: noteId,
      ownerId: currentUser.id,
      sharedWithEmail: 'link-share@aiorganizer.app',
      sharedWithUserId: null,
      permission: permission,
      expiresAt: expiresAt,
    );

    final link = await generateShareLink(share.id);

    return {
      'shareId': share.id,
      'link': link,
      'token': share.shareToken,
      'expiresAt': share.expiresAt?.toIso8601String(),
    };
  }

  // ===== SHARE ACCESS VALIDATION =====

  /// Validate a share token and return the share if valid
  Future<SharedNote?> validateShareToken(String token) async {
    final share = await _repository.getShareByToken(token);

    if (share == null || !share.isValid) {
      return null;
    }

    return share;
  }

  /// Check if current user can access a shared note
  Future<bool> canAccessNote(String noteId) async {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) return false;

    return await _repository.hasAccess(
      noteId,
      currentUser.email ?? currentUser.id,
    );
  }

  /// Check if current user can edit a shared note
  Future<bool> canEditNote(String noteId) async {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) return false;

    return await _repository.hasEditPermission(
      noteId,
      currentUser.email ?? currentUser.id,
    );
  }

  // ===== SHARE MANAGEMENT =====

  /// Update share permission
  Future<bool> updatePermission(
    String shareId,
    SharePermission newPermission,
  ) async {
    return await _repository.updateSharePermission(shareId, newPermission);
  }

  /// Revoke a share (deactivate it)
  Future<bool> revokeShare(String shareId) async {
    return await _repository.deactivateShare(shareId);
  }

  /// Delete a share permanently
  Future<bool> deleteShare(String shareId) async {
    return await _repository.deleteShare(shareId);
  }

  /// Get all people who have access to a note
  Future<List<SharedNote>> getSharesForNote(String noteId) async {
    return await _repository.getSharesForNote(noteId);
  }

  /// Get all notes shared with current user
  Future<List<SharedNote>> getNotesSharedWithMe() async {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) {
      throw Exception('User must be authenticated');
    }

    return await _repository.getNotesSharedWithUser(
      currentUser.email ?? currentUser.id,
    );
  }

  // ===== SHARING VIA SYSTEM SHARE =====

  /// Share a note link via system share sheet
  Future<void> shareViaSystemShare({
    required String noteId,
    required String noteTitle,
    SharePermission permission = SharePermission.view,
  }) async {
    // Create a shareable link
    final shareData = await createShareLink(
      noteId: noteId,
      permission: permission,
    );

    final link = shareData['link'] as String;
    final permissionText = permission == SharePermission.edit ? 'edit' : 'view';

    await Share.share(
      'Check out this note: "$noteTitle"\n\n'
      'You have $permissionText access.\n\n'
      'Open link: $link',
      subject: 'Shared Note: $noteTitle',
    );
  }

  /// Send email invitation (requires backend implementation)
  Future<void> sendEmailInvitation({
    required String shareId,
    required String recipientEmail,
    required String noteTitle,
  }) async {
    // This would typically call a Supabase Edge Function to send the email
    // For now, we'll just create the share link
    final share = await _repository.getShareById(shareId);
    if (share == null) {
      throw Exception('Share not found');
    }

    final link = await generateShareLink(shareId);
    final permissionText = share.permission == SharePermission.edit ? 'edit' : 'view';

    // TODO: Call Supabase Edge Function to send email
    // await _supabase.functions.invoke('send-share-invitation', body: {
    //   'recipientEmail': recipientEmail,
    //   'noteTitle': noteTitle,
    //   'shareLink': link,
    //   'permission': permissionText,
    //   'senderName': _supabase.auth.currentUser?.email,
    // });

    // For now, we'll use system share as fallback
    await Share.share(
      'You have been invited to $permissionText the note: "$noteTitle"\n\n'
      'Open link: $link',
      subject: 'Note Sharing Invitation',
    );
  }

  // ===== CLEANUP =====

  /// Clean up expired shares
  Future<int> cleanupExpiredShares() async {
    return await _repository.cleanupExpiredShares();
  }
}
