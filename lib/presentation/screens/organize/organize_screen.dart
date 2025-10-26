import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:ai_organizer/data/models/folder.dart';
import 'package:ai_organizer/presentation/widgets/action_sheet.dart';
import 'package:ai_organizer/presentation/widgets/app_search_bar.dart';
import 'package:ai_organizer/presentation/widgets/app_text_field.dart';
import 'package:ai_organizer/presentation/widgets/empty_state.dart';
import 'package:ai_organizer/presentation/widgets/folder_tree.dart';
import 'package:ai_organizer/presentation/widgets/simple_tab_bar.dart';
import 'package:ai_organizer/providers/folder_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OrganizeScreen extends ConsumerStatefulWidget {
  const OrganizeScreen({super.key});

  @override
  ConsumerState<OrganizeScreen> createState() => _OrganizeScreenState();
}

class _OrganizeScreenState extends ConsumerState<OrganizeScreen> {
  int _selectedTabIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text('organize.title'.tr(), style: textTheme.headlineMedium),
      ),
      body: Column(
        children: [
          const SizedBox(height: AppSpacing.sm),

          // Custom tab bar
          SimpleTabBar(
            tabs: ['organize.folders'.tr(), 'organize.tags'.tr()],
            selectedIndex: _selectedTabIndex,
            onTabSelected: (index) {
              setState(() {
                _selectedTabIndex = index;
                _searchQuery = '';
                _searchController.clear();
              });
            },
          ),

          const SizedBox(height: AppSpacing.md),

          // Tab content
          Expanded(
            child: _selectedTabIndex == 0 ? _buildFoldersTab(context) : _buildTagsTab(context),
          ),
        ],
      ),
      floatingActionButton: _selectedTabIndex == 0
          ? FloatingActionButton(
              onPressed: () => _showCreateFolderDialog(context),
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              elevation: 4,
              child: const Icon(Icons.create_new_folder),
            )
          : null,
    );
  }

  Widget _buildFoldersTab(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        // Search bar
        AppSearchBar(
          controller: _searchController,
          hintText: 'Search folders...',
          onChanged: (value) {
            setState(() {
              _searchQuery = value.toLowerCase();
            });
          },
        ),

        const SizedBox(height: AppSpacing.sm),

        // All Notes card
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            boxShadow: AppShadows.cardShadow,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                context.go('/notes');
              },
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Icon(
                      Icons.folder_outlined,
                      color: colorScheme.primary,
                      size: AppSpacing.iconSize,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(child: Text('All Notes', style: textTheme.titleMedium)),
                    Icon(Icons.arrow_forward_ios, size: 16, color: colorScheme.onSurfaceVariant),
                  ],
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        // Folder tree
        Expanded(
          child: FolderTree(
            showNoteCounts: true,
            onFolderTap: (folder) {
              context.go('/notes?folderId=${folder.id}');
            },
            onFolderLongPress: (folder) {
              _showFolderOptionsBottomSheet(context, folder);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTagsTab(BuildContext context) {
    return EmptyState(
      icon: Icons.label_outlined,
      title: 'Tag Management',
      message: 'Tag management features coming soon.\nStay tuned for updates!',
    );
  }

  void _showCreateFolderDialog(BuildContext context) {
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            boxShadow: AppShadows.modalShadow,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Create Folder', style: textTheme.titleLarge),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  controller: nameController,
                  labelText: 'Folder Name',
                  hintText: 'Enter folder name',
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a folder name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(foregroundColor: colorScheme.onSurfaceVariant),
                      child: Text(
                        'Cancel',
                        style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    FilledButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final actions = ref.read(folderActionsProvider);
                          try {
                            await actions.createFolder(name: nameController.text.trim());
                            if (context.mounted) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Folder created successfully'),
                                  backgroundColor: colorScheme.primary,
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error creating folder: $e'),
                                  backgroundColor: colorScheme.error,
                                ),
                              );
                            }
                          }
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                      ),
                      child: Text('Create', style: textTheme.labelLarge),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFolderOptionsBottomSheet(BuildContext context, Folder folder) {
    ActionSheet.show(
      context: context,
      items: [
        ActionSheetItem(
          title: 'Rename',
          icon: Icons.edit,
          onTap: () => _showRenameFolderDialog(context, folder),
        ),
        ActionSheetItem(
          title: 'Move',
          icon: Icons.drive_file_move,
          onTap: () => _showMoveFolderDialog(context, folder),
        ),
        ActionSheetItem(
          title: 'Change Color',
          icon: Icons.color_lens,
          onTap: () => _showColorPickerDialog(context, folder),
        ),
        ActionSheetItem(
          title: 'Delete',
          icon: Icons.delete,
          isDestructive: true,
          onTap: () => _showDeleteConfirmationDialog(context, folder),
        ),
      ],
    );
  }

  void _showRenameFolderDialog(BuildContext context, Folder folder) {
    final nameController = TextEditingController(text: folder.name);
    final formKey = GlobalKey<FormState>();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            boxShadow: AppShadows.modalShadow,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rename Folder', style: textTheme.titleLarge),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  controller: nameController,
                  labelText: 'Folder Name',
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a folder name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(foregroundColor: colorScheme.onSurfaceVariant),
                      child: Text(
                        'Cancel',
                        style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    FilledButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final actions = ref.read(folderActionsProvider);
                          try {
                            await actions.renameFolder(folder.id, nameController.text.trim());
                            if (context.mounted) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Folder renamed successfully'),
                                  backgroundColor: colorScheme.primary,
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error renaming folder: $e'),
                                  backgroundColor: colorScheme.error,
                                ),
                              );
                            }
                          }
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                      ),
                      child: Text('Rename', style: textTheme.labelLarge),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMoveFolderDialog(BuildContext context, Folder folder) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
        child: Container(
          height: 500,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            boxShadow: AppShadows.modalShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Move "${folder.name}" to', style: textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              const Divider(),
              Expanded(
                child: FolderTree(
                  selectedFolderId: folder.parentId,
                  showNoteCounts: false,
                  onFolderTap: (targetFolder) async {
                    final actions = ref.read(folderActionsProvider);
                    try {
                      await actions.moveFolder(folder.id, targetFolder.id);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Folder moved successfully'),
                            backgroundColor: colorScheme.primary,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e'), backgroundColor: colorScheme.error),
                        );
                      }
                    }
                  },
                ),
              ),
              const Divider(),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.onSurface,
                        side: BorderSide(color: colorScheme.outline),
                      ),
                      child: Text('Cancel', style: textTheme.labelLarge),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: FilledButton(
                      onPressed: () async {
                        final actions = ref.read(folderActionsProvider);
                        try {
                          await actions.moveFolder(folder.id, null);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Moved to root'),
                                backgroundColor: colorScheme.primary,
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: colorScheme.error,
                              ),
                            );
                          }
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                      ),
                      child: Text('Move to Root', style: textTheme.labelLarge),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showColorPickerDialog(BuildContext context, Folder folder) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final colors = [
      {'name': 'Default', 'value': null, 'color': colorScheme.primary},
      {'name': 'Red', 'value': '#F44336', 'color': const Color(0xFFF44336)},
      {'name': 'Pink', 'value': '#E91E63', 'color': const Color(0xFFE91E63)},
      {'name': 'Purple', 'value': '#9C27B0', 'color': const Color(0xFF9C27B0)},
      {'name': 'Blue', 'value': '#2196F3', 'color': const Color(0xFF2196F3)},
      {'name': 'Green', 'value': '#4CAF50', 'color': const Color(0xFF4CAF50)},
      {'name': 'Orange', 'value': '#FF9800', 'color': const Color(0xFFFF9800)},
      {'name': 'Brown', 'value': '#795548', 'color': const Color(0xFF795548)},
    ];

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            boxShadow: AppShadows.modalShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Choose Color', style: textTheme.titleLarge),
              const SizedBox(height: AppSpacing.lg),
              ...colors.map((colorData) {
                final colorValue = colorData['value'] as String?;
                final colorName = colorData['name'] as String;
                final displayColor = colorData['color'] as Color;

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      final actions = ref.read(folderActionsProvider);
                      try {
                        await actions.updateFolderColor(folder.id, colorValue);
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Color updated'),
                              backgroundColor: colorScheme.primary,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $e'),
                              backgroundColor: colorScheme.error,
                            ),
                          );
                        }
                      }
                    },
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                        horizontal: AppSpacing.xs,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: displayColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: colorScheme.outline, width: 1),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Text(colorName, style: textTheme.bodyLarge),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Folder folder) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            boxShadow: AppShadows.modalShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.warning_rounded, color: colorScheme.error, size: 28),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Delete Folder',
                    style: textTheme.titleLarge?.copyWith(color: colorScheme.error),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Are you sure you want to delete "${folder.name}"?\n\nNotes in this folder will be moved to the root.',
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(foregroundColor: colorScheme.onSurfaceVariant),
                    child: Text(
                      'Cancel',
                      style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  FilledButton(
                    onPressed: () async {
                      final actions = ref.read(folderActionsProvider);
                      try {
                        await actions.deleteFolder(folder.id);
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Folder deleted'),
                              backgroundColor: colorScheme.primary,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $e'),
                              backgroundColor: colorScheme.error,
                            ),
                          );
                        }
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.error,
                      foregroundColor: colorScheme.onError,
                    ),
                    child: Text('Delete', style: textTheme.labelLarge),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
