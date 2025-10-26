import 'package:ai_organizer/providers/auth_provider.dart';
import 'package:ai_organizer/services/email_service.dart';
import 'package:ai_organizer/services/gmail_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for EmailService
final emailServiceProvider = Provider<EmailService>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return EmailService(supabase!);
});

/// Provider for GmailService
final gmailServiceProvider = Provider<GmailService>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return GmailService(supabase!);
});

/// Provider for email settings
final emailSettingsProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final emailService = ref.watch(emailServiceProvider);
  final user = ref.watch(currentUserProvider);

  if (user == null) return null;

  return await emailService.getEmailSettings();
});

/// Provider for checking if Gmail is connected
final isGmailConnectedProvider = Provider<bool>((ref) {
  final emailSettings = ref.watch(emailSettingsProvider);

  return emailSettings.whenData((settings) {
    if (settings == null) return false;
    return settings['gmail_connected'] as bool? ?? false;
  }).value ?? false;
});

/// Provider for email actions
final emailActionsProvider = Provider<EmailActions>((ref) {
  final emailService = ref.watch(emailServiceProvider);
  final gmailService = ref.watch(gmailServiceProvider);
  return EmailActions(ref, emailService, gmailService);
});

/// Email actions class
class EmailActions {
  EmailActions(this._ref, this._emailService, this._gmailService);

  final Ref _ref;
  final EmailService _emailService;
  final GmailService _gmailService;

  /// Initialize email settings for current user
  Future<Map<String, dynamic>> initializeEmailSettings() async {
    final result = await _emailService.initializeEmailSettings();
    // Invalidate the provider to refresh the UI
    _ref.invalidate(emailSettingsProvider);
    return result;
  }

  /// Regenerate unique email address
  Future<Map<String, dynamic>> regenerateUniqueEmail() async {
    final result = await _emailService.regenerateUniqueEmail();
    _ref.invalidate(emailSettingsProvider);
    return result;
  }

  /// Enable or disable email-to-note feature
  Future<void> toggleEmailToNote(bool enabled) async {
    await _emailService.updateEmailSettings(isEnabled: enabled);
    _ref.invalidate(emailSettingsProvider);
  }

  /// Connect to Gmail
  Future<bool> connectGmail() async {
    final success = await _gmailService.signInToGmail();

    if (success) {
      // Update email settings
      await _emailService.updateEmailSettings(
        gmailConnected: true,
        gmailEmail: _gmailService.currentUserEmail,
        lastGmailSync: DateTime.now(),
      );
      _ref.invalidate(emailSettingsProvider);
    }

    return success;
  }

  /// Disconnect from Gmail
  Future<void> disconnectGmail() async {
    await _gmailService.signOutFromGmail();
    await _emailService.updateEmailSettings(
      gmailConnected: false,
      gmailEmail: null,
      gmailRefreshToken: null,
    );
    _ref.invalidate(emailSettingsProvider);
  }

  /// Fetch emails from Gmail
  Future<List<GmailMessage>> fetchGmailEmails({
    int maxResults = 50,
    String? query,
  }) async {
    return await _gmailService.fetchEmails(
      maxResults: maxResults,
      query: query,
    );
  }

  /// Update last Gmail sync time
  Future<void> updateLastGmailSync() async {
    await _emailService.updateEmailSettings(
      lastGmailSync: DateTime.now(),
    );
    _ref.invalidate(emailSettingsProvider);
  }

  /// Get Gmail labels
  Future<List<String>> getGmailLabels() async {
    return await _gmailService.getLabels();
  }

  /// Check if Gmail is signed in
  bool isGmailSignedIn() {
    return _gmailService.isSignedIn;
  }
}
