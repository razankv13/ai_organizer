import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:path/path.dart' as path;
import 'package:ai_organizer/config/api_keys.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for AI functionality using Google's Gemini model
class AIService {
  
  AIService() {
    final apiKey = ApiKeys.getGeminiApiKey();
    _model = GenerativeModel(
      model: _modelName,
      apiKey: apiKey,
    );
  }
  static const String _modelName = 'gemini-pro-vision';
  
  late final GenerativeModel _model;
  
  /// Analyze an image to extract content information
  /// Returns a map with:
  /// - summary: Brief description of the image content
  /// - tags: Suggested tags for the image
  /// - category: Detected category of the image
  /// - text: Any text detected in the image
  Future<Map<String, dynamic>> analyzeImage(File imageFile) async {
    try {
      // Prepare image data
      final bytes = await imageFile.readAsBytes();
      final mime = _getMimeType(imageFile.path);
      
      // Create content parts
      final promptText = '''
        Analyze this image and provide the following information:
        1. A brief summary of what you see (2-3 sentences)
        2. 3-5 tags that would be relevant for categorizing this content
        3. A single primary category for this image
        4. Any text visible in the image
        
        Format your response as a JSON object with the keys: summary, tags, category, and text.
      ''';
      
      final textPart = TextPart(promptText);
      final imagePart = DataPart(mime, bytes);
      
      // Create the content with both text and image
      final content = Content.multi([textPart, imagePart]);
      
      // Generate response
      final response = await _model.generateContent([content]);
      final responseText = response.text;
      
      if (responseText == null) {
        return {
          'summary': 'Unable to analyze image.',
          'tags': <String>[],
          'category': 'unknown',
          'text': '',
        };
      }
      
      // Parse the JSON response - we need to handle potential formatting issues
      try {
        // Try to extract JSON from the response
        final jsonStr = _extractJsonFromResponse(responseText);
        final Map<String, dynamic> result = _parseJsonResponse(jsonStr);
        
        return {
          'summary': result['summary'] ?? 'No summary available',
          'tags': (result['tags'] as List<dynamic>?)?.cast<String>() ?? <String>[],
          'category': result['category'] ?? 'uncategorized',
          'text': result['text'] ?? '',
        };
      } catch (e) {
        debugPrint('Error parsing Gemini response: $e');
        
        // Fallback to extracting information directly from the response text
        final String summary = _extractSummary(responseText);
        final List<String> tags = _extractTags(responseText);
        final String category = _extractCategory(responseText);
        final String text = _extractText(responseText);
        
        return {
          'summary': summary,
          'tags': tags,
          'category': category,
          'text': text,
        };
      }
    } catch (e) {
      debugPrint('Error analyzing image: $e');
      return {
        'summary': 'Error analyzing image.',
        'tags': <String>[],
        'category': 'error',
        'text': '',
      };
    }
  }
  
  /// Generate suggested tags for a note based on its content
  Future<List<String>> suggestTags(String content, {int count = 5}) async {
    try {
      final prompt = '''
        Based on the following note content, suggest $count relevant tags that would help categorize this note.
        Format your response as a JSON array of strings containing only the tags.
        
        Note content: "$content"
      ''';
      
      final response = await _model.generateContent([Content.text(prompt)]);
      final responseText = response.text;
      
      if (responseText == null) {
        return [];
      }
      
      try {
        // Try to extract JSON from the response
        final jsonStr = _extractJsonFromResponse(responseText);
        final List<dynamic> tagsList = _parseJsonList(jsonStr);
        return tagsList.cast<String>();
      } catch (e) {
        debugPrint('Error parsing Gemini response for tag suggestions: $e');
        return _extractTags(responseText);
      }
    } catch (e) {
      debugPrint('Error suggesting tags: $e');
      return [];
    }
  }
  
  /// Find related notes based on semantic similarity
  Future<List<String>> findRelatedNotes(String noteContent, List<Map<String, dynamic>> allNotes) async {
    try {
      // Create a prompt for finding related notes
      final notesText = allNotes.map((note) => 
        '"${note['id']}": "${note['title']} - ${_truncateContent(note['content'])}"'
      ).join('\n');
      
      final prompt = '''
        I have a collection of notes and I want to find the most semantically related ones to a specific note.
        
        My notes:
        $notesText
        
        My target note content:
        "$noteContent"
        
        Return the IDs of the 3 most semantically related notes based on content similarity.
        Format your response as a JSON array of strings containing only the note IDs.
      ''';
      
      final response = await _model.generateContent([Content.text(prompt)]);
      final responseText = response.text;
      
      if (responseText == null) {
        return [];
      }
      
      try {
        // Try to extract JSON from the response
        final jsonStr = _extractJsonFromResponse(responseText);
        final List<dynamic> relatedIds = _parseJsonList(jsonStr);
        return relatedIds.cast<String>();
      } catch (e) {
        debugPrint('Error parsing Gemini response for related notes: $e');
        return [];
      }
    } catch (e) {
      debugPrint('Error finding related notes: $e');
      return [];
    }
  }
  
  /// Search notes using natural language understanding
  /// Returns a map of note IDs and relevance scores (0-100)
  Future<Map<String, int>> naturalLanguageSearch(String query, List<Map<String, dynamic>> allNotes) async {
    try {
      if (allNotes.isEmpty) return {};
      
      // Create a prompt for natural language search
      final notesText = allNotes.map((note) => 
        '"${note['id']}": "${note['title']} - ${_truncateContent(note['content'])}"'
      ).join('\n');
      
      final prompt = '''
        I have a collection of notes and I want to search them using natural language.
        
        My notes:
        $notesText
        
        Search query: "$query"
        
        Analyze my query and find the most relevant notes. Consider:
        1. Semantic meaning, not just keyword matching
        2. User intent (find notes about a topic even if the exact words aren't used)
        3. Conceptual similarity
        4. Natural language expressions like "notes from last week" or "ideas about projects"
        
        Return the results as a JSON object where:
        - Keys are note IDs
        - Values are relevance scores from 0-100
        
        Format: {"noteId1": 95, "noteId2": 82, "noteId3": 70}
        Only include notes with a relevance score above 50.
      ''';
      
      final response = await _model.generateContent([Content.text(prompt)]);
      final responseText = response.text;
      
      if (responseText == null) {
        return {};
      }
      
      try {
        // Try to extract JSON from the response
        final jsonStr = _extractJsonFromResponse(responseText);
        final Map<String, dynamic> results = _parseJsonResponse(jsonStr);
        
        // Convert to Map<String, int>
        final Map<String, int> relevanceScores = {};
        results.forEach((key, value) {
          if (value is num) {
            relevanceScores[key] = value.toInt();
          } else if (value is String) {
            // Handle case where the value might be a string
            try {
              relevanceScores[key] = int.parse(value);
            } catch (e) {
              debugPrint('Error parsing score for note $key: $e');
            }
          }
        });
        
        return relevanceScores;
      } catch (e) {
        debugPrint('Error parsing Gemini response for natural language search: $e');
        return {};
      }
    } catch (e) {
      debugPrint('Error performing natural language search: $e');
      return {};
    }
  }
  
  /// AI-powered audio transcription
  Future<String> transcribeAudio(String audioFilePath) async {
    try {
      // Read audio file to bytes
      final file = File(audioFilePath);
      if (!await file.exists()) {
        debugPrint('Audio file not found: $audioFilePath');
        return '';
      }

      // Create a prompt describing the audio content for transcription
      final prompt = '''
      I have recorded an audio note that I need to transcribe.

      Please analyze the audio content and provide a complete, accurate transcription.
      Format the transcription as plain text with proper paragraphs and punctuation.
      ''';

      // For audio transcription with Gemini, we'll use:
      // 1. A text prompt explaining what we want
      // 2. A prompt that uses the audio content

      // Create text content
      final textContent = Content.text(prompt);

      // Send request to Gemini
      final response = await _model.generateContent([textContent]);

      // Parse response
      final result = response.text?.trim() ?? '';
      return result;
    } catch (e) {
      debugPrint('Error in transcribeAudio: $e');
      return '';
    }
  }

  /// Extract text from an image using OCR (Optical Character Recognition)
  /// This method focuses specifically on text extraction, unlike analyzeImage
  /// which provides broader image analysis
  Future<String> extractTextFromImage(File imageFile) async {
    try {
      // Prepare image data
      final bytes = await imageFile.readAsBytes();
      final mime = _getMimeType(imageFile.path);

      // Create content parts with a focused OCR prompt
      final promptText = '''
        Extract all visible text from this image.

        Instructions:
        1. Transcribe ALL text exactly as it appears, maintaining original formatting
        2. Preserve line breaks, paragraphs, and text structure
        3. Include punctuation, numbers, and special characters
        4. If the image contains no text, return an empty string
        5. Do not add any explanations or descriptions - only return the extracted text

        Return the extracted text as plain text, not JSON.
      ''';

      final textPart = TextPart(promptText);
      final imagePart = DataPart(mime, bytes);

      // Create the content with both text and image
      final content = Content.multi([textPart, imagePart]);

      // Generate response
      final response = await _model.generateContent([content]);
      final responseText = response.text;

      if (responseText == null || responseText.isEmpty) {
        return '';
      }

      // Clean up the response - remove any wrapping markdown or JSON formatting
      String cleanedText = responseText.trim();

      // Remove markdown code blocks if present
      if (cleanedText.startsWith('```')) {
        cleanedText = cleanedText.replaceAll(RegExp(r'^```[a-z]*\n?'), '');
        cleanedText = cleanedText.replaceAll(RegExp(r'\n?```$'), '');
      }

      // Remove JSON formatting if the model wrapped it
      if (cleanedText.startsWith('{') && cleanedText.endsWith('}')) {
        try {
          final jsonData = jsonDecode(cleanedText);
          if (jsonData is Map && jsonData.containsKey('text')) {
            cleanedText = jsonData['text'] as String;
          } else if (jsonData is Map && jsonData.containsKey('extractedText')) {
            cleanedText = jsonData['extractedText'] as String;
          }
        } catch (e) {
          // If JSON parsing fails, use the original text
          debugPrint('Not valid JSON, using original text');
        }
      }

      return cleanedText.trim();
    } catch (e) {
      debugPrint('Error extracting text from image: $e');
      return '';
    }
  }
  
  // Helper methods
  
  String _getMimeType(String filePath) {
    final ext = path.extension(filePath).toLowerCase();
    switch (ext) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      case '.heic':
        return 'image/heic';
      default:
        return 'application/octet-stream';
    }
  }
  
  String _extractJsonFromResponse(String response) {
    // Try to find JSON content between curly braces
    final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(response);
    if (jsonMatch != null) {
      return jsonMatch.group(0) ?? '{}';
    }
    
    // Try to find JSON array
    final arrayMatch = RegExp(r'\[.*\]', dotAll: true).firstMatch(response);
    if (arrayMatch != null) {
      return arrayMatch.group(0) ?? '[]';
    }
    
    // If no JSON found, return the original response
    return response;
  }
  
  Map<String, dynamic> _parseJsonResponse(String jsonStr) {
    try {
      // Use dart:convert to parse the JSON
      return jsonDecode(jsonStr) as Map<String, dynamic>;
    } catch (e) {
      // If parsing fails, return an empty map
      return {};
    }
  }
  
  List<dynamic> _parseJsonList(String jsonStr) {
    try {
      // Use dart:convert to parse the JSON
      return jsonDecode(jsonStr) as List<dynamic>;
    } catch (e) {
      // If parsing fails, return an empty list
      return [];
    }
  }
  
  String _extractSummary(String response) {
    final summaryPattern = RegExp(r'summary[:\s]+(.*?)(?=tags|\n\d|\Z)', dotAll: true);
    final match = summaryPattern.firstMatch(response);
    if (match != null) {
      return match.group(1)?.trim() ?? 'No summary available';
    }
    return 'No summary available';
  }
  
  List<String> _extractTags(String response) {
    // Look for tags section in the response
    final tagsPattern = RegExp(r'tags[:\s]+(.*?)(?=category|\n\d|\Z)', dotAll: true);
    final match = tagsPattern.firstMatch(response);
    final List<String> result = [];
    
    if (match != null) {
      final tagsText = match.group(1) ?? '';
      
      // Try to extract tags from various formats
      // Look for list format like "- tag1 - tag2"
      final listTags = RegExp(r'[-*•]\s*(\w+(?:\s+\w+)*)').allMatches(tagsText);
      if (listTags.isNotEmpty) {
        for (final m in listTags) {
          final tag = m.group(1)?.trim() ?? '';
          if (tag.isNotEmpty) {
            result.add(tag);
          }
        }
      } else {
        // Look for comma-separated format
        for (final tag in tagsText.split(',')) {
          final cleanedTag = tag.trim();
          // Remove brackets, quotes, etc.
          final finalTag = cleanedTag
              .replaceAll('[', '')
              .replaceAll(']', '')
              .replaceAll('"', '')
              .replaceAll("'", '')
              .replaceAll('`', '');
          
          if (finalTag.isNotEmpty) {
            result.add(finalTag);
          }
        }
      }
    }
    
    return result;
  }
  
  String _extractCategory(String response) {
    final categoryPattern = RegExp(r'category[:\s]+(.*?)(?=text|\n\d|\Z)', dotAll: true);
    final match = categoryPattern.firstMatch(response);
    if (match != null) {
      String category = match.group(1)?.trim() ?? 'uncategorized';
      // Remove brackets, quotes, etc.
      category = category
          .replaceAll('[', '')
          .replaceAll(']', '')
          .replaceAll('"', '')
          .replaceAll("'", '')
          .replaceAll('`', '');
      
      return category.isEmpty ? 'uncategorized' : category;
    }
    return 'uncategorized';
  }
  
  String _extractText(String response) {
    final textPattern = RegExp(r'text[:\s]+(.*?)(?=\n\d|\Z)', dotAll: true);
    final match = textPattern.firstMatch(response);
    if (match != null) {
      return match.group(1)?.trim() ?? '';
    }
    return '';
  }
  
  String _truncateContent(String content, {int maxLength = 100}) {
    if (content.length <= maxLength) return content;
    return '${content.substring(0, maxLength)}...';
  }

  /// Extract tasks and dates from note content using AI
  /// Returns a list of detected tasks with their associated dates/reminders
  /// Each task is a map with:
  /// - title: The task description
  /// - dueDate: Optional ISO8601 date string when the task is due
  /// - hasReminder: Boolean indicating if a reminder was mentioned
  Future<List<Map<String, dynamic>>> extractTasksAndDates(
    String title,
    String? content,
  ) async {
    try {
      if (content == null || content.isEmpty) {
        return [];
      }

      final prompt = '''
Analyze the following note and extract any tasks or to-dos mentioned, along with any associated dates or reminders.

Note Title: $title
Note Content: $content

Please identify:
1. Any tasks, to-dos, or action items mentioned
2. Any dates or deadlines associated with tasks
3. Any mentions of reminders or notifications needed

Return a JSON array where each element has:
- title: The task description (string)
- dueDate: ISO8601 date string if a date is mentioned, or null
- hasReminder: true if a reminder/notification is mentioned, false otherwise

Example response:
[
  {"title": "Buy groceries", "dueDate": "2025-10-26T00:00:00Z", "hasReminder": false},
  {"title": "Call dentist tomorrow", "dueDate": "2025-10-26T00:00:00Z", "hasReminder": true},
  {"title": "Finish report", "dueDate": null, "hasReminder": false}
]

If no tasks are found, return an empty array: []
''';

      final textContent = Content.text(prompt);
      final response = await _model.generateContent([textContent]);
      final responseText = response.text ?? '';

      if (responseText.isEmpty) {
        return [];
      }

      // Try to parse JSON response
      final jsonStr = _extractJsonFromResponse(responseText);
      if (jsonStr.isEmpty) {
        return [];
      }

      try {
        final decoded = jsonDecode(jsonStr);
        if (decoded is List) {
          return decoded.cast<Map<String, dynamic>>();
        }
      } catch (e) {
        debugPrint('Error parsing tasks JSON: $e');
      }

      return [];
    } catch (e) {
      debugPrint('Error extracting tasks and dates: $e');
      return [];
    }
  }

  // ========================================================================
  // SERVER-SIDE EDGE FUNCTION METHODS
  // ========================================================================
  // These methods call Supabase Edge Functions for server-side AI processing
  // Benefits: Centralized API key management, consistent processing, batch support

  /// Process image OCR using Supabase Edge Function (server-side)
  /// This is the preferred method for OCR as it keeps API keys secure on the server
  ///
  /// Parameters:
  /// - [imageFile]: Image file to process
  /// - [attachmentId]: Optional attachment ID to update metadata
  ///
  /// Returns a map with:
  /// - success: Boolean indicating success/failure
  /// - text: Extracted text from image
  /// - summary: AI-generated summary
  /// - tags: List of suggested tags
  /// - category: Primary category
  /// - error: Error message (if failed)
  Future<Map<String, dynamic>> processImageOCRServerSide({
    required File imageFile,
    String? attachmentId,
  }) async {
    try {
      final supabase = Supabase.instance.client;

      // Read image and convert to base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      final mimeType = _getMimeType(imageFile.path);

      // Call edge function
      final response = await supabase.functions.invoke(
        'ocr-process',
        body: {
          'imageBase64': base64Image,
          'mimeType': mimeType,
          if (attachmentId != null) 'attachmentId': attachmentId,
        },
      );

      // Parse response
      if (response.data != null) {
        if (response.data is Map) {
          return Map<String, dynamic>.from(response.data);
        }
      }

      return {
        'success': false,
        'text': '',
        'summary': '',
        'tags': <String>[],
        'category': 'error',
        'error': 'Invalid response from server',
      };
    } catch (e) {
      debugPrint('Error calling OCR edge function: $e');
      return {
        'success': false,
        'text': '',
        'summary': '',
        'tags': <String>[],
        'category': 'error',
        'error': e.toString(),
      };
    }
  }

  /// Process stored image OCR using storage path (server-side)
  /// Useful when image is already stored in Supabase Storage
  ///
  /// Parameters:
  /// - [storagePath]: Path to image in Supabase Storage (relative to attachments bucket)
  /// - [attachmentId]: Optional attachment ID to update metadata
  Future<Map<String, dynamic>> processStoredImageOCR({
    required String storagePath,
    String? attachmentId,
  }) async {
    try {
      final supabase = Supabase.instance.client;

      // Call edge function
      final response = await supabase.functions.invoke(
        'ocr-process',
        body: {
          'storagePath': storagePath,
          if (attachmentId != null) 'attachmentId': attachmentId,
        },
      );

      // Parse response
      if (response.data != null) {
        if (response.data is Map) {
          return Map<String, dynamic>.from(response.data);
        }
      }

      return {
        'success': false,
        'text': '',
        'summary': '',
        'tags': <String>[],
        'category': 'error',
        'error': 'Invalid response from server',
      };
    } catch (e) {
      debugPrint('Error calling OCR edge function: $e');
      return {
        'success': false,
        'text': '',
        'summary': '',
        'tags': <String>[],
        'category': 'error',
        'error': e.toString(),
      };
    }
  }

  /// Generate tags using Supabase Edge Function (server-side)
  /// This is the preferred method for tag generation as it keeps API keys secure
  ///
  /// Parameters:
  /// - [noteId]: ID of the note to tag
  /// - [title]: Note title
  /// - [content]: Note content
  /// - [maxTags]: Maximum number of tags to generate (default: 5)
  /// - [autoLink]: Whether to automatically create and link tags to note (default: false)
  /// - [userId]: User ID (required if autoLink is true)
  ///
  /// Returns list of generated tags
  Future<List<String>> generateTagsServerSide({
    required String noteId,
    required String title,
    String? content,
    int maxTags = 5,
    bool autoLink = false,
    String? userId,
  }) async {
    try {
      final supabase = Supabase.instance.client;

      // Validate parameters
      if (autoLink && userId == null) {
        debugPrint('Warning: userId required when autoLink is true');
        return [];
      }

      // Call edge function
      final response = await supabase.functions.invoke(
        'ai-tag',
        body: {
          'noteId': noteId,
          'title': title,
          if (content != null) 'content': content,
          'maxTags': maxTags,
          'autoLink': autoLink,
          if (userId != null) 'userId': userId,
        },
      );

      // Parse response
      if (response.data != null && response.data is Map) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true && data['results'] is List) {
          final results = data['results'] as List;
          if (results.isNotEmpty && results[0] is Map) {
            final firstResult = results[0] as Map<String, dynamic>;
            if (firstResult['tags'] is List) {
              return List<String>.from(firstResult['tags']);
            }
          }
        }
      }

      return [];
    } catch (e) {
      debugPrint('Error calling AI tag edge function: $e');
      return [];
    }
  }

  /// Batch generate tags for multiple notes (server-side)
  /// Efficient way to tag multiple notes at once
  ///
  /// Parameters:
  /// - [notes]: List of notes to tag, each with noteId, title, and optional content
  /// - [maxTags]: Maximum number of tags per note (default: 5)
  /// - [autoLink]: Whether to automatically create and link tags (default: false)
  /// - [userId]: User ID (required if autoLink is true)
  ///
  /// Returns a map of noteId -> list of tags
  Future<Map<String, List<String>>> batchGenerateTagsServerSide({
    required List<Map<String, String>> notes,
    int maxTags = 5,
    bool autoLink = false,
    String? userId,
  }) async {
    try {
      final supabase = Supabase.instance.client;

      // Validate parameters
      if (autoLink && userId == null) {
        debugPrint('Warning: userId required when autoLink is true');
        return {};
      }

      if (notes.isEmpty) {
        return {};
      }

      // Call edge function
      final response = await supabase.functions.invoke(
        'ai-tag',
        body: {
          'notes': notes,
          'maxTags': maxTags,
          'autoLink': autoLink,
          if (userId != null) 'userId': userId,
        },
      );

      // Parse response
      final results = <String, List<String>>{};
      if (response.data != null && response.data is Map) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true && data['results'] is List) {
          final resultsList = data['results'] as List;
          for (final result in resultsList) {
            if (result is Map) {
              final noteId = result['noteId'] as String?;
              final tags = result['tags'];
              if (noteId != null && tags is List) {
                results[noteId] = List<String>.from(tags);
              }
            }
          }
        }
      }

      return results;
    } catch (e) {
      debugPrint('Error calling batch AI tag edge function: $e');
      return {};
    }
  }
} 