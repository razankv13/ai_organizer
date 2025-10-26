import 'package:any_link_preview/any_link_preview.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as html_dom;
import 'package:http/http.dart' as http;
import 'package:ai_organizer/data/models/link_preview.dart';

/// Service for web clipping and link preview generation
class WebClipperService {
  /// Singleton instance
  WebClipperService._internal();

  factory WebClipperService() => _instance;

  static final WebClipperService _instance = WebClipperService._internal();

  // Cache for link previews (URL -> LinkPreview)
  final Map<String, LinkPreview> _previewCache = {};

  /// Extract all URLs from text using regex
  List<String> extractUrls(String text) {
    final urlRegex = RegExp(
      r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
      caseSensitive: false,
    );

    final matches = urlRegex.allMatches(text);
    return matches.map((match) => match.group(0)!).toList();
  }

  /// Get link preview metadata for a URL
  Future<LinkPreview?> getPreview(String url, {bool useCache = true}) async {
    try {
      // Check cache first
      if (useCache && _previewCache.containsKey(url)) {
        return _previewCache[url];
      }

      // Fetch metadata using any_link_preview
      final metadata = await AnyLinkPreview.getMetadata(
        link: url,
        cache: const Duration(days: 7), // Cache for 7 days
        proxyUrl: 'https://corsproxy.io/?', // CORS proxy for web
      );

      if (metadata == null) return null;

      // Create LinkPreview from metadata
      final preview = LinkPreview.create(
        url: url,
        title: metadata.title ?? '',
        description: metadata.desc,
        imageUrl: metadata.image,
        siteName: metadata.siteName,
      );

      // Cache the preview
      _previewCache[url] = preview;

      return preview;
    } catch (e) {
      // If any_link_preview fails, try manual parsing
      return await _manualPreviewFetch(url);
    }
  }

  /// Manual preview fetch as fallback
  Future<LinkPreview?> _manualPreviewFetch(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return null;

      final document = html_parser.parse(response.body);

      // Extract metadata from HTML
      final title =
          _getMetaContent(document, 'og:title') ??
          _getMetaContent(document, 'twitter:title') ??
          document.querySelector('title')?.text ??
          '';

      final description =
          _getMetaContent(document, 'og:description') ??
          _getMetaContent(document, 'twitter:description') ??
          _getMetaContent(document, 'description') ??
          '';

      final imageUrl =
          _getMetaContent(document, 'og:image') ??
          _getMetaContent(document, 'twitter:image') ??
          '';

      final siteName = _getMetaContent(document, 'og:site_name') ?? '';

      final faviconUrl = document
          .querySelector('link[rel*="icon"]')
          ?.attributes['href'];

      final preview = LinkPreview.create(
        url: url,
        title: title,
        description: description,
        imageUrl: imageUrl,
        siteName: siteName,
        faviconUrl: faviconUrl,
      );

      _previewCache[url] = preview;
      return preview;
    } catch (e) {
      return null;
    }
  }

  /// Helper to get meta content from HTML document
  String? _getMetaContent(html_dom.Document document, String property) {
    final meta =
        document.querySelector('meta[property="$property"]') ??
        document.querySelector('meta[name="$property"]');
    return meta?.attributes['content'];
  }

  /// Fetch and parse web page content
  Future<String?> fetchWebContent(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return null;

      final document = html_parser.parse(response.body);

      // Remove script, style, and navigation elements
      document
          .querySelectorAll('script, style, nav, header, footer')
          .forEach((el) => el.remove());

      // Get main content (try different selectors)
      final mainContent =
          document.querySelector('main') ??
          document.querySelector('article') ??
          document.querySelector('[role="main"]') ??
          document.querySelector('body');

      if (mainContent == null) return null;

      // Convert HTML to markdown-like text
      return _htmlToMarkdown(mainContent);
    } catch (e) {
      return null;
    }
  }

  /// Convert HTML element to markdown format
  String _htmlToMarkdown(html_dom.Element element) {
    final buffer = StringBuffer();

    for (final node in element.nodes) {
      if (node is html_dom.Element) {
        switch (node.localName) {
          case 'h1':
            buffer.writeln('# ${node.text}\n');
            break;
          case 'h2':
            buffer.writeln('## ${node.text}\n');
            break;
          case 'h3':
            buffer.writeln('### ${node.text}\n');
            break;
          case 'h4':
            buffer.writeln('#### ${node.text}\n');
            break;
          case 'h5':
            buffer.writeln('##### ${node.text}\n');
            break;
          case 'h6':
            buffer.writeln('###### ${node.text}\n');
            break;
          case 'p':
            buffer.writeln('${node.text}\n');
            break;
          case 'a':
            final href = node.attributes['href'];
            final text = node.text;
            buffer.write('[$text]($href)');
            break;
          case 'strong':
          case 'b':
            buffer.write('**${node.text}**');
            break;
          case 'em':
          case 'i':
            buffer.write('*${node.text}*');
            break;
          case 'ul':
          case 'ol':
            buffer.write(_processList(node));
            break;
          case 'li':
            buffer.writeln('- ${node.text}');
            break;
          case 'blockquote':
            buffer.writeln('> ${node.text}\n');
            break;
          case 'code':
            buffer.write('`${node.text}`');
            break;
          case 'pre':
            buffer.writeln('```\n${node.text}\n```\n');
            break;
          case 'img':
            final src = node.attributes['src'];
            final alt = node.attributes['alt'] ?? '';
            buffer.writeln('![$alt]($src)\n');
            break;
          default:
            buffer.write(_htmlToMarkdown(node));
        }
      } else if (node is html_dom.Text) {
        final text = node.text.trim();
        if (text.isNotEmpty) {
          buffer.write(text);
        }
      }
    }

    return buffer.toString();
  }

  /// Process list elements
  String _processList(html_dom.Element listElement) {
    final buffer = StringBuffer();
    final items = listElement.querySelectorAll('li');

    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      if (listElement.localName == 'ol') {
        buffer.writeln('${i + 1}. ${item.text}');
      } else {
        buffer.writeln('- ${item.text}');
      }
    }

    buffer.writeln();
    return buffer.toString();
  }

  /// Clear preview cache
  void clearCache() {
    _previewCache.clear();
  }

  /// Remove specific URL from cache
  void removeCached(String url) {
    _previewCache.remove(url);
  }
}
