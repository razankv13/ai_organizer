import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Manages API keys for external services
class ApiKeys {
  /// Get the Gemini API key
  static String getGeminiApiKey() {
    // For production, use an environment variable or secure storage
    if (kReleaseMode) {
      // In release mode, try to get from environment variables
      return const String.fromEnvironment('GEMINI_API_KEY', 
          defaultValue: 'YOUR_GEMINI_API_KEY');
    } else {
      // In debug mode, try to get from .env file if using dotenv
      try {
        final key = dotenv.env['GEMINI_API_KEY'];
        if (key != null && key.isNotEmpty) {
          return key;
        }
      } catch (e) {
        debugPrint('Error loading API key from .env: $e');
      }
      
      // Fallback for development (replace with your test API key)
      return 'YOUR_GEMINI_API_KEY';
    }
  }
} 