import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:ai_organizer/providers/email_provider.dart';
import 'package:ai_organizer/providers/notes_provider.dart';
import 'package:ai_organizer/services/gmail_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GmailImportScreen extends ConsumerStatefulWidget {
  const GmailImportScreen({super.key});

  @override
  ConsumerState<GmailImportScreen> createState() => _GmailImportScreenState();
}

class _GmailImportScreenState extends ConsumerState<GmailImportScreen> {
  List<GmailMessage> _emails = [];
  final Set<String> _selectedEmails = {};
  bool _isLoading = false;
  bool _isImporting = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEmails();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadEmails() async {
    setState(() => _isLoading = true);
    try {
      final emails = await ref.read(emailActionsProvider).fetchGmailEmails(
            query: _searchQuery.isEmpty ? null : _searchQuery,
          );
      if (mounted) {
        setState(() {
          _emails = emails;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading emails: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _importSelectedEmails() async {
    if (_selectedEmails.isEmpty) return;

    setState(() => _isImporting = true);

    int successCount = 0;
    int failCount = 0;

    for (final emailId in _selectedEmails) {
      try {
        final email = _emails.firstWhere((e) => e.id == emailId);

        // Create note from email
        await ref.read(notesActionsProvider).createNote(
              title: email.subject,
              content: email.body ?? email.snippet ?? '',
              tags: ['email'], // Tag as email
            );
        successCount++;
      } catch (e) {
        failCount++;
        debugPrint('Error importing email $emailId: $e');
      }
    }

    if (mounted) {
      setState(() {
        _isImporting = false;
        _selectedEmails.clear();
      });

      // Update last sync time
      await ref.read(emailActionsProvider).updateLastGmailSync();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Imported $successCount notes${failCount > 0 ? ', $failCount failed' : ''}',
          ),
          backgroundColor: failCount > 0
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.primary,
        ),
      );

      // Optionally navigate back
      if (successCount > 0 && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  void _toggleEmailSelection(String emailId) {
    setState(() {
      if (_selectedEmails.contains(emailId)) {
        _selectedEmails.remove(emailId);
      } else {
        _selectedEmails.add(emailId);
      }
    });
  }

  void _selectAll() {
    setState(() {
      if (_selectedEmails.length == _emails.length) {
        _selectedEmails.clear();
      } else {
        _selectedEmails.addAll(_emails.map((e) => e.id));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get theme data once at the top
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _selectedEmails.isEmpty
              ? 'Import Emails'
              : '${_selectedEmails.length} selected',
          style: textTheme.titleLarge,
        ),
        actions: [
          if (_selectedEmails.isNotEmpty) ...[
            IconButton(
              icon: Icon(Icons.clear_all, color: colorScheme.onSurface),
              onPressed: () => setState(() => _selectedEmails.clear()),
              tooltip: 'Clear selection',
            ),
          ] else
            IconButton(
              icon: Icon(Icons.select_all, color: colorScheme.onSurface),
              onPressed: _emails.isEmpty ? null : _selectAll,
              tooltip: 'Select all',
            ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
              vertical: AppSpacing.sm,
            ),
            child: _SearchBar(
              controller: _searchController,
              searchQuery: _searchQuery,
              onSearch: (value) {
                setState(() => _searchQuery = value);
                _loadEmails();
              },
              onClear: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
                _loadEmails();
              },
            ),
          ),

          // Email list
          Expanded(
            child: _isLoading
                ? _LoadingState()
                : _emails.isEmpty
                    ? _EmptyState(onRefresh: _loadEmails)
                    : RefreshIndicator(
                        onRefresh: _loadEmails,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.screenHorizontal,
                            vertical: AppSpacing.xs,
                          ),
                          itemCount: _emails.length,
                          itemBuilder: (context, index) {
                            final email = _emails[index];
                            final isSelected = _selectedEmails.contains(email.id);

                            return _EmailCard(
                              email: email,
                              isSelected: isSelected,
                              onTap: () => _toggleEmailSelection(email.id),
                            );
                          },
                        ),
                      ),
          ),

          // Bottom action bar
          if (_isImporting)
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                boxShadow: AppShadows.modalShadow,
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LinearProgressIndicator(
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      'Importing emails...',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_selectedEmails.isNotEmpty)
            _BottomActionBar(
              selectedCount: _selectedEmails.length,
              onImport: _importSelectedEmails,
            ),
        ],
      ),
    );
  }
}

/// Search bar component following AppSearchBar pattern
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String searchQuery;
  final ValueChanged<String> onSearch;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.searchQuery,
    required this.onSearch,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: colorScheme.outline,
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        onSubmitted: onSearch,
        style: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          hintText: 'Search emails (e.g., from:example@gmail.com)',
          hintStyle: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: colorScheme.onSurfaceVariant,
            size: AppSpacing.iconSize,
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: colorScheme.onSurfaceVariant,
                    size: AppSpacing.iconSizeSmall,
                  ),
                  onPressed: onClear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
      ),
    );
  }
}

/// Email card component matching NoteCard pattern from guidelines
class _EmailCard extends StatelessWidget {
  final GmailMessage email;
  final bool isSelected;
  final VoidCallback onTap;

  const _EmailCard({
    required this.email,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.listItemSpacing),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: isSelected ? colorScheme.primary : colorScheme.outline,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected ? AppShadows.cardElevatedShadow : AppShadows.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkbox
                Container(
                  width: AppSpacing.iconSize,
                  height: AppSpacing.iconSize,
                  margin: const EdgeInsets.only(right: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outline,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          size: AppSpacing.iconSizeSmall,
                          color: colorScheme.onPrimary,
                        )
                      : null,
                ),

                // Email content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subject and date row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              email.subject.isEmpty ? '(No Subject)' : email.subject,
                              style: textTheme.titleLarge,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: AppSpacing.xs),
                          Text(
                            _formatDate(email.date),
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: AppSpacing.xs),

                      // From address
                      Text(
                        email.from,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Snippet
                      if (email.snippet != null && email.snippet!.isNotEmpty) ...[
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          email.snippet!,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],

                      // Attachment indicator
                      if (email.attachments.isNotEmpty) ...[
                        SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Icon(
                              Icons.attach_file,
                              size: AppSpacing.iconSizeSmall,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            SizedBox(width: AppSpacing.xxs),
                            Text(
                              '${email.attachments.length} attachment${email.attachments.length > 1 ? 's' : ''}',
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final emailDate = DateTime(date.year, date.month, date.day);

    if (emailDate == today) {
      final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
      final period = date.hour >= 12 ? 'PM' : 'AM';
      return '${hour}:${date.minute.toString().padLeft(2, '0')} $period';
    } else if (emailDate == yesterday) {
      return 'Yesterday';
    } else if (now.year == date.year) {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[date.month - 1]} ${date.day}';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}

/// Empty state component following EmptyState pattern from guidelines
class _EmptyState extends StatelessWidget {
  final VoidCallback onRefresh;

  const _EmptyState({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mail_outline,
              size: 64,
              color: colorScheme.outlineVariant,
            ),
            SizedBox(height: AppSpacing.xl),
            Text(
              'No emails found',
              style: textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Try adjusting your search or refresh to load emails',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: AppSpacing.buttonPadding,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Loading skeleton following NoteCardSkeleton pattern from guidelines
class _LoadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.xs,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => _EmailCardSkeleton(),
    );
  }
}

class _EmailCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.listItemSpacing),
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox skeleton
          Container(
            width: AppSpacing.iconSize,
            height: AppSpacing.iconSize,
            margin: const EdgeInsets.only(right: AppSpacing.sm),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
            ),
          ),

          // Content skeleton
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subject skeleton
                Container(
                  width: double.infinity,
                  height: 20,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                // From skeleton
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 16,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                // Snippet skeleton
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 14,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom action bar component with proper theming
class _BottomActionBar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onImport;

  const _BottomActionBar({
    required this.selectedCount,
    required this.onImport,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: AppShadows.modalShadow,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Selection count
            Text(
              '$selectedCount email${selectedCount > 1 ? 's' : ''} selected',
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm),
            // Import button
            FilledButton.icon(
              onPressed: onImport,
              icon: const Icon(Icons.download),
              label: Text('Import $selectedCount email${selectedCount > 1 ? 's' : ''}'),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
