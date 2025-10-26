import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_organizer/services/web_clipper_service.dart';
import 'package:ai_organizer/data/models/link_preview.dart';
import 'package:ai_organizer/data/models/note.dart';
import 'package:ai_organizer/providers/notes_provider.dart';

/// Provider for WebClipperService singleton instance
final webClipperServiceProvider = Provider<WebClipperService>((ref) {
  return WebClipperService();
});

/// Provider for fetching link preview for a specific URL
/// Returns AsyncValue with LinkPreview or null if preview couldn't be fetched
final linkPreviewProvider = FutureProvider.family<LinkPreview?, String>((
  ref,
  url,
) async {
  final service = ref.watch(webClipperServiceProvider);
  return await service.getPreview(url);
});

/// Provider for link preview cache management
final linkPreviewCacheProvider =
    StateNotifierProvider<LinkPreviewCacheNotifier, Map<String, LinkPreview>>((
      ref,
    ) {
      return LinkPreviewCacheNotifier(ref);
    });

/// State notifier for managing link preview cache
class LinkPreviewCacheNotifier extends StateNotifier<Map<String, LinkPreview>> {
  LinkPreviewCacheNotifier(this.ref) : super({});

  final Ref ref;

  /// Add preview to cache
  void addToCache(String url, LinkPreview preview) {
    state = {...state, url: preview};
  }

  /// Get preview from cache
  LinkPreview? getFromCache(String url) {
    return state[url];
  }

  /// Clear all cached previews
  void clearCache() {
    state = {};
    ref.read(webClipperServiceProvider).clearCache();
  }

  /// Remove specific URL from cache
  void removeFromCache(String url) {
    final newState = Map<String, LinkPreview>.from(state);
    newState.remove(url);
    state = newState;
    ref.read(webClipperServiceProvider).removeCached(url);
  }
}

/// Actions for web clipping operations
class WebClipperActions {
  WebClipperActions(this._ref);

  final Ref _ref;

  /// Extract URLs from text
  List<String> extractUrls(String text) {
    final service = _ref.read(webClipperServiceProvider);
    return service.extractUrls(text);
  }

  /// Get link preview for a URL
  Future<LinkPreview?> getPreview(String url) async {
    final service = _ref.read(webClipperServiceProvider);
    final preview = await service.getPreview(url);

    if (preview != null) {
      _ref.read(linkPreviewCacheProvider.notifier).addToCache(url, preview);
    }

    return preview;
  }

  /// Clip web page and create a note
  Future<Note?> clipWebPage({
    required String url,
    String? folderId,
    List<String>? tags,
  }) async {
    final service = _ref.read(webClipperServiceProvider);

    // Fetch preview first
    final preview = await service.getPreview(url);
    if (preview == null) return null;

    // Fetch full web content
    final content = await service.fetchWebContent(url);
    if (content == null || content.isEmpty) return null;

    // Create note from web content
    final note = Note.create(
      title: preview.displayTitle,
      content:
          '''
${preview.hasDescription ? '${preview.description}\n\n' : ''}---

$content

---

**Source:** [${preview.shortDomain}]($url)
''',
      tags: tags ?? [],
      folderId: folderId,
    );

    // Save note using notes actions
    final notesActions = _ref.read(notesActionsProvider);
    final createdNote = await notesActions.createNote(
      title: note.title,
      content: note.content,
      tags: note.tags,
      folderId: note.folderId,
    );

    return createdNote;
  }

  /// Create a quick bookmark note from URL (just preview, no full content)
  Future<Note?> createBookmarkNote({
    required String url,
    String? folderId,
    List<String>? tags,
  }) async {
    final service = _ref.read(webClipperServiceProvider);

    // Fetch preview
    final preview = await service.getPreview(url);
    if (preview == null) return null;

    // Create note from preview
    final note = Note.create(
      title: preview.displayTitle,
      content:
          '''
${preview.hasDescription ? '${preview.description}\n\n' : ''}**Source:** [${preview.shortDomain}]($url)
''',
      tags: [...?tags, 'bookmark'],
      folderId: folderId,
    );

    // Save note
    final notesActions = _ref.read(notesActionsProvider);
    final createdNote = await notesActions.createNote(
      title: note.title,
      content: note.content,
      tags: note.tags,
      folderId: note.folderId,
    );

    return createdNote;
  }

  /// Clear preview cache
  void clearCache() {
    _ref.read(linkPreviewCacheProvider.notifier).clearCache();
  }
}

/// Provider for web clipper actions
final webClipperActionsProvider = Provider<WebClipperActions>((ref) {
  return WebClipperActions(ref);
});
