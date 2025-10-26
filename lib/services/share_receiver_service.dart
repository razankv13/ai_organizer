import 'package:flutter/services.dart';
import 'dart:async';

/// Service for receiving shared data from native platforms (iOS/Android)
/// Handles URLs and text shared from browsers and other apps
class ShareReceiverService {
  static const platform = MethodChannel('app.organizer.ai/share');

  /// Stream controller for shared data
  final _sharedDataController = StreamController<SharedData>.broadcast();

  /// Stream of shared data from native platforms
  Stream<SharedData> get sharedDataStream => _sharedDataController.stream;

  ShareReceiverService() {
    _setupMethodCallHandler();
  }

  /// Set up method call handler to receive data from native platforms
  void _setupMethodCallHandler() {
    platform.setMethodCallHandler(_handleMethodCall);
  }

  /// Handle method calls from native platforms
  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onSharedData':
        final data = _parseSharedData(call.arguments);
        if (data != null) {
          _sharedDataController.add(data);
        }
        return true;
      default:
        throw PlatformException(
          code: 'UNIMPLEMENTED',
          message: 'Method ${call.method} not implemented',
        );
    }
  }

  /// Parse shared data from arguments
  SharedData? _parseSharedData(dynamic arguments) {
    if (arguments == null) return null;

    try {
      final Map<String, dynamic> data = Map<String, dynamic>.from(arguments);
      final type = data['type'] as String?;
      final content = data['content'] as String?;

      if (content == null || content.isEmpty) return null;

      switch (type) {
        case 'url':
          return SharedData(
            type: SharedDataType.url,
            content: content,
            title: data['title'] as String?,
            description: data['description'] as String?,
          );
        case 'text':
          return SharedData(
            type: SharedDataType.text,
            content: content,
            title: data['title'] as String?,
          );
        default:
          return SharedData(
            type: SharedDataType.text,
            content: content,
          );
      }
    } catch (e) {
      return null;
    }
  }

  /// Get initially shared URL (for app launch via share)
  Future<String?> getInitialSharedUrl() async {
    try {
      final String? url = await platform.invokeMethod('getInitialSharedUrl');
      return url;
    } on PlatformException catch (e) {
      print('Failed to get initial shared URL: ${e.message}');
      return null;
    }
  }

  /// Get initially shared text (for app launch via share)
  Future<String?> getInitialSharedText() async {
    try {
      final String? text = await platform.invokeMethod('getInitialSharedText');
      return text;
    } on PlatformException catch (e) {
      print('Failed to get initial shared text: ${e.message}');
      return null;
    }
  }

  /// Get initially shared data (unified method)
  Future<SharedData?> getInitialSharedData() async {
    try {
      final Map<dynamic, dynamic>? data =
          await platform.invokeMethod('getInitialSharedData');

      if (data == null) return null;

      return _parseSharedData(data);
    } on PlatformException catch (e) {
      print('Failed to get initial shared data: ${e.message}');
      return null;
    }
  }

  /// Clear shared data (after processing)
  Future<void> clearSharedData() async {
    try {
      await platform.invokeMethod('clearSharedData');
    } on PlatformException catch (e) {
      print('Failed to clear shared data: ${e.message}');
    }
  }

  /// Dispose resources
  void dispose() {
    _sharedDataController.close();
  }
}

/// Type of shared data
enum SharedDataType {
  url,
  text,
}

/// Shared data model
class SharedData {
  final SharedDataType type;
  final String content;
  final String? title;
  final String? description;

  SharedData({
    required this.type,
    required this.content,
    this.title,
    this.description,
  });

  bool get isUrl => type == SharedDataType.url;
  bool get isText => type == SharedDataType.text;

  @override
  String toString() {
    return 'SharedData(type: $type, content: $content, title: $title)';
  }
}
