import 'package:ai_organizer/data/models/share_permission.dart';
import 'package:ai_organizer/data/models/shared_note.dart';
import 'package:ai_organizer/data/repositories/shared_notes_repository.dart';
import 'package:ai_organizer/providers/auth_provider.dart';
import 'package:ai_organizer/providers/database_provider.dart';
import 'package:ai_organizer/services/sharing_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sharing state management

/// Shared notes repository provider
final sharedNotesRepositoryProvider = Provider<SharedNotesRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return SharedNotesRepository(database);
});

/// Sharing service provider
final sharingServiceProvider = Provider<SharingService>((ref) {
  final repository = ref.watch(sharedNotesRepositoryProvider);
  final supabase = ref.watch(supabaseClientProvider);
  // SharingService will handle null client gracefully
  return SharingService(repository, supabase!);
});

/// Get all shares for a note
final sharesForNoteProvider = FutureProvider.family<List<SharedNote>, String>((ref, noteId) async {
  final service = ref.watch(sharingServiceProvider);
  return await service.getSharesForNote(noteId);
});

/// Get all notes shared with current user
final notesSharedWithMeProvider = FutureProvider<List<SharedNote>>((ref) async {
  final service = ref.watch(sharingServiceProvider);
  try {
    return await service.getNotesSharedWithMe();
  } catch (e) {
    // Return empty list if user is not authenticated
    return [];
  }
});

/// Check if a note is shared
final isNoteSharedProvider = FutureProvider.family<bool, String>((ref, noteId) async {
  final repository = ref.watch(sharedNotesRepositoryProvider);
  return await repository.isNoteShared(noteId);
});

/// Get active share count for a note
final shareCountProvider = FutureProvider.family<int, String>((ref, noteId) async {
  final repository = ref.watch(sharedNotesRepositoryProvider);
  return await repository.getActiveShareCount(noteId);
});

/// Sharing actions provider
final sharingActionsProvider = Provider((ref) => SharingActions(ref));

/// Actions class for sharing operations
class SharingActions {
  SharingActions(this._ref);

  final Ref _ref;

  SharingService get _service => _ref.read(sharingServiceProvider);
  SharedNotesRepository get _repository => _ref.read(sharedNotesRepositoryProvider);

  /// Share a note with a user via email
  Future<SharedNote> shareWithEmail({
    required String noteId,
    required String email,
    required SharePermission permission,
    DateTime? expiresAt,
  }) async {
    final share = await _service.shareNoteWithEmail(
      noteId: noteId,
      email: email,
      permission: permission,
      expiresAt: expiresAt,
    );

    // Invalidate the shares for this note to refresh the UI
    _ref.invalidate(sharesForNoteProvider(noteId));
    _ref.invalidate(isNoteSharedProvider(noteId));
    _ref.invalidate(shareCountProvider(noteId));

    return share;
  }

  /// Create a shareable link for a note
  Future<Map<String, dynamic>> createShareLink({
    required String noteId,
    required SharePermission permission,
    DateTime? expiresAt,
  }) async {
    final shareData = await _service.createShareLink(
      noteId: noteId,
      permission: permission,
      expiresAt: expiresAt,
    );

    // Invalidate the shares for this note to refresh the UI
    _ref.invalidate(sharesForNoteProvider(noteId));
    _ref.invalidate(isNoteSharedProvider(noteId));
    _ref.invalidate(shareCountProvider(noteId));

    return shareData;
  }

  /// Update share permission
  Future<bool> updatePermission({
    required String shareId,
    required String noteId,
    required SharePermission newPermission,
  }) async {
    final result = await _service.updatePermission(shareId, newPermission);

    if (result) {
      // Invalidate the shares for this note to refresh the UI
      _ref.invalidate(sharesForNoteProvider(noteId));
    }

    return result;
  }

  /// Revoke a share (deactivate it)
  Future<bool> revokeShare({
    required String shareId,
    required String noteId,
  }) async {
    final result = await _service.revokeShare(shareId);

    if (result) {
      // Invalidate the shares for this note to refresh the UI
      _ref.invalidate(sharesForNoteProvider(noteId));
      _ref.invalidate(isNoteSharedProvider(noteId));
      _ref.invalidate(shareCountProvider(noteId));
    }

    return result;
  }

  /// Delete a share permanently
  Future<bool> deleteShare({
    required String shareId,
    required String noteId,
  }) async {
    final result = await _service.deleteShare(shareId);

    if (result) {
      // Invalidate the shares for this note to refresh the UI
      _ref.invalidate(sharesForNoteProvider(noteId));
      _ref.invalidate(isNoteSharedProvider(noteId));
      _ref.invalidate(shareCountProvider(noteId));
    }

    return result;
  }

  /// Share via system share sheet
  Future<void> shareViaSystemShare({
    required String noteId,
    required String noteTitle,
    SharePermission permission = SharePermission.view,
  }) async {
    await _service.shareViaSystemShare(
      noteId: noteId,
      noteTitle: noteTitle,
      permission: permission,
    );

    // Invalidate the shares for this note to refresh the UI
    _ref.invalidate(sharesForNoteProvider(noteId));
    _ref.invalidate(isNoteSharedProvider(noteId));
    _ref.invalidate(shareCountProvider(noteId));
  }

  /// Send email invitation
  Future<void> sendEmailInvitation({
    required String shareId,
    required String recipientEmail,
    required String noteTitle,
  }) async {
    await _service.sendEmailInvitation(
      shareId: shareId,
      recipientEmail: recipientEmail,
      noteTitle: noteTitle,
    );
  }

  /// Validate a share token
  Future<SharedNote?> validateShareToken(String token) async {
    return await _service.validateShareToken(token);
  }

  /// Check if current user can access a note
  Future<bool> canAccessNote(String noteId) async {
    return await _service.canAccessNote(noteId);
  }

  /// Check if current user can edit a note
  Future<bool> canEditNote(String noteId) async {
    return await _service.canEditNote(noteId);
  }

  /// Clean up expired shares
  Future<int> cleanupExpiredShares() async {
    final count = await _service.cleanupExpiredShares();

    // Invalidate all share providers to refresh the UI
    _ref.invalidate(notesSharedWithMeProvider);

    return count;
  }
}
