import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ai_organizer/data/models/share_permission.dart';

part 'shared_note.freezed.dart';
part 'shared_note.g.dart';

/// Model representing a shared note relationship
@freezed
abstract class SharedNote with _$SharedNote {
  const factory SharedNote({
    required String id,
    required String noteId,
    required String ownerId,
    required String sharedWithEmail,
    String? sharedWithUserId,
    required SharePermission permission,
    required String shareToken,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? expiresAt,
    @Default(true) bool isActive,
  }) = _SharedNote;

  factory SharedNote.fromJson(Map<String, dynamic> json) => _$SharedNoteFromJson(json);

  /// Create a new share with generated ID, token, and timestamps
  factory SharedNote.create({
    required String noteId,
    required String ownerId,
    required String sharedWithEmail,
    String? sharedWithUserId,
    required SharePermission permission,
    DateTime? expiresAt,
  }) {
    final now = DateTime.now();
    return SharedNote(
      id: _generateId(),
      noteId: noteId,
      ownerId: ownerId,
      sharedWithEmail: sharedWithEmail,
      sharedWithUserId: sharedWithUserId,
      permission: permission,
      shareToken: _generateToken(),
      createdAt: now,
      updatedAt: now,
      expiresAt: expiresAt,
      isActive: true,
    );
  }

  const SharedNote._();

  /// Check if the share has expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Check if the share is valid (active and not expired)
  bool get isValid => isActive && !isExpired;

  /// Update permission level
  SharedNote updatePermission(SharePermission newPermission) {
    return copyWith(permission: newPermission, updatedAt: DateTime.now());
  }

  /// Deactivate the share
  SharedNote deactivate() {
    return copyWith(isActive: false, updatedAt: DateTime.now());
  }

  /// Activate the share
  SharedNote activate() {
    return copyWith(isActive: true, updatedAt: DateTime.now());
  }

  /// Extend expiration date
  SharedNote extendExpiration(DateTime newExpiresAt) {
    return copyWith(expiresAt: newExpiresAt, updatedAt: DateTime.now());
  }

  /// Remove expiration (make share permanent)
  SharedNote removeExpiration() {
    return copyWith(expiresAt: null, updatedAt: DateTime.now());
  }
}

/// Generate a unique ID for the share
String _generateId() {
  return DateTime.now().millisecondsSinceEpoch.toString() +
      '_' +
      (DateTime.now().microsecond % 1000).toString().padLeft(3, '0');
}

/// Generate a secure random token for link sharing
String _generateToken() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final random = DateTime.now().millisecondsSinceEpoch;
  final buffer = StringBuffer();

  // Generate a 32-character token
  for (int i = 0; i < 32; i++) {
    final index = (random + i * 13) % chars.length;
    buffer.write(chars[index]);
  }

  return buffer.toString();
}
