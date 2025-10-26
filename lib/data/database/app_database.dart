import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:ai_organizer/data/models/attachment.dart';
import 'package:ai_organizer/data/models/cloud_storage_connection.dart';
import 'package:ai_organizer/data/models/task.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'package:ai_organizer/data/models/note.dart' as model;
import 'package:ai_organizer/data/models/tag.dart' as model;
import 'package:ai_organizer/data/models/attachment.dart' as model;
import 'package:ai_organizer/data/models/folder.dart' as model;
import 'package:ai_organizer/data/models/task.dart' as model;
import 'package:ai_organizer/data/models/cloud_storage_connection.dart' as model;
import 'package:ai_organizer/data/models/shared_note.dart' as model;
import 'package:ai_organizer/data/models/share_permission.dart';

part 'app_database.g.dart';

/// Presuming model.AttachmentType is an enum like:
/// enum AttachmentType { image, video, audio, document, link, other }
/// Ensure 'other' or a suitable default exists for the orElse clause.
class AttachmentTypeConverter extends TypeConverter<model.AttachmentType, String> {
  const AttachmentTypeConverter();

  @override
  model.AttachmentType fromSql(String fromDb) {
    return model.AttachmentType.values.firstWhere(
      (e) => e.name == fromDb,

      /// Update `model.AttachmentType.other` if your default enum value is different
      orElse: () => model.AttachmentType.values.firstWhere(
        (e) => e.name == 'other',
        orElse: () => model.AttachmentType.values.first,
      ),
    );
  }

  @override
  String toSql(model.AttachmentType value) {
    return value.name;
  }
}

class NullableMetadataConverter extends TypeConverter<Map<String, dynamic>?, String?> {
  const NullableMetadataConverter();

  @override
  Map<String, dynamic>? fromSql(String? fromDb) {
    if (fromDb == null || fromDb.isEmpty) return null;
    try {
      return json.decode(fromDb) as Map<String, dynamic>;
    } catch (e) {
      developer.log('Error decoding metadata from SQL: $e', name: 'AppDatabase');
      return null;
    }
  }

  @override
  String? toSql(Map<String, dynamic>? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return json.encode(value);
    } catch (e) {
      developer.log('Error encoding metadata to SQL: $e', name: 'AppDatabase');
      return null;
    }
  }
}

class CloudStorageProviderConverter extends TypeConverter<model.CloudStorageProvider, String> {
  const CloudStorageProviderConverter();

  @override
  model.CloudStorageProvider fromSql(String fromDb) {
    return model.CloudStorageProvider.values.firstWhere(
      (e) => e.name == fromDb || _getJsonValue(e) == fromDb,
      orElse: () => model.CloudStorageProvider.dropbox,
    );
  }

  @override
  String toSql(model.CloudStorageProvider value) {
    return _getJsonValue(value);
  }

  String _getJsonValue(model.CloudStorageProvider provider) {
    switch (provider) {
      case model.CloudStorageProvider.dropbox:
        return 'dropbox';
      case model.CloudStorageProvider.googleDrive:
        return 'google_drive';
    }
  }
}

/// Converter for SharePermission enum
class SharePermissionConverter extends TypeConverter<SharePermission, String> {
  const SharePermissionConverter();

  @override
  SharePermission fromSql(String fromDb) {
    return SharePermission.values.firstWhere(
      (e) => e.name == fromDb,
      orElse: () => SharePermission.view,
    );
  }

  @override
  String toSql(SharePermission value) {
    return value.name;
  }
}

/// Notes table definition
class Notes extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  TextColumn get folderId => text().nullable()();
  TextColumn get color => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Tags table definition
class Tags extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get color => text().withDefault(const Constant('#FF6B6B'))();
  IntColumn get useCount => integer().withDefault(const Constant(0))();
  TextColumn get description => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Attachments table definition
@UseRowClass(model.Attachment)
class Attachments extends Table {
  TextColumn get id => text()();
  TextColumn get noteId => text().nullable().references(Notes, #id, onDelete: KeyAction.cascade)();
  TextColumn get fileName => text()();
  TextColumn get filePath => text()();
  TextColumn get type => text().map(const AttachmentTypeConverter())();
  IntColumn get fileSize => integer()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get mimeType => text().nullable()();
  TextColumn get thumbnailPath => text().nullable()();
  TextColumn get metadata =>
      text().nullable().map(const NullableMetadataConverter())(); // JSON string

  @override
  Set<Column> get primaryKey => {id};
}

/// Folders table definition
class Folders extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get parentId => text().nullable()(); // null for root folders
  TextColumn get color => text().nullable()();
  TextColumn get icon => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Backlinks table for note-to-note references
class Backlinks extends Table {
  TextColumn get id => text()();
  TextColumn get sourceNoteId => text().references(Notes, #id, onDelete: KeyAction.cascade)();
  TextColumn get targetNoteId => text().references(Notes, #id, onDelete: KeyAction.cascade)();
  TextColumn get targetText => text()(); // The text/title used in the backlink
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Tasks table for managing to-do items within notes
@UseRowClass(model.Task)
class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get noteId => text().references(Notes, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get dueDate => dateTime().nullable()();
  DateTimeColumn get reminderDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get hasNotified => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Email settings table for managing user's email integration preferences
class EmailSettingsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get uniqueEmail => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get gmailConnected => boolean().withDefault(const Constant(false))();
  TextColumn get gmailEmail => text().nullable()();
  TextColumn get gmailRefreshToken => text().nullable()();
  DateTimeColumn get lastGmailSync => dateTime().nullable()();
  TextColumn get preferences => text().nullable().map(const NullableMetadataConverter())();

  @override
  Set<Column> get primaryKey => {id};
}

/// Calendar settings table for managing user's calendar integration preferences
class CalendarSettingsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  BoolColumn get isGoogleCalendarConnected => boolean().withDefault(const Constant(false))();
  TextColumn get googleAccountEmail => text().nullable()();
  TextColumn get googleCalendarId => text().nullable()();
  BoolColumn get syncTasksToCalendar => boolean().withDefault(const Constant(true))();
  BoolColumn get syncEventsToNotes => boolean().withDefault(const Constant(true))();
  IntColumn get syncIntervalMinutes => integer().withDefault(const Constant(30))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Cloud Storage Connections table for managing OAuth connections to cloud storage providers
@UseRowClass(model.CloudStorageConnection)
class CloudStorageConnections extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get provider => text().map(const CloudStorageProviderConverter())(); // 'dropbox' or 'google_drive'
  TextColumn get accessToken => text()();
  TextColumn get refreshToken => text().nullable()();
  DateTimeColumn get tokenExpiry => dateTime().nullable()();
  TextColumn get userEmail => text().nullable()();
  TextColumn get userName => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Shared Notes table for managing note sharing and permissions
@UseRowClass(model.SharedNote)
class SharedNotes extends Table {
  TextColumn get id => text()();
  TextColumn get noteId => text().references(Notes, #id, onDelete: KeyAction.cascade)();
  TextColumn get ownerId => text()(); // User ID of the note owner
  TextColumn get sharedWithEmail => text()(); // Email of the person the note is shared with
  TextColumn get sharedWithUserId => text().nullable()(); // User ID if recipient is registered
  TextColumn get permission => text().map(const SharePermissionConverter())(); // 'view' or 'edit'
  TextColumn get shareToken => text()(); // Unique token for link-based sharing
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get expiresAt => dateTime().nullable()(); // Optional expiration date
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Note-Tag junction table for many-to-many relationship
class NoteTags extends Table {
  TextColumn get noteId => text().references(Notes, #id, onDelete: KeyAction.cascade)();
  TextColumn get tagId => text().references(Tags, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {noteId, tagId};
}

/// Main database class
@DriftDatabase(
  tables: [
    Notes,
    Tags,
    Attachments,
    Folders,
    Backlinks,
    Tasks,
    EmailSettingsTable,
    CalendarSettingsTable,
    CloudStorageConnections,
    SharedNotes,
    NoteTags,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        // Add Tasks table in version 2
        await m.createTable(tasks);
      }
      if (from < 3) {
        // Add EmailSettingsTable in version 3
        await m.createTable(emailSettingsTable);
      }
      if (from < 4) {
        // Add CalendarSettingsTable in version 4
        await m.createTable(calendarSettingsTable);
      }
      if (from < 5) {
        // Add CloudStorageConnections in version 5
        await m.createTable(cloudStorageConnections);
      }
      if (from < 6) {
        // Add SharedNotes table in version 6
        await m.createTable(sharedNotes);
      }
    },
  );

  // ===== NOTES OPERATIONS =====

  /// Get all notes
  Future<List<Note>> getAllNotes() async {
    final query = select(notes)
      ..orderBy([
        (note) => OrderingTerm(expression: note.isPinned, mode: OrderingMode.desc),
        (note) => OrderingTerm(expression: note.updatedAt, mode: OrderingMode.desc),
      ]);
    return await query.get();
  }

  /// Get note by ID
  Future<Note?> getNoteById(String id) async {
    return await (select(notes)..where((note) => note.id.equals(id))).getSingleOrNull();
  }

  /// Insert or update note
  Future<void> insertNote(model.Note note) async {
    await into(notes).insertOnConflictUpdate(
      NotesCompanion(
        id: Value(note.id),
        title: Value(note.title),
        content: Value(note.content),
        createdAt: Value(note.createdAt),
        updatedAt: Value(note.updatedAt),
        isPinned: Value(note.isPinned),
        isArchived: Value(note.isArchived),
        isFavorite: Value(note.isFavorite),
        folderId: Value(note.folderId),
        color: Value(note.color),
      ),
    );

    // Handle tags
    await _updateNoteTags(note.id, note.tags);
  }

  /// Update note
  Future<bool> updateNote(model.Note note) async {
    final result = await (update(notes)..where((n) => n.id.equals(note.id))).write(
      NotesCompanion(
        title: Value(note.title),
        content: Value(note.content),
        updatedAt: Value(note.updatedAt),
        isPinned: Value(note.isPinned),
        isArchived: Value(note.isArchived),
        isFavorite: Value(note.isFavorite),
        folderId: Value(note.folderId),
        color: Value(note.color),
      ),
    );

    if (result > 0) {
      await _updateNoteTags(note.id, note.tags);
    }

    return result > 0;
  }

  /// Delete note
  Future<bool> deleteNote(String id) async {
    // Tags and attachments will be cascade deleted
    final result = await (delete(notes)..where((note) => note.id.equals(id))).go();
    return result > 0;
  }

  /// Search notes (includes searching in note content, title, and OCR extracted text from attachments)
  Future<List<Note>> searchNotes(String query) async {
    if (query.isEmpty) return await getAllNotes();

    final searchQuery = '%${query.toLowerCase()}%';

    // First, get notes that match in title or content
    final matchingNotes =
        await (select(notes)..where(
              (note) =>
                  note.title.lower().like(searchQuery) | note.content.lower().like(searchQuery),
            ))
            .get();

    // Also search in attachment metadata for extracted text
    final matchingAttachments = await (select(
      attachments,
    )..where((att) => att.metadata.like(searchQuery))).get();

    // Get unique note IDs from attachments that match
    final noteIdsFromAttachments = <String>{};
    for (final att in matchingAttachments) {
      if (att.noteId != null) {
        noteIdsFromAttachments.add(att.noteId!);
      }
    }

    // Fetch additional notes that have matching attachments
    final additionalNotes = <Note>[];
    for (final noteId in noteIdsFromAttachments) {
      // Only add if not already in matching notes
      if (!matchingNotes.any((note) => note.id == noteId)) {
        final note = await (select(notes)..where((n) => n.id.equals(noteId))).getSingleOrNull();
        if (note != null) {
          additionalNotes.add(note);
        }
      }
    }

    // Combine and return all matching notes
    return [...matchingNotes, ...additionalNotes];
  }

  // ===== TAGS OPERATIONS =====

  /// Get all tags
  Future<List<Tag>> getAllTags() async {
    return await (select(tags)..orderBy([
          (tag) => OrderingTerm(expression: tag.useCount, mode: OrderingMode.desc),
          (tag) => OrderingTerm(expression: tag.name),
        ]))
        .get();
  }

  /// Get tag by ID
  Future<Tag?> getTagById(String id) async {
    return await (select(tags)..where((tag) => tag.id.equals(id))).getSingleOrNull();
  }

  /// Insert or update tag
  Future<void> insertTag(model.Tag tag) async {
    await into(tags).insertOnConflictUpdate(
      TagsCompanion(
        id: Value(tag.id),
        name: Value(tag.name),
        createdAt: Value(tag.createdAt),
        color: Value(tag.color),
        useCount: Value(tag.useCount),
        description: Value(tag.description),
      ),
    );
  }

  /// Get tags for a note
  Future<List<Tag>> getTagsForNote(String noteId) async {
    final query = select(tags).join([innerJoin(noteTags, noteTags.tagId.equalsExp(tags.id))])
      ..where(noteTags.noteId.equals(noteId));

    return await query.map((row) => row.readTable(tags)).get();
  }

  /// Update note tags
  Future<void> _updateNoteTags(String noteId, List<String> tagNames) async {
    // Remove existing tags for this note
    await (delete(noteTags)..where((nt) => nt.noteId.equals(noteId))).go();

    // Add new tags
    for (final tagName in tagNames) {
      // Find or create tag
      var tag = await (select(tags)..where((t) => t.name.equals(tagName))).getSingleOrNull();
      if (tag == null) {
        final newTag = model.Tag.create(name: tagName);
        await insertTag(newTag);
        tag = await (select(tags)..where((t) => t.id.equals(newTag.id))).getSingle();
      } else {
        // Increment use count
        await (update(tags)..where((t) => t.id.equals(tag!.id))).write(
          TagsCompanion(useCount: Value(tag.useCount + 1)),
        );
      }

      // Link note to tag
      await into(noteTags).insert(
        NoteTagsCompanion(
          noteId: Value(noteId),
          tagId: Value(tag.id),
          createdAt: Value(DateTime.now()),
        ),
      );
    }
  }

  // ===== ATTACHMENTS OPERATIONS =====

  /// Get attachments for a note (returns model.Attachment objects)
  Future<List<model.Attachment>> getAttachmentsForNote(String noteId) async {
    // With @UseRowClass(model.Attachment) and converters, select directly returns List<model.Attachment>
    return await (select(attachments)..where((att) => att.noteId.equals(noteId))).get();
  }

  /// Insert attachment
  Future<void> insertAttachment(model.Attachment attachment) async {
    await into(attachments).insert(
      AttachmentsCompanion(
        id: Value(attachment.id),
        noteId: Value(attachment.noteId),
        fileName: Value(attachment.fileName),
        filePath: Value(attachment.filePath),
        type: Value(attachment.type), // Pass the converted string for the DB
        fileSize: Value(attachment.fileSize),
        createdAt: Value(attachment.createdAt),
        mimeType: Value(attachment.mimeType),
        thumbnailPath: Value(attachment.thumbnailPath),
        metadata: Value(attachment.metadata), // Pass the converted JSON string for the DB
      ),
    );
  }

  /// Update attachment
  Future<bool> updateAttachment(model.Attachment attachment) async {
    final result = await (update(attachments)..where((att) => att.id.equals(attachment.id))).write(
      AttachmentsCompanion(
        noteId: Value(attachment.noteId),
        fileName: Value(attachment.fileName),
        filePath: Value(attachment.filePath),
        type: Value(attachment.type),
        fileSize: Value(attachment.fileSize),
        createdAt: Value(attachment.createdAt),
        mimeType: Value(attachment.mimeType),
        thumbnailPath: Value(attachment.thumbnailPath),
        metadata: Value(attachment.metadata),
      ),
    );
    return result > 0;
  }

  /// Delete attachment
  Future<bool> deleteAttachment(String id) async {
    final result = await (delete(attachments)..where((att) => att.id.equals(id))).go();
    return result > 0;
  }

  // ===== FOLDERS OPERATIONS =====

  /// Get all folders (returns model.Folder objects)
  Future<List<model.Folder>> getAllFolders() async {
    // Note: The Folders table returns Folder objects that implement Insertable<model.Folder>
    // But we need to return List<model.Folder>. Let me query and reconstruct.
    final dbFolders = await select(folders).get();
    return dbFolders
        .map(
          (f) => model.Folder(
            id: f.id,
            name: f.name,
            createdAt: f.createdAt,
            updatedAt: f.updatedAt,
            parentId: f.parentId,
            color: f.color,
            icon: f.icon,
          ),
        )
        .toList();
  }

  /// Get folder by ID
  Future<model.Folder?> getFolderById(String id) async {
    final f = await (select(folders)..where((folder) => folder.id.equals(id))).getSingleOrNull();
    if (f == null) return null;
    return model.Folder(
      id: f.id,
      name: f.name,
      createdAt: f.createdAt,
      updatedAt: f.updatedAt,
      parentId: f.parentId,
      color: f.color,
      icon: f.icon,
    );
  }

  /// Get root folders (folders without parent)
  Future<List<model.Folder>> getRootFolders() async {
    final dbFolders = await (select(folders)..where((folder) => folder.parentId.isNull())).get();
    return dbFolders
        .map(
          (f) => model.Folder(
            id: f.id,
            name: f.name,
            createdAt: f.createdAt,
            updatedAt: f.updatedAt,
            parentId: f.parentId,
            color: f.color,
            icon: f.icon,
          ),
        )
        .toList();
  }

  /// Get child folders for a parent folder
  Future<List<model.Folder>> getChildFolders(String parentId) async {
    final dbFolders = await (select(
      folders,
    )..where((folder) => folder.parentId.equals(parentId))).get();
    return dbFolders
        .map(
          (f) => model.Folder(
            id: f.id,
            name: f.name,
            createdAt: f.createdAt,
            updatedAt: f.updatedAt,
            parentId: f.parentId,
            color: f.color,
            icon: f.icon,
          ),
        )
        .toList();
  }

  /// Create folder
  Future<void> insertFolder(model.Folder folder) async {
    await into(folders).insert(
      FoldersCompanion(
        id: Value(folder.id),
        name: Value(folder.name),
        createdAt: Value(folder.createdAt),
        updatedAt: Value(folder.updatedAt),
        parentId: Value(folder.parentId),
        color: Value(folder.color),
        icon: Value(folder.icon),
      ),
    );
  }

  /// Update folder
  Future<bool> updateFolder(model.Folder folder) async {
    final result = await (update(folders)..where((f) => f.id.equals(folder.id))).write(
      FoldersCompanion(
        name: Value(folder.name),
        updatedAt: Value(DateTime.now()),
        parentId: Value(folder.parentId),
        color: Value(folder.color),
        icon: Value(folder.icon),
      ),
    );
    return result > 0;
  }

  /// Delete folder
  Future<bool> deleteFolder(String id) async {
    // First, set folderId to null for all notes in this folder
    await (update(notes)..where((note) => note.folderId.equals(id))).write(
      const NotesCompanion(folderId: Value(null)),
    );

    // Then delete the folder
    final result = await (delete(folders)..where((folder) => folder.id.equals(id))).go();
    return result > 0;
  }

  /// Count notes in folder
  Future<int> countNotesInFolder(String folderId) async {
    final result = await (select(notes)..where((note) => note.folderId.equals(folderId))).get();
    return result.length;
  }

  // ===== BACKLINKS OPERATIONS =====

  /// Get all backlinks where this note is the source (outgoing links)
  Future<List<Backlink>> getOutgoingBacklinks(String noteId) async {
    return await (select(backlinks)..where((bl) => bl.sourceNoteId.equals(noteId))).get();
  }

  /// Get all backlinks where this note is the target (incoming links)
  Future<List<Backlink>> getIncomingBacklinks(String noteId) async {
    return await (select(backlinks)..where((bl) => bl.targetNoteId.equals(noteId))).get();
  }

  /// Insert a backlink
  Future<void> insertBacklink({
    required String sourceNoteId,
    required String targetNoteId,
    required String targetText,
  }) async {
    final id = 'bl_${DateTime.now().millisecondsSinceEpoch}';
    await into(backlinks).insert(
      BacklinksCompanion.insert(
        id: id,
        sourceNoteId: sourceNoteId,
        targetNoteId: targetNoteId,
        targetText: targetText,
        createdAt: DateTime.now(),
      ),
    );
  }

  /// Delete all backlinks from a source note
  Future<void> deleteBacklinksFromSource(String sourceNoteId) async {
    await (delete(backlinks)..where((bl) => bl.sourceNoteId.equals(sourceNoteId))).go();
  }

  /// Delete specific backlink
  Future<void> deleteBacklink(String backlinkId) async {
    await (delete(backlinks)..where((bl) => bl.id.equals(backlinkId))).go();
  }

  /// Update backlinks for a note (delete old ones and insert new ones)
  Future<void> updateBacklinksForNote({
    required String sourceNoteId,
    required List<Map<String, String>> newBacklinks,
  }) async {
    // Delete existing backlinks
    await deleteBacklinksFromSource(sourceNoteId);

    // Insert new backlinks
    for (final link in newBacklinks) {
      await insertBacklink(
        sourceNoteId: sourceNoteId,
        targetNoteId: link['targetNoteId']!,
        targetText: link['targetText']!,
      );
    }
  }

  /// Delete all backlinks to a target note
  Future<void> deleteBacklinksToTarget(String targetNoteId) async {
    await (delete(backlinks)..where((bl) => bl.targetNoteId.equals(targetNoteId))).go();
  }

  /// Get total backlink count for a note (incoming + outgoing)
  Future<int> getBacklinkCount(String noteId) async {
    final outgoing = await getOutgoingBacklinks(noteId);
    final incoming = await getIncomingBacklinks(noteId);
    return outgoing.length + incoming.length;
  }

  // ===== TASKS OPERATIONS =====

  /// Get all tasks for a note
  Future<List<model.Task>> getTasksForNote(String noteId) async {
    final query = select(tasks)
      ..where((task) => task.noteId.equals(noteId))
      ..orderBy([
        (task) => OrderingTerm(expression: task.isCompleted, mode: OrderingMode.asc),
        (task) => OrderingTerm(expression: task.createdAt, mode: OrderingMode.asc),
      ]);
    return await query.get();
  }

  /// Get task by ID
  Future<model.Task?> getTaskById(String id) async {
    return await (select(tasks)..where((task) => task.id.equals(id))).getSingleOrNull();
  }

  /// Get all incomplete tasks with reminders due before a certain date
  Future<List<model.Task>> getUpcomingTasks(DateTime before) async {
    final query = select(tasks)
      ..where(
        (task) =>
            task.isCompleted.equals(false) &
            task.reminderDate.isSmallerThanValue(before) &
            task.reminderDate.isNotNull(),
      )
      ..orderBy([(task) => OrderingTerm(expression: task.reminderDate, mode: OrderingMode.asc)]);
    return await query.get();
  }

  /// Get all tasks (optionally filter by completion status)
  Future<List<model.Task>> getAllTasks({bool? completed}) async {
    final query = select(tasks);
    if (completed != null) {
      query.where((task) => task.isCompleted.equals(completed));
    }
    query.orderBy([
      (task) => OrderingTerm(expression: task.isCompleted, mode: OrderingMode.asc),
      (task) => OrderingTerm(expression: task.dueDate, mode: OrderingMode.asc),
    ]);
    return await query.get();
  }

  /// Insert a new task
  Future<int> insertTask(model.Task task) async {
    return await into(tasks).insert(
      TasksCompanion(
        id: Value(task.id),
        noteId: Value(task.noteId),
        title: Value(task.title),
        description: Value(task.description),
        isCompleted: Value(task.isCompleted),
        dueDate: Value(task.dueDate),
        reminderDate: Value(task.reminderDate),
        createdAt: Value(task.createdAt),
        updatedAt: Value(task.updatedAt),
        hasNotified: Value(task.hasNotified),
      ),
    );
  }

  /// Update an existing task
  Future<bool> updateTask(model.Task task) async {
    final result = await (update(tasks)..where((t) => t.id.equals(task.id))).write(
      TasksCompanion(
        noteId: Value(task.noteId),
        title: Value(task.title),
        description: Value(task.description),
        isCompleted: Value(task.isCompleted),
        dueDate: Value(task.dueDate),
        reminderDate: Value(task.reminderDate),
        updatedAt: Value(task.updatedAt),
        hasNotified: Value(task.hasNotified),
      ),
    );
    return result > 0;
  }

  /// Delete a task
  Future<int> deleteTask(String id) async {
    return await (delete(tasks)..where((task) => task.id.equals(id))).go();
  }

  /// Toggle task completion status
  Future<void> toggleTaskCompletion(String id) async {
    final task = await getTaskById(id);
    if (task != null) {
      await (update(tasks)..where((t) => t.id.equals(id))).write(
        TasksCompanion(isCompleted: Value(!task.isCompleted), updatedAt: Value(DateTime.now())),
      );
    }
  }

  /// Delete all tasks for a note
  Future<int> deleteTasksForNote(String noteId) async {
    return await (delete(tasks)..where((task) => task.noteId.equals(noteId))).go();
  }

  /// Get count of incomplete tasks for a note
  Future<int> getIncompleteTaskCount(String noteId) async {
    final query = selectOnly(tasks)
      ..addColumns([tasks.id.count()])
      ..where(tasks.noteId.equals(noteId) & tasks.isCompleted.equals(false));
    final result = await query.getSingle();
    return result.read(tasks.id.count()) ?? 0;
  }

  // ===== EMAIL SETTINGS OPERATIONS =====

  /// Get email settings for a user
  Future<EmailSettingsTableData?> getEmailSettings(String userId) async {
    return await (select(
      emailSettingsTable,
    )..where((es) => es.userId.equals(userId))).getSingleOrNull();
  }

  /// Insert or update email settings
  Future<void> insertEmailSettings(String id, String userId, String uniqueEmail) async {
    await into(emailSettingsTable).insertOnConflictUpdate(
      EmailSettingsTableCompanion(
        id: Value(id),
        userId: Value(userId),
        uniqueEmail: Value(uniqueEmail),
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Update email settings
  Future<bool> updateEmailSettings(
    String id, {
    bool? isEnabled,
    bool? gmailConnected,
    String? gmailEmail,
    String? gmailRefreshToken,
    DateTime? lastGmailSync,
    Map<String, dynamic>? preferences,
  }) async {
    final result = await (update(emailSettingsTable)..where((es) => es.id.equals(id))).write(
      EmailSettingsTableCompanion(
        isEnabled: isEnabled != null ? Value(isEnabled) : const Value.absent(),
        gmailConnected: gmailConnected != null ? Value(gmailConnected) : const Value.absent(),
        gmailEmail: gmailEmail != null ? Value(gmailEmail) : const Value.absent(),
        gmailRefreshToken: gmailRefreshToken != null
            ? Value(gmailRefreshToken)
            : const Value.absent(),
        lastGmailSync: lastGmailSync != null ? Value(lastGmailSync) : const Value.absent(),
        preferences: preferences != null ? Value(preferences) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
    return result > 0;
  }

  /// Delete email settings
  Future<int> deleteEmailSettings(String id) async {
    return await (delete(emailSettingsTable)..where((es) => es.id.equals(id))).go();
  }

  // ===== CALENDAR SETTINGS OPERATIONS =====

  /// Get calendar settings for a user
  Future<CalendarSettingsTableData?> getCalendarSettings(String userId) async {
    return await (select(
      calendarSettingsTable,
    )..where((cs) => cs.userId.equals(userId))).getSingleOrNull();
  }

  /// Insert or update calendar settings
  Future<void> insertCalendarSettings(String id, String userId) async {
    await into(calendarSettingsTable).insertOnConflictUpdate(
      CalendarSettingsTableCompanion(
        id: Value(id),
        userId: Value(userId),
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Update calendar settings
  Future<bool> updateCalendarSettings(
    String id, {
    bool? isGoogleCalendarConnected,
    String? googleAccountEmail,
    String? googleCalendarId,
    bool? syncTasksToCalendar,
    bool? syncEventsToNotes,
    int? syncIntervalMinutes,
    DateTime? lastSyncedAt,
  }) async {
    final result = await (update(calendarSettingsTable)..where((cs) => cs.id.equals(id))).write(
      CalendarSettingsTableCompanion(
        isGoogleCalendarConnected: isGoogleCalendarConnected != null
            ? Value(isGoogleCalendarConnected)
            : const Value.absent(),
        googleAccountEmail: googleAccountEmail != null
            ? Value(googleAccountEmail)
            : const Value.absent(),
        googleCalendarId: googleCalendarId != null ? Value(googleCalendarId) : const Value.absent(),
        syncTasksToCalendar: syncTasksToCalendar != null
            ? Value(syncTasksToCalendar)
            : const Value.absent(),
        syncEventsToNotes: syncEventsToNotes != null
            ? Value(syncEventsToNotes)
            : const Value.absent(),
        syncIntervalMinutes: syncIntervalMinutes != null
            ? Value(syncIntervalMinutes)
            : const Value.absent(),
        lastSyncedAt: lastSyncedAt != null ? Value(lastSyncedAt) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
    return result > 0;
  }

  /// Delete calendar settings
  Future<int> deleteCalendarSettings(String id) async {
    return await (delete(calendarSettingsTable)..where((cs) => cs.id.equals(id))).go();
  }

  // ===== CLOUD STORAGE CONNECTIONS OPERATIONS =====

  /// Get all cloud storage connections for a user
  Future<List<model.CloudStorageConnection>> getAllCloudStorageConnections(String userId) async {
    // With @UseRowClass(model.CloudStorageConnection), select directly returns List<model.CloudStorageConnection>
    return await (select(cloudStorageConnections)..where((c) => c.userId.equals(userId))).get();
  }

  /// Get cloud storage connection by ID
  Future<model.CloudStorageConnection?> getCloudStorageConnectionById(String id) async {
    return await (select(cloudStorageConnections)..where((conn) => conn.id.equals(id))).getSingleOrNull();
  }

  /// Get cloud storage connection by provider
  Future<model.CloudStorageConnection?> getCloudStorageConnectionByProvider(
    String userId,
    String provider,
  ) async {
    return await (select(cloudStorageConnections)
          ..where((conn) => conn.userId.equals(userId))
          ..where((conn) => conn.provider.equals(provider)))
        .getSingleOrNull();
  }

  /// Insert cloud storage connection
  Future<void> insertCloudStorageConnection(CloudStorageConnectionsCompanion connection) async {
    await into(cloudStorageConnections).insert(connection, mode: InsertMode.replace);
  }

  /// Update cloud storage connection
  Future<bool> updateCloudStorageConnection(
    String id, {
    String? accessToken,
    String? refreshToken,
    DateTime? tokenExpiry,
    String? userEmail,
    String? userName,
  }) async {
    final result = await (update(cloudStorageConnections)..where((c) => c.id.equals(id))).write(
      CloudStorageConnectionsCompanion(
        accessToken: accessToken != null ? Value(accessToken) : const Value.absent(),
        refreshToken: refreshToken != null ? Value(refreshToken) : const Value.absent(),
        tokenExpiry: tokenExpiry != null ? Value(tokenExpiry) : const Value.absent(),
        userEmail: userEmail != null ? Value(userEmail) : const Value.absent(),
        userName: userName != null ? Value(userName) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
    return result > 0;
  }

  /// Delete cloud storage connection
  Future<int> deleteCloudStorageConnection(String id) async {
    return await (delete(cloudStorageConnections)..where((c) => c.id.equals(id))).go();
  }

  /// Delete cloud storage connection by provider
  Future<int> deleteCloudStorageConnectionByProvider(String userId, String provider) async {
    return await (delete(cloudStorageConnections)
          ..where((c) => c.userId.equals(userId))
          ..where((c) => c.provider.equals(provider)))
        .go();
  }

  // ===== SHARED NOTES OPERATIONS =====

  /// Get all shares for a note (as owner)
  Future<List<model.SharedNote>> getSharesForNote(String noteId) async {
    return await (select(sharedNotes)..where((s) => s.noteId.equals(noteId))).get();
  }

  /// Get all notes shared with a user (as recipient)
  Future<List<model.SharedNote>> getNotesSharedWith(String emailOrUserId) async {
    return await (select(sharedNotes)
          ..where((s) =>
              s.sharedWithEmail.equals(emailOrUserId) |
              s.sharedWithUserId.equals(emailOrUserId))
          ..where((s) => s.isActive.equals(true)))
        .get();
  }

  /// Get share by ID
  Future<model.SharedNote?> getShareById(String id) async {
    return await (select(sharedNotes)..where((s) => s.id.equals(id))).getSingleOrNull();
  }

  /// Get share by token
  Future<model.SharedNote?> getShareByToken(String token) async {
    return await (select(sharedNotes)
          ..where((s) => s.shareToken.equals(token))
          ..where((s) => s.isActive.equals(true)))
        .getSingleOrNull();
  }

  /// Check if a note is shared with a specific user
  Future<model.SharedNote?> getShareForNoteAndUser(String noteId, String emailOrUserId) async {
    return await (select(sharedNotes)
          ..where((s) => s.noteId.equals(noteId))
          ..where((s) =>
              s.sharedWithEmail.equals(emailOrUserId) |
              s.sharedWithUserId.equals(emailOrUserId)))
        .getSingleOrNull();
  }

  /// Insert or update a share
  Future<void> insertShare(model.SharedNote share) async {
    await into(sharedNotes).insertOnConflictUpdate(
      SharedNotesCompanion(
        id: Value(share.id),
        noteId: Value(share.noteId),
        ownerId: Value(share.ownerId),
        sharedWithEmail: Value(share.sharedWithEmail),
        sharedWithUserId: Value(share.sharedWithUserId),
        permission: Value(share.permission),
        shareToken: Value(share.shareToken),
        createdAt: Value(share.createdAt),
        updatedAt: Value(share.updatedAt),
        expiresAt: Value(share.expiresAt),
        isActive: Value(share.isActive),
      ),
    );
  }

  /// Update share permission
  Future<bool> updateSharePermission(String id, SharePermission permission) async {
    final result = await (update(sharedNotes)..where((s) => s.id.equals(id))).write(
      SharedNotesCompanion(
        permission: Value(permission),
        updatedAt: Value(DateTime.now()),
      ),
    );
    return result > 0;
  }

  /// Deactivate a share
  Future<bool> deactivateShare(String id) async {
    final result = await (update(sharedNotes)..where((s) => s.id.equals(id))).write(
      SharedNotesCompanion(
        isActive: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
    return result > 0;
  }

  /// Delete a share
  Future<bool> deleteShare(String id) async {
    final result = await (delete(sharedNotes)..where((s) => s.id.equals(id))).go();
    return result > 0;
  }

  /// Delete all shares for a note
  Future<int> deleteSharesForNote(String noteId) async {
    return await (delete(sharedNotes)..where((s) => s.noteId.equals(noteId))).go();
  }

  /// Get count of active shares for a note
  Future<int> getActiveShareCountForNote(String noteId) async {
    final query = selectOnly(sharedNotes)
      ..addColumns([sharedNotes.id.count()])
      ..where(sharedNotes.noteId.equals(noteId))
      ..where(sharedNotes.isActive.equals(true));

    final result = await query.getSingleOrNull();
    return result?.read(sharedNotes.id.count()) ?? 0;
  }
}

/// Create database connection
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'ai_organizer.db'));
    return NativeDatabase(file);
  });
}
