import 'package:ai_organizer/core/accessibility/semantic_labels.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:ai_organizer/data/models/note.dart';
import 'package:flutter/material.dart';

/// Variants for displaying a note card.
enum NoteCardVariant { list, grid }

/// Primary note card used in list and grid views.
/// Follows UI/UX guidelines for minimalist design with subtle shadows.
class NoteCard extends StatelessWidget {

  const NoteCard({
    super.key,
    required this.note,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
    this.trailing,
    this.compact = false,
    this.variant = NoteCardVariant.list,
    this.margin,
  });
  final Note note;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;
  final Widget? trailing;
  final bool compact;
  final NoteCardVariant variant;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Build comprehensive semantic label for screen readers
    final semanticLabel = SemanticLabels.noteCard(
      title: note.title.isNotEmpty ? note.title : 'Untitled',
      preview: note.content.isNotEmpty ? note.preview : null,
      tagCount: note.tags.length,
      isPinned: note.isPinned,
      isFavorite: note.isFavorite,
      isArchived: note.isArchived,
    );

    final EdgeInsetsGeometry effectiveMargin = margin ?? const EdgeInsets.symmetric(
      horizontal: AppSpacing.screenHorizontal,
      vertical: AppSpacing.listItemSpacing / 2,
    );

    return Semantics(
      label: semanticLabel,
      button: true,
      selected: isSelected,
      onTap: onTap,
      onLongPress: onLongPress,
      child: ExcludeSemantics(
        child: Container(
      margin: effectiveMargin,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: AppShadows.cardShadow,
        border: isSelected
            ? Border.all(color: colorScheme.primary, width: 2)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          splashColor: colorScheme.primary.withValues(alpha: 0.1),
          highlightColor: colorScheme.primary.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row (title + date + icons)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        note.title.isNotEmpty ? note.title : 'Untitled',
                        style: textTheme.titleLarge,
                        maxLines: compact ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    if (note.isPinned) ...[
                      Icon(
                        Icons.push_pin,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                    ],
                    if (note.isFavorite) ...[
                      Icon(
                        Icons.favorite,
                        size: 16,
                        color: colorScheme.error,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                    ],
                    if (trailing != null) trailing!,
                  ],
                ),

                // Preview content
                if (note.content.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    note.preview,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: compact ? 2 : 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                // Tags (if applicable)
                if (note.tags.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: note.tags.take(3).map((tag) => _buildTag(context, tag)).toList(),
                  ),
                ],

                // Footer with timestamp
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Text(
                      _formatDateTime(note.updatedAt),
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    if (note.wordCount > 0)
                      Text(
                        '${note.wordCount} words',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      ),
      ),
    );
  }

  Widget _buildTag(BuildContext context, String tag) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
      ),
      child: Text(
        '#$tag',
        style: textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) return 'Yesterday';
      if (difference.inDays < 7) return '${difference.inDays}d ago';
      if (difference.inDays < 30) return '${(difference.inDays / 7).floor()}w ago';
      if (difference.inDays < 365) return '${(difference.inDays / 30).floor()}mo ago';
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
