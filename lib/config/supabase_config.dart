import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Supabase configuration class
class SupabaseConfig {
  // Private constructor to prevent instantiation
  SupabaseConfig._();

  /// Get Supabase URL from environment variables
  static String get supabaseUrl {
    final url = dotenv.env['SUPABASE_URL'];
    debugPrint('🔍 Checking SUPABASE_URL: ${url != null && url.isNotEmpty ? "Found (${url.substring(0, 20)}...)" : "NOT FOUND"}');
    if (url == null || url.isEmpty) {
      throw Exception('SUPABASE_URL not found in .env file. Make sure .env exists and contains SUPABASE_URL.');
    }
    return url;
  }

  /// Get Supabase anon key from environment variables
  static String get supabaseAnonKey {
    final key = dotenv.env['SUPABASE_ANON_KEY'];
    debugPrint('🔍 Checking SUPABASE_ANON_KEY: ${key != null && key.isNotEmpty ? "Found (${key.substring(0, 20)}...)" : "NOT FOUND"}');
    if (key == null || key.isEmpty) {
      throw Exception('SUPABASE_ANON_KEY not found in .env file. Make sure .env exists and contains SUPABASE_ANON_KEY.');
    }
    return key;
  }

  /// Initialize Supabase
  static Future<void> initialize() async {
    try {
      // Check if already initialized (important for hot reloads)
      try {
        final _ = Supabase.instance.client;
        debugPrint('Supabase already initialized, skipping re-initialization');
        return;
      } catch (_) {
        // Not initialized yet, proceed with initialization
      }

      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        debug: kDebugMode,
      );

      debugPrint('Supabase initialized successfully');
      debugPrint('Connected to: $supabaseUrl');
    } catch (e) {
      debugPrint('Error initializing Supabase: $e');
      rethrow;
    }
  }
  
  /// Database schema documentation
  ///
  /// The actual schema has been created via Supabase MCP migrations.
  /// See migrations in Supabase dashboard:
  /// - create_initial_schema: Creates tables with proper structure
  /// - enable_row_level_security: Enables RLS and creates policies
  /// - optimize_rls_and_functions_v2: Optimizes performance and security
  ///
  /// Key tables:
  /// - notes: Core note entity with title, content, timestamps, flags
  /// - tags: Reusable tags for categorization
  /// - attachments: File attachments with metadata
  /// - note_tags: Junction table for many-to-many notes-tags relationship
  ///
  /// Storage:
  /// - attachments bucket: Stores user files (50MB limit per file)
  ///
  /// All tables have RLS enabled with user-scoped policies.
  static const String schemaDocumentation = '''
Database Schema (Managed via Supabase MCP)

Tables:
- notes: id, user_id, title, content, created_at, updated_at, is_pinned, is_archived, is_favorite, folder_id, color
- tags: id, user_id, name, created_at, color, use_count, description
- attachments: id, user_id, note_id, file_name, file_path, type, file_size, created_at, mime_type, thumbnail_path, metadata
- note_tags: note_id, tag_id, created_at

Storage Buckets:
- attachments: User file storage with 50MB limit

Security:
- All tables have Row Level Security (RLS) enabled
- Optimized RLS policies with (select auth.uid()) pattern
- Functions use SECURITY DEFINER with SET search_path
  ''';
} 