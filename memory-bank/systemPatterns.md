# System Patterns: AI-Powered Organizer App

## Architecture Overview

### Clean Architecture Pattern
```
Presentation Layer (UI)
    ↓
Domain Layer (Business Logic)
    ↓
Data Layer (Repositories & Data Sources)
```

#### Layer Responsibilities
- **Presentation**: Widgets, screens, state management (Riverpod)
- **Domain**: Entities, use cases, repository interfaces
- **Data**: Repository implementations, local/remote data sources

### State Management Architecture (Riverpod)

#### Provider Patterns
```dart
// Entity providers for core data
final noteProvider = StateNotifierProvider<NoteNotifier, AsyncValue<List<Note>>>();

// Repository providers for data access
final noteRepositoryProvider = Provider<NoteRepository>();

// Use case providers for business logic
final createNoteUseCaseProvider = Provider<CreateNoteUseCase>();

// UI state providers for screen-specific state
final noteListStateProvider = StateNotifierProvider<NoteListNotifier, NoteListState>();
```

#### State Flow Pattern
1. **UI Action** → Trigger provider method
2. **Provider** → Call use case
3. **Use Case** → Execute business logic via repository
4. **Repository** → Coordinate local/remote data sources
5. **Data Source** → Persist/retrieve data
6. **State Update** → Notify UI consumers

## Data Layer Patterns

### Repository Pattern
```dart
abstract class NoteRepository {
  Future<List<Note>> getNotes();
  Future<Note> createNote(CreateNoteRequest request);
  Future<Note> updateNote(UpdateNoteRequest request);
  Future<void> deleteNote(String noteId);
  Stream<List<Note>> watchNotes();
}

class NoteRepositoryImpl implements NoteRepository {
  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;
  final SyncEngine syncEngine;
  
  // Implementation with offline-first logic
}
```

### Offline-First Sync Pattern
```dart
class SyncEngine {
  // 1. Local operations always succeed immediately
  // 2. Queue operations for remote sync
  // 3. Background sync with conflict resolution
  // 4. "Last write wins" strategy initially
  
  Future<void> syncNote(Note note) async {
    try {
      await remoteDataSource.syncNote(note);
      await localDataSource.markSynced(note.id);
    } catch (e) {
      await localDataSource.markPendingSync(note.id);
    }
  }
}
```

## UI/Presentation Patterns

### Screen Structure Pattern
```dart
class NoteListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(noteListProvider);
    
    return notesAsync.when(
      loading: () => LoadingWidget(),
      error: (error, stack) => ErrorWidget(error),
      data: (notes) => NoteListView(notes: notes),
    );
  }
}
```

### Navigation Pattern (GoRouter)
```dart
final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
      routes: [
        GoRoute(
          path: '/note/:id',
          builder: (context, state) => NoteDetailScreen(
            noteId: state.params['id']!,
          ),
        ),
      ],
    ),
  ],
);
```

## Data Modeling Patterns

### Freezed Entity Pattern
```dart
@freezed
class Note with _$Note {
  const factory Note({
    required String id,
    required String title,
    required String content,
    required DateTime createdAt,
    required DateTime updatedAt,
    required List<String> tags,
    String? folderId,
    List<Attachment>? attachments,
  }) = _Note;
  
  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
}
```

### Result Pattern for Error Handling
```dart
@freezed
class Result<T> with _$Result<T> {
  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(String error) = Failure<T>;
}

// Usage in repositories
Future<Result<Note>> createNote(CreateNoteRequest request) async {
  try {
    final note = await dataSource.createNote(request);
    return Result.success(note);
  } catch (e) {
    return Result.failure(e.toString());
  }
}
```

## AI Integration Patterns

### AI Service Abstraction
```dart
abstract class AIService {
  Future<List<String>> suggestTags(String content);
  Future<List<Note>> findRelatedNotes(String noteId);
  Future<String> extractTextFromImage(File image);
  Future<List<Task>> extractTasks(String content);
}

class HybridAIService implements AIService {
  final OnDeviceAI onDeviceAI;
  final CloudAI cloudAI;
  
  @override
  Future<List<String>> suggestTags(String content) async {
    // Try on-device first, fallback to cloud
    try {
      return await onDeviceAI.suggestTags(content);
    } catch (e) {
      return await cloudAI.suggestTags(content);
    }
  }
}
```

### OCR Processing Pattern
```dart
class OCRProcessor {
  Future<String> processImage(File imageFile) async {
    // 1. Compress image for processing
    final compressedImage = await _compressImage(imageFile);
    
    // 2. Extract text using ML Kit
    final extractedText = await _extractText(compressedImage);
    
    // 3. Post-process and clean text
    final cleanedText = await _cleanText(extractedText);
    
    return cleanedText;
  }
}
```

## Search & Indexing Patterns

### Search Service Pattern
```dart
class SearchService {
  Future<List<Note>> search(SearchQuery query) async {
    final results = <Note>[];
    
    // 1. Full-text search in content
    results.addAll(await _fullTextSearch(query.text));
    
    // 2. Tag-based filtering
    if (query.tags.isNotEmpty) {
      results.addAll(await _tagSearch(query.tags));
    }
    
    // 3. OCR text search
    results.addAll(await _ocrTextSearch(query.text));
    
    // 4. Semantic search (AI-powered)
    if (query.useSemanticSearch) {
      results.addAll(await _semanticSearch(query.text));
    }
    
    return _deduplicateAndRank(results, query);
  }
}
```

## Integration Patterns

### External Service Integration
```dart
abstract class CalendarIntegration {
  Future<void> syncEvents();
  Future<Event> createEvent(CreateEventRequest request);
  Stream<CalendarEvent> watchEvents();
}

class GoogleCalendarIntegration implements CalendarIntegration {
  final GoogleCalendarAPI api;
  final LocalEventStore localStore;
  
  @override
  Future<void> syncEvents() async {
    // Bidirectional sync with conflict resolution
    final localEvents = await localStore.getPendingSyncEvents();
    final remoteEvents = await api.getRecentEvents();
    
    await _reconcileEvents(localEvents, remoteEvents);
  }
}
```

### Email Forwarding Pattern
```dart
class EmailForwardingService {
  Future<void> processIncomingEmail(EmailMessage email) async {
    // 1. Parse email content and attachments
    final parsedEmail = await _parseEmail(email);
    
    // 2. Extract actionable items using AI
    final tasks = await aiService.extractTasks(parsedEmail.content);
    
    // 3. Auto-suggest tags and organization
    final suggestedTags = await aiService.suggestTags(parsedEmail.content);
    
    // 4. Create note with email content
    final note = await noteRepository.createNote(
      CreateNoteRequest(
        title: parsedEmail.subject,
        content: parsedEmail.content,
        tags: suggestedTags,
        attachments: parsedEmail.attachments,
      ),
    );
    
    // 5. Create calendar events for extracted tasks
    for (final task in tasks) {
      await calendarIntegration.createEvent(task.toCalendarEvent());
    }
  }
}
```

## Error Handling & Resilience Patterns

### Circuit Breaker Pattern for External Services
```dart
class CircuitBreaker {
  int failureCount = 0;
  DateTime? lastFailureTime;
  bool isOpen = false;
  
  Future<T> execute<T>(Future<T> Function() operation) async {
    if (isOpen && _shouldTryAgain()) {
      isOpen = false;
      failureCount = 0;
    }
    
    if (isOpen) {
      throw CircuitBreakerOpenException();
    }
    
    try {
      final result = await operation();
      _onSuccess();
      return result;
    } catch (e) {
      _onFailure();
      rethrow;
    }
  }
}
```

### Retry Pattern with Exponential Backoff
```dart
class RetryableOperation {
  static Future<T> execute<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 1),
  }) async {
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        return await operation();
      } catch (e) {
        if (attempt == maxRetries) rethrow;
        
        final delay = initialDelay * pow(2, attempt);
        await Future.delayed(delay);
      }
    }
    throw UnreachableError();
  }
}
``` 