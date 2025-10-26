import 'package:freezed_annotation/freezed_annotation.dart';

part 'email_settings.freezed.dart';
part 'email_settings.g.dart';

@freezed
abstract class EmailSettings with _$EmailSettings {
  const factory EmailSettings({
    required String id,
    required String userId,
    required String uniqueEmail,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(true) bool isEnabled,
    @Default(false) bool gmailConnected,
    String? gmailEmail,
    String? gmailRefreshToken,
    DateTime? lastGmailSync,
    @Default({}) Map<String, dynamic> preferences,
  }) = _EmailSettings;

  factory EmailSettings.fromJson(Map<String, dynamic> json) =>
      _$EmailSettingsFromJson(json);
}
