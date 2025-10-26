import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_organizer/services/share_receiver_service.dart';
import 'package:ai_organizer/providers/web_clipper_provider.dart';
import 'package:ai_organizer/providers/notes_provider.dart';

/// Provider for ShareReceiverService
final shareReceiverServiceProvider = Provider<ShareReceiverService>((ref) {
  final service = ShareReceiverService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Provider for shared data stream
final sharedDataStreamProvider = StreamProvider<SharedData>((ref) {
  final service = ref.watch(shareReceiverServiceProvider);
  return service.sharedDataStream;
});

/// Provider for handling shared data
final shareReceiverActionsProvider = Provider<ShareReceiverActions>((ref) {
  return ShareReceiverActions(ref);
});

/// Actions for handling shared data
class ShareReceiverActions {
  final Ref ref;

  ShareReceiverActions(this.ref);

  /// Check and process initial shared data (on app launch)
  Future<void> processInitialSharedData() async {
    final service = ref.read(shareReceiverServiceProvider);
    final sharedData = await service.getInitialSharedData();

    if (sharedData != null) {
      await _processSharedData(sharedData);
      await service.clearSharedData();
    }
  }

  /// Process shared data
  Future<void> _processSharedData(SharedData data) async {
    final webClipperActions = ref.read(webClipperActionsProvider);

    if (data.isUrl) {
      // Handle shared URL - create web clip or bookmark
      await webClipperActions.clipWebPage(
        url: data.content,
        tags: ['web-clip', 'shared'],
        folderId: null,
      );
    } else if (data.isText) {
      // Handle shared text
      // Check if text contains URLs
      final urls = webClipperActions.extractUrls(data.content);

      if (urls.isNotEmpty) {
        // Text contains URL(s) - clip the first one
        await webClipperActions.clipWebPage(
          url: urls.first,
          tags: ['web-clip', 'shared'],
          folderId: null,
        );
      } else {
        // Plain text - create a simple note
        final notesActions = ref.read(notesActionsProvider);
        await notesActions.createNote(
          title: data.title ?? 'Shared Note',
          content: data.content,
          tags: ['shared'],
        );
      }
    }
  }

  /// Listen to shared data stream and process automatically
  void startListening() {
    ref.listen(sharedDataStreamProvider, (previous, next) {
      next.whenData((data) async {
        await _processSharedData(data);
        final service = ref.read(shareReceiverServiceProvider);
        await service.clearSharedData();
      });
    });
  }
}
