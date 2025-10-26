import 'package:flutter/material.dart';

/// Utility class for parsing and handling note backlinks
/// Supports [[note-title]] and [[note-id|display-text]] syntax
class BacklinkParser {
  /// Regular expression for matching backlinks
  /// Matches: [[text]], [[id|text]], [[text with spaces]]
  static final RegExp _backlinkRegex = RegExp(
    r'\[\[([^\]]+)\]\]',
    multiLine: true,
  );

  /// Parse content and extract all backlinks
  /// Returns list of BacklinkMatch objects
  static List<BacklinkMatch> parseBacklinks(String content) {
    final matches = <BacklinkMatch>[];
    final regexMatches = _backlinkRegex.allMatches(content);

    for (final match in regexMatches) {
      final fullMatch = match.group(0)!; // [[text]] or [[id|text]]
      final innerText = match.group(1)!; // text or id|text

      String targetId;
      String displayText;

      // Check if it uses [[id|display-text]] format
      if (innerText.contains('|')) {
        final parts = innerText.split('|');
        targetId = parts[0].trim();
        displayText = parts.length > 1 ? parts[1].trim() : targetId;
      } else {
        // Use title as both target and display
        targetId = innerText.trim();
        displayText = innerText.trim();
      }

      matches.add(BacklinkMatch(
        fullMatch: fullMatch,
        targetId: targetId,
        displayText: displayText,
        startIndex: match.start,
        endIndex: match.end,
      ));
    }

    return matches;
  }

  /// Check if content contains any backlinks
  static bool hasBacklinks(String content) {
    return _backlinkRegex.hasMatch(content);
  }

  /// Count backlinks in content
  static int countBacklinks(String content) {
    return _backlinkRegex.allMatches(content).length;
  }

  /// Extract unique target IDs/titles from backlinks
  static Set<String> extractTargetIds(String content) {
    final backlinks = parseBacklinks(content);
    return backlinks.map((b) => b.targetId).toSet();
  }

  /// Build a TextSpan with clickable backlinks
  static TextSpan buildTextSpanWithBacklinks(
    String content,
    TextStyle? defaultStyle,
    TextStyle? backlinkStyle,
    Function(String targetId)? onBacklinkTap,
  ) {
    final backlinks = parseBacklinks(content);

    if (backlinks.isEmpty) {
      return TextSpan(text: content, style: defaultStyle);
    }

    final spans = <InlineSpan>[];
    int currentIndex = 0;

    for (final backlink in backlinks) {
      // Add text before backlink
      if (backlink.startIndex > currentIndex) {
        spans.add(TextSpan(
          text: content.substring(currentIndex, backlink.startIndex),
          style: defaultStyle,
        ));
      }

      // Add clickable backlink
      spans.add(WidgetSpan(
        child: GestureDetector(
          onTap: () => onBacklinkTap?.call(backlink.targetId),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: backlinkStyle?.backgroundColor ?? Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: backlinkStyle?.color ?? Colors.blue,
                width: 1,
              ),
            ),
            child: Text(
              backlink.displayText,
              style: backlinkStyle ?? TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ));

      currentIndex = backlink.endIndex;
    }

    // Add remaining text
    if (currentIndex < content.length) {
      spans.add(TextSpan(
        text: content.substring(currentIndex),
        style: defaultStyle,
      ));
    }

    return TextSpan(children: spans);
  }

  /// Replace backlink target IDs in content (useful for note renaming/ID changes)
  static String replaceBacklinkTargets(
    String content,
    Map<String, String> replacements,
  ) {
    String result = content;
    final backlinks = parseBacklinks(content);

    // Sort by start index in reverse order to maintain correct positions
    final sortedBacklinks = backlinks.toList()
      ..sort((a, b) => b.startIndex.compareTo(a.startIndex));

    for (final backlink in sortedBacklinks) {
      final newTargetId = replacements[backlink.targetId];
      if (newTargetId != null) {
        final newBacklink = backlink.displayText == backlink.targetId
            ? '[[$newTargetId]]'
            : '[[$newTargetId|${backlink.displayText}]]';

        result = result.replaceRange(
          backlink.startIndex,
          backlink.endIndex,
          newBacklink,
        );
      }
    }

    return result;
  }

  /// Create a backlink string
  static String createBacklink(String targetId, [String? displayText]) {
    if (displayText != null && displayText != targetId) {
      return '[[$targetId|$displayText]]';
    }
    return '[[$targetId]]';
  }

  /// Remove all backlink formatting from content (useful for preview/search)
  static String stripBacklinkFormatting(String content) {
    return content.replaceAllMapped(_backlinkRegex, (match) {
      final innerText = match.group(1)!;
      // If it has display text, use that; otherwise use the target
      if (innerText.contains('|')) {
        return innerText.split('|')[1].trim();
      }
      return innerText.trim();
    });
  }
}

/// Represents a matched backlink in content
class BacklinkMatch {
  const BacklinkMatch({
    required this.fullMatch,
    required this.targetId,
    required this.displayText,
    required this.startIndex,
    required this.endIndex,
  });

  /// The full matched text including brackets: [[text]]
  final String fullMatch;

  /// The target note ID or title
  final String targetId;

  /// The text to display (may differ from targetId if using [[id|text]] format)
  final String displayText;

  /// Start position in the content
  final int startIndex;

  /// End position in the content
  final int endIndex;

  @override
  String toString() {
    return 'BacklinkMatch(target: $targetId, display: $displayText, range: $startIndex-$endIndex)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BacklinkMatch &&
        other.targetId == targetId &&
        other.displayText == displayText &&
        other.startIndex == startIndex &&
        other.endIndex == endIndex;
  }

  @override
  int get hashCode {
    return Object.hash(targetId, displayText, startIndex, endIndex);
  }
}
