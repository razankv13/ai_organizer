import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ai_organizer/data/models/link_preview.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';

/// Widget to display rich link preview cards
/// Shows title, description, image, and domain with tap-to-open functionality
class LinkPreviewWidget extends StatelessWidget {
  const LinkPreviewWidget({
    super.key,
    required this.preview,
    this.onTap,
    this.showImage = true,
    this.compact = false,
  });

  /// The link preview data to display
  final LinkPreview preview;

  /// Optional callback when preview is tapped
  /// If null, opens URL in browser
  final VoidCallback? onTap;

  /// Whether to show the preview image
  final bool showImage;

  /// Whether to use compact layout
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: InkWell(
        onTap: onTap ?? () => _launchUrl(preview.url),
        child: compact
            ? _buildCompactLayout(context)
            : _buildFullLayout(context),
      ),
    );
  }

  /// Build full layout with image
  Widget _buildFullLayout(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image section
        if (showImage && preview.hasImage)
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              preview.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.broken_image_outlined,
                  size: 48,
                  color: colorScheme.outline,
                ),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),

        // Content section
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Domain
              Row(
                children: [
                  Icon(Icons.language, size: 14, color: colorScheme.secondary),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      preview.shortDomain,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.secondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.open_in_new, size: 14, color: colorScheme.outline),
                ],
              ),

              const SizedBox(height: AppSpacing.xs),

              // Title
              Text(
                preview.displayTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Description
              if (preview.hasDescription) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  preview.description!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// Build compact horizontal layout
  Widget _buildCompactLayout(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: [
          // Thumbnail
          if (showImage && preview.hasImage)
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSmall),
              child: Image.network(
                preview.imageUrl!,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.broken_image_outlined,
                    size: 32,
                    color: colorScheme.outline,
                  ),
                ),
              ),
            ),

          const SizedBox(width: AppSpacing.md),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Domain
                Row(
                  children: [
                    Icon(
                      Icons.language,
                      size: 12,
                      color: colorScheme.secondary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        preview.shortDomain,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.secondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xs),

                // Title
                Text(
                  preview.displayTitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                // Description (optional in compact mode)
                if (preview.hasDescription) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    preview.description!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // External link icon
          Icon(Icons.open_in_new, size: 16, color: colorScheme.outline),
        ],
      ),
    );
  }

  /// Launch URL in browser
  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}

/// Loading placeholder for link preview
class LinkPreviewLoading extends StatelessWidget {
  const LinkPreviewLoading({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: compact
            ? Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.borderRadiusSmall,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 12,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Container(
                          width: 120,
                          height: 10,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    width: 200,
                    height: 12,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    width: double.infinity,
                    height: 10,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
