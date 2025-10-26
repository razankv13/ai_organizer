import 'package:flutter/material.dart';

/// Accessibility semantic labels and helpers for screen readers
///
/// This file provides reusable semantic labels and helper functions
/// to ensure consistent accessibility throughout the app.
class SemanticLabels {
  SemanticLabels._();

  // ===== NAVIGATION LABELS =====

  static const String homeTab = 'Home tab';
  static const String notesTab = 'Notes tab';
  static const String searchTab = 'Search tab';
  static const String organizeTab = 'Organize tab';
  static const String settingsTab = 'Settings tab';

  static String tabWithCount(String tabName, int count) =>
      '$tabName, $count items';

  // ===== BUTTON LABELS =====

  static const String saveButton = 'Save';
  static const String cancelButton = 'Cancel';
  static const String deleteButton = 'Delete';
  static const String editButton = 'Edit';
  static const String shareButton = 'Share';
  static const String backButton = 'Go back';
  static const String closeButton = 'Close';
  static const String moreOptionsButton = 'More options';

  static String saveButtonWithState(bool isSaving) =>
      isSaving ? 'Saving...' : 'Save';

  static String deleteButtonWithItem(String itemType) =>
      'Delete $itemType';

  // ===== ICON LABELS =====

  static const String searchIcon = 'Search';
  static const String filterIcon = 'Filter';
  static const String sortIcon = 'Sort';
  static const String favoriteIcon = 'Favorite';
  static const String unfavoriteIcon = 'Remove from favorites';
  static const String pinIcon = 'Pin note';
  static const String unpinIcon = 'Unpin note';
  static const String archiveIcon = 'Archive';
  static const String attachmentIcon = 'Attachment';
  static const String aiIcon = 'AI assistant';
  static const String lockIcon = 'Locked';
  static const String unlockIcon = 'Unlocked';

  // ===== NOTE-SPECIFIC LABELS =====

  static String noteCard({
    required String title,
    required String? preview,
    required int tagCount,
    required bool isPinned,
    required bool isFavorite,
    required bool isArchived,
  }) {
    final parts = <String>[title];

    if (preview != null && preview.isNotEmpty) {
      parts.add(preview);
    }

    if (tagCount > 0) {
      parts.add('$tagCount ${tagCount == 1 ? 'tag' : 'tags'}');
    }

    final states = <String>[];
    if (isPinned) states.add('pinned');
    if (isFavorite) states.add('favorite');
    if (isArchived) states.add('archived');

    if (states.isNotEmpty) {
      parts.add(states.join(', '));
    }

    return parts.join('. ');
  }

  static String noteWithMetadata({
    required String title,
    required String createdDate,
    required int attachmentCount,
  }) {
    final parts = <String>[
      title,
      'Created $createdDate',
    ];

    if (attachmentCount > 0) {
      parts.add('$attachmentCount ${attachmentCount == 1 ? 'attachment' : 'attachments'}');
    }

    return parts.join('. ');
  }

  // ===== SEARCH LABELS =====

  static String searchResultsCount(int count) {
    if (count == 0) return 'No results found';
    if (count == 1) return '1 result found';
    return '$count results found';
  }

  static String searchQueryLabel(String query) =>
      'Search for "$query"';

  static const String clearSearchButton = 'Clear search';
  static const String searchFilterButton = 'Search filters';

  // ===== FORM LABELS =====

  static String textFieldLabel({
    required String label,
    required bool isRequired,
    String? errorMessage,
  }) {
    final parts = <String>[label];

    if (isRequired) {
      parts.add('required');
    }

    if (errorMessage != null) {
      parts.add('Error: $errorMessage');
    }

    return parts.join(', ');
  }

  static String textFieldValue({
    required String label,
    required String value,
    required int characterCount,
  }) {
    if (value.isEmpty) {
      return '$label, empty';
    }
    return '$label, $value, $characterCount characters';
  }

  // ===== LIST LABELS =====

  static String listOfItems({
    required String itemType,
    required int count,
  }) {
    if (count == 0) return 'No $itemType';
    if (count == 1) return '1 $itemType';
    return '$count $itemType';
  }

  static String listItemPosition({
    required int position,
    required int total,
    required String itemName,
  }) {
    return '$itemName, item $position of $total';
  }

  // ===== TAG LABELS =====

  static String tagChip({
    required String tagName,
    required bool canDelete,
  }) {
    if (canDelete) {
      return 'Tag $tagName, removable';
    }
    return 'Tag $tagName';
  }

  static String tagWithCount(String tagName, int noteCount) =>
      '$tagName tag, $noteCount ${noteCount == 1 ? 'note' : 'notes'}';

  // ===== FOLDER LABELS =====

  static String folderItem({
    required String folderName,
    required int noteCount,
    required String? color,
  }) {
    final parts = <String>[
      'Folder $folderName',
      '$noteCount ${noteCount == 1 ? 'note' : 'notes'}',
    ];

    if (color != null) {
      parts.add('$color color');
    }

    return parts.join(', ');
  }

  // ===== STATE LABELS =====

  static String loadingState(String itemType) =>
      'Loading $itemType...';

  static String emptyState(String itemType) =>
      'No $itemType found. Tap to create one.';

  static String errorState(String message) =>
      'Error: $message';

  // ===== SELECTION LABELS =====

  static String selectionMode({
    required int selectedCount,
    required int totalCount,
  }) {
    if (selectedCount == 0) {
      return 'Selection mode, no items selected';
    }
    return 'Selection mode, $selectedCount of $totalCount items selected';
  }

  static String selectableItem({
    required String itemName,
    required bool isSelected,
  }) {
    if (isSelected) {
      return '$itemName, selected';
    }
    return '$itemName, not selected';
  }

  // ===== TOGGLE LABELS =====

  static String toggleButton({
    required String label,
    required bool isOn,
  }) {
    return '$label, ${isOn ? 'on' : 'off'}';
  }

  static String checkboxLabel({
    required String label,
    required bool isChecked,
  }) {
    return '$label, ${isChecked ? 'checked' : 'unchecked'}';
  }

  // ===== PROGRESS LABELS =====

  static String progressIndicator({
    required String action,
    required int? progress,
  }) {
    if (progress == null) {
      return '$action in progress';
    }
    return '$action, $progress percent complete';
  }

  // ===== AI-SPECIFIC LABELS =====

  static const String aiSuggestionBadge = 'AI suggested';
  static const String aiProcessingIndicator = 'AI is processing';
  static String aiSuggestionButton(String suggestionType) =>
      'Get AI $suggestionType suggestions';

  // ===== ATTACHMENT LABELS =====

  static String attachmentItem({
    required String fileName,
    required String fileType,
    required String? fileSize,
  }) {
    final parts = <String>['Attachment: $fileName', fileType];

    if (fileSize != null) {
      parts.add(fileSize);
    }

    return parts.join(', ');
  }

  static const String addAttachmentButton = 'Add attachment';
  static const String removeAttachmentButton = 'Remove attachment';

  // ===== MODAL LABELS =====

  static String dialogTitle(String title) =>
      'Dialog: $title';

  static String bottomSheetLabel(String content) =>
      'Bottom sheet: $content';

  static const String dismissModal = 'Dismiss';

  // ===== SYNC LABELS =====

  static String syncStatus({
    required bool isConnected,
    required bool isSyncing,
    required DateTime? lastSyncTime,
  }) {
    if (isSyncing) {
      return 'Syncing data';
    }

    if (!isConnected) {
      return 'Offline, sync paused';
    }

    if (lastSyncTime != null) {
      return 'Synced, last update ${_formatSyncTime(lastSyncTime)}';
    }

    return 'Ready to sync';
  }

  static String _formatSyncTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inHours < 1) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inDays < 1) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    }
  }
}

/// Helper widget to add semantic labels to widgets
class SemanticWrapper extends StatelessWidget {
  const SemanticWrapper({
    super.key,
    required this.label,
    this.hint,
    this.value,
    this.isButton = false,
    this.isHeader = false,
    this.isLink = false,
    this.isImage = false,
    this.isFocusable = true,
    this.excludeSemantics = false,
    required this.child,
  });

  final String label;
  final String? hint;
  final String? value;
  final bool isButton;
  final bool isHeader;
  final bool isLink;
  final bool isImage;
  final bool isFocusable;
  final bool excludeSemantics;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (excludeSemantics) {
      return ExcludeSemantics(child: child);
    }

    return Semantics(
      label: label,
      hint: hint,
      value: value,
      button: isButton,
      header: isHeader,
      link: isLink,
      image: isImage,
      focusable: isFocusable,
      child: child,
    );
  }
}

/// Helper for decorative elements that should be excluded from semantics
class DecorativeWidget extends StatelessWidget {
  const DecorativeWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(child: child);
  }
}
