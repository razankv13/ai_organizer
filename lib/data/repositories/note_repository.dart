import 'package:ai_organizer/data/database/app_database.dart' hide Note, Tag;
import 'package:ai_organizer/data/models/note.dart' as model;
import 'package:ai_organizer/data/models/tag.dart' as model;
import 'package:ai_organizer/data/models/attachment.dart' as model;
import 'package:ai_organizer/data/repositories/backlink_repository.dart';

/// Repository for note operations
class NoteRepository {

  NoteRepository(this._database, this._backlinkRepository);
  final AppDatabase _database;
  final BacklinkRepository _backlinkRepository;

  // ===== NOTES OPERATIONS =====

  /// Get all notes
  Future<List<model.Note>> getAllNotes() async {
    final dbNotes = await _database.getAllNotes();
    final notes = <model.Note>[];
    
    for (final dbNote in dbNotes) {
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
    
    return notes;
  }

  /// Get note by ID
  Future<model.Note?> getNoteById(String id) async {
    final dbNote = await _database.getNoteById(id);
    if (dbNote == null) return null;

    final tags = await _database.getTagsForNote(id);
    final attachments = await _database.getAttachmentsForNote(id);

    return model.Note(
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
  }

  /// Create a new note
  Future<model.Note> createNote({
    required String title,
    required String content,
    List<String>? tags,
    String? folderId,
    String? color,
  }) async {
    final note = model.Note.create(
      title: title,
      content: content,
      tags: tags,
      folderId: folderId,
      color: color,
    );

    await _database.insertNote(note);

    // Index backlinks in the note content
    await _backlinkRepository.updateBacklinksForNote(
      noteId: note.id,
      content: content,
    );

    return note;
  }

  /// Update an existing note
  Future<bool> updateNote(model.Note note) async {
    final result = await _database.updateNote(note);

    if (result) {
      // Reindex backlinks in the note content
      await _backlinkRepository.updateBacklinksForNote(
        noteId: note.id,
        content: note.content,
      );
    }

    return result;
  }

  /// Delete a note
  Future<bool> deleteNote(String id) async {
    // Clean up backlinks (cascade delete will handle this in DB, but good to be explicit)
    await _backlinkRepository.deleteBacklinksForNote(id);

    return await _database.deleteNote(id);
  }

  /// Search notes
  Future<List<model.Note>> searchNotes(String query) async {
    final dbNotes = await _database.searchNotes(query);
    final notes = <model.Note>[];
    
    for (final dbNote in dbNotes) {
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
    
    return notes;
  }

  /// Get pinned notes
  Future<List<model.Note>> getPinnedNotes() async {
    final allNotes = await getAllNotes();
    return allNotes.where((note) => note.isPinned).toList();
  }

  /// Get favorite notes
  Future<List<model.Note>> getFavoriteNotes() async {
    final allNotes = await getAllNotes();
    return allNotes.where((note) => note.isFavorite).toList();
  }

  /// Get archived notes
  Future<List<model.Note>> getArchivedNotes() async {
    final allNotes = await getAllNotes();
    return allNotes.where((note) => note.isArchived).toList();
  }

  /// Get notes by folder ID
  Future<List<model.Note>> getNotesByFolder(String? folderId) async {
    final allNotes = await getAllNotes();
    return allNotes.where((note) => note.folderId == folderId).toList();
  }

  /// Pin/unpin a note
  Future<bool> togglePinNote(String id) async {
    final note = await getNoteById(id);
    if (note == null) return false;

    final updatedNote = note.updateContent(isPinned: !note.isPinned);
    return await updateNote(updatedNote);
  }

  /// Favorite/unfavorite a note
  Future<bool> toggleFavoriteNote(String id) async {
    final note = await getNoteById(id);
    if (note == null) return false;

    final updatedNote = note.updateContent(isFavorite: !note.isFavorite);
    return await updateNote(updatedNote);
  }

  /// Archive/unarchive a note
  Future<bool> toggleArchiveNote(String id) async {
    final note = await getNoteById(id);
    if (note == null) return false;

    final updatedNote = note.updateContent(isArchived: !note.isArchived);
    return await updateNote(updatedNote);
  }

  // ===== TAGS OPERATIONS =====

  /// Get all tags
  Future<List<model.Tag>> getAllTags() async {
    final dbTags = await _database.getAllTags();
    return dbTags.map((dbTag) => model.Tag(
      id: dbTag.id,
      name: dbTag.name,
      createdAt: dbTag.createdAt,
      color: dbTag.color,
      useCount: dbTag.useCount,
      description: dbTag.description,
    )).toList();
  }

  /// Get tags for a specific note
  Future<List<model.Tag>> getTagsForNote(String noteId) async {
    final dbTags = await _database.getTagsForNote(noteId);
    return dbTags.map((dbTag) => model.Tag(
      id: dbTag.id,
      name: dbTag.name,
      createdAt: dbTag.createdAt,
      color: dbTag.color,
      useCount: dbTag.useCount,
      description: dbTag.description,
    )).toList();
  }

  /// Create a new tag
  Future<model.Tag> createTag({
    required String name,
    String? color,
    String? description,
  }) async {
    final tag = model.Tag.create(
      name: name,
      color: color,
      description: description,
    );

    await _database.insertTag(tag);
    return tag;
  }

  // ===== ATTACHMENTS OPERATIONS =====

  /// Get attachments for a note
  Future<List<model.Attachment>> getAttachmentsForNote(String noteId) async {
    final dbAttachments = await _database.getAttachmentsForNote(noteId);
    return dbAttachments.map((dbAtt) => model.Attachment(
      id: dbAtt.id,
      noteId: dbAtt.noteId,
      fileName: dbAtt.fileName,
      filePath: dbAtt.filePath,
      type: _mapStringToAttachmentType(dbAtt.type.name),
      fileSize: dbAtt.fileSize,
      createdAt: dbAtt.createdAt,
      mimeType: dbAtt.mimeType,
      thumbnailPath: dbAtt.thumbnailPath,
      metadata: dbAtt.metadata != null 
          ? Map<String, dynamic>.from({}) // Would parse JSON here
          : null,
    )).toList();
  }

  /// Helper method to map string type to AttachmentType enum
  model.AttachmentType _mapStringToAttachmentType(String type) {
    try {
      return model.AttachmentType.values.firstWhere(
        (enumType) => enumType.name == type,
        orElse: () => model.AttachmentType.other,
      );
    } catch (e) {
      return model.AttachmentType.other;
    }
  }

  /// Add attachment to note
  Future<void> addAttachment(model.Attachment attachment) async {
    await _database.insertAttachment(attachment);
  }

  /// Update attachment (useful for updating metadata like OCR text)
  Future<bool> updateAttachment(model.Attachment attachment) async {
    return await _database.updateAttachment(attachment);
  }

  /// Remove attachment
  Future<bool> removeAttachment(String attachmentId) async {
    return await _database.deleteAttachment(attachmentId);
  }

  // ===== UTILITY OPERATIONS =====

  /// Get note statistics
  Future<Map<String, int>> getNoteStatistics() async {
    final allNotes = await getAllNotes();
    
    return {
      'total': allNotes.length,
      'pinned': allNotes.where((note) => note.isPinned).length,
      'favorites': allNotes.where((note) => note.isFavorite).length,
      'archived': allNotes.where((note) => note.isArchived).length,
    };
  }

  /// Get recent notes (last 10)
  Future<List<model.Note>> getRecentNotes({int limit = 10}) async {
    final allNotes = await getAllNotes();
    // Notes are already sorted by updatedAt in descending order
    return allNotes.take(limit).toList();
  }
  
  /// Find semantically related notes using AI service
  Future<List<model.Note>> findRelatedNotes({
    required String noteId,
    required List<String> relatedIds,
    int limit = 3,
  }) async {
    if (relatedIds.isEmpty) return [];
    
    final relatedNotes = <model.Note>[];
    
    for (final id in relatedIds) {
      if (id == noteId) continue; // Skip self
      
      final note = await getNoteById(id);
      if (note != null) {
        relatedNotes.add(note);
      }
      
      if (relatedNotes.length >= limit) break;
    }
    
    return relatedNotes;
  }
} 