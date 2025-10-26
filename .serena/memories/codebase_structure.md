# Codebase Structure

## Directory Layout

```
lib/
├── main.dart                          # App entry point
├── config/                            # Configuration files
│   ├── api_keys.dart                  # API key management
│   └── supabase_config.dart           # Supabase initialization
├── core/                              # Core utilities and shared code
│   ├── constants/                     # App constants
│   ├── gen/                           # Generated assets (flutter_gen)
│   │   ├── assets.gen.dart
│   │   └── fonts.gen.dart
│   ├── l10n/                          # Localization setup
│   ├── navigation/
│   │   └── app_router.dart            # GoRouter configuration
│   ├── theme/                         # Theme system
│   │   ├── app_colors.dart
│   │   ├── app_spacing.dart
│   │   ├── app_theme.dart
│   │   └── app_typography.dart
│   └── utils/                         # Core utilities
├── data/                              # Data layer
│   ├── database/
│   │   ├── app_database.dart          # Drift database definition
│   │   └── app_database.g.dart        # Generated database code
│   ├── datasources/                   # External data sources
│   ├── models/                        # Data models with Freezed
│   │   ├── note.dart / note.freezed.dart / note.g.dart
│   │   ├── tag.dart / tag.freezed.dart / tag.g.dart
│   │   └── attachment.dart / attachment.freezed.dart / attachment.g.dart
│   └── repositories/                  # Repository implementations
│       └── note_repository.dart
├── domain/                            # Domain layer
│   ├── entities/                      # Business entities
│   ├── repositories/                  # Repository interfaces
│   └── usecases/                      # Business logic use cases
├── presentation/                      # Presentation layer
│   ├── providers/                     # Screen-specific providers
│   ├── screens/                       # UI screens
│   │   ├── auth/                      # Login, signup
│   │   ├── home/                      # Home screen
│   │   ├── notes/                     # Note list, detail, edit, voice note
│   │   ├── onboarding/                # Onboarding flow
│   │   ├── organize/                  # Organization features
│   │   ├── profile/                   # User profile
│   │   ├── search/                    # Search functionality
│   │   └── settings/                  # App settings
│   └── widgets/                       # Reusable UI components
│       ├── navigation/
│       │   └── main_navigation.dart
│       ├── app_bottom_nav.dart
│       ├── attachment_viewer.dart
│       └── glass_container.dart
├── providers/                         # App-wide Riverpod providers
│   ├── ai_provider.dart               # AI service provider
│   ├── auth_provider.dart             # Authentication state
│   ├── database_provider.dart         # Database instance
│   ├── notes_provider.dart            # Notes state and actions
│   ├── storage_provider.dart          # Storage management
│   └── sync_provider.dart             # Cloud sync logic
├── routes/
│   └── app_router.dart                # Route definitions
├── services/                          # External service integrations
│   └── ai_service.dart                # Google Gemini integration
└── utils/                             # Utility functions
    └── file_utils.dart

assets/
├── animations/                        # Lottie animation files
├── images/                            # Static images
└── translations/                      # Localization JSON files
```

## Architecture Pattern

### Clean Architecture Layers
1. **Presentation**: UI screens, widgets, screen-specific state
2. **Domain**: Business logic, entities, use cases, repository interfaces
3. **Data**: Repository implementations, models, data sources, database

### Key Architectural Decisions
- **Offline-first**: Local SQLite (Drift) as source of truth, Supabase for cloud sync
- **State management**: Riverpod providers split into data providers and action providers
- **Navigation**: GoRouter with stateful nested navigation (5 main tabs with separate navigator keys)
- **Code generation**: Freezed for models, Drift for database, flutter_gen for assets
