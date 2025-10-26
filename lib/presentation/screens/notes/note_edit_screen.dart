import 'dart:io';

import 'package:ai_organizer/core/navigation/app_routes.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:ai_organizer/data/models/attachment.dart';
import 'package:ai_organizer/data/models/note.dart';
import 'package:ai_organizer/presentation/widgets/folder_tree.dart';
import 'package:ai_organizer/providers/ai_provider.dart';
import 'package:ai_organizer/providers/database_provider.dart';
import 'package:ai_organizer/providers/folder_provider.dart';
import 'package:ai_organizer/providers/notes_provider.dart';
import 'package:ai_organizer/utils/file_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

/// Note edit screen - for creating and editing notes
class NoteEditScreen extends ConsumerStatefulWidget {
  const NoteEditScreen({super.key, this.noteId});

  final String? noteId;

  @override
  ConsumerState<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends ConsumerState<NoteEditScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _contentFocus = FocusNode();

  List<String> _tags = [];
  final Set<String> _aiSuggestedTags = {}; // Track AI-suggested tags
  final List<File> _pendingAttachments = [];
  List<Attachment> _existingAttachments = [];
  bool _isLoading = false;
  bool _hasUnsavedChanges = false;
  Note? _originalNote;
  String? _selectedFolderId;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_onContentChanged);
    _contentController.addListener(_onContentChanged);

    // Add focus listeners to rebuild when focus changes
    _titleFocus.addListener(() => setState(() {}));
    _contentFocus.addListener(() => setState(() {}));

    if (widget.noteId != null) {
      _loadNote();
    } else {
      // Auto-focus title for new notes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _titleFocus.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    _titleFocus.dispose();
    _contentFocus.dispose();
    super.dispose();
  }

  void _onContentChanged() {
    setState(() {
      _hasUnsavedChanges = true;
    });
  }

  Future<void> _loadNote() async {
    if (widget.noteId == null) return;

    setState(() => _isLoading = true);

    try {
      final noteRepository = ref.read(noteRepositoryProvider);
      final note = await noteRepository.getNoteById(widget.noteId!);

      if (note != null) {
        setState(() {
          _originalNote = note;
          _titleController.text = note.title;
          _contentController.text = note.content;
          _tags = List.from(note.tags);
          _selectedFolderId = note.folderId;
          _hasUnsavedChanges = false;
        });

        // Load existing attachments
        final attachments = await noteRepository.getAttachmentsForNote(note.id);
        setState(() {
          _existingAttachments = attachments;
        });
      }
    } catch (e) {
      if (mounted) {
        final colorScheme = Theme.of(context).colorScheme;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading note: $e'),
            backgroundColor: colorScheme.errorContainer,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvoked: (didPop) {
        if (!didPop && _hasUnsavedChanges) {
          _showUnsavedChangesDialog();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5), // #F5F5F5 light gray background
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildPremiumHeader(context),
                  Expanded(child: _buildEditor(context)),
                ],
              ),
        floatingActionButton: _hasUnsavedChanges ? _buildPremiumFAB(context) : null,
      ),
    );
  }

  /// Premium custom header with precise styling
  Widget _buildPremiumHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: const Color(0xFFF5F5F5), // Match screen background
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: AppSpacing.md,
      ),
      child: Row(
        children: [
          // Back button (44x44 touch target)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (_hasUnsavedChanges) {
                  _showUnsavedChangesDialog();
                } else {
                  context.pop();
                }
              },
              borderRadius: BorderRadius.circular(22),
              child: Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.arrow_back,
                  size: 24,
                  color: Color(0xFF1A1A1A), // Near-black
                ),
              ),
            ),
          ),

          const SizedBox(width: AppSpacing.sm),

          // "Create Note" title (34pt Bold)
          Expanded(
            child: Text(
              widget.noteId == null ? 'Create Note' : 'Edit Note',
              style: textTheme.displayLarge?.copyWith(
                fontSize: 34,
                fontWeight: FontWeight.w700, // Bold
                letterSpacing: 0.4,
                color: const Color(0xFF1A1A1A), // Near-black
              ),
            ),
          ),

          // Action icons row
          Row(
            children: [
              // Folder icon (44x44 touch target)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _showFolderPicker,
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    child: const Icon(Icons.folder_outlined, size: 24, color: Color(0xFF1A1A1A)),
                  ),
                ),
              ),

              // Camera icon (44x44 touch target)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _pickImage(ImageSource.camera),
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      size: 24,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
              ),

              // Paperclip icon (44x44 touch target)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _showAttachmentOptions,
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    child: const Icon(Icons.attach_file, size: 24, color: Color(0xFF1A1A1A)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Premium FAB with precise sizing and shadow
  Widget _buildPremiumFAB(BuildContext context) {
    return AnimatedScale(
      scale: _isLoading ? 0.95 : 1.0,
      duration: AppSpacing.fastAnimation,
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: Color(0xFF007AFF), // iOS blue
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x14000000), // 8% black
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _isLoading ? null : _saveNote,
            borderRadius: BorderRadius.circular(28),
            child: Center(
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.save, size: 24, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  /// Premium input container with white background, shadow, and focus state
  Widget _buildInputContainer(
    BuildContext context, {
    required Widget child,
    required bool isFocused,
  }) {
    return AnimatedContainer(
      duration: AppSpacing.fastAnimation,
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(AppSpacing.md), // 16dp padding
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF), // White background
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm), // 12dp radius
        border: Border.all(
          color: isFocused
              ? const Color(0xFF007AFF) // #007AFF focused
              : const Color(0xFFE8E8E8), // #E8E8E8 unfocused
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000), // 4% black
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildEditor(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.md), // 16dp top spacing
          // Title input container
          _buildInputContainer(
            context,
            child: TextField(
              controller: _titleController,
              focusNode: _titleFocus,
              decoration: const InputDecoration(
                hintText: 'Note title',
                hintStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFB0B0B0), // #B0B0B0 placeholder
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600, // Semi-bold
                color: Color(0xFF1A1A1A), // Near-black
                height: 1.4,
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: 2,
            ),
            isFocused: _titleFocus.hasFocus,
          ),

          const SizedBox(height: AppSpacing.md), // 16dp gap
          // Content input container
          _buildInputContainer(
            context,
            child: TextField(
              controller: _contentController,
              focusNode: _contentFocus,
              decoration: const InputDecoration(
                hintText: 'Start writing...',
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFB0B0B0), // #B0B0B0 placeholder
                  height: 1.5,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400, // Regular
                color: Color(0xFF1A1A1A), // Near-black
                height: 1.5,
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: null,
              minLines: 10,
            ),
            isFocused: _contentFocus.hasFocus,
          ),

          const SizedBox(height: AppSpacing.xxl), // 32dp gap
          // Attachments section
          if (_existingAttachments.isNotEmpty || _pendingAttachments.isNotEmpty) ...[
            _buildAttachmentsSection(context),
            const SizedBox(height: AppSpacing.lg),
          ],

          // Compact Folder section
          _buildCompactFolderSection(context),

          const SizedBox(height: AppSpacing.xl), // 24dp gap
          // Compact Tags section
          _buildCompactTagsSection(context),

          // Bottom spacing
          const SizedBox(height: AppSpacing.xxl * 2),
        ],
      ),
    );
  }

  /// Compact premium folder section
  Widget _buildCompactFolderSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row: Icon, Label, Choose Folder button
        Row(
          children: [
            // Folder icon (24x24)
            const Icon(
              Icons.folder,
              size: 24,
              color: Color(0xFF007AFF), // #007AFF blue
            ),

            const SizedBox(width: AppSpacing.sm), // 12dp
            // "Folder" label (16pt Semi-bold)
            Text(
              'Folder',
              style: textTheme.titleMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600, // Semi-bold
                color: const Color(0xFF1A1A1A), // Near-black
              ),
            ),

            const Spacer(),

            // "Choose Folder" button
            TextButton(
              onPressed: _showFolderPicker,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                minimumSize: const Size(44, 44), // Touch target
              ),
              child: Text(
                'Choose Folder',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500, // Medium
                  color: Color(0xFF007AFF), // #007AFF blue
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.xs), // 8dp
        // Current folder or "No folder selected"
        if (_selectedFolderId != null)
          Consumer(
            builder: (context, ref, child) {
              final folderAsync = ref.watch(folderByIdProvider(_selectedFolderId!));
              return folderAsync.when(
                data: (folder) => folder != null
                    ? Chip(
                        avatar: folder.color != null
                            ? CircleAvatar(
                                backgroundColor: Color(
                                  int.parse(folder.color!.replaceFirst('#', '0xFF')),
                                ),
                                radius: 8,
                              )
                            : const Icon(Icons.folder, size: 16),
                        label: Text(folder.name),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          setState(() {
                            _selectedFolderId = null;
                            _hasUnsavedChanges = true;
                          });
                        },
                      )
                    : Chip(
                        label: const Text('Unknown folder'),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          setState(() {
                            _selectedFolderId = null;
                            _hasUnsavedChanges = true;
                          });
                        },
                      ),
                loading: () => const Chip(label: Text('Loading...')),
                error: (_, __) => const Chip(label: Text('Error loading folder')),
              );
            },
          )
        else
          Text(
            'No folder selected',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400, // Regular
              color: Color(0xFF8E8E8E), // #8E8E8E light gray
            ),
          ),
      ],
    );
  }

  /// Compact premium tags section
  Widget _buildCompactTagsSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row: Icon, Label, AI button, Add button
        Row(
          children: [
            // Tag icon (24x24)
            const Icon(
              Icons.tag,
              size: 24,
              color: Color(0xFF007AFF), // #007AFF blue
            ),

            const SizedBox(width: AppSpacing.sm), // 12dp
            // "Tags" label (16pt Semi-bold)
            Text(
              'Tags',
              style: textTheme.titleMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600, // Semi-bold
                color: const Color(0xFF1A1A1A), // Near-black
              ),
            ),

            const Spacer(),

            // AI suggestion icon (24x24, 44x44 touch target)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _suggestTags,
                borderRadius: BorderRadius.circular(22),
                child: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.auto_awesome,
                    size: 24,
                    color: Color(0xFF007AFF), // #007AFF blue
                  ),
                ),
              ),
            ),

            // Add icon (24x24, 44x44 touch target)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _showAddTagDialog,
                borderRadius: BorderRadius.circular(22),
                child: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.add,
                    size: 24,
                    color: Color(0xFF1A1A1A), // #1A1A1A near-black
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.xs), // 8dp
        // Tags list or "No tags added"
        _tags.isEmpty
            ? const Text(
                'No tags added',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400, // Regular
                  color: Color(0xFF8E8E8E), // #8E8E8E light gray
                ),
              )
            : Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: _tags.map((tag) {
                  final isAiSuggested = _aiSuggestedTags.contains(tag);
                  return _buildTagChip(tag, isAiSuggested);
                }).toList(),
              ),
      ],
    );
  }

  Widget _buildAttachmentsSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.attach_file, color: colorScheme.primary, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Attachments',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _showAttachmentOptions,
                iconSize: 20,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Existing attachments
          if (_existingAttachments.isNotEmpty) ...[
            ..._existingAttachments.map(
              (attachment) => _buildAttachmentItem(context, attachment: attachment),
            ),
          ],

          // Pending attachments
          if (_pendingAttachments.isNotEmpty) ...[
            ..._pendingAttachments.asMap().entries.map(
              (entry) => _buildAttachmentItem(context, pendingFile: entry.value, index: entry.key),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAttachmentItem(
    BuildContext context, {
    Attachment? attachment,
    File? pendingFile,
    int? index,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final fileName = attachment?.fileName ?? pendingFile?.path.split('/').last ?? 'Unknown';
    final fileSize =
        attachment?.fileSizeFormatted ?? _formatFileSize(pendingFile?.lengthSync() ?? 0);
    final isPending = pendingFile != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
          boxShadow: AppShadows.cardShadow,
        ),
        child: Row(
          children: [
            // File icon
            Icon(_getFileIcon(fileName), color: colorScheme.primary, size: 24),

            const SizedBox(width: AppSpacing.sm),

            // File info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    fileSize,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),

            // Status indicator
            if (isPending) ...[
              Icon(Icons.upload_file, color: colorScheme.tertiary, size: 16),
              const SizedBox(width: AppSpacing.sm),
            ],

            // Remove button
            IconButton(
              icon: Icon(Icons.close, color: colorScheme.error, size: 16),
              onPressed: () => _removeAttachment(attachment, index),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF3A3A3A), // Dark modal background from guidelines
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusMd)),
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

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.sm,
                ),
                child: Text(
                  'Add Attachment',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFFFFFFFF), // White text on dark modal
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Action items
              _buildActionSheetItem(
                context: context,
                icon: Icons.camera_alt,
                title: 'Take Photo',
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),

              _buildActionSheetItem(
                context: context,
                icon: Icons.photo_library,
                title: 'Choose Photo',
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),

              _buildActionSheetItem(
                context: context,
                icon: Icons.attach_file,
                title: 'Choose File',
                onTap: () {
                  Navigator.of(context).pop();
                  _pickFile();
                },
              ),

              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionSheetItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? const Color(0xFFFF5454) : const Color(0xFFFFFFFF);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
          child: Row(
            children: [
              Icon(icon, size: 22, color: color),
              const SizedBox(width: AppSpacing.md),
              Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: color)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _pendingAttachments.add(File(pickedFile.path));
          _hasUnsavedChanges = true;
        });
      }
    } catch (e) {
      final colorScheme = Theme.of(context).colorScheme;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: colorScheme.errorContainer,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.single.path != null) {
        setState(() {
          _pendingAttachments.add(File(result.files.single.path!));
          _hasUnsavedChanges = true;
        });
      }
    } catch (e) {
      final colorScheme = Theme.of(context).colorScheme;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking file: $e'),
          backgroundColor: colorScheme.errorContainer,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _removeAttachment(Attachment? attachment, int? index) {
    setState(() {
      if (attachment != null) {
        _existingAttachments.remove(attachment);
      } else if (index != null) {
        _pendingAttachments.removeAt(index);
      }
      _hasUnsavedChanges = true;
    });
  }

  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
        return Icons.image;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'txt':
        return Icons.text_snippet;
      case 'mp3':
      case 'wav':
      case 'm4a':
        return Icons.audiotrack;
      case 'mp4':
      case 'mov':
      case 'avi':
        return Icons.videocam;
      default:
        return Icons.attach_file;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }

  Future<void> _saveNote() async {
    setState(() => _isLoading = true);

    try {
      final notesActions = ref.read(notesActionsProvider);
      final title = _titleController.text.trim();
      final content = _contentController.text.trim();

      // Validate input
      if (title.isEmpty && content.isEmpty && _pendingAttachments.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please add some content or attachments to save'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      Note note;
      if (widget.noteId == null) {
        // Create new note
        note = await notesActions.createNote(
          title: title.isEmpty ? 'Untitled' : title,
          content: content,
          tags: _tags,
          folderId: _selectedFolderId,
        );
      } else {
        // Update existing note
        note = _originalNote!.updateContent(
          title: title.isEmpty ? 'Untitled' : title,
          content: content,
          tags: _tags,
          folderId: _selectedFolderId,
        );
        await notesActions.updateNote(note);
      }

      // Handle pending attachments
      if (_pendingAttachments.isNotEmpty) {
        final noteRepository = ref.read(noteRepositoryProvider);
        for (final file in _pendingAttachments) {
          // Save file to app storage and get paths
          final filePaths = await FileUtils.saveAttachmentFile(file, note.id);
          final savedFilePath = filePaths['filePath']!;
          final thumbnailPath = filePaths['thumbnailPath'];

          final fileName = file.path.split('/').last;
          final attachment = Attachment.create(
            noteId: note.id,
            fileName: fileName,
            filePath: savedFilePath,
            type: AttachmentType.fromExtension(fileName.split('.').last),
            fileSize: file.lengthSync(),
            mimeType: FileUtils.getMimeType(file.path),
            thumbnailPath: thumbnailPath?.isNotEmpty == true ? thumbnailPath : null,
          );
          await noteRepository.addAttachment(attachment);
        }
      }

      setState(() {
        _hasUnsavedChanges = false;
        _pendingAttachments.clear();
      });

      final colorScheme = Theme.of(context).colorScheme;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Note saved successfully'),
          backgroundColor: colorScheme.primaryContainer,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Navigate to note detail if this was a new note
      if (widget.noteId == null) {
        context.go(AppRoutes.noteDetail(note.id));
      }
    } catch (e) {
      final colorScheme = Theme.of(context).colorScheme;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving note: $e'),
          backgroundColor: colorScheme.errorContainer,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('common.unsavedChanges'.tr()),
        content: const Text('You have unsaved changes. Do you want to save before leaving?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Exit without saving
            },
            child: const Text('Discard'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('common.cancel'.tr()),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _saveNote();
            },
            child: Text('common.save'.tr()),
          ),
        ],
      ),
    );
  }

  Future<void> _suggestTags() async {
    if (_contentController.text.trim().isEmpty) {
      final colorScheme = Theme.of(context).colorScheme;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please add some content before generating tag suggestions'),
          backgroundColor: colorScheme.tertiaryContainer,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Show loading dialog
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.secondary),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_awesome, size: 20, color: colorScheme.secondary),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Generating tag suggestions...',
                  style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    try {
      // Get tag suggestions from AI service
      final content = _contentController.text;
      final aiService = ref.read(aiServiceProvider);
      final suggestions = await aiService.suggestTags(content);

      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      if (suggestions.isEmpty) {
        if (mounted) {
          final colorScheme = Theme.of(context).colorScheme;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('No tag suggestions found'),
              backgroundColor: colorScheme.tertiaryContainer,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }

      // Show tag suggestions
      if (mounted) {
        _showTagSuggestions(suggestions);
      }
    } catch (e) {
      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();

        final colorScheme = Theme.of(context).colorScheme;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating tag suggestions: $e'),
            backgroundColor: colorScheme.errorContainer,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showTagSuggestions(List<String> suggestions) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusMd)),
              boxShadow: AppShadows.modalShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: colorScheme.outline.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.sm,
                    AppSpacing.sm,
                    AppSpacing.md,
                  ),
                  child: Row(
                    children: [
                      // AI Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5FF), // Light blue background
                          borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                          border: Border.all(
                            color: colorScheme.secondary.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.auto_awesome, size: 16, color: colorScheme.secondary),
                            const SizedBox(width: AppSpacing.xxs),
                            Text(
                              'AI Suggestions',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: colorScheme.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Text(
                    'Select tags to add to your note:',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Divider
                Divider(height: 1, color: colorScheme.outline.withValues(alpha: 0.2)),

                // Tag suggestions
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      indent: AppSpacing.xxl * 2,
                      color: colorScheme.outline.withValues(alpha: 0.1),
                    ),
                    itemCount: suggestions.length,
                    itemBuilder: (context, index) {
                      final tag = suggestions[index];
                      final isSelected = _tags.contains(tag);

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (_tags.contains(tag)) {
                                _tags.remove(tag);
                              } else {
                                _tags.add(tag);
                                _aiSuggestedTags.add(tag); // Mark as AI-suggested
                              }
                              _hasUnsavedChanges = true;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.md,
                            ),
                            child: Row(
                              children: [
                                // Tag icon
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? colorScheme.secondaryContainer
                                        : colorScheme.surfaceContainer,
                                    borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                                  ),
                                  child: Icon(
                                    Icons.tag,
                                    size: 18,
                                    color: isSelected
                                        ? colorScheme.secondary
                                        : colorScheme.onSurfaceVariant,
                                  ),
                                ),

                                const SizedBox(width: AppSpacing.md),

                                // Tag name
                                Expanded(
                                  child: Text(
                                    tag,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: isSelected
                                          ? colorScheme.onSurface
                                          : colorScheme.onSurfaceVariant,
                                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                                    ),
                                  ),
                                ),

                                // Checkbox
                                Checkbox(
                                  value: isSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == true) {
                                        if (!_tags.contains(tag)) {
                                          _tags.add(tag);
                                          _aiSuggestedTags.add(tag); // Mark as AI-suggested
                                          _hasUnsavedChanges = true;
                                        }
                                      } else {
                                        _tags.remove(tag);
                                        _hasUnsavedChanges = true;
                                      }
                                    });
                                  },
                                  activeColor: colorScheme.secondary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Bottom padding and apply button
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    border: Border(
                      top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2), width: 1),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.check, size: 20),
                        label: const Text('Apply Selected Tags'),
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.secondary,
                          foregroundColor: colorScheme.onSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddTagDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final TextEditingController tagController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
        title: Row(
          children: [
            Icon(Icons.tag, color: colorScheme.primary, size: 24),
            const SizedBox(width: AppSpacing.sm),
            Text('Add Tag', style: theme.textTheme.titleLarge),
          ],
        ),
        content: TextField(
          controller: tagController,
          decoration: InputDecoration(
            hintText: 'Enter tag name',
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            prefixIcon: Icon(Icons.label_outline, color: colorScheme.onSurfaceVariant, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: BorderSide(color: colorScheme.outline, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: BorderSide(color: colorScheme.outline, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            filled: true,
            fillColor: colorScheme.surfaceContainer,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
          ),
          style: theme.textTheme.bodyLarge,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) {
            _addTag(tagController.text);
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
            ),
            child: Text(
              'Cancel',
              style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ),
          FilledButton(
            onPressed: () {
              _addTag(tagController.text);
              Navigator.of(context).pop();
            },
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addTag(String tag) {
    final trimmedTag = tag.trim();
    if (trimmedTag.isNotEmpty && !_tags.contains(trimmedTag)) {
      setState(() {
        _tags.add(trimmedTag);
        _hasUnsavedChanges = true;
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
      _hasUnsavedChanges = true;
    });
  }

  Widget _buildTagChip(String tag, bool isAiSuggested) {
    return Container(
      decoration: BoxDecoration(
        color: isAiSuggested
            ? const Color(0xFFE8F5FF) // Light blue for AI tags
            : const Color(0xFFF5F5F5), // Light gray for regular tags
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
        border: Border.all(
          color: isAiSuggested
              ? const Color(0x4D007AFF) // 30% opacity #007AFF
              : const Color(0x4DE8E8E8), // 30% opacity #E8E8E8
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
          onTap: () => _removeTag(tag),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isAiSuggested) ...[
                  const Icon(Icons.auto_awesome, size: 14, color: Color(0xFF007AFF)),
                  const SizedBox(width: AppSpacing.xxs),
                ],
                Text(
                  tag,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isAiSuggested
                        ? const Color(0xFF007AFF) // Blue for AI tags
                        : const Color(0xFF1A1A1A), // Near-black for regular tags
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Icon(
                  Icons.close,
                  size: 14,
                  color: isAiSuggested
                      ? const Color(0xFF007AFF) // Blue for AI tags
                      : const Color(0xFF8E8E8E), // Light gray for regular tags
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFolderPicker() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
        child: SizedBox(
          height: 500,
          width: 400,
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2), width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.folder, color: colorScheme.primary, size: 24),
                    const SizedBox(width: AppSpacing.sm),
                    Text('Choose Folder', style: theme.textTheme.titleLarge),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(40, 40),
                      ),
                    ),
                  ],
                ),
              ),

              // "No Folder" option
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedFolderId = null;
                      _hasUnsavedChanges = true;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: _selectedFolderId == null
                          ? colorScheme.secondaryContainer.withValues(alpha: 0.3)
                          : null,
                      border: Border(
                        bottom: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.folder_off,
                          color: _selectedFolderId == null
                              ? colorScheme.secondary
                              : colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Text(
                          'No Folder',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: _selectedFolderId == null
                                ? colorScheme.secondary
                                : colorScheme.onSurface,
                            fontWeight: _selectedFolderId == null
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                        if (_selectedFolderId == null) ...[
                          const Spacer(),
                          Icon(Icons.check, color: colorScheme.secondary, size: 20),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              // Folder tree
              Expanded(
                child: FolderTree(
                  selectedFolderId: _selectedFolderId,
                  showNoteCounts: false,
                  onFolderTap: (folder) {
                    setState(() {
                      _selectedFolderId = folder.id;
                      _hasUnsavedChanges = true;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
