import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_organizer/data/models/attachment.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:ai_organizer/providers/ai_provider.dart';

/// Widget for viewing attachments (images, documents, etc.)
class AttachmentViewer extends ConsumerWidget {
  const AttachmentViewer({
    super.key,
    required this.attachment,
    this.onClose,
  });

  final Attachment attachment;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text(
          attachment.fileName,
          style: textTheme.titleLarge,
        ),
        actions: [
          if (attachment.type == AttachmentType.image)
            IconButton(
              icon: const Icon(Icons.auto_awesome),
              tooltip: 'Analyze with AI',
              onPressed: () => _showAiAnalysis(context, ref),
            ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareAttachment(context),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportAttachment(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // File viewer
            Expanded(
              child: _buildFileViewer(context, ref),
            ),

            // File info footer
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: colorScheme.outlineVariant,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    attachment.fileName,
                    style: textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      _buildInfoChip(
                        context,
                        Icons.insert_drive_file,
                        attachment.fileSizeFormatted,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _buildInfoChip(
                        context,
                        Icons.category,
                        attachment.type.name.toUpperCase(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileViewer(BuildContext context, WidgetRef ref) {
    switch (attachment.type) {
      case AttachmentType.image:
        return _buildImageViewer(context, ref);
      case AttachmentType.document:
        return _buildDocumentViewer(context);
      case AttachmentType.audio:
        return _buildAudioViewer(context);
      case AttachmentType.video:
        return _buildVideoViewer(context);
      case AttachmentType.other:
        return _buildGenericViewer(context);
    }
  }

  Widget _buildImageViewer(BuildContext context, WidgetRef ref) {
    final file = File(attachment.filePath);

    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 3.0,
      child: Center(
        child: Image.file(
          file,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorView(context, 'Failed to load image');
          },
        ),
      ),
    );
  }

  Widget _buildDocumentViewer(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description,
            size: 64,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Document Viewer',
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Tap the button below to open this document',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildPrimaryButton(
            context,
            onPressed: () => _openExternalViewer(context),
            icon: Icons.open_in_new,
            label: 'Open Document',
          ),
        ],
      ),
    );
  }

  Widget _buildAudioViewer(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.audiotrack,
            size: 64,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Audio Player',
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Audio playback coming soon',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildPrimaryButton(
            context,
            onPressed: () => _openExternalViewer(context),
            icon: Icons.play_arrow,
            label: 'Play Audio',
          ),
        ],
      ),
    );
  }

  Widget _buildVideoViewer(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.videocam,
            size: 64,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Video Player',
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Video playback coming soon',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildPrimaryButton(
            context,
            onPressed: () => _openExternalViewer(context),
            icon: Icons.play_arrow,
            label: 'Play Video',
          ),
        ],
      ),
    );
  }

  Widget _buildGenericViewer(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.attach_file,
            size: 64,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'File Viewer',
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'This file type cannot be previewed in the app',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildPrimaryButton(
            context,
            onPressed: () => _openExternalViewer(context),
            icon: Icons.open_in_new,
            label: 'Open File',
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Center(
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
            'Error',
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.error,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            message,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Primary button following UI guidelines
  Widget _buildPrimaryButton(
    BuildContext context, {
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
        ),
      ),
    );
  }

  void _shareAttachment(BuildContext context) {
    // TODO: Implement sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing coming soon')),
    );
  }

  void _exportAttachment(BuildContext context) {
    // TODO: Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export coming soon')),
    );
  }

  void _openExternalViewer(BuildContext context) {
    // TODO: Implement external viewer opening
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('External viewer opening coming soon')),
    );
  }

  /// Show AI analysis sheet for image
  void _showAiAnalysis(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AiAnalysisSheet(
        attachment: attachment,
      ),
    );
  }
}

/// AI analysis sheet for images - Dark themed modal following UI guidelines
class _AiAnalysisSheet extends ConsumerStatefulWidget {
  const _AiAnalysisSheet({
    required this.attachment,
  });

  final Attachment attachment;

  @override
  ConsumerState<_AiAnalysisSheet> createState() => _AiAnalysisSheetState();
}

class _AiAnalysisSheetState extends ConsumerState<_AiAnalysisSheet> {
  bool _isAnalyzing = false;
  Map<String, dynamic>? _analysisResults;

  @override
  void initState() {
    super.initState();
    _analyzeImage();
  }

  Future<void> _analyzeImage() async {
    setState(() {
      _isAnalyzing = true;
    });

    try {
      final aiService = ref.read(aiServiceProvider);
      final results = await aiService.analyzeImage(File(widget.attachment.filePath));

      setState(() {
        _analysisResults = results;
        _isAnalyzing = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error analyzing image: $e'),
            backgroundColor: const Color(0xFFFF5454),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF3A3A3A), // Dark background as per guidelines
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusMd),
            ),
            boxShadow: AppShadows.modalShadow,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6B6B6B),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Title
                  Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        color: Color(0xFF007AFF),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'AI Image Analysis',
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.35,
                          height: 1.3,
                          color: const Color(0xFFFFFFFF),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Color(0xFFFFFFFF),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Content
                  Expanded(
                    child: _isAnalyzing
                        ? _buildLoadingView(context)
                        : _analysisResults != null
                            ? _buildResultsView(context, scrollController)
                            : _buildErrorView(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF007AFF)),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Analyzing image with AI...',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.15,
              height: 1.4,
              color: const Color(0xFFFFFFFF),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'This may take a few moments',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.25,
              height: 1.5,
              color: const Color(0xFFE0E0E0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsView(BuildContext context, ScrollController scrollController) {
    final summary = _analysisResults?['summary'] as String? ?? 'No summary available';
    final tags = _analysisResults?['tags'] as List<String>? ?? <String>[];
    final category = _analysisResults?['category'] as String? ?? 'uncategorized';
    final text = _analysisResults?['text'] as String? ?? '';

    return ListView(
      controller: scrollController,
      children: [
        // Summary
        Text(
          'Summary',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.15,
            height: 1.4,
            color: const Color(0xFFFFFFFF),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildResultCard(
          child: Text(
            summary,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.25,
              height: 1.5,
              color: const Color(0xFFE0E0E0),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // Category
        Text(
          'Category',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.15,
            height: 1.4,
            color: const Color(0xFFFFFFFF),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildResultCard(
          child: Row(
            children: [
              const Icon(
                Icons.category,
                color: Color(0xFF007AFF),
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                category.toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: const Color(0xFFE0E0E0),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // Tags with AI indicator
        Row(
          children: [
            Text(
              'Suggested Tags',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.15,
                height: 1.4,
                color: const Color(0xFFFFFFFF),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            _buildAITag(),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (tags.isEmpty)
          _buildResultCard(
            child: Text(
              'No tags generated',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.25,
                height: 1.5,
                color: const Color(0xFFE0E0E0),
              ),
            ),
          )
        else
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF505050),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.tag,
                      color: Color(0xFF007AFF),
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '#$tag',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFE0E0E0),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

        if (text.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),

          // Extracted text
          Text(
            'Extracted Text',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.15,
              height: 1.4,
              color: const Color(0xFFFFFFFF),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildResultCard(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.25,
                height: 1.5,
                color: const Color(0xFFE0E0E0),
              ),
            ),
          ),
        ],

        const SizedBox(height: AppSpacing.xl),

        // Apply to note button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () => _applyToNote(context),
            icon: const Icon(Icons.note_add, size: 20),
            label: Text(
              'Apply to Note',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007AFF),
              foregroundColor: Colors.white,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.md),
      ],
    );
  }

  Widget _buildResultCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFF505050),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: child,
    );
  }

  /// AI tag indicator following UI guidelines
  Widget _buildAITag() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1A3A52), // Dark blue background for dark theme
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
        border: Border.all(
          color: const Color(0xFF007AFF).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.auto_awesome,
            size: 12,
            color: Color(0xFF007AFF),
          ),
          const SizedBox(width: 4),
          Text(
            'AI',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF007AFF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Color(0xFFFF5454),
            size: 64,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Analysis Failed',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.35,
              height: 1.3,
              color: const Color(0xFFFFFFFF),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Unable to analyze this image. Please try again later.',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.25,
              height: 1.5,
              color: const Color(0xFFE0E0E0),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _analyzeImage,
              icon: const Icon(Icons.refresh, size: 20),
              label: Text(
                'Try Again',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF),
                foregroundColor: Colors.white,
                elevation: 0,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.sm,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _applyToNote(BuildContext context) {
    // This will be implemented later to apply the tags and extracted text to the note
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Analysis results applied to note'),
        backgroundColor: const Color(0xFF34C759),
      ),
    );
  }
}
