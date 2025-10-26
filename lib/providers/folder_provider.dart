import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_organizer/data/models/folder.dart';
import 'package:ai_organizer/data/repositories/folder_repository.dart';
import 'package:ai_organizer/providers/database_provider.dart';

/// Folder repository provider
final folderRepositoryProvider = Provider<FolderRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return FolderRepository(database);
});

/// All folders provider
final foldersProvider = FutureProvider<List<Folder>>((ref) async {
  final repository = ref.watch(folderRepositoryProvider);
  return await repository.getAllFolders();
});

/// Root folders provider (top-level folders)
final rootFoldersProvider = FutureProvider<List<Folder>>((ref) async {
  final repository = ref.watch(folderRepositoryProvider);
  return await repository.getRootFolders();
});

/// Folder by ID provider - family provider
final folderByIdProvider = FutureProvider.family<Folder?, String>((ref, folderId) async {
  final repository = ref.watch(folderRepositoryProvider);
  return await repository.getFolderById(folderId);
});

/// Child folders provider - family provider
final childFoldersProvider = FutureProvider.family<List<Folder>, String>((ref, parentId) async {
  final repository = ref.watch(folderRepositoryProvider);
  return await repository.getChildFolders(parentId);
});

/// Folder hierarchy provider - family provider (folder with all descendants)
final folderHierarchyProvider = FutureProvider.family<List<Folder>, String>((ref, folderId) async {
  final repository = ref.watch(folderRepositoryProvider);
  return await repository.getFolderHierarchy(folderId);
});

/// Folder path provider - family provider (breadcrumb path from root to folder)
final folderPathProvider = FutureProvider.family<List<Folder>, String>((ref, folderId) async {
  final repository = ref.watch(folderRepositoryProvider);
  return await repository.getFolderPath(folderId);
});

/// Folders with note counts provider
final foldersWithNoteCountsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(folderRepositoryProvider);
  return await repository.getAllFoldersWithNoteCounts();
});

/// Folder with note count provider - family provider
final folderWithNoteCountProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, folderId) async {
  final repository = ref.watch(folderRepositoryProvider);
  return await repository.getFolderWithNoteCount(folderId);
});

/// Folder actions provider for mutations
class FolderActions {
  FolderActions(this._repository, this._ref);
  final FolderRepository _repository;
  final Ref _ref;

  /// Create a new folder
  Future<Folder> createFolder({
    required String name,
    String? parentId,
    String? color,
    String? icon,
  }) async {
    final folder = await _repository.createFolder(
      name: name,
      parentId: parentId,
      color: color,
      icon: icon,
    );

    // Invalidate folder providers to refresh UI
    _invalidateFolderProviders();

    return folder;
  }

  /// Update folder
  Future<bool> updateFolder(Folder folder) async {
    final result = await _repository.updateFolder(folder);

    if (result) {
      _invalidateFolderProviders();
    }

    return result;
  }

  /// Delete folder
  Future<bool> deleteFolder(String folderId) async {
    final result = await _repository.deleteFolder(folderId);

    if (result) {
      _invalidateFolderProviders();
      // Also invalidate notes providers as notes may have been moved
      _ref.invalidate(foldersProvider);
    }

    return result;
  }

  /// Move folder to new parent
  Future<bool> moveFolder(String folderId, String? newParentId) async {
    try {
      final result = await _repository.moveFolder(folderId, newParentId);

      if (result) {
        _invalidateFolderProviders();
      }

      return result;
    } catch (e) {
      // Handle circular reference error
      rethrow;
    }
  }

  /// Rename folder
  Future<bool> renameFolder(String folderId, String newName) async {
    final result = await _repository.renameFolder(folderId, newName);

    if (result) {
      _invalidateFolderProviders();
    }

    return result;
  }

  /// Update folder color
  Future<bool> updateFolderColor(String folderId, String? color) async {
    final result = await _repository.updateFolderColor(folderId, color);

    if (result) {
      _invalidateFolderProviders();
    }

    return result;
  }

  /// Update folder icon
  Future<bool> updateFolderIcon(String folderId, String? icon) async {
    final result = await _repository.updateFolderIcon(folderId, icon);

    if (result) {
      _invalidateFolderProviders();
    }

    return result;
  }

  /// Invalidate all folder-related providers
  void _invalidateFolderProviders() {
    _ref.invalidate(foldersProvider);
    _ref.invalidate(rootFoldersProvider);
    _ref.invalidate(foldersWithNoteCountsProvider);
    // Family providers will be automatically refreshed when accessed again
  }
}

/// Folder actions provider
final folderActionsProvider = Provider<FolderActions>((ref) {
  final repository = ref.watch(folderRepositoryProvider);
  return FolderActions(repository, ref);
});
