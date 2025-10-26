import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_organizer/core/navigation/app_routes.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:ai_organizer/providers/folder_provider.dart';
import 'package:ai_organizer/providers/notes_provider.dart';
import 'package:ai_organizer/data/models/note.dart';
import 'package:ai_organizer/presentation/widgets/note_card.dart';
import 'package:ai_organizer/presentation/widgets/app_search_bar.dart';
import 'package:ai_organizer/presentation/widgets/simple_tab_bar.dart';
import 'package:ai_organizer/presentation/widgets/action_sheet.dart';
import 'package:ai_organizer/presentation/widgets/skeletons/note_list_skeleton.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Notes list screen - displays all notes with search and filtering
/// Redesigned to strictly follow UI/UX guidelines
class NotesListScreen extends ConsumerStatefulWidget {
  const NotesListScreen({super.key, this.folderId});

  final String? folderId;

  @override
  ConsumerState<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends ConsumerState<NotesListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  NoteFilterOption _filterOption = NoteFilterOption.all;
  NoteSortOption _sortOption = NoteSortOption.updatedDesc;
  bool _isGridView = false;

  // Selection mode state
  bool _isSelectionMode = false;
  final Set<String> _selectedNoteIds = {};

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    unawaited(_loadPrefs());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final notesAsync = _searchQuery.isNotEmpty
        ? ref.watch(searchNotesProvider(_searchQuery))
        : (widget.folderId != null && _filterOption == NoteFilterOption.all)
            ? ref.watch(notesByFolderProvider(widget.folderId))
            : _getFilteredNotesProvider();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar.large(
                pinned: true,
                backgroundColor: colorScheme.surface,
                leading: _isSelectionMode
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            _isSelectionMode = false;
                            _selectedNoteIds.clear();
                          });
                        },
                      )
                    : null,
                title: _isSelectionMode
                    ? Text(
                        '${_selectedNoteIds.length} selected',
                        style: textTheme.titleLarge,
                      )
                    : widget.folderId != null
                        ? _buildFolderTitle(context)
                        : Text(
                            'navigation.notes'.tr(),
                            style: textTheme.displaySmall,
                          ),
                actions: [
                  if (!_isSelectionMode) ...[
                    IconButton(
                      tooltip: _isGridView ? 'notes.view.list'.tr() : 'notes.view.grid'.tr(),
                      icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
                      onPressed: () async {
                        await HapticFeedback.selectionClick();
                        setState(() => _isGridView = !_isGridView);
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('notes.isGridView', _isGridView);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () => _showOptionsMenu(context),
                    ),
                  ] else ...[
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () => _showBatchActionsMenu(context),
                    ),
                  ],
                ],
              ),

              if (widget.folderId != null && _searchQuery.isEmpty)
                SliverToBoxAdapter(child: _buildFolderBreadcrumb(context)),

              SliverPersistentHeader(
                pinned: true,
                delegate: _PinnedHeaderDelegate(
                  minExtent: 68,
                  maxExtent: 76,
                  child: Container(
                    color: colorScheme.surface,
                    padding: const EdgeInsets.only(
                      top: AppSpacing.xs,
                      bottom: AppSpacing.xs,
                    ),
                    child: AppSearchBar(
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenHorizontal,
                        vertical: AppSpacing.xs,
                      ),
                      controller: _searchController,
                      hintText: 'notes.searchPlaceholder'.tr(),
                      onChanged: (value) => _onSearchChanged(),
                    ),
                  ),
                ),
              ),

              if (widget.folderId == null && _searchQuery.isEmpty)
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _PinnedHeaderDelegate(
                    minExtent: 56,
                    maxExtent: 56,
                    child: Container(
                      color: colorScheme.surface,
                      padding: const EdgeInsets.only(
                        left: AppSpacing.screenHorizontal,
                        right: AppSpacing.screenHorizontal,
                        bottom: AppSpacing.sm,
                      ),
                      child: SimpleTabBar(
                        tabs: [
                          'notes.all'.tr(),
                          'notes.pinned'.tr(),
                          'notes.favorites'.tr(),
                          'notes.archived'.tr(),
                        ],
                        selectedIndex: _filterOption.index,
                        onTabSelected: (index) async {
                          await HapticFeedback.selectionClick();
                          setState(() {
                            _filterOption = NoteFilterOption.values[index];
                          });
                        },
                      ),
                    ),
                  ),
                ),

              // Content
              ...notesAsync.when(
                data: (notes) => _buildNotesSlivers(context, notes),
                loading: () => [
                  SliverToBoxAdapter(
                    child: NoteListSkeleton(isGrid: _isGridView),
                  ),
                ],
                error: (error, stackTrace) => [
                  SliverToBoxAdapter(
                    child: _buildErrorState(context, error.toString()),
                  ),
                ],
              ),

              // Add bottom space for FAB
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xxxl * 2),
              ),
            ],
          ),

          // Selection bottom action bar
          if (_isSelectionMode)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenHorizontal,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    boxShadow: AppShadows.modalShadow,
                    border: Border(
                      top: BorderSide(color: colorScheme.outlineVariant),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: 'Pin/Unpin',
                        icon: const Icon(Icons.push_pin),
                        onPressed: _batchTogglePin,
                      ),
                      IconButton(
                        tooltip: 'Archive/Unarchive',
                        icon: const Icon(Icons.archive),
                        onPressed: _batchToggleArchive,
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: 'Tags',
                        icon: const Icon(Icons.label),
                        onPressed: () => _showBatchTagPicker(context),
                      ),
                      IconButton(
                        tooltip: 'Move to Folder',
                        icon: const Icon(Icons.folder),
                        onPressed: () => _showBatchFolderPicker(context),
                      ),
                      IconButton(
                        tooltip: 'Delete',
                        icon: const Icon(Icons.delete),
                        onPressed: () => _confirmBatchDelete(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.noteCreate),
        tooltip: 'notes.create'.tr(),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  AsyncValue<List<Note>> _getFilteredNotesProvider() {
    switch (_filterOption) {
      case NoteFilterOption.all:
        return ref.watch(notesProvider);
      case NoteFilterOption.pinned:
        return ref.watch(pinnedNotesProvider);
      case NoteFilterOption.favorites:
        return ref.watch(favoriteNotesProvider);
      case NoteFilterOption.archived:
        return ref.watch(archivedNotesProvider);
    }
  }

  Widget _buildFolderBreadcrumb(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Icon(
            Icons.folder,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'Showing notes in:',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final folderAsync =
                    ref.watch(folderByIdProvider(widget.folderId!));
                return folderAsync.when(
                  data: (folder) => Chip(
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    label: Text(
                      folder?.name ?? 'Unknown',
                      style: textTheme.labelMedium,
                    ),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => context.go(AppRoutes.notes),
                  ),
                  loading: () => Chip(
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    label: Text('Loading...', style: textTheme.labelMedium),
                  ),
                  error: (_, __) => Chip(
                    backgroundColor: colorScheme.errorContainer,
                    label: Text('Error', style: textTheme.labelMedium),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildNotesSlivers(BuildContext context, List<Note> notes) {
    if (notes.isEmpty) {
      return [SliverToBoxAdapter(child: _buildEmptyState(context))];
    }

    final sortedNotes = _applySorting(notes);

    // If filtering "all", split into pinned and others
    if (_filterOption == NoteFilterOption.all && _searchQuery.isEmpty) {
      final pinned = sortedNotes.where((n) => n.isPinned).toList();
      final others = sortedNotes.where((n) => !n.isPinned).toList();
      return [
        if (pinned.isNotEmpty) ...[
          _buildSectionHeader(context, 'sections.pinned'.tr()),
          ..._buildNotesSliverList(context, pinned),
        ],
        _buildSectionHeader(context, 'notes.all'.tr()),
        ..._buildNotesSliverList(context, others),
      ];
    }

    // For other filters, render as a single list/grid
    return _buildNotesSliverList(context, sortedNotes);
  }

  List<Widget> _buildNotesSliverList(BuildContext context, List<Note> items) {
    final listPadding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.screenHorizontal,
      vertical: AppSpacing.sm,
    );

    if (_isGridView) {
      final width = MediaQuery.of(context).size.width;
      final crossAxisCount = width >= 900
          ? 4
          : width >= 700
              ? 3
              : 2;
      return [
        SliverPadding(
          padding: listPadding.copyWith(bottom: AppSpacing.xxxl * 2),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
              childAspectRatio: 3 / 2,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final note = items[index];
                final isSelected = _selectedNoteIds.contains(note.id);
                return _buildDismissible(
                  note: note,
                  child: NoteCard(
                    note: note,
                    isSelected: isSelected,
                    compact: true,
                    variant: NoteCardVariant.grid,
                    margin: EdgeInsets.zero,
                    onTap: () async {
                      await HapticFeedback.selectionClick();
                      if (_isSelectionMode) {
                        _toggleNoteSelection(note.id);
                      } else {
                        context.push(AppRoutes.noteDetail(note.id));
                      }
                    },
                    onLongPress: () async {
                      await HapticFeedback.selectionClick();
                      if (!_isSelectionMode) {
                        setState(() {
                          _isSelectionMode = true;
                          _selectedNoteIds.add(note.id);
                        });
                      }
                    },
                    trailing: _isSelectionMode
                        ? Checkbox(
                            value: isSelected,
                            onChanged: (_) async {
                              await HapticFeedback.selectionClick();
                              _toggleNoteSelection(note.id);
                            },
                          )
                        : IconButton(
                            icon: const Icon(Icons.more_vert),
                            iconSize: 20,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: AppSpacing.minTouchTarget,
                              minHeight: AppSpacing.minTouchTarget,
                            ),
                            onPressed: () => _showNoteActions(context, note),
                          ),
                  ),
                );
              },
              childCount: items.length,
            ),
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: listPadding.copyWith(bottom: AppSpacing.xxxl * 2),
        sliver: SliverList.separated(
          itemBuilder: (context, index) {
          final note = items[index];
          final isSelected = _selectedNoteIds.contains(note.id);
          return _buildDismissible(
            note: note,
            child: NoteCard(
              note: note,
              isSelected: isSelected,
              onTap: () async {
                await HapticFeedback.selectionClick();
                if (_isSelectionMode) {
                  _toggleNoteSelection(note.id);
                } else {
                  context.push('/notes/${note.id}');
                }
              },
              onLongPress: () async {
                await HapticFeedback.selectionClick();
                if (!_isSelectionMode) {
                  setState(() {
                    _isSelectionMode = true;
                    _selectedNoteIds.add(note.id);
                  });
                }
              },
              trailing: _isSelectionMode
                  ? Checkbox(
                      value: isSelected,
                      onChanged: (_) async {
                        await HapticFeedback.selectionClick();
                        _toggleNoteSelection(note.id);
                      },
                    )
                  : IconButton(
                      icon: const Icon(Icons.more_vert),
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: AppSpacing.minTouchTarget,
                        minHeight: AppSpacing.minTouchTarget,
                      ),
                      onPressed: () => _showNoteActions(context, note),
                    ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
        itemCount: items.length,
        ),
      ),
    ];
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenHorizontal,
          AppSpacing.md,
          AppSpacing.screenHorizontal,
          AppSpacing.xs,
        ),
        child: Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildDismissible({required Note note, required Widget child}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Dismissible(
      key: ValueKey('note-${note.id}'),
      background: _buildSwipeBackground(
        colorScheme.primaryContainer,
        Icons.push_pin,
        Alignment.centerLeft,
      ),
      secondaryBackground: _buildSwipeBackground(
        colorScheme.errorContainer,
        note.isArchived ? Icons.unarchive : Icons.archive,
        Alignment.centerRight,
      ),
      confirmDismiss: (direction) async {
        if (_isSelectionMode) return false; // disable during selection
        if (direction == DismissDirection.startToEnd) {
          await _togglePin(note);
          return false; // Don't actually dismiss
        } else {
          await _toggleArchive(note);
          return false;
        }
      },
      child: child,
    );
  }

  Widget _buildSwipeBackground(Color color, IconData icon, Alignment alignment) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      alignment: alignment,
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
      child: Icon(icon, color: colorScheme.onPrimaryContainer),
    );
  }

  Future<void> _togglePin(Note note) async {
    final notesActions = ref.read(notesActionsProvider);
    final previous = note.isPinned;
    await HapticFeedback.mediumImpact();
    await notesActions.togglePinNote(note.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(previous ? 'notes.actions.unpin'.tr() : 'notes.actions.pin'.tr()),
        action: SnackBarAction(
          label: 'notes.undo'.tr(),
          onPressed: () async {
            await notesActions.togglePinNote(note.id);
          },
        ),
      ),
    );
  }

  Future<void> _toggleArchive(Note note) async {
    final notesActions = ref.read(notesActionsProvider);
    final previous = note.isArchived;
    await HapticFeedback.mediumImpact();
    await notesActions.toggleArchiveNote(note.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(previous ? 'notes.unarchive'.tr() : 'notes.archive'.tr()),
        action: SnackBarAction(
          label: 'notes.undo'.tr(),
          onPressed: () async {
            await notesActions.toggleArchiveNote(note.id);
          },
        ),
      ),
    );
  }

  void _toggleNoteSelection(String noteId) {
    setState(() {
      if (_selectedNoteIds.contains(noteId)) {
        _selectedNoteIds.remove(noteId);
        if (_selectedNoteIds.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedNoteIds.add(noteId);
      }
    });
  }

  List<Note> _applySorting(List<Note> notes) {
    final sortedNotes = List<Note>.from(notes);

    switch (_sortOption) {
      case NoteSortOption.updatedDesc:
        sortedNotes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
      case NoteSortOption.updatedAsc:
        sortedNotes.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
        break;
      case NoteSortOption.createdDesc:
        sortedNotes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case NoteSortOption.createdAsc:
        sortedNotes.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case NoteSortOption.titleAsc:
        sortedNotes.sort(
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case NoteSortOption.titleDesc:
        sortedNotes.sort(
            (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
        break;
    }

    return sortedNotes;
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getEmptyStateIcon(),
              size: 64,
              color: colorScheme.outlineVariant,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              _getEmptyStateTitle(),
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              _getEmptyStateDescription(),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (_filterOption == NoteFilterOption.all &&
                _searchQuery.isEmpty) ...[
              const SizedBox(height: AppSpacing.xl),
              FilledButton.icon(
                onPressed: () => context.push(AppRoutes.noteCreate),
                icon: const Icon(Icons.add),
                label: Text('notes.create'.tr()),
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getEmptyStateIcon() {
    if (_searchQuery.isNotEmpty) return Icons.search_off;
    switch (_filterOption) {
      case NoteFilterOption.all:
        return Icons.note_outlined;
      case NoteFilterOption.pinned:
        return Icons.push_pin_outlined;
      case NoteFilterOption.favorites:
        return Icons.favorite_outline;
      case NoteFilterOption.archived:
        return Icons.archive_outlined;
    }
  }

  String _getEmptyStateTitle() {
    if (_searchQuery.isNotEmpty) return 'notes.noSearchResults'.tr();
    switch (_filterOption) {
      case NoteFilterOption.all:
        return 'notes.empty'.tr();
      case NoteFilterOption.pinned:
        return 'notes.noPinned'.tr();
      case NoteFilterOption.favorites:
        return 'notes.noFavorites'.tr();
      case NoteFilterOption.archived:
        return 'notes.noArchived'.tr();
    }
  }

  String _getEmptyStateDescription() {
    if (_searchQuery.isNotEmpty) return 'notes.tryDifferentSearch'.tr();
    switch (_filterOption) {
      case NoteFilterOption.all:
        return 'notes.emptyDescription'.tr();
      case NoteFilterOption.pinned:
        return 'notes.noPinnedDescription'.tr();
      case NoteFilterOption.favorites:
        return 'notes.noFavoritesDescription'.tr();
      case NoteFilterOption.archived:
        return 'notes.noArchivedDescription'.tr();
    }
  }

  // (kept as reference; currently using inline skeletons in slivers)

  Widget _buildErrorState(BuildContext context, String error) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Error loading notes',
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              error,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              onPressed: () {
                ref.invalidate(notesProvider);
                ref.invalidate(searchNotesProvider(_searchQuery));
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNoteActions(BuildContext context, Note note) {
    ActionSheet.show(
      context: context,
      title: note.title.isNotEmpty ? note.title : 'Untitled',
      items: [
        ActionSheetItem(
          title: 'notes.edit'.tr(),
          icon: Icons.edit,
          onTap: () => context.push(AppRoutes.noteEdit(note.id)),
        ),
        ActionSheetItem(
          title: note.isPinned ? 'notes.unpin'.tr() : 'notes.pin'.tr(),
          icon: note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
          onTap: () async {
            final notesActions = ref.read(notesActionsProvider);
            await notesActions.togglePinNote(note.id);
          },
        ),
        ActionSheetItem(
          title: note.isFavorite
              ? 'notes.unfavorite'.tr()
              : 'notes.favorite'.tr(),
          icon: note.isFavorite ? Icons.favorite : Icons.favorite_outline,
          onTap: () async {
            final notesActions = ref.read(notesActionsProvider);
            await notesActions.toggleFavoriteNote(note.id);
          },
        ),
        ActionSheetItem(
          title:
              note.isArchived ? 'notes.unarchive'.tr() : 'notes.archive'.tr(),
          icon: note.isArchived ? Icons.unarchive : Icons.archive,
          onTap: () async {
            final notesActions = ref.read(notesActionsProvider);
            await notesActions.toggleArchiveNote(note.id);
          },
        ),
        ActionSheetItem(
          title: 'common.share'.tr(),
          icon: Icons.share,
          onTap: () => _shareNote(note),
        ),
        ActionSheetItem(
          title: 'common.delete'.tr(),
          icon: Icons.delete,
          isDestructive: true,
          onTap: () => _confirmDeleteNote(context, note),
        ),
      ],
    );
  }

  void _showBatchActionsMenu(BuildContext context) {
    ActionSheet.show(
      context: context,
      title: 'Batch Actions (${_selectedNoteIds.length} selected)',
      items: [
        ActionSheetItem(
          title: 'Pin/Unpin',
          icon: Icons.push_pin,
          onTap: () => _batchTogglePin(),
        ),
        ActionSheetItem(
          title: 'Archive/Unarchive',
          icon: Icons.archive,
          onTap: () => _batchToggleArchive(),
        ),
        ActionSheetItem(
          title: 'Add Tags',
          icon: Icons.label,
          onTap: () => _showBatchTagPicker(context),
        ),
        ActionSheetItem(
          title: 'Move to Folder',
          icon: Icons.folder,
          onTap: () => _showBatchFolderPicker(context),
        ),
        ActionSheetItem(
          title: 'Delete',
          icon: Icons.delete,
          isDestructive: true,
          onTap: () => _confirmBatchDelete(context),
        ),
      ],
    );
  }

  void _showOptionsMenu(BuildContext context) {
    ActionSheet.show(
      context: context,
      title: 'Options',
      items: [
        ActionSheetItem(
          title: 'Sort by: ${_sortOption.label.tr()}',
          icon: Icons.sort,
          onTap: () => _showSortOptions(context),
        ),
        ActionSheetItem(
          title: 'Export Notes',
          icon: Icons.import_export,
          onTap: () {
            // TODO: Implement export functionality
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Export coming soon')),
            );
          },
        ),
        ActionSheetItem(
          title: 'common.settings'.tr(),
          icon: Icons.settings,
          onTap: () => context.push(AppRoutes.settings),
        ),
      ],
    );
  }

  void _showSortOptions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenHorizontal,
              AppSpacing.md,
              AppSpacing.screenHorizontal,
              AppSpacing.md,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sort By', style: textTheme.titleLarge),
                const SizedBox(height: AppSpacing.sm),
                ...NoteSortOption.values.map((option) {
                  final isSelected = option == _sortOption;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(option.label.tr(), style: textTheme.bodyLarge),
                    trailing: isSelected ? Icon(Icons.check, color: colorScheme.primary) : null,
                    onTap: () async {
                      await HapticFeedback.selectionClick();
                      setState(() => _sortOption = option);
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('notes.sort', option.name);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isGrid = prefs.getBool('notes.isGridView');
    final sortName = prefs.getString('notes.sort');
    if (!mounted) return;
    setState(() {
      if (isGrid != null) _isGridView = isGrid;
      if (sortName != null) {
        final match = NoteSortOption.values.where((e) => e.name == sortName);
        if (match.isNotEmpty) _sortOption = match.first;
      }
    });
  }

  void _shareNote(Note note) {
    // TODO: Implement actual sharing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality coming soon')),
    );
  }

  void _confirmDeleteNote(BuildContext context, Note note) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        title: Text('common.delete'.tr(), style: textTheme.titleLarge),
        content: Text(
          'Are you sure you want to delete this note?',
          style: textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('common.cancel'.tr()),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final notesActions = ref.read(notesActionsProvider);
              final success = await notesActions.deleteNote(note.id);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Note deleted successfully'
                          : 'Failed to delete note',
                    ),
                    backgroundColor: success
                        ? colorScheme.primaryContainer
                        : colorScheme.errorContainer,
                  ),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            child: Text('common.delete'.tr()),
          ),
        ],
      ),
    );
  }

  // Batch Operations

  void _confirmBatchDelete(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final count = _selectedNoteIds.length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        title: Text('Delete Notes', style: textTheme.titleLarge),
        content: Text(
          'Are you sure you want to delete $count note${count > 1 ? 's' : ''}?',
          style: textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('common.cancel'.tr()),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final notesActions = ref.read(notesActionsProvider);

              int successCount = 0;
              for (final noteId in _selectedNoteIds) {
                final success = await notesActions.deleteNote(noteId);
                if (success) successCount++;
              }

              setState(() {
                _isSelectionMode = false;
                _selectedNoteIds.clear();
              });

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Deleted $successCount of $count note${count > 1 ? 's' : ''}',
                    ),
                    backgroundColor: successCount == count
                        ? colorScheme.primaryContainer
                        : colorScheme.errorContainer,
                  ),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            child: Text('common.delete'.tr()),
          ),
        ],
      ),
    );
  }

  Future<void> _batchToggleArchive() async {
    final notesActions = ref.read(notesActionsProvider);
    final count = _selectedNoteIds.length;

    int successCount = 0;
    for (final noteId in _selectedNoteIds) {
      final success = await notesActions.toggleArchiveNote(noteId);
      if (success) successCount++;
    }

    setState(() {
      _isSelectionMode = false;
      _selectedNoteIds.clear();
    });

    if (mounted) {
      final colorScheme = Theme.of(context).colorScheme;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Updated $successCount of $count note${count > 1 ? 's' : ''}',
          ),
          backgroundColor: successCount == count
              ? colorScheme.primaryContainer
              : colorScheme.errorContainer,
        ),
      );
    }
  }

  Future<void> _batchTogglePin() async {
    final notesActions = ref.read(notesActionsProvider);
    final count = _selectedNoteIds.length;

    int successCount = 0;
    for (final noteId in _selectedNoteIds) {
      final success = await notesActions.togglePinNote(noteId);
      if (success) successCount++;
    }

    setState(() {
      _isSelectionMode = false;
      _selectedNoteIds.clear();
    });

    if (mounted) {
      final colorScheme = Theme.of(context).colorScheme;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Updated $successCount of $count note${count > 1 ? 's' : ''}',
          ),
          backgroundColor: successCount == count
              ? colorScheme.primaryContainer
              : colorScheme.errorContainer,
        ),
      );
    }
  }

  void _showBatchTagPicker(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final TextEditingController tagController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        title: Text('Add Tags', style: textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add tags to ${_selectedNoteIds.length} note${_selectedNoteIds.length > 1 ? 's' : ''}',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: tagController,
              style: textTheme.bodyLarge,
              decoration: InputDecoration(
                labelText: 'Tags (comma-separated)',
                hintText: 'work, important, project',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('common.cancel'.tr()),
          ),
          FilledButton(
            onPressed: () async {
              final tagsText = tagController.text.trim();
              if (tagsText.isEmpty) {
                Navigator.of(context).pop();
                return;
              }

              Navigator.of(context).pop();

              final tags = tagsText
                  .split(',')
                  .map((t) => t.trim())
                  .where((t) => t.isNotEmpty)
                  .toList();
              if (tags.isEmpty) return;

              final notesActions = ref.read(notesActionsProvider);
              final count = _selectedNoteIds.length;

              int successCount = 0;
              final notesAsync = ref.read(notesProvider);
              await notesAsync.when(
                data: (notes) async {
                  for (final noteId in _selectedNoteIds) {
                    try {
                      final note = notes.firstWhere((n) => n.id == noteId);
                      final updatedTags = {...note.tags, ...tags}.toList();
                      final updatedNote = note.copyWith(tags: updatedTags);
                      final success = await notesActions.updateNote(updatedNote);
                      if (success) successCount++;
                    } catch (e) {
                      continue;
                    }
                  }
                },
                loading: () {},
                error: (_, __) {},
              );

              setState(() {
                _isSelectionMode = false;
                _selectedNoteIds.clear();
              });

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added tags to $successCount of $count note${count > 1 ? 's' : ''}',
                    ),
                    backgroundColor: successCount == count
                        ? colorScheme.primaryContainer
                        : colorScheme.errorContainer,
                  ),
                );
              }
            },
            child: const Text('Add Tags'),
          ),
        ],
      ),
    );
  }

  void _showBatchFolderPicker(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: SizedBox(
          height: 500,
          width: 400,
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppSpacing.radiusMd),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Move ${_selectedNoteIds.length} note${_selectedNoteIds.length > 1 ? 's' : ''} to folder',
                        style: textTheme.titleMedium,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              // "No Folder" option
              ListTile(
                leading: Icon(Icons.folder_off, color: colorScheme.onSurface),
                title: Text('No Folder', style: textTheme.bodyLarge),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _batchMoveToFolder(null);
                },
              ),

              Divider(color: colorScheme.outlineVariant),

              // Folder list
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final foldersAsync = ref.watch(foldersProvider);

                    return foldersAsync.when(
                      data: (folders) {
                        if (folders.isEmpty) {
                          return Center(
                            child: Text(
                              'No folders available',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: folders.length,
                          itemBuilder: (context, index) {
                            final folder = folders[index];
                            return ListTile(
                              leading: Icon(
                                Icons.folder,
                                color: colorScheme.primary,
                              ),
                              title: Text(folder.name, style: textTheme.bodyLarge),
                              onTap: () async {
                                Navigator.of(context).pop();
                                await _batchMoveToFolder(folder.id);
                              },
                            );
                          },
                        );
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (error, _) => Center(
                        child: Text(
                          'Error: $error',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _batchMoveToFolder(String? folderId) async {
    final notesActions = ref.read(notesActionsProvider);
    final count = _selectedNoteIds.length;

    int successCount = 0;
    final notesAsync = ref.read(notesProvider);
    await notesAsync.when(
      data: (notes) async {
        for (final noteId in _selectedNoteIds) {
          try {
            final note = notes.firstWhere((n) => n.id == noteId);
            final updatedNote = note.copyWith(folderId: folderId);
            final success = await notesActions.updateNote(updatedNote);
            if (success) successCount++;
          } catch (e) {
            continue;
          }
        }
      },
      loading: () {},
      error: (_, __) {},
    );

    setState(() {
      _isSelectionMode = false;
      _selectedNoteIds.clear();
    });

    if (mounted) {
      final colorScheme = Theme.of(context).colorScheme;
      final folderName = folderId == null ? 'root' : 'folder';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Moved $successCount of $count note${count > 1 ? 's' : ''} to $folderName',
          ),
          backgroundColor: successCount == count
              ? colorScheme.primaryContainer
              : colorScheme.errorContainer,
        ),
      );
    }
  }

  Widget _buildFolderTitle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final folderAsync = ref.watch(folderByIdProvider(widget.folderId!));

    return folderAsync.when(
      data: (folder) {
        if (folder == null) {
          return Text('Unknown Folder', style: textTheme.titleLarge);
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder,
              size: 20,
              color: colorScheme.primary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: Text(
                folder.name,
                style: textTheme.titleLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      },
      loading: () => Text('Loading...', style: textTheme.titleLarge),
      error: (_, __) => Text('Error', style: textTheme.titleLarge),
    );
  }
}

class _PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  _PinnedHeaderDelegate({required this.minExtent, required this.maxExtent, required this.child});

  @override
  final double minExtent;
  @override
  final double maxExtent;

  final Widget child;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _PinnedHeaderDelegate oldDelegate) {
    return oldDelegate.child != child || oldDelegate.minExtent != minExtent || oldDelegate.maxExtent != maxExtent;
  }
}

/// Filter options for notes
enum NoteFilterOption {
  all,
  pinned,
  favorites,
  archived;

  String get label {
    switch (this) {
      case NoteFilterOption.all:
        return 'notes.all';
      case NoteFilterOption.pinned:
        return 'notes.pinned';
      case NoteFilterOption.favorites:
        return 'notes.favorites';
      case NoteFilterOption.archived:
        return 'notes.archived';
    }
  }
}

/// Sort options for notes
enum NoteSortOption {
  updatedDesc,
  updatedAsc,
  createdDesc,
  createdAsc,
  titleAsc,
  titleDesc;

  String get label {
    switch (this) {
      case NoteSortOption.updatedDesc:
        return 'notes.sort.updatedDesc';
      case NoteSortOption.updatedAsc:
        return 'notes.sort.updatedAsc';
      case NoteSortOption.createdDesc:
        return 'notes.sort.createdDesc';
      case NoteSortOption.createdAsc:
        return 'notes.sort.createdAsc';
      case NoteSortOption.titleAsc:
        return 'notes.sort.titleAsc';
      case NoteSortOption.titleDesc:
        return 'notes.sort.titleDesc';
    }
  }
}
