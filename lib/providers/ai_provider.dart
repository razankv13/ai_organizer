import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_organizer/services/ai_service.dart';

/// Provider for the AI service
final aiServiceProvider = Provider<AIService>((ref) {
  return AIService();
});

/// Provider for image analysis results - family provider that takes a file path
final imageAnalysisProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, imagePath) async {
  final aiService = ref.watch(aiServiceProvider);
  return await aiService.analyzeImage(File(imagePath));
});

/// Provider for tag suggestions - family provider that takes content text
final tagSuggestionsProvider = FutureProvider.family<List<String>, String>((ref, content) async {
  final aiService = ref.watch(aiServiceProvider);
  return await aiService.suggestTags(content);
});

/// Provider for related notes - family provider that takes note content and all notes
final relatedNotesProvider = FutureProvider.family<List<String>, (String, List<Map<String, dynamic>>)>((ref, params) async {
  final (noteContent, allNotes) = params;
  final aiService = ref.watch(aiServiceProvider);
  return await aiService.findRelatedNotes(noteContent, allNotes);
});

/// Provider for natural language search - family provider that takes a search query and all notes
final naturalLanguageSearchProvider = FutureProvider.family<Map<String, int>, (String, List<Map<String, dynamic>>)>((ref, params) async {
  final (query, allNotes) = params;
  final aiService = ref.watch(aiServiceProvider);
  return await aiService.naturalLanguageSearch(query, allNotes);
});

/// Provider for OCR text extraction - family provider that takes an image file path
final ocrTextExtractionProvider = FutureProvider.family<String, String>((ref, imagePath) async {
  final aiService = ref.watch(aiServiceProvider);
  return await aiService.extractTextFromImage(File(imagePath));
}); 