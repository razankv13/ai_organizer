import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_organizer/data/models/folder.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:ai_organizer/providers/folder_provider.dart';

/// Widget for displaying folders in a hierarchical tree structure
class FolderTree extends ConsumerStatefulWidget {
  const FolderTree({
    super.key,
    this.onFolderTap,
    this.onFolderLongPress,
    this.selectedFolderId,
    this.showNoteCounts = true,
  });

  final Function(Folder)? onFolderTap;
  final Function(Folder)? onFolderLongPress;
  final String? selectedFolderId;
  final bool showNoteCounts;

  @override
  ConsumerState<FolderTree> createState() => _FolderTreeState();
}

class _FolderTreeState extends ConsumerState<FolderTree> {
  final Set<String> _expandedFolders = {};

  @override
  Widget build(BuildContext context) {
    final foldersAsync = widget.showNoteCounts
        ? ref.watch(foldersWithNoteCountsProvider)
        : ref.watch(foldersProvider).whenData((folders) =>
            folders.map((f) => {'folder': f, 'noteCount': 0}).toList());

    return foldersAsync.when(
      data: (foldersData) {
        // Extract root folders
        final rootFolders = foldersData
            .where((data) => (data['folder'] as Folder).parentId == null)
            .toList();

        if (rootFolders.isEmpty) {
          return _buildEmptyState(context);
        }

        return ListView.builder(
          itemCount: rootFolders.length,
          itemBuilder: (context, index) {
            return _buildFolderItem(
              context,
              rootFolders[index],
              foldersData,
              0,
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text('Error loading folders: $error'),
      ),
    );
  }

  Widget _buildFolderItem(
    BuildContext context,
    Map<String, dynamic> folderData,
    List<Map<String, dynamic>> allFoldersData,
    int depth,
  ) {
    final folder = folderData['folder'] as Folder;
    final noteCount = folderData['noteCount'] as int;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Get child folders
    final childFolders = allFoldersData
        .where((data) => (data['folder'] as Folder).parentId == folder.id)
        .toList();

    final hasChildren = childFolders.isNotEmpty;
    final isExpanded = _expandedFolders.contains(folder.id);
    final isSelected = widget.selectedFolderId == folder.id;

    // Parse folder color
    Color? folderColor;
    if (folder.color != null) {
      try {
        folderColor = Color(int.parse(folder.color!.replaceFirst('#', '0xFF')));
      } catch (e) {
        folderColor = null;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Folder item
        InkWell(
          onTap: () => widget.onFolderTap?.call(folder),
          onLongPress: () => widget.onFolderLongPress?.call(folder),
          child: Container(
            padding: EdgeInsets.only(
              left: AppSpacing.md + (depth * AppSpacing.lg),
              right: AppSpacing.md,
              top: AppSpacing.sm,
              bottom: AppSpacing.sm,
            ),
            color: isSelected
                ? colorScheme.primaryContainer.withValues(alpha: 0.3)
                : null,
            child: Row(
              children: [
                // Expand/collapse icon (if has children)
                if (hasChildren) ...[
                  IconButton(
                    icon: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isExpanded) {
                          _expandedFolders.remove(folder.id);
                        } else {
                          _expandedFolders.add(folder.id);
                        }
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ] else ...[
                  const SizedBox(width: 32),
                ],

                const SizedBox(width: AppSpacing.xs),

                // Folder icon
                Icon(
                  _getFolderIcon(folder.icon),
                  color: folderColor ?? colorScheme.primary,
                  size: 20,
                ),

                const SizedBox(width: AppSpacing.sm),

                // Folder name
                Expanded(
                  child: Text(
                    folder.displayName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Note count badge
                if (widget.showNoteCounts && noteCount > 0) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(AppSpacing.xs),
                    ),
                    child: Text(
                      noteCount.toString(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Child folders (if expanded)
        if (hasChildren && isExpanded)
          ...childFolders.map((childData) => _buildFolderItem(
                context,
                childData,
                allFoldersData,
                depth + 1,
              )),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_outlined,
              size: 64,
              color: colorScheme.outline,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No Folders Yet',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Create your first folder to organize your notes',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getFolderIcon(String? icon) {
    if (icon == null || icon.isEmpty) {
      return Icons.folder;
    }

    // Map icon names to IconData
    final iconMap = {
      'folder': Icons.folder,
      'folder_open': Icons.folder_open,
      'folder_special': Icons.folder_special,
      'work': Icons.work,
      'school': Icons.school,
      'home': Icons.home,
      'favorite': Icons.favorite,
      'star': Icons.star,
      'bookmark': Icons.bookmark,
      'label': Icons.label,
      'category': Icons.category,
    };

    return iconMap[icon] ?? Icons.folder;
  }
}

/// Simple folder picker widget
class FolderPicker extends ConsumerWidget {
  const FolderPicker({
    super.key,
    this.selectedFolderId,
    required this.onFolderSelected,
    this.showRootOption = true,
  });

  final String? selectedFolderId;
  final Function(String? folderId) onFolderSelected;
  final bool showRootOption;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Text(
            'Select Folder',
            style: theme.textTheme.titleMedium,
          ),
        ),
        if (showRootOption)
          ListTile(
            leading: const Icon(Icons.folder_outlined),
            title: const Text('No Folder (Root)'),
            selected: selectedFolderId == null,
            onTap: () => onFolderSelected(null),
          ),
        Expanded(
          child: FolderTree(
            selectedFolderId: selectedFolderId,
            showNoteCounts: false,
            onFolderTap: (folder) => onFolderSelected(folder.id),
          ),
        ),
      ],
    );
  }
}
