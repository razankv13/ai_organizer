import 'dart:io';

import 'package:ai_organizer/core/navigation/app_routes.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:ai_organizer/data/models/attachment.dart';
import 'package:ai_organizer/data/models/note.dart';
import 'package:ai_organizer/presentation/screens/sharing/share_note_screen.dart';
import 'package:ai_organizer/presentation/widgets/attachment_viewer.dart';
import 'package:ai_organizer/providers/backlink_provider.dart';
import 'package:ai_organizer/providers/database_provider.dart';
import 'package:ai_organizer/providers/folder_provider.dart';
import 'package:ai_organizer/providers/notes_provider.dart';
import 'package:ai_organizer/utils/backlink_parser.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Note detail screen - displays full note content with actions
/// Redesigned to follow UI/UX guidelines with clean, minimalist design
class NoteDetailScreen extends ConsumerStatefulWidget {
  const NoteDetailScreen({super.key, required this.noteId});

  final String noteId;

  @override
  ConsumerState<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends ConsumerState<NoteDetailScreen> {
  List<Attachment> _attachments = [];
  bool _attachmentsLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAttachments();
  }

  Future<void> _loadAttachments() async {
    try {
      final repository = ref.read(noteRepositoryProvider);
      final attachments = await repository.getAttachmentsForNote(widget.noteId);
      setState(() {
        _attachments = attachments;
        _attachmentsLoading = false;
      });
    } catch (e) {
      setState(() {
        _attachmentsLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteAsync = ref.watch(noteByIdProvider(widget.noteId));

    return noteAsync.when(
      data: (note) {
        if (note == null) {
          return _buildNotFoundScreen(context);
        }
        return _buildNoteDetailContent(context, ref, note);
      },
      loading: () => _buildLoadingScreen(context),
      error: (error, stackTrace) => _buildErrorScreen(context, error.toString(), ref),
    );
  }

  Widget _buildNoteDetailContent(BuildContext context, WidgetRef ref, Note note) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(note.title.isNotEmpty ? note.title : 'Note', style: textTheme.titleLarge),
        actions: [
          // Edit button
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push(AppRoutes.noteEdit(note.id)),
            tooltip: 'notes.edit'.tr(),
          ),
          // More actions menu
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showActionSheet(context, ref, note),
            tooltip: 'More actions',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main content card
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontal,
                vertical: AppSpacing.cardMargin,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                boxShadow: AppShadows.cardShadow,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    if (note.title.isNotEmpty) ...[
                      Text(
                        note.title,
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                    ],

                    // Timestamp
                    Row(
                      children: [
                        Text(
                          _formatDateTime(note.updatedAt),
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (note.folderId != null) ...[
                          const SizedBox(width: AppSpacing.sm),
                          _buildFolderBadge(context, note.folderId!),
                        ],
                      ],
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Content with clickable backlinks
                    if (note.content.isNotEmpty) ...[
                      SelectableText.rich(
                        BacklinkParser.buildTextSpanWithBacklinks(
                          note.content,
                          textTheme.bodyLarge?.copyWith(height: 1.6, color: colorScheme.onSurface),
                          textTheme.bodyLarge?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                          ),
                          (targetId) {
                            _navigateToLinkedNote(context, targetId);
                          },
                        ),
                      ),
                    ] else ...[
                      Text(
                        'This note is empty.',
                        style: textTheme.bodyLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],

                    // Tags
                    if (note.tags.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Wrap(
                        spacing: AppSpacing.xs,
                        runSpacing: AppSpacing.xs,
                        children: note.tags.map((tag) => _buildTagChip(context, tag)).toList(),
                      ),
                    ],

                    // Attachments
                    if (_attachments.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      const Divider(),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Icon(Icons.attach_file, size: 18, color: colorScheme.onSurfaceVariant),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            'Attachments',
                            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ..._attachments.map(
                        (attachment) => _buildAttachmentItem(context, attachment),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Related notes section
            _buildRelatedNotesSection(context, ref, note.id),

            // Backlinks section
            _buildBacklinksSection(context, ref, note.id),

            // Bottom spacing for FAB
            const SizedBox(height: AppSpacing.xxl * 2),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/notes/${note.id}/edit'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        tooltip: 'notes.edit'.tr(),
        child: const Icon(Icons.edit),
      ),
    );
  }

  /// Build tag chip following UI guidelines
  Widget _buildTagChip(BuildContext context, String tag) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xxs),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
      ),
      child: Text(
        '#$tag',
        style: textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
    );
  }

  /// Build folder badge
  Widget _buildFolderBadge(BuildContext context, String folderId) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final folderAsync = ref.watch(folderPathProvider(folderId));

    return folderAsync.when(
      data: (folderPath) {
        return GestureDetector(
          onTap: () => context.push(AppRoutes.notesWithFolder(folderId)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.outline, width: 1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.folder_outlined, size: 12, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(
                  folderPath.join(' > '),
                  style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  /// Build attachment item following UI guidelines
  Widget _buildAttachmentItem(BuildContext context, Attachment attachment) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final hasThumb = attachment.thumbnailPath != null && attachment.thumbnailPath!.isNotEmpty;
    final isImage = attachment.type == AttachmentType.image;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openAttachment(context, attachment),
          borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.outlineVariant, width: 1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
            ),
            child: Row(
              children: [
                // File preview/icon
                if (isImage && hasThumb) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                    child: Image.file(
                      File(attachment.thumbnailPath!),
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        _getAttachmentIcon(attachment),
                        color: colorScheme.onSurfaceVariant,
                        size: 40,
                      ),
                    ),
                  ),
                ] else ...[
                  Icon(
                    _getAttachmentIcon(attachment),
                    color: colorScheme.onSurfaceVariant,
                    size: 40,
                  ),
                ],

                const SizedBox(width: AppSpacing.sm),

                // File info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attachment.fileName,
                        style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        attachment.fileSizeFormatted,
                        style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),

                // Action icons
                Icon(Icons.open_in_new, size: 18, color: colorScheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build related notes section
  Widget _buildRelatedNotesSection(BuildContext context, WidgetRef ref, String noteId) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Consumer(
      builder: (context, ref, child) {
        final relatedNotesAsync = ref.watch(relatedNotesForNoteProvider(noteId));

        return relatedNotesAsync.when(
          data: (relatedNotes) {
            if (relatedNotes.isEmpty) {
              return const SizedBox.shrink();
            }

            return Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontal,
                vertical: AppSpacing.cardMargin,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                boxShadow: AppShadows.cardShadow,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.auto_awesome, size: 18, color: colorScheme.secondary),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'ai.relatedNotes'.tr(),
                          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ...relatedNotes.map((note) => _buildNoteListItem(context, note)),
                  ],
                ),
              ),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
    );
  }

  /// Build backlinks section
  Widget _buildBacklinksSection(BuildContext context, WidgetRef ref, String noteId) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Consumer(
      builder: (context, ref, child) {
        final backlinksAsync = ref.watch(incomingBacklinksProvider(noteId));

        return backlinksAsync.when(
          data: (backlinks) {
            if (backlinks.isEmpty) {
              return const SizedBox.shrink();
            }

            return Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontal,
                vertical: AppSpacing.cardMargin,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                boxShadow: AppShadows.cardShadow,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.link, size: 18, color: colorScheme.primary),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Backlinks',
                          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'Notes that link to this note',
                      style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ...backlinks.map((note) => _buildNoteListItem(context, note)),
                  ],
                ),
              ),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
    );
  }

  /// Build note list item for related notes and backlinks
  Widget _buildNoteListItem(BuildContext context, Note note) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push(AppRoutes.noteDetail(note.id)),
          borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.title.isNotEmpty ? note.title : 'Untitled',
                        style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (note.content.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          note.content,
                          style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Icon(Icons.arrow_forward_ios, size: 14, color: colorScheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Show dark action sheet following UI guidelines (lines 627-726)
  void _showActionSheet(BuildContext context, WidgetRef ref, Note note) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF3A3A3A), // Dark gray background
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16), // AppSpacing.radiusMd
          ),
          boxShadow: AppShadows.modalShadow,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle indicator
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: const Color(0xFF6B6B6B),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Action items
              _buildActionSheetItem(
                context,
                icon: note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                title: note.isPinned ? 'notes.unpin'.tr() : 'notes.pin'.tr(),
                onTap: () {
                  Navigator.of(context).pop();
                  final notesActions = ref.read(notesActionsProvider);
                  notesActions.togglePinNote(note.id);
                },
              ),

              _buildActionSheetItem(
                context,
                icon: note.isFavorite ? Icons.favorite : Icons.favorite_outline,
                title: note.isFavorite ? 'notes.unfavorite'.tr() : 'notes.favorite'.tr(),
                onTap: () {
                  Navigator.of(context).pop();
                  final notesActions = ref.read(notesActionsProvider);
                  notesActions.toggleFavoriteNote(note.id);
                },
              ),

              _buildActionSheetItem(
                context,
                icon: Icons.share,
                title: 'common.share'.tr(),
                onTap: () {
                  Navigator.of(context).pop();
                  _shareNote(context, note);
                },
              ),

              _buildActionSheetItem(
                context,
                icon: note.isArchived ? Icons.unarchive : Icons.archive,
                title: note.isArchived ? 'notes.unarchive'.tr() : 'notes.archive'.tr(),
                onTap: () {
                  Navigator.of(context).pop();
                  final notesActions = ref.read(notesActionsProvider);
                  notesActions.toggleArchiveNote(note.id);
                },
              ),

              _buildActionSheetItem(
                context,
                icon: Icons.file_download,
                title: 'Export Note',
                onTap: () {
                  Navigator.of(context).pop();
                  _exportNote(context, note);
                },
              ),

              _buildActionSheetItem(
                context,
                icon: Icons.delete,
                title: 'common.delete'.tr(),
                isDestructive: true,
                onTap: () {
                  Navigator.of(context).pop();
                  _confirmDeleteNote(context, ref, note);
                },
              ),

              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }

  /// Build action sheet item following UI guidelines
  Widget _buildActionSheetItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: isDestructive ? const Color(0xFFFF5454) : const Color(0xFFFFFFFF),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: isDestructive ? const Color(0xFFFF5454) : const Color(0xFFFFFFFF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getAttachmentIcon(Attachment attachment) {
    switch (attachment.type) {
      case AttachmentType.image:
        return Icons.image_outlined;
      case AttachmentType.document:
        return Icons.description_outlined;
      case AttachmentType.audio:
        return Icons.audiotrack;
      case AttachmentType.video:
        return Icons.videocam_outlined;
      case AttachmentType.other:
        return Icons.attach_file;
    }
  }

  void _openAttachment(BuildContext context, Attachment attachment) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => AttachmentViewer(attachment: attachment)));
  }

  Widget _buildLoadingScreen(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(backgroundColor: colorScheme.surface, title: const Text('Loading...')),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildNotFoundScreen(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(backgroundColor: colorScheme.surface, title: const Text('Note Not Found')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.note_outlined, size: 64, color: colorScheme.outlineVariant),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Note Not Found',
                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'This note may have been deleted or moved.',
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton.icon(
                onPressed: () => context.go(AppRoutes.notes),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Notes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorScreen(BuildContext context, String error, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(backgroundColor: colorScheme.surface, title: const Text('Error')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: colorScheme.error),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Error Loading Note',
                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                error,
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => context.go(AppRoutes.notes),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back to Notes'),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  FilledButton.icon(
                    onPressed: () => ref.invalidate(noteByIdProvider(widget.noteId)),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _shareNote(BuildContext context, Note note) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ShareNoteScreen(noteId: note.id, noteTitle: note.title),
      ),
    );
  }

  void _exportNote(BuildContext context, Note note) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export functionality coming soon'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _confirmDeleteNote(BuildContext context, WidgetRef ref, Note note) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('common.delete'.tr()),
        content: const Text(
          'Are you sure you want to delete this note? This action cannot be undone.',
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

              if (context.mounted) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Note deleted successfully'),
                      backgroundColor: colorScheme.primary,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  context.go(AppRoutes.notes);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Failed to delete note'),
                      backgroundColor: colorScheme.error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
            style: FilledButton.styleFrom(backgroundColor: colorScheme.error),
            child: Text('common.delete'.tr()),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  /// Navigate to a linked note by ID or title
  Future<void> _navigateToLinkedNote(BuildContext context, String targetId) async {
    final repository = ref.read(noteRepositoryProvider);

    // Try to find by ID first
    Note? targetNote = await repository.getNoteById(targetId);

    // If not found, search by title
    if (targetNote == null) {
      final allNotes = await repository.getAllNotes();
      try {
        targetNote = allNotes.firstWhere(
          (note) => note.title.toLowerCase() == targetId.toLowerCase(),
        );
      } catch (_) {
        // Try partial match
        try {
          targetNote = allNotes.firstWhere(
            (note) => note.title.toLowerCase().contains(targetId.toLowerCase()),
          );
        } catch (_) {
          // Note not found
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Note "$targetId" not found')));
          }
          return;
        }
      }
    }

    // Navigate to the note
    if (context.mounted) {
      await context.push(AppRoutes.noteDetail(targetNote.id));
    }
  }
}
