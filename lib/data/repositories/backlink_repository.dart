import 'package:ai_organizer/data/database/app_database.dart' as db;
import 'package:ai_organizer/data/models/note.dart' as model;
import 'package:ai_organizer/utils/backlink_parser.dart';

/// Repository for managing note backlinks
class BacklinkRepository {
  BacklinkRepository(this._database);
  final db.AppDatabase _database;

  /// Get all outgoing backlinks from a note
  Future<List<db.Backlink>> getOutgoingBacklinks(String noteId) async {
    return await _database.getOutgoingBacklinks(noteId);
  }

  /// Get all incoming backlinks to a note
  Future<List<db.Backlink>> getIncomingBacklinks(String noteId) async {
    return await _database.getIncomingBacklinks(noteId);
  }

  /// Get backlink count for a note (incoming + outgoing)
  Future<int> getBacklinkCount(String noteId) async {
    return await _database.getBacklinkCount(noteId);
  }

  /// Get incoming backlink count
  Future<int> getIncomingBacklinkCount(String noteId) async {
    final incoming = await getIncomingBacklinks(noteId);
    return incoming.length;
  }

  /// Get outgoing backlink count
  Future<int> getOutgoingBacklinkCount(String noteId) async {
    final outgoing = await getOutgoingBacklinks(noteId);
    return outgoing.length;
  }

  /// Get all notes that link to this note (with full note data)
  Future<List<model.Note>> getNotesLinkingTo(String noteId) async {
    final backlinks = await getIncomingBacklinks(noteId);
    final sourceNoteIds = backlinks.map((bl) => bl.sourceNoteId).toSet();

    final notes = <model.Note>[];
    for (final sourceId in sourceNoteIds) {
      final dbNote = await _database.getNoteById(sourceId);
      if (dbNote != null) {
        final tags = await _database.getTagsForNote(dbNote.id);
        final attachments = await _database.getAttachmentsForNote(dbNote.id);

        notes.add(model.Note(
          id: dbNote.id,
          title: dbNote.title,
          content: dbNote.content,
          createdAt: dbNote.createdAt,
          updatedAt: dbNote.updatedAt,
          tags: tags.map((tag) => tag.name).toList(),
          attachments: attachments.map((att) => att.filePath).toList(),
          isPinned: dbNote.isPinned,
          isArchived: dbNote.isArchived,
          isFavorite: dbNote.isFavorite,
          folderId: dbNote.folderId,
          color: dbNote.color,
        ));
      }
    }

    return notes;
  }

  /// Get all notes linked from this note (with full note data)
  Future<List<model.Note>> getNotesLinkedFrom(String noteId) async {
    final backlinks = await getOutgoingBacklinks(noteId);
    final targetNoteIds = backlinks.map((bl) => bl.targetNoteId).toSet();

    final notes = <model.Note>[];
    for (final targetId in targetNoteIds) {
      final dbNote = await _database.getNoteById(targetId);
      if (dbNote != null) {
        final tags = await _database.getTagsForNote(dbNote.id);
        final attachments = await _database.getAttachmentsForNote(dbNote.id);

        notes.add(model.Note(
          id: dbNote.id,
          title: dbNote.title,
          content: dbNote.content,
          createdAt: dbNote.createdAt,
          updatedAt: dbNote.updatedAt,
          tags: tags.map((tag) => tag.name).toList(),
          attachments: attachments.map((att) => att.filePath).toList(),
          isPinned: dbNote.isPinned,
          isArchived: dbNote.isArchived,
          isFavorite: dbNote.isFavorite,
          folderId: dbNote.folderId,
          color: dbNote.color,
        ));
      }
    }

    return notes;
  }

  /// Parse note content and update backlinks
  /// This should be called whenever a note is saved or updated
  Future<void> updateBacklinksForNote({
    required String noteId,
    required String content,
  }) async {
    // Parse backlinks from content
    final backlinkMatches = BacklinkParser.parseBacklinks(content);

    // Find matching notes by title or ID
    final newBacklinks = <Map<String, String>>[];

    for (final match in backlinkMatches) {
      // Try to find note by ID first
      db.Note? targetNote = await _database.getNoteById(match.targetId);

      // If not found, search by title
      if (targetNote == null) {
        final allNotes = await _database.getAllNotes();
        try {
          targetNote = allNotes.firstWhere(
            (note) => note.title.toLowerCase() == match.targetId.toLowerCase(),
          );
        } catch (_) {
          // If exact match not found, try contains
          try {
            targetNote = allNotes.firstWhere(
              (note) => note.title.toLowerCase().contains(match.targetId.toLowerCase()),
            );
          } catch (_) {
            // No match found
            targetNote = null;
          }
        }
      }

      // If valid target found, add to backlinks
      if (targetNote != null && targetNote.id.isNotEmpty) {
        newBacklinks.add({
          'targetNoteId': targetNote.id,
          'targetText': match.displayText,
        });
      }
    }

    // Update backlinks in database
    await _database.updateBacklinksForNote(
      sourceNoteId: noteId,
      newBacklinks: newBacklinks,
    );
  }

  /// Delete all backlinks related to a note
  Future<void> deleteBacklinksForNote(String noteId) async {
    // Delete outgoing backlinks
    await _database.deleteBacklinksFromSource(noteId);

    // Delete incoming backlinks
    await _database.deleteBacklinksToTarget(noteId);
  }

  /// Get backlink graph data for visualization
  /// Returns a map of note relationships
  Future<Map<String, List<String>>> getBacklinkGraph() async {
    final graph = <String, List<String>>{};
    final allNotes = await _database.getAllNotes();

    for (final note in allNotes) {
      final outgoing = await getOutgoingBacklinks(note.id);
      graph[note.id] = outgoing.map((bl) => bl.targetNoteId).toList();
    }

    return graph;
  }

  /// Find orphaned notes (notes with no backlinks in or out)
  Future<List<model.Note>> getOrphanedNotes() async {
    final dbNotes = await _database.getAllNotes();
    final orphaned = <model.Note>[];

    for (final dbNote in dbNotes) {
      final count = await getBacklinkCount(dbNote.id);
      if (count == 0) {
        final tags = await _database.getTagsForNote(dbNote.id);
        final attachments = await _database.getAttachmentsForNote(dbNote.id);

        orphaned.add(model.Note(
          id: dbNote.id,
          title: dbNote.title,
          content: dbNote.content,
          createdAt: dbNote.createdAt,
          updatedAt: dbNote.updatedAt,
          tags: tags.map((tag) => tag.name).toList(),
          attachments: attachments.map((att) => att.filePath).toList(),
          isPinned: dbNote.isPinned,
          isArchived: dbNote.isArchived,
          isFavorite: dbNote.isFavorite,
          folderId: dbNote.folderId,
          color: dbNote.color,
        ));
      }
    }

    return orphaned;
  }

  /// Find hub notes (notes with many backlinks)
  Future<List<Map<String, dynamic>>> getHubNotes({int minBacklinks = 3}) async {
    final dbNotes = await _database.getAllNotes();
    final hubs = <Map<String, dynamic>>[];

    for (final dbNote in dbNotes) {
      final incomingCount = await getIncomingBacklinkCount(dbNote.id);
      if (incomingCount >= minBacklinks) {
        final tags = await _database.getTagsForNote(dbNote.id);
        final attachments = await _database.getAttachmentsForNote(dbNote.id);

        final modelNote = model.Note(
          id: dbNote.id,
          title: dbNote.title,
          content: dbNote.content,
          createdAt: dbNote.createdAt,
          updatedAt: dbNote.updatedAt,
          tags: tags.map((tag) => tag.name).toList(),
          attachments: attachments.map((att) => att.filePath).toList(),
          isPinned: dbNote.isPinned,
          isArchived: dbNote.isArchived,
          isFavorite: dbNote.isFavorite,
          folderId: dbNote.folderId,
          color: dbNote.color,
        );

        hubs.add({
          'note': modelNote,
          'backlinkCount': incomingCount,
        });
      }
    }

    // Sort by backlink count descending
    hubs.sort((a, b) => (b['backlinkCount'] as int).compareTo(a['backlinkCount'] as int));

    return hubs;
  }
}
