import 'package:freezed_annotation/freezed_annotation.dart';

part 'link_preview.freezed.dart';
part 'link_preview.g.dart';

/// Link preview metadata model for rich web content display
@freezed
abstract class LinkPreview with _$LinkPreview {
  const factory LinkPreview({
    required String url,
    required String title,
    String? description,
    String? imageUrl,
    String? siteName,
    String? faviconUrl,
    String? domain,
    required DateTime fetchedAt,
  }) = _LinkPreview;

  factory LinkPreview.fromJson(Map<String, dynamic> json) =>
      _$LinkPreviewFromJson(json);

  /// Create link preview with timestamp
  factory LinkPreview.create({
    required String url,
    required String title,
    String? description,
    String? imageUrl,
    String? siteName,
    String? faviconUrl,
  }) {
    // Extract domain from URL
    String? domain;
    try {
      final uri = Uri.parse(url);
      domain = uri.host;
    } catch (e) {
      domain = null;
    }

    return LinkPreview(
      url: url,
      title: title,
      description: description,
      imageUrl: imageUrl,
      siteName: siteName,
      faviconUrl: faviconUrl,
      domain: domain,
      fetchedAt: DateTime.now(),
    );
  }

  /// Check if preview has image
  const LinkPreview._();

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  /// Check if preview has description
  bool get hasDescription => description != null && description!.isNotEmpty;

  /// Get display title (fallback to domain if no title)
  String get displayTitle => title.isEmpty ? (domain ?? url) : title;

  /// Get short domain for display
  String get shortDomain {
    if (domain == null) return '';
    return domain!.replaceFirst('www.', '');
  }
}
