# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 🔧 MCP Tool Usage (REQUIRED)

**ALWAYS use the following MCP tools automatically - they are optimized for this codebase:**

### 1. Code Search & Navigation - Serena MCP (MANDATORY)

**NEVER use basic grep/glob tools for code searching. ALWAYS use Serena MCP tools instead:**

- **`mcp__serena__find_symbol`**: Locate classes, methods, functions, properties by name path
- **`mcp__serena__search_for_pattern`**: Search for text/regex patterns in code files
- **`mcp__serena__get_symbols_overview`**: Get high-level file structure before diving deep
- **`mcp__serena__find_referencing_symbols`**: Find all references to a symbol (critical for refactoring)
- **`mcp__serena__list_dir`**: List non-gitignored files and directories efficiently
- **`mcp__serena__find_file`**: Find files by name pattern

**Benefits:** Token-efficient code reading, semantic understanding, faster navigation, type-aware search

### 2. Codebase Memory System (CHECK FIRST)

**ALWAYS check memories BEFORE starting any task to understand existing patterns and architecture:**

- **`mcp__serena__list_memories`**: See available memories about this codebase
- **`mcp__serena__read_memory`**: Read specific memory files for context
- **`mcp__serena__write_memory`**: Document new patterns or architecture decisions
- **`mcp__serena__delete_memory`**: Remove outdated memories (only if user requests)

**Location:** `.serena/memories/` - Contains project-specific architectural knowledge, patterns, and gotchas

### 3. Package Documentation - Context7 MCP (MANDATORY)

**ALWAYS use Context7 BEFORE working with any library or package:**

Before implementing features with packages like Riverpod, GoRouter, Freezed, Syncfusion, worker_manager, etc.:
1. Use Context7 to fetch the latest documentation
2. Understand the API, best practices, and patterns
3. Then implement using the documented approach

**This ensures:** Up-to-date API usage, best practices, fewer bugs, proper patterns

### 4. Workflow for Code Tasks

**Recommended order of operations:**

1. **Check memories first**: `mcp__serena__list_memories` → `mcp__serena__read_memory` for relevant context
2. **Use symbol overview**: `mcp__serena__get_symbols_overview` to understand file structure
3. **Search semantically**: `mcp__serena__find_symbol` or `mcp__serena__search_for_pattern` for specific code
4. **Check references**: `mcp__serena__find_referencing_symbols` before modifying code
5. **Consult docs**: Use Context7 for any package-related questions
6. **Document learnings**: `mcp__serena__write_memory` for new patterns discovered

## Project Overview

AI Organizer is a cross-platform Flutter app for intelligent note organization using AI capabilities. The app uses Supabase for backend services (auth, storage, database) and Google Gemini for AI features like image analysis, smart tagging, and natural language search.

## Development Commands

### Getting Started
```bash
flutter pub get                    # Install dependencies
flutter run                        # Run the app (default device)
flutter run -d chrome              # Run on Chrome
flutter run -d macos               # Run on macOS
```

### Code Generation
```bash
# Generate code for Freezed, JSON serialization, Drift database, and assets
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for continuous generation during development
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Testing & Analysis
```bash
flutter analyze                    # Run static analysis
flutter test                       # Run all tests
flutter test test/path/to/test.dart  # Run a single test file
```

### Environment Setup
Copy `.env.example` to `.env` and configure:
- `SUPABASE_URL` - Supabase project URL
- `SUPABASE_ANON_KEY` - Supabase anonymous key
- `GEMINI_API_KEY` - Google Gemini API key

## Architecture

### Layer Structure
The app follows Clean Architecture principles with clear separation:

1. **Presentation Layer** (`lib/presentation/`)
   - Screens organized by feature (home, auth, notes, search, organize, settings, profile, onboarding)
   - Widgets for reusable UI components
   - Uses Riverpod for state management

2. **Domain Layer** (`lib/domain/`)
   - Entities: Pure business objects
   - Use cases: Application-specific business rules
   - Repository interfaces

3. **Data Layer** (`lib/data/`)
   - Models with Freezed for immutability
   - Repositories implementing domain interfaces
   - Database (Drift/SQLite) for offline-first storage
   - Datasources for external APIs

4. **Core** (`lib/core/`)
   - Theme system (colors, typography, spacing)
   - Navigation (GoRouter with nested navigation)
   - Constants and generated assets
   - Localization setup

5. **Providers** (`lib/providers/`)
   - Riverpod providers for app-wide state
   - Key providers: `notesProvider`, `authProvider`, `aiProvider`, `syncProvider`, `databaseProvider`

6. **Services** (`lib/services/`)
   - External integrations (AI, Supabase)
   - `AIService` handles Gemini API calls for image analysis, tagging, transcription

### Key Design Patterns

**Offline-First Architecture**:
- Local SQLite database (Drift) as source of truth
- Supabase for cloud sync and backup
- Sync logic in `sync_provider.dart` handles conflict resolution

**State Management**:
- Riverpod providers in `lib/providers/` and `lib/presentation/providers/`
- Provider pattern: data providers fetch/cache data, action providers handle mutations
- Example: `notesProvider` for data, `NotesActions` for operations

**Navigation**:
- GoRouter with stateful nested navigation using separate navigator keys
- Bottom navigation maintains state across tabs
- Route extensions in `AppRouterExtension` for type-safe navigation

**Data Models**:
- Freezed for immutable data classes with copy-with
- JSON serialization with `json_serializable`
- Drift tables for database schema

### Database Schema (Drift)

Tables defined in `lib/data/database/app_database.dart`:
- `Notes`: Core note entity with title, content, timestamps, flags (pinned, archived, favorite)
- `Tags`: Reusable tags with usage tracking
- `Attachments`: File references with metadata (images, documents, audio)
- `NoteTags`: Many-to-many relationship between notes and tags

Custom converters handle complex types (AttachmentType enum, JSON metadata).

### AI Integration

`AIService` (`lib/services/ai_service.dart`) provides:
- `analyzeImage()`: Extract text and generate summaries from images
- `suggestTags()`: AI-generated tag suggestions for note content
- `findRelatedNotes()`: Semantic similarity search
- `naturalLanguageSearch()`: Query notes with natural language
- `transcribeAudio()`: Audio-to-text transcription

All methods use Google Gemini 1.5 Flash model with structured JSON responses.

## Code Style & Conventions

### Linting
Configured in `analysis_options.yaml`:
- Based on `flutter_lints`
- Enforces: return types, const constructors, final fields, package imports
- Treats unawaited futures as errors

### Import Style
- Always use package imports: `import 'package:ai_organizer/...'`
- Never use relative imports within lib/

### Code Generation
Files with `.g.dart` and `.freezed.dart` are generated - never edit manually. Run build_runner after modifying:
- Freezed classes (with `@freezed` annotation)
- JSON serializable classes (with `@JsonSerializable()`)
- Drift database classes (with `@DriftDatabase` or table definitions)

### Asset Management
Assets auto-generated via `flutter_gen` in `lib/core/gen/`:
- Use `Assets.images.imageName` for images
- Use `Assets.animations.animationName` for Lottie files
- Fonts accessed via Google Fonts package, not generated assets

## UI/UX Guidelines (STRICTLY ENFORCE)

**CRITICAL: All UI implementations MUST use the centralized theme system via `Theme.of(context)`. NEVER use hardcoded colors, text styles, or spacing values.**

### Color Usage

**ALWAYS use `Theme.of(context).colorScheme` for colors. NEVER hardcode colors or use direct `AppColors` references in UI code.**

**ColorScheme Properties (Automatically theme-aware):**
```dart
final colorScheme = Theme.of(context).colorScheme;

// Primary colors
colorScheme.primary              // Primary brand color (iOS Blue in light, adapted for dark)
colorScheme.onPrimary            // Text/icons on primary color
colorScheme.primaryContainer     // Container variant of primary
colorScheme.onPrimaryContainer   // Text/icons on primary container

// Secondary colors (AI features)
colorScheme.secondary            // Secondary accent (Purple for AI)
colorScheme.onSecondary          // Text/icons on secondary
colorScheme.secondaryContainer   // AI feature containers
colorScheme.onSecondaryContainer // Text/icons on secondary container

// Surfaces & backgrounds
colorScheme.surface              // Cards, sheets, dialogs
colorScheme.onSurface            // Text/icons on surfaces
colorScheme.surfaceContainerLowest   // Lowest elevation surfaces
colorScheme.surfaceContainerLow      // Low elevation surfaces
colorScheme.surfaceContainer         // Default surface container
colorScheme.surfaceContainerHigh     // High elevation surfaces
colorScheme.surfaceContainerHighest  // Highest elevation surfaces

// Background
colorScheme.background           // Screen background (deprecated in Material 3, use surface)
colorScheme.onBackground         // Text/icons on background

// Semantic colors
colorScheme.error                // Error states
colorScheme.onError              // Text/icons on error
colorScheme.errorContainer       // Error container backgrounds
colorScheme.onErrorContainer     // Text/icons on error containers

// Variants
colorScheme.outline              // Borders, dividers
colorScheme.outlineVariant       // Subtle borders
colorScheme.surfaceVariant       // Surface variations
colorScheme.onSurfaceVariant     // Text on surface variants
colorScheme.inverseSurface       // Inverse surface (tooltips, snackbars)
colorScheme.onInverseSurface     // Text on inverse surface
colorScheme.inversePrimary       // Inverse primary
```

**Common Usage Patterns:**
```dart
// Container backgrounds
Container(color: Theme.of(context).colorScheme.surface)           // Cards
Container(color: Theme.of(context).colorScheme.surfaceContainer)  // Elevated surfaces
Container(color: Theme.of(context).colorScheme.primaryContainer)  // Highlighted containers

// Text colors
Text('Title', style: TextStyle(color: Theme.of(context).colorScheme.onSurface))
Text('Body', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))

// Borders
border: Border.all(color: Theme.of(context).colorScheme.outline)
border: Border.all(color: Theme.of(context).colorScheme.outlineVariant)  // Subtle

// Buttons
backgroundColor: Theme.of(context).colorScheme.primary
foregroundColor: Theme.of(context).colorScheme.onPrimary
```

**Common Mistakes to Avoid:**
```dart
// ❌ WRONG - Never hardcode colors
Container(color: Color(0xFF007AFF))
Text('Hello', style: TextStyle(color: Colors.black))

// ❌ WRONG - Don't use AppColors directly in UI code
Container(color: AppColors.lightPrimary)
Text('Hello', style: TextStyle(color: AppColors.lightPrimaryText))

// ✅ CORRECT - Always use Theme.of(context).colorScheme
Container(color: Theme.of(context).colorScheme.primary)
Text('Hello', style: TextStyle(color: Theme.of(context).colorScheme.onSurface))

// ✅ CORRECT - Or store colorScheme in a variable
final colorScheme = Theme.of(context).colorScheme;
Container(color: colorScheme.surface)
```

### Typography Usage

**ALWAYS use `Theme.of(context).textTheme` for text styles. NEVER create TextStyle manually or use direct `AppTypography` calls in UI code.**

**TextTheme Properties (Automatically theme-aware):**
```dart
final textTheme = Theme.of(context).textTheme;

// Display - Largest text (screen headers)
textTheme.displayLarge     // 57sp, bold - Hero text
textTheme.displayMedium    // 45sp - Large headers
textTheme.displaySmall     // 36sp - Headers

// Headline - Section headers
textTheme.headlineLarge    // 32sp - Major sections
textTheme.headlineMedium   // 28sp - Section headers
textTheme.headlineSmall    // 24sp - Sub-sections

// Title - Card/component titles
textTheme.titleLarge       // 22sp, medium - Card headers, dialog titles
textTheme.titleMedium      // 16sp, medium - Card subtitles, list titles
textTheme.titleSmall       // 14sp, medium - Compact titles

// Body - Content text
textTheme.bodyLarge        // 16sp - Emphasized body text
textTheme.bodyMedium       // 14sp - Default body text
textTheme.bodySmall        // 12sp - Small body text

// Label - UI elements
textTheme.labelLarge       // 14sp, medium - Buttons, tabs
textTheme.labelMedium      // 12sp, medium - Input labels
textTheme.labelSmall       // 11sp, medium - Captions, helper text
```

**Examples:**
```dart
// Get text theme once
final textTheme = Theme.of(context).textTheme;
final colorScheme = Theme.of(context).colorScheme;

// Screen title
Text('My Notes', style: textTheme.displayLarge)

// Card title
Text('Note Title', style: textTheme.titleLarge)

// Body text
Text('Note content...', style: textTheme.bodyMedium)

// Metadata / timestamp
Text('2 hours ago', style: textTheme.labelSmall?.copyWith(
  color: colorScheme.onSurfaceVariant,
))

// Custom color override (when needed)
Text(
  'Important',
  style: textTheme.titleMedium?.copyWith(
    color: colorScheme.primary,
    fontWeight: FontWeight.w600,
  ),
)

// Using with explicit color from colorScheme
Text(
  'Error message',
  style: textTheme.bodySmall?.copyWith(color: colorScheme.error),
)
```

**Common Mistakes to Avoid:**
```dart
// ❌ WRONG - Never create TextStyle manually
Text('Hello', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))

// ❌ WRONG - Don't use AppTypography directly in UI code
Text('Hello', style: AppTypography.titleLarge(color: AppColors.lightPrimaryText))

// ✅ CORRECT - Always use Theme.of(context).textTheme
Text('Hello', style: Theme.of(context).textTheme.titleLarge)

// ✅ CORRECT - With color override from colorScheme
Text(
  'Hello',
  style: Theme.of(context).textTheme.titleLarge?.copyWith(
    color: Theme.of(context).colorScheme.primary,
  ),
)
```

### Spacing Usage

**ALWAYS use `AppSpacing` for all spacing, padding, and margin values. NEVER hardcode numbers.**

**Base Spacing Values:**
- `AppSpacing.xxxs` (2dp), `xxs` (4dp), `xs` (8dp), `sm` (12dp)
- `AppSpacing.md` (16dp) - **Base unit**
- `AppSpacing.lg` (20dp), `xl` (24dp), `xxl` (32dp), `xxxl` (40dp)

**Border Radius:**
- `AppSpacing.radiusXs` (8dp), `radiusSm` (12dp), `radiusMd` (16dp), `radiusLg` (20dp), `radiusXl` (24dp)

**Component-Specific:**
- Padding: `AppSpacing.cardPadding`, `buttonPadding`, `listItemPadding`, `screenHorizontal`, `screenVertical`
- Margins: `AppSpacing.cardMargin`, `listItemSpacing`, `fabMargin`, `dividerSpacing`
- Sizes: `AppSpacing.iconSize`, `iconSizeSmall`, `iconSizeLarge`, `minTouchTarget`
- Layout: `AppSpacing.maxContentWidth`, `appBarHeight`, `bottomNavHeight`

**Examples:**
```dart
// Card with proper spacing
Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppSpacing.radiusSm), // 12dp
  ),
  child: Padding(
    padding: const EdgeInsets.all(AppSpacing.cardPadding), // 16dp
    child: Column(
      spacing: AppSpacing.sm, // 12dp gap between children
      children: [...],
    ),
  ),
)

// Button padding
ElevatedButton(
  style: ElevatedButton.styleFrom(
    padding: AppSpacing.buttonPadding, // 24dp horizontal, 12dp vertical
  ),
)

// Screen padding
Padding(
  padding: const EdgeInsets.symmetric(
    horizontal: AppSpacing.screenHorizontal, // 16dp
    vertical: AppSpacing.screenVertical, // 16dp
  ),
)

// SizedBox spacing
SizedBox(height: AppSpacing.md) // 16dp
SizedBox(width: AppSpacing.xs)  // 8dp
```

**Responsive Spacing:**
```dart
// Use responsive methods for different screen sizes
AppSpacing.responsive(context, mobile: AppSpacing.md, tablet: AppSpacing.lg, desktop: AppSpacing.xl)

// Context extensions (preferred)
Padding(padding: context.screenPadding)
Padding(padding: context.horizontalPadding)
Padding(padding: context.safeScreenPadding) // Safe area aware
```

**Shadows:**
```dart
// Use AppShadows instead of elevation
Container(
  decoration: BoxDecoration(
    color: AppColors.lightCardBackground,
    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
    boxShadow: AppShadows.cardShadow, // Subtle 4% shadow
  ),
)

// For elevated state
boxShadow: AppShadows.cardElevatedShadow // 8% shadow on press/hover
boxShadow: AppShadows.modalShadow // 20% shadow for modals
```

**Animation Durations:**
```dart
AnimatedContainer(
  duration: AppSpacing.animationDuration, // 250ms
  duration: AppSpacing.fastAnimation,     // 150ms
  duration: AppSpacing.slowAnimation,     // 350ms
)
```

**Common Mistakes to Avoid:**
```dart
// ❌ WRONG - Never hardcode spacing
Padding(padding: EdgeInsets.all(16.0))
SizedBox(height: 24)
BorderRadius.circular(12)

// ✅ CORRECT - Always use AppSpacing
Padding(padding: EdgeInsets.all(AppSpacing.md))
SizedBox(height: AppSpacing.xl)
BorderRadius.circular(AppSpacing.radiusSm)
```

### Complete Component Example

```dart
// ✅ CORRECT - Following all theme guidelines
class NoteCard extends StatelessWidget {
  final String title;
  final String content;
  final DateTime timestamp;

  @override
  Widget build(BuildContext context) {
    // Get theme data once at the top
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.cardMargin,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.xs,
          children: [
            // Title
            Text(
              title,
              style: textTheme.titleLarge,
            ),

            // Content
            Text(
              content,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: AppSpacing.xs),

            // Timestamp
            Text(
              _formatTimestamp(timestamp),
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Theme Access Patterns

**Accessing Theme in Widgets:**
```dart
// Best practice: Get theme data once at the top of build method
final colorScheme = Theme.of(context).colorScheme;
final textTheme = Theme.of(context).textTheme;

// Then use throughout the widget
Container(
  color: colorScheme.surface,
  child: Text('Hello', style: textTheme.titleLarge),
)

// Access specific properties
final primaryColor = colorScheme.primary;
final titleStyle = textTheme.titleLarge;
final surfaceColor = colorScheme.surface;
```

**Common Color Mappings:**
```dart
final colorScheme = Theme.of(context).colorScheme;

// Screen backgrounds
colorScheme.surface              // Replaces AppColors.lightBackground/darkBackground

// Card backgrounds
colorScheme.surface              // Replaces AppColors.lightCardBackground/darkCardBackground
colorScheme.surfaceContainer     // For elevated cards

// Text colors
colorScheme.onSurface           // Primary text (titles)
colorScheme.onSurfaceVariant    // Secondary text (body, metadata)

// Borders & dividers
colorScheme.outline             // Borders
colorScheme.outlineVariant      // Subtle dividers

// AI features
colorScheme.secondary           // AI accent color
colorScheme.secondaryContainer  // AI backgrounds
```

**When to Use AppColors (Rare Cases):**
```dart
// AppColors should ONLY be used in theme definition files
// (e.g., lib/core/theme/app_theme.dart, lib/core/theme/app_colors.dart)
// NOT in UI component code

// ❌ WRONG - In a widget
Container(color: AppColors.lightPrimary)

// ✅ CORRECT - In theme definition
ThemeData(
  colorScheme: ColorScheme.light(
    primary: AppColors.lightPrimary,
    secondary: AppColors.lightSecondary,
  ),
)
```

### Shared Widget Guidelines (MANDATORY)

**CRITICAL: Always use existing shared widgets from `lib/presentation/widgets/` before creating new components. Reusability is a top priority.**

**Available Shared Widgets:**

The following reusable components are available in `lib/presentation/widgets/`:

**Buttons:**
- `PrimaryButton` - Main action buttons with theme-aware styling
- `SecondaryButton` - Secondary action buttons

**Form Inputs:**
- `AppTextField` - Themed text input fields with consistent styling
- `AppSearchBar` - Search input with search icon and theming
- `BacklinkAutocompleteField` - Autocomplete field for note backlinking

**Navigation:**
- `AppBottomNav` - Bottom navigation bar (in navigation/ subfolder)
- `SimpleTabBar` - Simple tab bar component

**Data Display:**
- `NoteCard` - Card component for displaying notes
- `AttachmentViewer` - View and display note attachments
- `LinkPreviewWidget` - Preview links with metadata
- `EmptyState` - Empty state placeholder with icon and message

**Layout & Organization:**
- `FolderTree` - Tree view for folder/hierarchical navigation

**Dialogs & Sheets:**
- `ActionSheet` - Bottom sheet for action menus

**Widget Usage Guidelines:**

1. **Check Before Creating (MANDATORY):**
   ```dart
   // ❌ WRONG - Creating a new button without checking existing widgets
   class MyCustomButton extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       return ElevatedButton(...); // Reinventing the wheel
     }
   }

   // ✅ CORRECT - Use existing PrimaryButton
   import 'package:ai_organizer/presentation/widgets/primary_button.dart';

   PrimaryButton(
     text: 'Save',
     onPressed: () => _handleSave(),
   )
   ```

2. **Before Creating Any UI Component:**
   - First, check `lib/presentation/widgets/` for existing components
   - Review the widget's API to see if it supports your use case
   - Use composition and configuration over duplication
   - Only create new widgets if no existing widget fits your needs

3. **When to Use Shared Widgets:**
   - **Always** for buttons (use `PrimaryButton` or `SecondaryButton`)
   - **Always** for text inputs (use `AppTextField` or `AppSearchBar`)
   - **Always** for note display (use `NoteCard`)
   - **Always** for empty states (use `EmptyState`)
   - **Always** for bottom sheets/action menus (use `ActionSheet`)

4. **When to Create New Shared Widgets:**
   Create a new shared widget in `lib/presentation/widgets/` when:
   - The component will be used in 2+ different screens/features
   - It represents a common UI pattern (cards, inputs, buttons, etc.)
   - It encapsulates reusable business logic + UI
   - It provides consistent styling across the app

   **DO NOT** create new widgets for:
   - One-off, screen-specific layouts (keep in screen file)
   - Simple composition of existing widgets (use inline)
   - Widgets that won't be reused elsewhere

5. **Creating New Shared Widgets - Best Practices:**
   ```dart
   // ✅ CORRECT - Reusable, configurable, theme-aware
   class CustomCard extends StatelessWidget {
     final String title;
     final Widget? trailing;
     final VoidCallback? onTap;

     const CustomCard({
       super.key,
       required this.title,
       this.trailing,
       this.onTap,
     });

     @override
     Widget build(BuildContext context) {
       final colorScheme = Theme.of(context).colorScheme;
       final textTheme = Theme.of(context).textTheme;

       return InkWell(
         onTap: onTap,
         borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
         child: Container(
           padding: const EdgeInsets.all(AppSpacing.cardPadding),
           decoration: BoxDecoration(
             color: colorScheme.surface,
             borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
             boxShadow: AppShadows.cardShadow,
           ),
           child: Row(
             children: [
               Expanded(
                 child: Text(title, style: textTheme.titleMedium),
               ),
               if (trailing != null) trailing!,
             ],
           ),
         ),
       );
     }
   }
   ```

6. **Widget File Naming:**
   - Use snake_case for filenames: `primary_button.dart`, `note_card.dart`
   - Class names should be PascalCase: `PrimaryButton`, `NoteCard`
   - Place in `lib/presentation/widgets/` root or appropriate subfolder

7. **Widget Documentation:**
   Always add documentation comments to new shared widgets:
   ```dart
   /// A primary action button with consistent theming.
   ///
   /// Use this for main CTAs like "Save", "Submit", "Create".
   /// For secondary actions, use [SecondaryButton] instead.
   ///
   /// Example:
   /// ```dart
   /// PrimaryButton(
   ///   text: 'Save Note',
   ///   onPressed: () => _saveNote(),
   ///   isLoading: _isSaving,
   /// )
   /// ```
   class PrimaryButton extends StatelessWidget {
     // ...
   }
   ```

8. **Examples - What to Reuse vs Create:**

   **Reuse Existing:**
   ```dart
   // Need a button? Use PrimaryButton
   PrimaryButton(text: 'Submit', onPressed: _submit)

   // Need a text field? Use AppTextField
   AppTextField(
     label: 'Note Title',
     controller: _titleController,
   )

   // Need to show empty state? Use EmptyState
   EmptyState(
     icon: Icons.note_outlined,
     title: 'No notes yet',
     message: 'Create your first note to get started',
   )
   ```

   **Create New (if truly reusable):**
   ```dart
   // New pattern used across multiple screens
   // Place in lib/presentation/widgets/tag_chip.dart
   class TagChip extends StatelessWidget {
     final String label;
     final VoidCallback? onDelete;
     // Theme-aware, reusable component
   }
   ```

   **Keep in Screen (one-off layouts):**
   ```dart
   // Screen-specific layout, not reused elsewhere
   // Keep in lib/presentation/screens/my_screen/my_screen.dart
   class _MyScreenHeader extends StatelessWidget {
     // Screen-specific, not reusable
   }
   ```

**Shared Widget Checklist:**

Before creating any new widget, verify:
- [ ] Checked `lib/presentation/widgets/` for existing components
- [ ] Confirmed no existing widget can be adapted/configured for this use case
- [ ] Determined widget will be reused in 2+ places (if creating new)
- [ ] New widget follows theme guidelines (colorScheme, textTheme, AppSpacing)
- [ ] New widget is configurable via constructor parameters
- [ ] New widget has documentation comments
- [ ] New widget is placed in `lib/presentation/widgets/` (not in screen folders)

### Enforcement Checklist

Before submitting any UI code, verify:
- [ ] No hardcoded color values (no `Color(0x...)` or `Colors.xxx` except in theme definition files)
- [ ] No direct `AppColors` usage in UI code (use `Theme.of(context).colorScheme` instead)
- [ ] No direct `AppTypography` usage in UI code (use `Theme.of(context).textTheme` instead)
- [ ] No hardcoded `TextStyle` creation (use `textTheme` properties)
- [ ] No hardcoded spacing numbers (use `AppSpacing` constants)
- [ ] No hardcoded border radius (use `AppSpacing.radius*`)
- [ ] No hardcoded elevation values (use `AppShadows` instead)
- [ ] Theme data extracted once at top of build method (`final colorScheme = Theme.of(context).colorScheme`)
- [ ] All components automatically theme-aware (no manual brightness checks needed with colorScheme)
- [ ] Responsive spacing used for adaptive layouts where appropriate
- [ ] Accessibility: minimum touch target size (`AppSpacing.minTouchTarget`)

**Quick Reference - What to Use Where:**
- **UI Components**: `Theme.of(context).colorScheme`, `Theme.of(context).textTheme`, `AppSpacing`
- **Theme Definitions**: `AppColors`, `AppTypography` (only in `lib/core/theme/` files)

## Common Workflows

### Adding a New Note Feature
1. Define domain entity in `lib/domain/entities/` if needed
2. Update Drift schema in `lib/data/database/app_database.dart`
3. Run build_runner to generate database code
4. Add repository method in `lib/data/repositories/note_repository.dart`
5. Create/update Riverpod provider in `lib/providers/notes_provider.dart`
6. Implement UI in `lib/presentation/screens/notes/`

### Adding a New Screen
1. Create screen file in appropriate `lib/presentation/screens/` subdirectory
2. Add route to `lib/core/navigation/app_router.dart`
3. Add navigation extension method if needed
4. Update bottom navigation in `lib/presentation/widgets/app_bottom_nav.dart` if it's a main tab

### Integrating New AI Features
1. Add method to `AIService` class in `lib/services/ai_service.dart`
2. Create provider in `lib/providers/ai_provider.dart` if stateful
3. Use provider in presentation layer
4. Handle loading/error states with AsyncValue

### Adding Translations
1. Add translation keys to JSON files in `assets/translations/`
2. Use `context.tr('key')` or `'key'.tr()` with easy_localization
3. Supported languages defined in main.dart initialization

## Important Notes

- **Never commit `.env` file** - contains API keys
- **Database migrations**: Update `schemaVersion` and `migration` in AppDatabase when changing schema
- **Theme changes**: Modify `lib/core/theme/` files, uses Material 3 with adaptive themes
- **Sync conflicts**: Currently uses "last write wins" strategy (see `sync_provider.dart`)
- **Permissions**: Audio recording and camera require runtime permissions via `permission_handler`
