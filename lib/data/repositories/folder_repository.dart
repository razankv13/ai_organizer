import 'package:ai_organizer/data/database/app_database.dart' hide Folder;
import 'package:ai_organizer/data/models/folder.dart';

/// Repository for folder operations
class FolderRepository {
  FolderRepository(this._database);
  final AppDatabase _database;

  // ===== READ OPERATIONS =====

  /// Get all folders
  Future<List<Folder>> getAllFolders() async {
    return await _database.getAllFolders();
  }

  /// Get folder by ID
  Future<Folder?> getFolderById(String id) async {
    return await _database.getFolderById(id);
  }

  /// Get root folders (folders without parent)
  Future<List<Folder>> getRootFolders() async {
    return await _database.getRootFolders();
  }

  /// Get child folders for a parent folder
  Future<List<Folder>> getChildFolders(String parentId) async {
    return await _database.getChildFolders(parentId);
  }

  /// Get folder hierarchy (folder with all its descendants)
  Future<List<Folder>> getFolderHierarchy(String folderId) async {
    final List<Folder> hierarchy = [];
    final folder = await getFolderById(folderId);

    if (folder != null) {
      hierarchy.add(folder);
      final children = await getChildFolders(folderId);

      for (final child in children) {
        final childHierarchy = await getFolderHierarchy(child.id);
        hierarchy.addAll(childHierarchy);
      }
    }

    return hierarchy;
  }

  /// Get folder path (from root to folder)
  Future<List<Folder>> getFolderPath(String folderId) async {
    final List<Folder> path = [];
    Folder? currentFolder = await getFolderById(folderId);

    while (currentFolder != null) {
      path.insert(0, currentFolder);
      if (currentFolder.parentId != null) {
        currentFolder = await getFolderById(currentFolder.parentId!);
      } else {
        break;
      }
    }

    return path;
  }

  /// Get folder with note count
  Future<Map<String, dynamic>> getFolderWithNoteCount(String folderId) async {
    final folder = await getFolderById(folderId);
    final noteCount = await _database.countNotesInFolder(folderId);

    return {
      'folder': folder,
      'noteCount': noteCount,
    };
  }

  /// Get all folders with note counts
  Future<List<Map<String, dynamic>>> getAllFoldersWithNoteCounts() async {
    final folders = await getAllFolders();
    final result = <Map<String, dynamic>>[];

    for (final folder in folders) {
      final noteCount = await _database.countNotesInFolder(folder.id);
      result.add({
        'folder': folder,
        'noteCount': noteCount,
      });
    }

    return result;
  }

  // ===== WRITE OPERATIONS =====

  /// Create a new folder
  Future<Folder> createFolder({
    required String name,
    String? parentId,
    String? color,
    String? icon,
  }) async {
    final folder = Folder.create(
      name: name,
      parentId: parentId,
      color: color,
      icon: icon,
    );

    await _database.insertFolder(folder);
    return folder;
  }

  /// Update an existing folder
  Future<bool> updateFolder(Folder folder) async {
    return await _database.updateFolder(folder);
  }

  /// Delete a folder
  /// Notes: Notes in this folder will be moved to the parent folder or root
  Future<bool> deleteFolder(String id) async {
    return await _database.deleteFolder(id);
  }

  /// Move folder to a new parent
  Future<bool> moveFolder(String folderId, String? newParentId) async {
    final folder = await getFolderById(folderId);
    if (folder == null) return false;

    // Check for circular reference
    if (newParentId != null) {
      final isCircular = await _isCircularReference(folderId, newParentId);
      if (isCircular) {
        throw Exception('Cannot move folder: circular reference detected');
      }
    }

    final updatedFolder = folder.copyWith(
      parentId: newParentId,
      updatedAt: DateTime.now(),
    );

    return await updateFolder(updatedFolder);
  }

  /// Rename folder
  Future<bool> renameFolder(String folderId, String newName) async {
    final folder = await getFolderById(folderId);
    if (folder == null) return false;

    final updatedFolder = folder.copyWith(
      name: newName,
      updatedAt: DateTime.now(),
    );

    return await updateFolder(updatedFolder);
  }

  /// Update folder color
  Future<bool> updateFolderColor(String folderId, String? color) async {
    final folder = await getFolderById(folderId);
    if (folder == null) return false;

    final updatedFolder = folder.copyWith(
      color: color,
      updatedAt: DateTime.now(),
    );

    return await updateFolder(updatedFolder);
  }

  /// Update folder icon
  Future<bool> updateFolderIcon(String folderId, String? icon) async {
    final folder = await getFolderById(folderId);
    if (folder == null) return false;

    final updatedFolder = folder.copyWith(
      icon: icon,
      updatedAt: DateTime.now(),
    );

    return await updateFolder(updatedFolder);
  }

  // ===== HELPER METHODS =====

  /// Check if moving a folder would create a circular reference
  Future<bool> _isCircularReference(String folderId, String targetParentId) async {
    String? currentId = targetParentId;

    while (currentId != null) {
      if (currentId == folderId) {
        return true; // Circular reference detected
      }

      final folder = await getFolderById(currentId);
      currentId = folder?.parentId;
    }

    return false;
  }

  /// Count total notes in folder (including subfolders)
  Future<int> countTotalNotesInFolder(String folderId) async {
    int count = await _database.countNotesInFolder(folderId);

    // Add counts from subfolders
    final children = await getChildFolders(folderId);
    for (final child in children) {
      count += await countTotalNotesInFolder(child.id);
    }

    return count;
  }
}
