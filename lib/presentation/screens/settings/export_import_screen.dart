import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:ai_organizer/providers/export_import_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Screen for exporting and importing notes
class ExportImportScreen extends ConsumerStatefulWidget {
  const ExportImportScreen({super.key});

  @override
  ConsumerState<ExportImportScreen> createState() => _ExportImportScreenState();
}

class _ExportImportScreenState extends ConsumerState<ExportImportScreen> {
  ExportFormat _selectedExportFormat = ExportFormat.json;
  bool _exportAllNotes = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Extract theme data once at the top
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Export & Import',
          style: textTheme.titleLarge,
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontal,
          vertical: AppSpacing.screenVertical,
        ),
        children: [
          _buildExportSection(colorScheme, textTheme),
          const SizedBox(height: AppSpacing.xl),
          _buildImportSection(colorScheme, textTheme),
          const SizedBox(height: AppSpacing.xl),
          _buildBackupSection(colorScheme, textTheme),
        ],
      ),
    );
  }

  Widget _buildExportSection(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.cardMargin),
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
            // Header
            Row(
              children: [
                Icon(
                  Icons.upload_outlined,
                  color: colorScheme.primary,
                  size: AppSpacing.iconSize,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Export Notes',
                  style: textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Export your notes to various formats',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Format selector
            _buildFormatSelector(colorScheme, textTheme),
            const SizedBox(height: AppSpacing.lg),

            // Export all switch
            _buildCustomSwitch(
              colorScheme: colorScheme,
              textTheme: textTheme,
              title: 'Export all notes',
              subtitle: 'If disabled, only selected notes will be exported',
              value: _exportAllNotes,
              onChanged: (value) {
                setState(() {
                  _exportAllNotes = value;
                });
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            // Export button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleExport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  disabledBackgroundColor: colorScheme.onSurface.withOpacity(0.12),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
                child: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.download, size: 20),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            'Export',
                            style: textTheme.labelLarge?.copyWith(
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatSelector(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Export Format',
          style: textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: ExportFormat.values.map((format) {
            final isSelected = _selectedExportFormat == format;
            return _buildCustomChoiceChip(
              colorScheme: colorScheme,
              textTheme: textTheme,
              label: format.displayName,
              icon: format.icon,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  _selectedExportFormat = format;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCustomChoiceChip({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primaryContainer
                : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outline.withOpacity(0.5),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                label,
                style: textTheme.labelMedium?.copyWith(
                  color: isSelected
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomSwitch({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.titleSmall,
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                subtitle,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: colorScheme.primary,
        ),
      ],
    );
  }

  Widget _buildImportSection(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.cardMargin),
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
            // Header
            Row(
              children: [
                Icon(
                  Icons.download_outlined,
                  color: colorScheme.primary,
                  size: AppSpacing.iconSize,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Import Notes',
                  style: textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Import notes from JSON or Markdown files',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Import from JSON button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: _isLoading ? null : () => _handleImport(ImportFormat.json),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  side: BorderSide(color: colorScheme.outline, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.file_upload, size: 20),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Import from JSON',
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Import from Markdown button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: _isLoading ? null : () => _handleImport(ImportFormat.markdown),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  side: BorderSide(color: colorScheme.outline, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.file_upload, size: 20),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Import from Markdown',
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackupSection(ColorScheme colorScheme, TextTheme textTheme) {
    final backupsAsync = ref.watch(backupListProvider);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.cardMargin),
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
            // Header
            Row(
              children: [
                Icon(
                  Icons.backup_outlined,
                  color: colorScheme.primary,
                  size: AppSpacing.iconSize,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Backup & Restore',
                  style: textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Create full backups of your app data or restore from existing backups',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Create backup button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleCreateBackup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  disabledBackgroundColor: colorScheme.onSurface.withOpacity(0.12),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
                child: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.backup, size: 20),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            'Create Backup',
                            style: textTheme.labelLarge?.copyWith(
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Backup list
            backupsAsync.when(
              data: (backups) {
                if (backups.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Text(
                        'No backups available',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Backups',
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ...backups.map((backup) =>
                      _buildBackupItem(colorScheme, textTheme, backup)
                    ),
                  ],
                );
              },
              loading: () => Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: CircularProgressIndicator(
                    color: colorScheme.primary,
                  ),
                ),
              ),
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(
                    'Error loading backups: $error',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackupItem(
    ColorScheme colorScheme,
    TextTheme textTheme,
    BackupInfo backup,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
              ),
              child: Icon(
                Icons.folder_outlined,
                size: AppSpacing.iconSize,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    backup.filename,
                    style: textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    '${backup.formattedSize} • ${backup.formattedDate}',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    '${backup.notesCount} notes • ${backup.tagsCount} tags',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Actions
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Restore button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _handleRestoreBackup(backup),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      child: Icon(
                        Icons.restore,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xxs),
                // Delete button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _handleDeleteBackup(backup),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      child: Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: colorScheme.error,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Handlers

  Future<void> _handleExport() async {
    setState(() => _isLoading = true);

    try {
      final result = await ref.read(exportImportProvider.notifier).exportNotes(
            format: _selectedExportFormat,
            exportAll: _exportAllNotes,
          );

      if (result != null && mounted) {
        // Share the exported file
        await Share.shareXFiles(
          [XFile(result.path)],
          subject: 'Exported Notes',
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notes exported successfully')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleImport(ImportFormat format) async {
    try {
      // Pick file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: format == ImportFormat.json ? ['json'] : ['md'],
      );

      if (result == null || result.files.isEmpty) return;

      setState(() => _isLoading = true);

      final filePath = result.files.first.path;
      if (filePath == null) {
        throw Exception('File path is null');
      }

      final importResult = await ref.read(exportImportProvider.notifier).importNotes(
            filePath: filePath,
            format: format,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Imported ${importResult.notesImported} notes, '
              '${importResult.tagsImported} tags',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Import failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleCreateBackup() async {
    setState(() => _isLoading = true);

    try {
      final result = await ref.read(exportImportProvider.notifier).createBackup();

      if (result.success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Backup created: ${result.notesCount} notes, '
              '${result.tagsCount} tags',
            ),
          ),
        );

        // Refresh backup list
        ref.invalidate(backupListProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Backup failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleRestoreBackup(BackupInfo backup) async {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        title: Text(
          'Restore Backup?',
          style: textTheme.titleLarge,
        ),
        content: Text(
          'This will restore ${backup.notesCount} notes and ${backup.tagsCount} tags. '
          'Existing data will not be deleted, but duplicates may occur.',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.onSurfaceVariant,
            ),
            child: Text(
              'Cancel',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
            ),
            child: Text(
              'Restore',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      final result = await ref
          .read(exportImportProvider.notifier)
          .restoreBackup(backup.filePath);

      if (result.success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Restored ${result.notesRestored} notes, '
              '${result.tagsRestored} tags',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Restore failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleDeleteBackup(BackupInfo backup) async {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        title: Text(
          'Delete Backup?',
          style: textTheme.titleLarge,
        ),
        content: Text(
          'This action cannot be undone.',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.onSurfaceVariant,
            ),
            child: Text(
              'Cancel',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
            ),
            child: Text(
              'Delete',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onError,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(exportImportProvider.notifier).deleteBackup(backup.filePath);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup deleted')),
        );

        // Refresh backup list
        ref.invalidate(backupListProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delete failed: $e')),
        );
      }
    }
  }
}

/// Export format enum
enum ExportFormat {
  json,
  markdown,
  html,
  pdf;

  String get displayName {
    switch (this) {
      case ExportFormat.json:
        return 'JSON';
      case ExportFormat.markdown:
        return 'Markdown';
      case ExportFormat.html:
        return 'HTML';
      case ExportFormat.pdf:
        return 'PDF';
    }
  }

  IconData get icon {
    switch (this) {
      case ExportFormat.json:
        return Icons.code;
      case ExportFormat.markdown:
        return Icons.text_fields;
      case ExportFormat.html:
        return Icons.web;
      case ExportFormat.pdf:
        return Icons.picture_as_pdf;
    }
  }
}

/// Import format enum
enum ImportFormat {
  json,
  markdown;
}
