# Wiki-Style Note Backlinking Implementation

**Implementation Date:** October 25, 2025
**Feature Status:**  Complete
**Task Reference:** Priority 1, Task 1.4 from `memory-bank/next-tasks.md`

## Overview

This document describes the complete implementation of wiki-style note backlinking functionality for the AI Organizer app. This feature allows users to create bidirectional links between notes using `[[note-title]]` or `[[note-id]]` syntax, similar to popular note-taking apps like Obsidian and Roam Research.

## Features Implemented

### 1. Backlink Syntax Parser
**File:** `lib/utils/backlink_parser.dart`

The backlink parser handles:
- Parsing `[[text]]` syntax in note content
- Support for both `[[note-title]]` and `[[note-id|display-text]]` formats
- Extracting all backlinks from note content
- Building clickable TextSpan widgets with visual styling
- Helper methods for backlink manipulation

**Key Methods:**
- `parseBacklinks(String content)` - Extracts all backlink matches
- `buildTextSpanWithBacklinks()` - Creates clickable, styled backlinks in UI
- `extractTargetIds()` - Gets unique target IDs from content
- `createBacklink()` - Helper to create backlink syntax
- `stripBacklinkFormatting()` - Remove backlink formatting for search/preview

### 2. Database Schema
**Files:**
- `lib/data/database/app_database.dart` - Local SQLite schema
- `supabase/migrations/20251025021810_create_backlinks_table.sql` - Supabase migration

**Backlinks Table Structure:**
```dart
class Backlinks extends Table {
  TextColumn get id => text()();
  TextColumn get sourceNoteId => text().references(Notes, #id, onDelete: KeyAction.cascade)();
  TextColumn get targetNoteId => text().references(Notes, #id, onDelete: KeyAction.cascade)();
  TextColumn get targetText => text()(); // The text/title used in the backlink
  DateTimeColumn get createdAt => dateTime()();
}
```

**Database Operations:**
- `getOutgoingBacklinks(noteId)` - Get links from this note
- `getIncomingBacklinks(noteId)` - Get links to this note
- `insertBacklink()` - Create new backlink
- `deleteBacklinksFromSource()` - Remove all outgoing links
- `updateBacklinksForNote()` - Refresh all backlinks for a note

### 3. Backlink Repository
**File:** `lib/data/repositories/backlink_repository.dart`

**Key Features:**
- Automatic backlink parsing and indexing
- Resolves backlinks by both title and ID
- Fuzzy matching (contains) if exact match not found
- Provides full note objects for backlink sources/targets
- Utility methods for graph analysis:
  - `getBacklinkGraph()` - Full note relationship map
  - `getOrphanedNotes()` - Notes with no connections
  - `getHubNotes()` - Notes with many incoming links

**Backlink Resolution Logic:**
1. First tries exact UUID match
2. Then tries exact title match (case-insensitive)
3. Falls back to title contains match

### 4. Note Repository Integration
**File:** `lib/data/repositories/note_repository.dart`

Backlinks are automatically managed when notes are created or updated:

```dart
Future<Note> createNote(...) async {
  // ...create note...

  // Index backlinks in the note content
  await _backlinkRepository.updateBacklinksForNote(
    noteId: note.id,
    content: content,
  );

  return note;
}
```

Same integration exists in `updateNote()` and `deleteNote()` methods.

### 5. UI Components

#### Clickable Backlinks in Note Content
**File:** `lib/presentation/screens/notes/note_detail_screen.dart` (lines 433-461)

Notes display with clickable backlinks:
```dart
SelectableText.rich(
  BacklinkParser.buildTextSpanWithBacklinks(
    note.content,
    defaultStyle,
    backlinkStyle,
    (targetId) => _navigateToLinkedNote(context, targetId),
  ),
)
```

**Visual Styling:**
- Blue text color
- Light blue background (10% opacity)
- Blue border
- Rounded corners
- Medium font weight

#### Backlinks Section
**File:** `lib/presentation/screens/notes/note_detail_screen.dart` (lines 1122-1250)

Shows all notes that link to the current note:
- Card-based UI for each linking note
- Displays note title and preview
- Click to navigate to linking note
- Shows "No backlinks yet" message when empty
- Loading and error states handled

### 6. Backlink Providers
**File:** `lib/providers/backlink_provider.dart`

Riverpod providers for reactive state management:

**Data Providers:**
- `incomingBacklinksProvider` - Notes linking to this note
- `outgoingBacklinksProvider` - Notes this note links to
- `incomingBacklinkCountProvider` - Count of incoming links
- `outgoingBacklinkCountProvider` - Count of outgoing links
- `backlinkCountProvider` - Total link count
- `backlinkGraphProvider` - Full relationship graph
- `orphanedNotesProvider` - Unconnected notes
- `hubNotesProvider` - Highly connected notes

**Action Provider:**
- `backlinkActionsProvider` - Mutation operations with cache invalidation

### 7. Supabase Sync Integration
**File:** `lib/providers/sync_provider.dart`

Backlinks are synced to/from Supabase automatically:

**Sync to Server:**
- Deletes existing backlinks for note on server
- Inserts new backlinks based on current note content
- Called after syncing each note

**Sync from Server:**
- Fetches backlinks from server
- Replaces local backlinks with server version
- Called when syncing notes from server

**Supabase Schema:**
```sql
CREATE TABLE public.backlinks (
    id TEXT PRIMARY KEY,
    source_note_id TEXT NOT NULL,
    target_note_id TEXT NOT NULL,
    target_text TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    user_id UUID NOT NULL
);
```

Row Level Security (RLS) policies ensure users only see their own backlinks.

## Architecture Decisions

### 1. Offline-First
Backlinks are stored in local SQLite database and synced to Supabase. This ensures:
- Fast local performance
- Works without internet connection
- Automatic sync when online

### 2. Automatic Indexing
Backlinks are automatically parsed and indexed when notes are saved. Users don't need to manually manage them.

### 3. Bidirectional Links
The system maintains both directions:
- Outgoing links (links from this note)
- Incoming links (backlinks to this note)

### 4. Smart Resolution
Backlinks can use either:
- Note ID: `[[abc-123-def]]` - Direct, never breaks
- Note title: `[[My Note]]` - User-friendly, may need updates if title changes

### 5. Non-Blocking Sync
Backlink sync errors don't prevent note sync. Backlinks are considered supplementary data.

## Usage Examples

### Creating Backlinks

In any note content, users can create links:

```markdown
This is a reference to [[My Project Note]].

You can also use IDs: [[abc-123-def-456]].

Or use display text: [[abc-123-def|see this note]].
```

### Viewing Backlinks

When viewing a note, users see:
1. **Content section** - Clickable backlinks in the note text
2. **Backlinks section** - List of notes that reference this note

### Navigation

Clicking any backlink:
1. Resolves the target note
2. Navigates to note detail screen
3. Target note's backlinks include the source note

## Testing Recommendations

### Unit Tests
- `BacklinkParser` utility methods
- Repository backlink resolution logic
- Sync methods (mock Supabase)

### Integration Tests
- Create note with backlinks
- Update note content with new backlinks
- Delete note with backlinks (cascade)
- Sync cycle (local ’ server ’ local)

### E2E Tests
- Create two notes
- Add backlink from Note A to Note B
- Verify backlink appears in Note B's backlinks section
- Click backlink to navigate
- Edit Note A to remove backlink
- Verify backlink removed from Note B

## Future Enhancements

### Autocomplete (Deferred)
**Status:** Not implemented in this phase
**Reason:** Requires complex TextField wrapping and real-time suggestion UI

**Suggested Implementation:**
- Create custom `BacklinkAutocompleteField` widget
- Detect `[[` input trigger
- Show overlay with note title suggestions
- Insert selected note title or ID
- File: `lib/presentation/widgets/backlink_autocomplete_field.dart` (placeholder created)

### Graph Visualization
**Status:** Optional future feature
**Complexity:** High

**Suggested Approach:**
- Use `backlinkGraphProvider` data
- Implement force-directed graph layout
- Interactive node navigation
- Package suggestions: `flutter_graph_view`, `graphite`

### Backlink Mentions
Show context around where note is mentioned:
- Extract surrounding text
- Display as preview in backlinks section
- "...mentioned in context..."

### Broken Link Detection
- Detect backlinks to deleted/non-existent notes
- Highlight in red or with warning icon
- Offer to remove or update

## Files Modified/Created

### Created Files:
- `lib/utils/backlink_parser.dart` 
- `lib/data/repositories/backlink_repository.dart` 
- `lib/providers/backlink_provider.dart` 
- `supabase/migrations/20251025021810_create_backlinks_table.sql` 
- `docs/BACKLINKS_IMPLEMENTATION.md` 

### Modified Files:
- `lib/data/database/app_database.dart` - Added Backlinks table 
- `lib/data/repositories/note_repository.dart` - Added backlink integration 
- `lib/providers/sync_provider.dart` - Added backlink sync methods 
- `lib/presentation/screens/notes/note_detail_screen.dart` - Added UI components 

### Files Not Modified:
- `lib/presentation/screens/notes/note_edit_screen.dart` - Autocomplete deferred

## Performance Considerations

### Database Indexes
Created indexes on:
- `source_note_id` - Fast lookup of outgoing links
- `target_note_id` - Fast lookup of incoming links (backlinks)
- `user_id` - Fast filtering by user

### Caching
Riverpod providers cache backlink data:
- Invalidated when notes are updated
- Prevents unnecessary database queries
- Reactive UI updates

### Sync Optimization
- Backlinks synced in batches per note
- Delete-then-insert strategy (simpler than diff)
- Silent error handling (non-blocking)

## Known Limitations

1. **No Autocomplete:** Users must manually type note titles/IDs
2. **No Rename Cascade:** If note title changes, backlinks by title may break
3. **No Bidirectional Title Sync:** `[[Old Title]]` won't automatically update to `[[New Title]]`

**Mitigation:** Use note IDs for permanent links, titles for readability.

## Migration Path for Existing Notes

For notes created before backlink feature:
1. Backlinks are indexed on next save/edit
2. Old notes without edits won't have backlinks indexed
3. Consider batch re-indexing job:

```dart
Future<void> reindexAllBacklinks() async {
  final notes = await noteRepository.getAllNotes();
  for (final note in notes) {
    await backlinkRepository.updateBacklinksForNote(
      noteId: note.id,
      content: note.content,
    );
  }
}
```

## Supabase Setup Instructions

1. **Run Migration:**
   ```bash
   supabase migration up
   ```

2. **Verify Table:**
   ```sql
   SELECT * FROM backlinks LIMIT 10;
   ```

3. **Test RLS:**
   Create test backlink and verify user can only see their own.

## Conclusion

The wiki-style backlink feature is fully implemented with:
-  Automatic backlink parsing and indexing
-  Bidirectional link tracking
-  Clickable UI with visual styling
-  Backlinks section showing incoming links
-  Local SQLite and Supabase sync
-  Provider-based state management
-  Cascade deletion
- ø Autocomplete (deferred to future phase)

The implementation follows the app's clean architecture pattern, integrates seamlessly with existing note CRUD operations, and provides a solid foundation for future graph-based features.

**Task Status:**  **COMPLETE**
