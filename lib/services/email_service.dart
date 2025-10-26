import 'dart:developer' as developer;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

/// Service for managing email integration features
/// Handles unique email addresses for email-to-note functionality
class EmailService {
  EmailService(this._supabaseClient);

  final SupabaseClient? _supabaseClient;
  final _uuid = const Uuid();

  /// Helper to ensure client is initialized
  SupabaseClient get _ensureClient {
    if (_supabaseClient == null) {
      throw Exception('Supabase is not initialized. Check your .env configuration.');
    }
    return _supabaseClient!;
  }

  static const String _emailDomain = '@notes.aiorganizer.app'; // Placeholder domain

  /// Generate a unique email address for a user
  /// Format: {short_uuid}@notes.aiorganizer.app
  String generateUniqueEmail() {
    // Generate a short unique identifier (first 12 characters of UUID)
    final shortId = _uuid.v4().replaceAll('-', '').substring(0, 12);
    return '$shortId$_emailDomain';
  }

  /// Get email settings for the current user
  Future<Map<String, dynamic>?> getEmailSettings() async {
    try {
      final client = _ensureClient;
      final user = client.auth.currentUser;
      if (user == null) {
        developer.log('No authenticated user', name: 'EmailService');
        return null;
      }

      final response = await client
          .from('email_settings')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      return response;
    } catch (e) {
      developer.log('Error getting email settings: $e', name: 'EmailService');
      rethrow;
    }
  }

  /// Initialize email settings for a user (create unique email address)
  Future<Map<String, dynamic>> initializeEmailSettings() async {
    try {
      final client = _ensureClient;
      final user = client.auth.currentUser;
      if (user == null) {
        throw Exception('User must be authenticated to initialize email settings');
      }

      // Check if settings already exist
      final existing = await getEmailSettings();
      if (existing != null) {
        return existing;
      }

      // Create new email settings with unique email address
      final uniqueEmail = generateUniqueEmail();
      final settingsId = _uuid.v4();

      final data = {
        'id': settingsId,
        'user_id': user.id,
        'unique_email': uniqueEmail,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'is_enabled': true,
        'gmail_connected': false,
        'preferences': {},
      };

      final response = await client
          .from('email_settings')
          .insert(data)
          .select()
          .single();

      developer.log('Email settings initialized: $uniqueEmail', name: 'EmailService');
      return response;
    } catch (e) {
      developer.log('Error initializing email settings: $e', name: 'EmailService');
      rethrow;
    }
  }

  /// Regenerate unique email address for a user
  Future<Map<String, dynamic>> regenerateUniqueEmail() async {
    try {
      final client = _ensureClient;
      final user = client.auth.currentUser;
      if (user == null) {
        throw Exception('User must be authenticated');
      }

      final settings = await getEmailSettings();
      if (settings == null) {
        // If no settings exist, initialize them
        return await initializeEmailSettings();
      }

      // Generate new unique email
      final newEmail = generateUniqueEmail();

      final response = await client
          .from('email_settings')
          .update({
            'unique_email': newEmail,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', user.id)
          .select()
          .single();

      developer.log('Email address regenerated: $newEmail', name: 'EmailService');
      return response;
    } catch (e) {
      developer.log('Error regenerating email: $e', name: 'EmailService');
      rethrow;
    }
  }

  /// Update email settings (enable/disable, preferences)
  Future<Map<String, dynamic>> updateEmailSettings({
    bool? isEnabled,
    bool? gmailConnected,
    String? gmailEmail,
    String? gmailRefreshToken,
    DateTime? lastGmailSync,
    Map<String, dynamic>? preferences,
  }) async {
    try {
      final client = _ensureClient;
      final user = client.auth.currentUser;
      if (user == null) {
        throw Exception('User must be authenticated');
      }

      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (isEnabled != null) updates['is_enabled'] = isEnabled;
      if (gmailConnected != null) updates['gmail_connected'] = gmailConnected;
      if (gmailEmail != null) updates['gmail_email'] = gmailEmail;
      if (gmailRefreshToken != null) updates['gmail_refresh_token'] = gmailRefreshToken;
      if (lastGmailSync != null) updates['last_gmail_sync'] = lastGmailSync.toIso8601String();
      if (preferences != null) updates['preferences'] = preferences;

      final response = await client
          .from('email_settings')
          .update(updates)
          .eq('user_id', user.id)
          .select()
          .single();

      return response;
    } catch (e) {
      developer.log('Error updating email settings: $e', name: 'EmailService');
      rethrow;
    }
  }

  /// Delete email settings for current user
  Future<void> deleteEmailSettings() async {
    try {
      final client = _ensureClient;
      final user = client.auth.currentUser;
      if (user == null) {
        throw Exception('User must be authenticated');
      }

      await client
          .from('email_settings')
          .delete()
          .eq('user_id', user.id);

      developer.log('Email settings deleted', name: 'EmailService');
    } catch (e) {
      developer.log('Error deleting email settings: $e', name: 'EmailService');
      rethrow;
    }
  }

  /// Get user ID from unique email address
  /// Used by edge function to lookup which user sent the email
  Future<String?> getUserIdFromEmail(String uniqueEmail) async {
    try {
      final client = _ensureClient;
      final response = await client
          .from('email_settings')
          .select('user_id')
          .eq('unique_email', uniqueEmail)
          .eq('is_enabled', true)
          .maybeSingle();

      return response?['user_id'] as String?;
    } catch (e) {
      developer.log('Error looking up user from email: $e', name: 'EmailService');
      return null;
    }
  }
}
