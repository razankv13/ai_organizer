import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provider for checking if Supabase is initialized
/// Using autoDispose to ensure fresh evaluation after hot reloads
final supabaseInitializedProvider = Provider.autoDispose<bool>((ref) {
  try {
    // Try to access the instance
    final _ = Supabase.instance.client;
    return true;
  } catch (e) {
    return false;
  }
});

/// Provider for the Supabase client (nullable to handle uninitialized state)
/// Using autoDispose to ensure fresh evaluation after hot reloads
final supabaseClientProvider = Provider.autoDispose<SupabaseClient?>((ref) {
  try {
    final client = Supabase.instance.client;
    // Successfully got client
    return client;
  } catch (e, stackTrace) {
    // Supabase not initialized yet
    print('⚠️ supabaseClientProvider: Supabase not initialized - $e');
    print('⚠️ Stack trace: $stackTrace');
    return null;
  }
});

/// Provider for auth state changes (user login/logout)
final authStateChangesProvider = StreamProvider<AuthState>((ref) {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) {
    // Return a stream that never emits if Supabase is not initialized
    return const Stream<AuthState>.empty();
  }
  return client.auth.onAuthStateChange;
});

/// Provider for the current user
final currentUserProvider = Provider<User?>((ref) {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) return null;
  return client.auth.currentUser;
});

/// Provider for authentication actions
final authActionsProvider = Provider.autoDispose<AuthActions>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthActions(client);
});

/// Authentication actions
class AuthActions {
  AuthActions(this._client);
  final SupabaseClient? _client;

  /// Helper to ensure client is initialized
  SupabaseClient get _ensureClient {
    if (_client == null) {
      print('❌ AuthActions._ensureClient: _client is null');
      print('❌ This likely means Supabase failed to initialize.');
      print('❌ Check the app startup logs for "Supabase initialized successfully"');
      throw Exception(
        'Supabase is not initialized. Check your .env configuration and app startup logs.',
      );
    }
    return _client;
  }

  /// Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? userData,
  }) async {
    final response = await _ensureClient.auth.signUp(
      email: email,
      password: password,
      data: userData,
    );
    return response;
  }

  /// Sign in with email and password
  Future<AuthResponse> signIn({required String email, required String password}) async {
    final response = await _ensureClient.auth.signInWithPassword(email: email, password: password);
    return response;
  }

  /// Sign in with OAuth provider
  Future<bool> signInWithOAuth(OAuthProvider provider) async {
    return await _ensureClient.auth.signInWithOAuth(provider);
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    await _ensureClient.auth.resetPasswordForEmail(email);
  }

  /// Sign out
  Future<void> signOut() async {
    await _ensureClient.auth.signOut();
  }

  /// Get user profile data
  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = _ensureClient.auth.currentUser;
    if (user == null) return null;

    final response = await _ensureClient.from('profiles').select().eq('id', user.id).single();

    return response;
  }

  /// Update user profile data
  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    final user = _ensureClient.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _ensureClient.from('profiles').update(data).eq('id', user.id);
  }

  /// Check if user is authenticated
  bool get isAuthenticated {
    if (_client == null) return false;
    return _client.auth.currentUser != null;
  }

  /// Delete user account and all related data (production method)
  /// This calls a Supabase function that safely deletes all user data
  Future<Map<String, dynamic>> deleteAccount() async {
    final user = _ensureClient.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    try {
      // Call the Supabase function to delete account
      final response = await _ensureClient.rpc(
        'delete_user_account',
        params: {'user_id_to_delete': user.id},
      );

      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }
}
