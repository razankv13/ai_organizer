import 'dart:io';

import 'package:ai_organizer/data/models/attachment.dart';
import 'package:ai_organizer/data/models/folder.dart';
import 'package:ai_organizer/data/models/note.dart';
import 'package:ai_organizer/data/models/share_permission.dart';
import 'package:ai_organizer/data/models/shared_note.dart';
import 'package:ai_organizer/data/repositories/backlink_repository.dart';
import 'package:ai_organizer/data/repositories/folder_repository.dart';
import 'package:ai_organizer/data/repositories/note_repository.dart';
import 'package:ai_organizer/data/repositories/shared_notes_repository.dart';
import 'package:ai_organizer/providers/auth_provider.dart';
import 'package:ai_organizer/providers/database_provider.dart';
import 'package:ai_organizer/providers/folder_provider.dart';
import 'package:ai_organizer/providers/sharing_provider.dart';
import 'package:ai_organizer/providers/storage_provider.dart';
import 'package:ai_organizer/utils/file_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provider for the sync state
final syncStateProvider = StateProvider<SyncState>((ref) => SyncState.idle);

/// Provider for the last sync time
final lastSyncTimeProvider = StateProvider<DateTime?>((ref) => null);

/// Provider for sync actions
final syncActionsProvider = Provider<SyncActions>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final storageActions = ref.watch(storageActionsProvider);
  final noteRepository = ref.watch(noteRepositoryProvider);
  final folderRepository = ref.watch(folderRepositoryProvider);
  final backlinkRepository = ref.watch(backlinkRepositoryProvider);
  final sharedNotesRepository = ref.watch(sharedNotesRepositoryProvider);
  final database = ref.watch(databaseProvider);

  return SyncActions(
    client: client, // Can be null
    storageActions: storageActions,
    noteRepository: noteRepository,
    folderRepository: folderRepository,
    backlinkRepository: backlinkRepository,
    sharedNotesRepository: sharedNotesRepository,
    database: database,
    ref: ref,
  );
});

/// Enum for the sync state
enum SyncState { idle, syncing, error }

/// Class for sync actions
class SyncActions {
  SyncActions({
    required SupabaseClient? client,
    required StorageActions storageActions,
    required NoteRepository noteRepository,
    required FolderRepository folderRepository,
    required BacklinkRepository backlinkRepository,
    required SharedNotesRepository sharedNotesRepository,
    required this.database,
    required Ref ref,
  }) : _client = client,
       _storageActions = storageActions,
       _noteRepository = noteRepository,
       _folderRepository = folderRepository,
       _backlinkRepository = backlinkRepository,
       _sharedNotesRepository = sharedNotesRepository,
       _ref = ref;
  final SupabaseClient? _client;

  /// Helper to ensure client is initialized
  SupabaseClient get _ensureClient {
    if (_client == null) {
      throw Exception('Supabase is not initialized. Cannot sync without Supabase connection.');
    }
    return _client;
  }

  final StorageActions _storageActions;
  final NoteRepository _noteRepository;
  final FolderRepository _folderRepository;
  final BacklinkRepository _backlinkRepository;
  final SharedNotesRepository _sharedNotesRepository;
  final dynamic database;
  final Ref _ref;

  /// Initialize Supabase synchronization
  Future<void> initializeSync() async {
    // Ensure storage bucket exists
    await _storageActions.ensureBucketExists();

    // Subscribe to realtime changes for notes
    _subscribeToNoteChanges();
  }

  /// Subscribe to note changes from Supabase
  void _subscribeToNoteChanges() {
    if (_client == null) return; // Skip if not initialized
    final user = _ensureClient.auth.currentUser;
    if (user == null) return;

    // Using the correct Supabase realtime API
    _client
        .channel('public:notes')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'notes',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: user.id,
          ),
          callback: (payload) async {
            // Handle note changes from server
            await _handleRemoteNoteChange(payload);
          },
        )
        .subscribe();
  }

  /// Handle note changes from the server
  Future<void> _handleRemoteNoteChange(PostgresChangePayload payload) async {
    try {
      final eventType = payload.eventType;
      final newData = payload.newRecord;
      final oldData = payload.oldRecord;

      if (eventType == PostgresChangeEvent.insert || eventType == PostgresChangeEvent.update) {
        await _handleRemoteNoteInsertOrUpdate(newData);
      } else if (eventType == PostgresChangeEvent.delete) {
        if (oldData['id'] != null) {
          await _handleRemoteNoteDelete(oldData['id'] as String);
        }
      }
    } catch (e) {
      // Handle error
    }
  }

  /// Handle note insert or update from the server
  Future<void> _handleRemoteNoteInsertOrUpdate(Map<String, dynamic> noteData) async {
    try {
      // Convert to local note model
      final note = _convertToLocalNote(noteData);

      // Check if note exists locally
      final existingNote = await _noteRepository.getNoteById(note.id);

      if (existingNote == null) {
        // Insert new note directly into the database
        await database.insertNote(note);
      } else {
        // Update existing note if server version is newer
        final serverUpdatedAt = note.updatedAt;
        final localUpdatedAt = existingNote.updatedAt;

        if (serverUpdatedAt.isAfter(localUpdatedAt)) {
          await _noteRepository.updateNote(note);
        }
      }
    } catch (e) {
      // Handle error
    }
  }

  /// Handle note deletion from the server
  Future<void> _handleRemoteNoteDelete(String noteId) async {
    try {
      await _noteRepository.deleteNote(noteId);
    } catch (e) {
      // Handle error
    }
  }

  /// Convert Supabase note to local note model
  Note _convertToLocalNote(Map<String, dynamic> noteData) {
    return Note(
      id: noteData['id'] as String,
      title: noteData['title'] as String,
      content: noteData['content'] as String,
      createdAt: DateTime.parse(noteData['created_at'] as String),
      updatedAt: DateTime.parse(noteData['updated_at'] as String),
      isPinned: noteData['is_pinned'] as bool? ?? false,
      isArchived: noteData['is_archived'] as bool? ?? false,
      isFavorite: noteData['is_favorite'] as bool? ?? false,
      tags: (noteData['tags'] as List<dynamic>?)?.map((tag) => tag as String).toList() ?? [],
      attachments: [], // Will be handled separately
      folderId: noteData['folder_id'] as String?,
      color: noteData['color'] as String?,
    );
  }

  /// Sync local notes to the server
  Future<void> syncToServer() async {
    try {
      final client = _ensureClient;
      final user = client.auth.currentUser;
      if (user == null) return;

      // Update sync state
      _ref.read(syncStateProvider.notifier).state = SyncState.syncing;

      // Sync folders first (since notes depend on them)
      final folders = await _folderRepository.getAllFolders();
      for (final folder in folders) {
        await _syncFolderToServer(folder);
      }

      // Get all local notes
      final notes = await _noteRepository.getAllNotes();

      // Sync each note
      for (final note in notes) {
        await _syncNoteToServer(note);
      }

      // Update last sync time
      _ref.read(lastSyncTimeProvider.notifier).state = DateTime.now();

      // Update sync state
      _ref.read(syncStateProvider.notifier).state = SyncState.idle;
    } catch (e) {
      // Handle error
      _ref.read(syncStateProvider.notifier).state = SyncState.error;
    }
  }

  /// Sync a specific note to the server
  Future<void> _syncNoteToServer(Note note) async {
    try {
      final client = _ensureClient;
      final user = client.auth.currentUser;
      if (user == null) return;

      // Get note attachments
      final attachments = await _noteRepository.getAttachmentsForNote(note.id);

      // Prepare note data for server
      final noteData = {
        'id': note.id,
        'user_id': user.id,
        'title': note.title,
        'content': note.content,
        'created_at': note.createdAt.toIso8601String(),
        'updated_at': note.updatedAt.toIso8601String(),
        'is_pinned': note.isPinned,
        'is_archived': note.isArchived,
        'is_favorite': note.isFavorite,
        'tags': note.tags,
        'folder_id': note.folderId,
        'color': note.color,
      };

      // Check if note exists on server
      final existingNote = await client.from('notes').select().eq('id', note.id).maybeSingle();

      if (existingNote == null) {
        // Insert new note
        await client.from('notes').insert(noteData);
      } else {
        // Update existing note
        final serverUpdatedAt = DateTime.parse(existingNote['updated_at'] as String);

        if (note.updatedAt.isAfter(serverUpdatedAt)) {
          await client.from('notes').update(noteData).eq('id', note.id);
        }
      }

      // Sync attachments
      for (final attachment in attachments) {
        await _syncAttachmentToServer(attachment);
      }

      // Sync backlinks
      await _syncBacklinksToServer(note.id);

      // Sync shared notes
      await _syncSharedNotesToServer(note.id);
    } catch (e) {
      // Handle error
    }
  }

  /// Sync a specific folder to the server
  Future<void> _syncFolderToServer(Folder folder) async {
    try {
      final user = _ensureClient.auth.currentUser;
      if (user == null) return;

      // Prepare folder data for server
      final folderData = {
        'id': folder.id,
        'user_id': user.id,
        'name': folder.name,
        'parent_id': folder.parentId,
        'color': folder.color,
        'icon': folder.icon,
        'created_at': folder.createdAt.toIso8601String(),
        'updated_at': folder.updatedAt.toIso8601String(),
      };

      // Check if folder exists on server
      final existingFolder = await _ensureClient
          .from('folders')
          .select()
          .eq('id', folder.id)
          .maybeSingle();

      if (existingFolder == null) {
        // Insert new folder
        await _ensureClient.from('folders').insert(folderData);
      } else {
        // Update existing folder (last write wins)
        final serverUpdatedAt = DateTime.parse(existingFolder['updated_at'] as String);

        if (folder.updatedAt.isAfter(serverUpdatedAt)) {
          await _ensureClient.from('folders').update(folderData).eq('id', folder.id);
        }
      }
    } catch (e) {
      // Handle error
    }
  }

  /// Sync an attachment to the server
  Future<void> _syncAttachmentToServer(Attachment attachment) async {
    try {
      final user = _ensureClient.auth.currentUser;
      if (user == null) return;

      // Check if the attachment file exists
      final file = File(attachment.filePath);
      if (!await file.exists()) return;

      // Check if attachment exists on server
      final existingAttachment = await _ensureClient
          .from('attachments')
          .select()
          .eq('id', attachment.id)
          .maybeSingle();

      if (existingAttachment == null) {
        // Upload file to storage
        final fileUrl = await _storageActions.uploadFile(file, attachment.noteId!);

        // Upload thumbnail if exists
        String? thumbnailUrl;
        if (attachment.thumbnailPath != null && attachment.thumbnailPath!.isNotEmpty) {
          final thumbnailFile = File(attachment.thumbnailPath!);
          if (await thumbnailFile.exists()) {
            thumbnailUrl = await _storageActions.uploadThumbnail(thumbnailFile, attachment.noteId!);
          }
        }

        // Insert attachment record
        await _ensureClient.from('attachments').insert({
          'id': attachment.id,
          'note_id': attachment.noteId,
          'user_id': user.id,
          'file_name': attachment.fileName,
          'file_url': fileUrl,
          'file_size': attachment.fileSize,
          'mime_type': attachment.mimeType,
          'type': attachment.type.name,
          'thumbnail_url': thumbnailUrl,
          'created_at': attachment.createdAt.toIso8601String(),
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  /// Sync backlinks for a note to the server
  Future<void> _syncBacklinksToServer(String noteId) async {
    try {
      final user = _ensureClient.auth.currentUser;
      if (user == null) return;

      // Get all outgoing backlinks for this note
      final backlinks = await database.getOutgoingBacklinks(noteId);

      // Delete existing backlinks for this note on server
      await _ensureClient
          .from('backlinks')
          .delete()
          .eq('source_note_id', noteId)
          .eq('user_id', user.id);

      // Insert new backlinks
      for (final backlink in backlinks) {
        await _ensureClient.from('backlinks').insert({
          'id': backlink.id,
          'source_note_id': backlink.sourceNoteId,
          'target_note_id': backlink.targetNoteId,
          'target_text': backlink.targetText,
          'created_at': backlink.createdAt.toIso8601String(),
          'user_id': user.id,
        });
      }
    } catch (e) {
      // Handle error silently - backlinks are not critical for note sync
    }
  }

  /// Sync backlinks from server for a note
  Future<void> _syncBacklinksFromServer(String noteId) async {
    try {
      final user = _ensureClient.auth.currentUser;
      if (user == null) return;

      // Get backlinks from server
      final serverBacklinks = await _ensureClient
          .from('backlinks')
          .select()
          .eq('source_note_id', noteId)
          .eq('user_id', user.id);

      // Delete existing local backlinks for this note
      await database.deleteBacklinksFromSource(noteId);

      // Insert backlinks from server
      for (final backlinkData in serverBacklinks) {
        await database.insertBacklink(
          sourceNoteId: backlinkData['source_note_id'] as String,
          targetNoteId: backlinkData['target_note_id'] as String,
          targetText: backlinkData['target_text'] as String,
        );
      }
    } catch (e) {
      // Handle error silently - backlinks are not critical for note sync
    }
  }

  /// Sync shared notes for a note to the server
  Future<void> _syncSharedNotesToServer(String noteId) async {
    try {
      final user = _ensureClient.auth.currentUser;
      if (user == null) return;

      // Get all shares for this note
      final shares = await database.getSharesForNote(noteId);

      // Sync each share
      for (final share in shares) {
        // Prepare share data for server
        final shareData = {
          'id': share.id,
          'note_id': share.noteId,
          'owner_id': share.ownerId,
          'shared_with_email': share.sharedWithEmail,
          'shared_with_user_id': share.sharedWithUserId,
          'permission': share.permission.name,
          'share_token': share.shareToken,
          'created_at': share.createdAt.toIso8601String(),
          'updated_at': share.updatedAt.toIso8601String(),
          'expires_at': share.expiresAt?.toIso8601String(),
          'is_active': share.isActive,
        };

        // Check if share exists on server
        final existingShare = await _ensureClient
            .from('shared_notes')
            .select()
            .eq('id', share.id)
            .maybeSingle();

        if (existingShare == null) {
          // Insert new share
          await _ensureClient.from('shared_notes').insert(shareData);
        } else {
          // Update existing share if local is newer
          final serverUpdatedAt = DateTime.parse(existingShare['updated_at'] as String);

          if (share.updatedAt.isAfter(serverUpdatedAt)) {
            await _ensureClient.from('shared_notes').update(shareData).eq('id', share.id);
          }
        }
      }
    } catch (e) {
      // Handle error silently - shares are not critical for note sync
    }
  }

  /// Sync shared notes from server for a note
  Future<void> _syncSharedNotesFromServer(String noteId) async {
    try {
      final user = _ensureClient.auth.currentUser;
      if (user == null) return;

      // Get shares from server where user is owner or recipient
      final serverShares = await _ensureClient.from('shared_notes').select().eq('note_id', noteId);

      // Insert or update local shares
      for (final shareData in serverShares) {
        final share = SharedNote(
          id: shareData['id'] as String,
          noteId: shareData['note_id'] as String,
          ownerId: shareData['owner_id'] as String,
          sharedWithEmail: shareData['shared_with_email'] as String,
          sharedWithUserId: shareData['shared_with_user_id'] as String?,
          permission: SharePermission.fromString(shareData['permission'] as String),
          shareToken: shareData['share_token'] as String,
          createdAt: DateTime.parse(shareData['created_at'] as String),
          updatedAt: DateTime.parse(shareData['updated_at'] as String),
          expiresAt: shareData['expires_at'] != null
              ? DateTime.parse(shareData['expires_at'] as String)
              : null,
          isActive: shareData['is_active'] as bool,
        );

        // Insert or update in local database
        await database.insertShare(share);
      }
    } catch (e) {
      // Handle error silently - shares are not critical for note sync
    }
  }

  /// Sync from server to local storage
  Future<void> syncFromServer() async {
    try {
      final user = _ensureClient.auth.currentUser;
      if (user == null) return;

      // Update sync state
      _ref.read(syncStateProvider.notifier).state = SyncState.syncing;

      // Sync folders first (since notes depend on them)
      final serverFolders = await _ensureClient.from('folders').select().eq('user_id', user.id);
      for (final folderData in serverFolders) {
        await _syncFolderFromServer(folderData);
      }

      // Get notes from server
      final serverNotes = await _ensureClient.from('notes').select().eq('user_id', user.id);

      // Sync each note
      for (final noteData in serverNotes) {
        await _syncNoteFromServer(noteData);
      }

      // Update last sync time
      _ref.read(lastSyncTimeProvider.notifier).state = DateTime.now();

      // Update sync state
      _ref.read(syncStateProvider.notifier).state = SyncState.idle;
    } catch (e) {
      // Handle error
      _ref.read(syncStateProvider.notifier).state = SyncState.error;
    }
  }

  /// Sync a note from the server to local storage
  Future<void> _syncNoteFromServer(Map<String, dynamic> noteData) async {
    try {
      // Convert to local note model
      final note = _convertToLocalNote(noteData);

      // Check if note exists locally
      final existingNote = await _noteRepository.getNoteById(note.id);

      if (existingNote == null) {
        // Insert new note
        await database.insertNote(note);
      } else {
        // Update existing note if server version is newer
        final serverUpdatedAt = note.updatedAt;
        final localUpdatedAt = existingNote.updatedAt;

        if (serverUpdatedAt.isAfter(localUpdatedAt)) {
          await _noteRepository.updateNote(note);
        }
      }

      // Sync attachments
      await _syncAttachmentsFromServer(note.id);

      // Sync backlinks
      await _syncBacklinksFromServer(note.id);
    } catch (e) {
      // Handle error
    }
  }

  /// Sync a folder from the server to local storage
  Future<void> _syncFolderFromServer(Map<String, dynamic> folderData) async {
    try {
      // Convert to local folder model
      final folder = Folder(
        id: folderData['id'] as String,
        name: folderData['name'] as String,
        createdAt: DateTime.parse(folderData['created_at'] as String),
        updatedAt: DateTime.parse(folderData['updated_at'] as String),
        parentId: folderData['parent_id'] as String?,
        color: folderData['color'] as String?,
        icon: folderData['icon'] as String?,
      );

      // Check if folder exists locally
      final existingFolder = await _folderRepository.getFolderById(folder.id);

      if (existingFolder == null) {
        // Insert new folder
        await database.insertFolder(folder);
      } else {
        // Update existing folder if server version is newer
        if (folder.updatedAt.isAfter(existingFolder.updatedAt)) {
          await _folderRepository.updateFolder(folder);
        }
      }
    } catch (e) {
      // Handle error
    }
  }

  /// Sync attachments for a note from server to local storage
  Future<void> _syncAttachmentsFromServer(String noteId) async {
    try {
      final user = _ensureClient.auth.currentUser;
      if (user == null) return;

      // Get attachments from server
      final serverAttachments = await _ensureClient
          .from('attachments')
          .select()
          .eq('note_id', noteId)
          .eq('user_id', user.id);

      // Get local attachments
      final localAttachments = await _noteRepository.getAttachmentsForNote(noteId);

      // Handle each server attachment
      for (final attachmentData in serverAttachments) {
        final attachmentId = attachmentData['id'] as String;

        // Check if attachment exists locally
        final existingAttachment = localAttachments.where((a) => a.id == attachmentId).firstOrNull;

        if (existingAttachment == null) {
          // Download and save attachment
          await _downloadAttachment(attachmentData);
        }
      }
    } catch (e) {
      // Handle error
    }
  }

  /// Download an attachment from server to local storage
  Future<void> _downloadAttachment(Map<String, dynamic> attachmentData) async {
    try {
      final fileUrl = attachmentData['file_url'] as String;
      final thumbnailUrl = attachmentData['thumbnail_url'] as String?;
      final noteId = attachmentData['note_id'] as String;
      final fileName = attachmentData['file_name'] as String;
      final attachId = attachmentData['id'] as String;

      // Download file
      final response = await HttpClient().getUrl(Uri.parse(fileUrl));
      final httpResponse = await response.close();

      // Get attachment directories
      final attachDir = await FileUtils.attachmentsDir;
      final noteDir = Directory('$attachDir/$noteId');
      if (!await noteDir.exists()) {
        await noteDir.create(recursive: true);
      }

      // Save file locally
      final fileData = await httpResponse.expand((e) => e).toList();
      final filePath = '${noteDir.path}/${path.basename(fileUrl)}';
      final file = File(filePath);
      await file.writeAsBytes(fileData);

      // Download and save thumbnail if available
      String? thumbnailPath;
      if (thumbnailUrl != null && thumbnailUrl.isNotEmpty) {
        final thumbResponse = await HttpClient().getUrl(Uri.parse(thumbnailUrl));
        final thumbHttpResponse = await thumbResponse.close();

        final thumbDir = await FileUtils.thumbnailsDir;
        final noteThumbDir = Directory('$thumbDir/$noteId');
        if (!await noteThumbDir.exists()) {
          await noteThumbDir.create(recursive: true);
        }

        final thumbData = await thumbHttpResponse.expand((e) => e).toList();
        thumbnailPath = '${noteThumbDir.path}/${path.basename(thumbnailUrl)}';
        final thumbFile = File(thumbnailPath);
        await thumbFile.writeAsBytes(thumbData);
      }

      // Create attachment in local database
      final attachment = Attachment(
        id: attachId,
        noteId: noteId,
        fileName: fileName,
        filePath: filePath,
        fileSize: attachmentData['file_size'] as int,
        type: AttachmentType.values.firstWhere(
          (type) => type.name == (attachmentData['type'] as String),
          orElse: () => AttachmentType.other,
        ),
        mimeType: attachmentData['mime_type'] as String?,
        thumbnailPath: thumbnailPath,
        createdAt: DateTime.parse(attachmentData['created_at'] as String),
      );

      await _noteRepository.addAttachment(attachment);
    } catch (e) {
      // Handle error
    }
  }

  /// Delete a note locally and on the server
  Future<void> deleteNote(String noteId) async {
    try {
      // Delete locally
      await _noteRepository.deleteNote(noteId);

      // Delete from server
      await _ensureClient.from('notes').delete().eq('id', noteId);

      // Delete attachments from storage
      await _storageActions.deleteNoteFiles(noteId);
    } catch (e) {
      // Handle error
    }
  }

  /// Check if device is online
  Future<bool> isOnline() async {
    try {
      final result = await InternetAddress.lookup('supabase.co');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
