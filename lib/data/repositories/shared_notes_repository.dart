import 'package:ai_organizer/data/database/app_database.dart';
import 'package:ai_organizer/data/models/shared_note.dart';
import 'package:ai_organizer/data/models/share_permission.dart';

/// Repository for managing shared notes and permissions
class SharedNotesRepository {
  SharedNotesRepository(this._database);

  final AppDatabase _database;

  // ===== SHARED NOTES OPERATIONS =====

  /// Get all shares for a specific note (as owner)
  Future<List<SharedNote>> getSharesForNote(String noteId) async {
    return await _database.getSharesForNote(noteId);
  }

  /// Get all notes shared with a user (as recipient)
  Future<List<SharedNote>> getNotesSharedWithUser(String emailOrUserId) async {
    return await _database.getNotesSharedWith(emailOrUserId);
  }

  /// Get a share by its ID
  Future<SharedNote?> getShareById(String id) async {
    return await _database.getShareById(id);
  }

  /// Get a share by its token (for link-based sharing)
  Future<SharedNote?> getShareByToken(String token) async {
    return await _database.getShareByToken(token);
  }

  /// Check if a note is already shared with a specific user
  Future<SharedNote?> getShareForNoteAndUser(
    String noteId,
    String emailOrUserId,
  ) async {
    return await _database.getShareForNoteAndUser(noteId, emailOrUserId);
  }

  /// Create a new share
  Future<SharedNote> createShare({
    required String noteId,
    required String ownerId,
    required String sharedWithEmail,
    String? sharedWithUserId,
    required SharePermission permission,
    DateTime? expiresAt,
  }) async {
    // Check if note is already shared with this user
    final existingShare = await getShareForNoteAndUser(
      noteId,
      sharedWithUserId ?? sharedWithEmail,
    );

    if (existingShare != null) {
      throw Exception('Note is already shared with this user');
    }

    final share = SharedNote.create(
      noteId: noteId,
      ownerId: ownerId,
      sharedWithEmail: sharedWithEmail,
      sharedWithUserId: sharedWithUserId,
      permission: permission,
      expiresAt: expiresAt,
    );

    await _database.insertShare(share);
    return share;
  }

  /// Update a share (full update)
  Future<bool> updateShare(SharedNote share) async {
    await _database.insertShare(share);
    return true;
  }

  /// Update share permission
  Future<bool> updateSharePermission(
    String shareId,
    SharePermission newPermission,
  ) async {
    return await _database.updateSharePermission(shareId, newPermission);
  }

  /// Deactivate a share (soft delete)
  Future<bool> deactivateShare(String shareId) async {
    return await _database.deactivateShare(shareId);
  }

  /// Reactivate a previously deactivated share
  Future<bool> reactivateShare(String shareId) async {
    final share = await getShareById(shareId);
    if (share == null) return false;

    final updatedShare = share.activate();
    return await updateShare(updatedShare);
  }

  /// Delete a share permanently
  Future<bool> deleteShare(String shareId) async {
    return await _database.deleteShare(shareId);
  }

  /// Delete all shares for a note
  Future<int> deleteAllSharesForNote(String noteId) async {
    return await _database.deleteSharesForNote(noteId);
  }

  /// Get count of active shares for a note
  Future<int> getActiveShareCount(String noteId) async {
    return await _database.getActiveShareCountForNote(noteId);
  }

  /// Check if a note is shared (has at least one active share)
  Future<bool> isNoteShared(String noteId) async {
    final count = await getActiveShareCount(noteId);
    return count > 0;
  }

  /// Check if a user has access to a note
  Future<bool> hasAccess(String noteId, String emailOrUserId) async {
    final share = await getShareForNoteAndUser(noteId, emailOrUserId);
    return share != null && share.isValid;
  }

  /// Check if a user has edit permission for a note
  Future<bool> hasEditPermission(String noteId, String emailOrUserId) async {
    final share = await getShareForNoteAndUser(noteId, emailOrUserId);
    return share != null && share.isValid && share.permission == SharePermission.edit;
  }

  /// Extend the expiration date of a share
  Future<bool> extendShareExpiration(
    String shareId,
    DateTime newExpiresAt,
  ) async {
    final share = await getShareById(shareId);
    if (share == null) return false;

    final updatedShare = share.extendExpiration(newExpiresAt);
    return await updateShare(updatedShare);
  }

  /// Remove expiration from a share (make it permanent)
  Future<bool> makeSharePermanent(String shareId) async {
    final share = await getShareById(shareId);
    if (share == null) return false;

    final updatedShare = share.removeExpiration();
    return await updateShare(updatedShare);
  }

  /// Get all shares that have expired
  Future<List<SharedNote>> getExpiredShares() async {
    final allShares = await _database.getSharesForNote('');
    return allShares.where((share) => share.isExpired).toList();
  }

  /// Clean up expired shares (deactivate them)
  Future<int> cleanupExpiredShares() async {
    final expiredShares = await getExpiredShares();
    int count = 0;

    for (final share in expiredShares) {
      if (await deactivateShare(share.id)) {
        count++;
      }
    }

    return count;
  }
}
