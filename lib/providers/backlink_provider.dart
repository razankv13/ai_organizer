import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_organizer/data/models/note.dart' as model;
import 'package:ai_organizer/data/database/app_database.dart';
import 'package:ai_organizer/data/repositories/backlink_repository.dart';
import 'package:ai_organizer/providers/database_provider.dart';

/// Backlinks state management

/// Get incoming backlinks for a note (notes that link to this note)
final incomingBacklinksProvider = FutureProvider.family<List<model.Note>, String>((ref, noteId) async {
  final repository = ref.watch(backlinkRepositoryProvider);
  return await repository.getNotesLinkingTo(noteId);
});

/// Get outgoing backlinks for a note (notes this note links to)
final outgoingBacklinksProvider = FutureProvider.family<List<model.Note>, String>((ref, noteId) async {
  final repository = ref.watch(backlinkRepositoryProvider);
  return await repository.getNotesLinkedFrom(noteId);
});

/// Get incoming backlink count for a note
final incomingBacklinkCountProvider = FutureProvider.family<int, String>((ref, noteId) async {
  final repository = ref.watch(backlinkRepositoryProvider);
  return await repository.getIncomingBacklinkCount(noteId);
});

/// Get outgoing backlink count for a note
final outgoingBacklinkCountProvider = FutureProvider.family<int, String>((ref, noteId) async {
  final repository = ref.watch(backlinkRepositoryProvider);
  return await repository.getOutgoingBacklinkCount(noteId);
});

/// Get total backlink count for a note
final backlinkCountProvider = FutureProvider.family<int, String>((ref, noteId) async {
  final repository = ref.watch(backlinkRepositoryProvider);
  return await repository.getBacklinkCount(noteId);
});

/// Get incoming backlink objects (with metadata)
final incomingBacklinkObjectsProvider = FutureProvider.family<List<Backlink>, String>((ref, noteId) async {
  final repository = ref.watch(backlinkRepositoryProvider);
  return await repository.getIncomingBacklinks(noteId);
});

/// Get outgoing backlink objects (with metadata)
final outgoingBacklinkObjectsProvider = FutureProvider.family<List<Backlink>, String>((ref, noteId) async {
  final repository = ref.watch(backlinkRepositoryProvider);
  return await repository.getOutgoingBacklinks(noteId);
});

/// Get backlink graph (all note relationships)
final backlinkGraphProvider = FutureProvider<Map<String, List<String>>>((ref) async {
  final repository = ref.watch(backlinkRepositoryProvider);
  return await repository.getBacklinkGraph();
});

/// Get orphaned notes (notes with no backlinks)
final orphanedNotesProvider = FutureProvider<List<model.Note>>((ref) async {
  final repository = ref.watch(backlinkRepositoryProvider);
  return await repository.getOrphanedNotes();
});

/// Get hub notes (notes with many backlinks)
final hubNotesProvider = FutureProvider.family<List<Map<String, dynamic>>, int>((ref, minBacklinks) async {
  final repository = ref.watch(backlinkRepositoryProvider);
  return await repository.getHubNotes(minBacklinks: minBacklinks);
});

/// Backlink actions provider for mutations
class BacklinkActions {
  BacklinkActions(this._repository, this._ref);
  final BacklinkRepository _repository;
  final Ref _ref;

  /// Manually update backlinks for a note
  /// (This is usually called automatically by note save/update)
  Future<void> updateBacklinksForNote({
    required String noteId,
    required String content,
  }) async {
    await _repository.updateBacklinksForNote(
      noteId: noteId,
      content: content,
    );

    // Invalidate all backlink providers
    _invalidateBacklinkProviders(noteId);
  }

  /// Delete all backlinks for a note
  Future<void> deleteBacklinksForNote(String noteId) async {
    await _repository.deleteBacklinksForNote(noteId);
    _invalidateBacklinkProviders(noteId);
  }

  /// Refresh backlinks for a note
  /// Useful after external changes or manual corrections
  Future<void> refreshBacklinks(String noteId) async {
    _invalidateBacklinkProviders(noteId);
  }

  /// Invalidate all backlink-related providers
  void _invalidateBacklinkProviders(String noteId) {
    _ref.invalidate(incomingBacklinksProvider);
    _ref.invalidate(outgoingBacklinksProvider);
    _ref.invalidate(incomingBacklinkCountProvider);
    _ref.invalidate(outgoingBacklinkCountProvider);
    _ref.invalidate(backlinkCountProvider);
    _ref.invalidate(incomingBacklinkObjectsProvider);
    _ref.invalidate(outgoingBacklinkObjectsProvider);
    _ref.invalidate(backlinkGraphProvider);
    _ref.invalidate(orphanedNotesProvider);
    _ref.invalidate(hubNotesProvider);
  }
}

/// Backlink actions provider
final backlinkActionsProvider = Provider<BacklinkActions>((ref) {
  final repository = ref.watch(backlinkRepositoryProvider);
  return BacklinkActions(repository, ref);
});
