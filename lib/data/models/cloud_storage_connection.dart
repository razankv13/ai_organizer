import 'package:freezed_annotation/freezed_annotation.dart';

part 'cloud_storage_connection.freezed.dart';
part 'cloud_storage_connection.g.dart';

/// Represents different cloud storage providers
enum CloudStorageProvider {
  @JsonValue('dropbox')
  dropbox,
  @JsonValue('google_drive')
  googleDrive,
}

/// Model for cloud storage connection/authentication
@freezed
abstract class CloudStorageConnection with _$CloudStorageConnection {
  const factory CloudStorageConnection({
    required String id,
    required String userId,
    required CloudStorageProvider provider,
    required String accessToken,
    String? refreshToken,
    DateTime? tokenExpiry,
    String? userEmail,
    String? userName,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _CloudStorageConnection;

  factory CloudStorageConnection.fromJson(Map<String, dynamic> json) =>
      _$CloudStorageConnectionFromJson(json);
}

/// Extension to provide helper methods
extension CloudStorageConnectionX on CloudStorageConnection {
  /// Check if the access token is expired
  bool get isTokenExpired {
    if (tokenExpiry == null) return false;
    return DateTime.now().isAfter(tokenExpiry!);
  }

  /// Get display name for the provider
  String get providerDisplayName {
    switch (provider) {
      case CloudStorageProvider.dropbox:
        return 'Dropbox';
      case CloudStorageProvider.googleDrive:
        return 'Google Drive';
    }
  }

  /// Get provider icon name (for UI)
  String get providerIcon {
    switch (provider) {
      case CloudStorageProvider.dropbox:
        return 'dropbox';
      case CloudStorageProvider.googleDrive:
        return 'google_drive';
    }
  }
}
