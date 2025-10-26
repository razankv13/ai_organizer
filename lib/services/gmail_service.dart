import 'dart:convert';
import 'dart:developer' as developer;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Gmail email model for import
class GmailMessage {
  const GmailMessage({
    required this.id,
    required this.threadId,
    required this.subject,
    required this.from,
    required this.to,
    required this.date,
    this.body,
    this.snippet,
    this.attachments = const [],
  });

  final String id;
  final String threadId;
  final String subject;
  final String from;
  final String to;
  final DateTime date;
  final String? body;
  final String? snippet;
  final List<GmailAttachment> attachments;
}

/// Gmail attachment model
class GmailAttachment {
  const GmailAttachment({
    required this.filename,
    required this.mimeType,
    required this.size,
    this.attachmentId,
  });

  final String filename;
  final String mimeType;
  final int size;
  final String? attachmentId;
}

/// HTTP client with Google Sign-In authentication
class GoogleAuthClient extends http.BaseClient {
  GoogleAuthClient(this._headers, this._client);

  final Map<String, String> _headers;
  final http.Client _client;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

/// Service for Gmail OAuth integration and email import
class GmailService {
  GmailService(this._supabaseClient);

  final SupabaseClient? _supabaseClient;

  // Google Sign-In configuration
  // Note: You need to configure OAuth credentials in Google Cloud Console
  // and add the client ID to your platform-specific configuration files
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      gmail.GmailApi.gmailReadonlyScope,
      gmail.GmailApi.gmailModifyScope,
    ],
  );

  GoogleSignInAccount? _currentUser;
  gmail.GmailApi? _gmailApi;

  /// Check if user is signed in to Gmail
  bool get isSignedIn => _currentUser != null;

  /// Get current Gmail user email
  String? get currentUserEmail => _currentUser?.email;

  /// Authenticate with Gmail using Google Sign-In
  Future<bool> signInToGmail() async {
    try {
      // Attempt silent sign-in first
      final account = await _googleSignIn.signInSilently();

      // If silent sign-in fails, show sign-in UI
      _currentUser = account ?? await _googleSignIn.signIn();

      if (_currentUser == null) {
        developer.log('User cancelled Gmail sign-in', name: 'GmailService');
        return false;
      }

      // Get authentication headers
      final auth = await _currentUser!.authentication;
      if (auth.accessToken == null) {
        developer.log('Failed to get access token', name: 'GmailService');
        return false;
      }

      // Create authenticated HTTP client
      final authClient = GoogleAuthClient(
        {'Authorization': 'Bearer ${auth.accessToken}'},
        http.Client(),
      );

      // Initialize Gmail API
      _gmailApi = gmail.GmailApi(authClient);

      developer.log(
        'Successfully signed in to Gmail: ${_currentUser!.email}',
        name: 'GmailService',
      );

      return true;
    } catch (e) {
      developer.log('Error signing in to Gmail: $e', name: 'GmailService');
      return false;
    }
  }

  /// Sign out from Gmail
  Future<void> signOutFromGmail() async {
    try {
      await _googleSignIn.signOut();
      _currentUser = null;
      _gmailApi = null;
      developer.log('Signed out from Gmail', name: 'GmailService');
    } catch (e) {
      developer.log('Error signing out from Gmail: $e', name: 'GmailService');
    }
  }

  /// Fetch emails from Gmail
  /// [maxResults] - Maximum number of emails to fetch (default: 50)
  /// [query] - Gmail search query (e.g., "is:unread", "from:example@gmail.com")
  Future<List<GmailMessage>> fetchEmails({
    int maxResults = 50,
    String? query,
    String? pageToken,
  }) async {
    if (_gmailApi == null) {
      throw Exception('Not signed in to Gmail. Call signInToGmail() first.');
    }

    try {
      // List messages
      final messagesResponse = await _gmailApi!.users.messages.list(
        'me',
        maxResults: maxResults,
        q: query,
        pageToken: pageToken,
      );

      if (messagesResponse.messages == null || messagesResponse.messages!.isEmpty) {
        return [];
      }

      // Fetch full message details for each message
      final messages = <GmailMessage>[];
      for (final message in messagesResponse.messages!) {
        if (message.id == null) continue;

        try {
          final fullMessage = await _gmailApi!.users.messages.get(
            'me',
            message.id!,
            format: 'full',
          );

          final parsed = _parseGmailMessage(fullMessage);
          if (parsed != null) {
            messages.add(parsed);
          }
        } catch (e) {
          developer.log('Error fetching message ${message.id}: $e', name: 'GmailService');
          continue;
        }
      }

      return messages;
    } catch (e) {
      developer.log('Error fetching emails: $e', name: 'GmailService');
      rethrow;
    }
  }

  /// Parse Gmail message to our model
  GmailMessage? _parseGmailMessage(gmail.Message message) {
    try {
      final headers = message.payload?.headers ?? [];

      String? subject;
      String? from;
      String? to;
      String? dateStr;

      for (final header in headers) {
        switch (header.name?.toLowerCase()) {
          case 'subject':
            subject = header.value;
            break;
          case 'from':
            from = header.value;
            break;
          case 'to':
            to = header.value;
            break;
          case 'date':
            dateStr = header.value;
            break;
        }
      }

      // Extract body
      final body = _extractBody(message.payload);

      // Extract attachments
      final attachments = _extractAttachments(message.payload);

      // Parse date
      DateTime date;
      try {
        date = dateStr != null ? DateTime.parse(dateStr) : DateTime.now();
      } catch (e) {
        date = DateTime.now();
      }

      return GmailMessage(
        id: message.id ?? '',
        threadId: message.threadId ?? '',
        subject: subject ?? '(No Subject)',
        from: from ?? '',
        to: to ?? '',
        date: date,
        body: body,
        snippet: message.snippet,
        attachments: attachments,
      );
    } catch (e) {
      developer.log('Error parsing Gmail message: $e', name: 'GmailService');
      return null;
    }
  }

  /// Extract body from message payload
  String? _extractBody(gmail.MessagePart? payload) {
    if (payload == null) return null;

    // Check if this part contains the body
    if (payload.body?.data != null) {
      try {
        final decoded = utf8.decode(base64Url.decode(payload.body!.data!));
        return decoded;
      } catch (e) {
        developer.log('Error decoding body: $e', name: 'GmailService');
      }
    }

    // Recursively check parts
    if (payload.parts != null) {
      for (final part in payload.parts!) {
        // Prefer text/plain, then text/html
        if (part.mimeType == 'text/plain' || part.mimeType == 'text/html') {
          final body = _extractBody(part);
          if (body != null) return body;
        }
      }

      // If no text parts found, try any part
      for (final part in payload.parts!) {
        final body = _extractBody(part);
        if (body != null) return body;
      }
    }

    return null;
  }

  /// Extract attachments from message payload
  List<GmailAttachment> _extractAttachments(gmail.MessagePart? payload) {
    if (payload == null) return [];

    final attachments = <GmailAttachment>[];

    void extractFromPart(gmail.MessagePart part) {
      // Check if this part is an attachment
      if (part.filename != null && part.filename!.isNotEmpty) {
        attachments.add(
          GmailAttachment(
            filename: part.filename!,
            mimeType: part.mimeType ?? 'application/octet-stream',
            size: part.body?.size ?? 0,
            attachmentId: part.body?.attachmentId,
          ),
        );
      }

      // Recursively check parts
      if (part.parts != null) {
        for (final subPart in part.parts!) {
          extractFromPart(subPart);
        }
      }
    }

    extractFromPart(payload);
    return attachments;
  }

  /// Download attachment from Gmail
  Future<List<int>?> downloadAttachment(String messageId, String attachmentId) async {
    if (_gmailApi == null) {
      throw Exception('Not signed in to Gmail');
    }

    try {
      final attachment = await _gmailApi!.users.messages.attachments.get(
        'me',
        messageId,
        attachmentId,
      );

      if (attachment.data == null) return null;

      return base64Url.decode(attachment.data!);
    } catch (e) {
      developer.log('Error downloading attachment: $e', name: 'GmailService');
      return null;
    }
  }

  /// Mark email as read
  Future<void> markAsRead(String messageId) async {
    if (_gmailApi == null) {
      throw Exception('Not signed in to Gmail');
    }

    try {
      await _gmailApi!.users.messages.modify(
        gmail.ModifyMessageRequest(removeLabelIds: ['UNREAD']),
        'me',
        messageId,
      );
    } catch (e) {
      developer.log('Error marking message as read: $e', name: 'GmailService');
    }
  }

  /// Get labels/folders from Gmail
  Future<List<String>> getLabels() async {
    if (_gmailApi == null) {
      throw Exception('Not signed in to Gmail');
    }

    try {
      final response = await _gmailApi!.users.labels.list('me');
      return response.labels?.map((l) => l.name ?? '').where((n) => n.isNotEmpty).toList() ?? [];
    } catch (e) {
      developer.log('Error fetching labels: $e', name: 'GmailService');
      return [];
    }
  }
}
