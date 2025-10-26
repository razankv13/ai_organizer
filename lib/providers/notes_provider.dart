import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_organizer/data/models/note.dart';
import 'package:ai_organizer/data/repositories/note_repository.dart';
import 'package:ai_organizer/providers/database_provider.dart';
import 'package:ai_organizer/providers/sync_provider.dart';
import 'package:ai_organizer/providers/ai_provider.dart';

/// Notes state management

/// All notes provider
final notesProvider = FutureProvider<List<Note>>((ref) async {
  final repository = ref.watch(noteRepositoryProvider);
  return await repository.getAllNotes();
});

/// Recent notes provider (for home screen)
final recentNotesProvider = FutureProvider<List<Note>>((ref) async {
  final repository = ref.watch(noteRepositoryProvider);
  return await repository.getRecentNotes(limit: 5);
});

/// Pinned notes provider
final pinnedNotesProvider = FutureProvider<List<Note>>((ref) async {
  final repository = ref.watch(noteRepositoryProvider);
  return await repository.getPinnedNotes();
});

/// Favorite notes provider
final favoriteNotesProvider = FutureProvider<List<Note>>((ref) async {
  final repository = ref.watch(noteRepositoryProvider);
  return await repository.getFavoriteNotes();
});

/// Archived notes provider
final archivedNotesProvider = FutureProvider<List<Note>>((ref) async {
  final repository = ref.watch(noteRepositoryProvider);
  return await repository.getArchivedNotes();
});

/// Notes by folder provider
final notesByFolderProvider = FutureProvider.family<List<Note>, String?>((ref, folderId) async {
  final repository = ref.watch(noteRepositoryProvider);
  return await repository.getNotesByFolder(folderId);
});

/// Note by ID provider
final noteByIdProvider = FutureProvider.family<Note?, String>((ref, noteId) async {
  final repository = ref.watch(noteRepositoryProvider);
  return await repository.getNoteById(noteId);
});

/// Search notes provider
final searchNotesProvider = FutureProvider.family<List<Note>, String>((ref, query) async {
  final repository = ref.watch(noteRepositoryProvider);
  if (query.isEmpty) {
    return await repository.getAllNotes();
  }
  return await repository.searchNotes(query);
});

/// Related notes provider - uses AI to find semantically similar notes
final relatedNotesForNoteProvider = FutureProvider.family<List<Note>, String>((ref, noteId) async {
  // First get the current note
  final noteRepository = ref.watch(noteRepositoryProvider);
  final note = await noteRepository.getNoteById(noteId);
  if (note == null) return [];
  
  // Get all notes and prepare them for AI analysis
  final allNotes = await noteRepository.getAllNotes();
  final notesForAI = allNotes
      .where((n) => n.id != noteId) // Exclude current note
      .map((n) => {'id': n.id, 'title': n.title, 'content': n.content})
      .toList();
  
  // Use AI to find related notes
  final aiService = ref.watch(aiServiceProvider);
  final relatedIds = await aiService.findRelatedNotes(note.content, notesForAI);
  
  // Return the related notes
  return await noteRepository.findRelatedNotes(noteId: noteId, relatedIds: relatedIds);
});

/// Advanced search provider - combines AI natural language search with regular search
final advancedSearchProvider = FutureProvider.family<List<Note>, String>((ref, query) async {
  if (query.isEmpty) {
    return [];
  }
  
  // First get all notes
  final noteRepository = ref.watch(noteRepositoryProvider);
  final allNotes = await noteRepository.getAllNotes();
  
  // If query is simple, use regular search
  if (query.length < 3 || _isSimpleQuery(query)) {
    return await noteRepository.searchNotes(query);
  }
  
  // Prepare notes for AI analysis
  final notesForAI = allNotes
      .map((note) => {'id': note.id, 'title': note.title, 'content': note.content})
      .toList();
  
  // Get AI relevance scores
  final relevanceScores = await ref.watch(
    naturalLanguageSearchProvider((query, notesForAI)).future
  );
  
  if (relevanceScores.isEmpty) {
    // Fallback to regular search if AI search fails
    return await noteRepository.searchNotes(query);
  }
  
  // Sort notes by relevance score
  final result = <Note>[];
  for (final entry in relevanceScores.entries) {
    final noteId = entry.key;
    final matchingNotes = allNotes.where((note) => note.id == noteId);
    if (matchingNotes.isNotEmpty) {
      result.add(matchingNotes.first);
    }
  }
  
  // If AI search returned no results, fallback to regular search
  if (result.isEmpty) {
    return await noteRepository.searchNotes(query);
  }
  
  return result;
});

/// Helper to determine if a query is simple (just keywords) or complex (natural language)
bool _isSimpleQuery(String query) {
  // Check if query contains special characters that might indicate natural language
  final containsSpecialChars = RegExp(r'[?,.]').hasMatch(query);
  
  // Check if query has common natural language phrases
  final naturalLanguagePhrases = [
    'find', 'show', 'where', 'when', 'what', 'how', 'why',
    'about', 'related', 'similar', 'containing', 'today',
    'yesterday', 'week', 'month', 'from', 'with', 'without'
  ];
  
  final words = query.toLowerCase().split(' ');
  final hasNaturalLanguage = words.any((word) => 
    naturalLanguagePhrases.contains(word)
  );
  
  return !containsSpecialChars && !hasNaturalLanguage;
}

/// Note statistics provider
final noteStatisticsProvider = FutureProvider<Map<String, int>>((ref) async {
  final repository = ref.watch(noteRepositoryProvider);
  return await repository.getNoteStatistics();
});

/// Notes actions - for mutations
class NotesActions {

  NotesActions(this._repository, this._syncActions, this._ref);
  final NoteRepository _repository;
  final SyncActions _syncActions;
  final Ref _ref;

  /// Create a new note
  Future<Note> createNote({
    required String title,
    required String content,
    List<String>? tags,
    String? folderId,
    String? color,
  }) async {
    // Create note locally
    final note = await _repository.createNote(
      title: title,
      content: content,
      tags: tags,
      folderId: folderId,
      color: color,
    );
    
    // Sync to cloud if online
    if (await _syncActions.isOnline()) {
      try {
        await _syncActions.syncToServer();
      } catch (e) {
        // If sync fails, we still have the note locally
        // Could show a message to the user here
      }
    }
    
    // Invalidate providers to refresh UI
    _invalidateNoteProviders();
    
    return note;
  }

  /// Update an existing note
  Future<bool> updateNote(Note note) async {
    final result = await _repository.updateNote(note);
    
    // Sync to cloud if online
    if (result && await _syncActions.isOnline()) {
      try {
        await _syncActions.syncToServer();
      } catch (e) {
        // If sync fails, we still have updated the note locally
      }
    }
    
    // Invalidate providers to refresh UI
    _invalidateNoteProviders();
    
    return result;
  }

  /// Delete a note
  Future<bool> deleteNote(String noteId) async {
    final result = await _repository.deleteNote(noteId);
    
    // Delete from cloud if online
    if (result && await _syncActions.isOnline()) {
      try {
        await _syncActions.deleteNote(noteId);
      } catch (e) {
        // If cloud delete fails, we still deleted locally
      }
    }
    
    // Invalidate providers to refresh UI
    _invalidateNoteProviders();
    
    return result;
  }

  /// Toggle pin status
  Future<bool> togglePinNote(String noteId) async {
    final result = await _repository.togglePinNote(noteId);
    
    // Sync to cloud if online
    if (result && await _syncActions.isOnline()) {
      try {
        await _syncActions.syncToServer();
      } catch (e) {
        // If sync fails, we still have updated the note locally
      }
    }
    
    // Invalidate providers to refresh UI
    _invalidateNoteProviders();
    
    return result;
  }

  /// Toggle favorite status
  Future<bool> toggleFavoriteNote(String noteId) async {
    final result = await _repository.toggleFavoriteNote(noteId);
    
    // Sync to cloud if online
    if (result && await _syncActions.isOnline()) {
      try {
        await _syncActions.syncToServer();
      } catch (e) {
        // If sync fails, we still have updated the note locally
      }
    }
    
    // Invalidate providers to refresh UI
    _invalidateNoteProviders();
    
    return result;
  }

  /// Toggle archive status
  Future<bool> toggleArchiveNote(String noteId) async {
    final result = await _repository.toggleArchiveNote(noteId);
    
    // Sync to cloud if online
    if (result && await _syncActions.isOnline()) {
      try {
        await _syncActions.syncToServer();
      } catch (e) {
        // If sync fails, we still have updated the note locally
      }
    }
    
    // Invalidate providers to refresh UI
    _invalidateNoteProviders();
    
    return result;
  }

  /// Synchronize notes with cloud
  Future<void> syncNotes() async {
    if (await _syncActions.isOnline()) {
      await _syncActions.syncToServer();
      await _syncActions.syncFromServer();
      
      // Invalidate providers to refresh UI
      _invalidateNoteProviders();
    }
  }

  /// Invalidate all note-related providers
  void _invalidateNoteProviders() {
    _ref.invalidate(notesProvider);
    _ref.invalidate(recentNotesProvider);
    _ref.invalidate(pinnedNotesProvider);
    _ref.invalidate(favoriteNotesProvider);
    _ref.invalidate(archivedNotesProvider);
    // Also invalidate the related notes provider
    // No need to invalidate with specific parameters as all will be refreshed
    _ref.invalidate(noteStatisticsProvider);
    // Note: family providers like noteByIdProvider, searchNotesProvider, and relatedNotesForNoteProvider
    // will be invalidated automatically when their dependencies change
  }
}

/// Notes actions provider
final notesActionsProvider = Provider<NotesActions>((ref) {
  final repository = ref.watch(noteRepositoryProvider);
  final syncActions = ref.watch(syncActionsProvider);
  return NotesActions(repository, syncActions, ref);
}); 