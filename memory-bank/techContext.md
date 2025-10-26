# Technical Context: AI-Powered Organizer App

## Technology Stack

### Frontend - Flutter Framework
- **Flutter SDK**: Latest stable version for cross-platform mobile development
- **Target Platforms**: iOS and Android (with potential desktop expansion)

#### Core Dependencies
- **Riverpod**: State management solution for reactive programming
- **GoRouter**: Declarative routing and navigation
- **Freezed**: Immutable data classes and union types
- **Google Fonts**: Typography and font management
- **Drift/Moor**: SQLite ORM for local database operations

#### Internationalization & Localization
- **flutter_localizations**: Built-in Flutter localization support
- **intl**: Internationalization utilities for date, number, and message formatting
- **easy_localization**: Advanced localization with JSON/ARB file support
- **flutter_gen**: Code generation for localized strings and assets

#### Theme & UI Dependencies
- **dynamic_color**: Material You dynamic color support
- **flex_color_scheme**: Advanced theming with color harmonization
- **adaptive_theme**: Seamless light/dark mode transitions
- **shared_preferences**: Theme preference persistence

#### Additional Flutter Packages
- **Image Processing**: Camera, image_picker, flutter_image_compress
- **OCR Integration**: Google ML Kit or similar on-device processing
- **File Handling**: File picker, path provider, pdf viewer
- **UI Components**: Custom widgets with Material Design 3

### Backend - Supabase Platform
- **Authentication**: Supabase Auth (email/password, OAuth providers)
- **Database**: PostgreSQL with real-time subscriptions
- **Storage**: File and media storage with CDN
- **Edge Functions**: Serverless functions for AI processing and integrations

#### Database Schema (PostgreSQL)
```sql
-- Core tables structure
users, notes, tags, attachments, tasks, notebooks, folders
note_tags (many-to-many), note_links (backlinking)
user_preferences, sync_metadata
```

#### Edge Functions
- OCR text extraction from images
- AI-powered content analysis and tagging
- Email parsing and forwarding
- Integration webhooks (Calendar, Gmail)

### Local Storage Architecture
- **SQLite Database**: Offline-first data storage via Drift
- **File System**: Local attachment caching and management
- **Sync Engine**: Conflict resolution and background synchronization

### AI/ML Integration
- **Hybrid Approach**: On-device + cloud processing
- **On-Device**: Basic text analysis, image recognition
- **Cloud Processing**: Advanced semantic analysis, content suggestions
- **Privacy**: Minimize cloud data exposure, user-controlled processing

## Development Environment

### Setup Requirements
- Flutter SDK (latest stable)
- Dart SDK (latest compatible)
- Android Studio / VS Code with Flutter extensions
- iOS development: Xcode (for iOS deployment)
- Supabase CLI for backend management

### Localization Development Setup
```yaml
# pubspec.yaml additions for localization
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: any
  easy_localization: ^3.0.3
  
dev_dependencies:
  flutter_gen: ^5.3.2
  intl_translation: ^0.18.2
```

### Project Structure
```
lib/
├── core/           # Core utilities, constants, themes
│   ├── theme/      # Theme system and configurations
│   ├── l10n/       # Localization utilities
│   └── constants/  # App constants and configurations
├── data/           # Data layer (repositories, data sources)
├── domain/         # Business logic (entities, use cases)
├── presentation/   # UI layer (screens, widgets, providers)
├── shared/         # Shared components and utilities
└── main.dart       # App entry point

assets/
├── translations/   # Localization files
├── fonts/         # Custom fonts
└── images/        # App images and icons
```

### Development Workflow
- **State Management**: Riverpod providers for reactive state
- **Code Generation**: Build runner for Freezed/JSON serialization
- **Testing**: Unit tests, widget tests, integration tests
- **CI/CD**: GitHub Actions for automated testing and deployment

## Technical Constraints

### Performance Requirements
- **Load Time**: <2 seconds for app launch and content loading
- **Search Performance**: <500ms for full-text search results
- **Sync Performance**: Background sync without UI blocking
- **Memory Usage**: Efficient for devices with limited RAM

### Security & Privacy
- **Data Encryption**: End-to-end encryption for sensitive content
- **Local Storage**: Encrypted SQLite database
- **Network Security**: HTTPS/TLS for all communications
- **Privacy Compliance**: GDPR/CCPA compliant data handling

### Scalability Considerations
- **Offline-First**: Full functionality without network connectivity
- **Sync Efficiency**: Incremental sync with conflict resolution
- **Storage Limits**: Efficient media compression and cleanup
- **User Data Growth**: Handle large volumes of notes and attachments

## Integration Architecture

### External Services
- **Google Calendar API**: Two-way event synchronization
- **Gmail API**: Email import and analysis
- **Cloud Storage**: Dropbox/Google Drive file attachments
- **ML Services**: Content analysis and OCR processing

### API Design
- **REST APIs**: Supabase generated APIs for CRUD operations
- **Real-time**: WebSocket connections for live sync
- **GraphQL**: Potential future enhancement for complex queries
- **Webhook Integration**: External service notifications

## Development Phases

### Phase 1: Foundation
- Flutter project setup with core dependencies
- Supabase configuration and basic schema
- Authentication and user management
- Basic note capture and storage

### Phase 2: Core Features
- OCR integration for image processing
- AI tagging and organization
- Search implementation (full-text + tags)
- Offline sync mechanism

### Phase 3: Integrations
- Email forwarding system
- Calendar synchronization
- Cloud storage connections
- Advanced AI features

### Phase 4: Polish & Optimization
- Performance optimization
- UI/UX refinements
- Advanced organizational features
- Security hardening

## Internationalization Architecture

### Supported Languages (Phase 1)
- **English (en)**: Primary language and fallback
- **Spanish (es)**: Major market coverage
- **French (fr)**: European market
- **German (de)**: European market
- **Japanese (ja)**: Asian market
- **Chinese Simplified (zh-CN)**: Asian market
- **Arabic (ar)**: RTL language support

### Localization Strategy
```dart
// Localization configuration
class LocalizationConfig {
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),  // English (United States)
    Locale('es', 'ES'),  // Spanish (Spain)
    Locale('fr', 'FR'),  // French (France)
    Locale('de', 'DE'),  // German (Germany)
    Locale('ja', 'JP'),  // Japanese (Japan)
    Locale('zh', 'CN'),  // Chinese (China)
    Locale('ar', 'SA'),  // Arabic (Saudi Arabia)
  ];
  
  static const Locale fallbackLocale = Locale('en', 'US');
  
  // RTL language support
  static const List<String> rtlLanguages = ['ar', 'he', 'fa'];
}
```

### Translation File Structure
```
assets/
├── translations/
│   ├── en.json          # English translations
│   ├── es.json          # Spanish translations
│   ├── fr.json          # French translations
│   ├── de.json          # German translations
│   ├── ja.json          # Japanese translations
│   ├── zh-CN.json       # Chinese Simplified
│   └── ar.json          # Arabic translations
```

### Context-Aware Localization
```dart
// Smart localization for AI content
class SmartLocalization {
  // Detect content language for mixed-language notes
  Future<String> detectContentLanguage(String content);
  
  // Localize AI-generated content
  Future<String> localizeAIContent(String content, Locale targetLocale);
  
  // Format dates/times according to locale
  String formatDateTime(DateTime dateTime, Locale locale);
  
  // Number and currency formatting
  String formatNumber(double number, Locale locale);
}
```

## Theme Architecture

### Advanced Theme System
```dart
// Premium theme configuration
class PremiumThemeConfig {
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF1976D2,
    <int, Color>{
      50: Color(0xFFE3F2FD),
      100: Color(0xFFBBDEFB),
      200: Color(0xFF90CAF9),
      300: Color(0xFF64B5F6),
      400: Color(0xFF42A5F5),
      500: Color(0xFF1976D2),  // Primary
      600: Color(0xFF1E88E5),
      700: Color(0xFF1976D2),
      800: Color(0xFF1565C0),
      900: Color(0xFF0D47A1),
    },
  );
  
  // Dynamic color support for Material You
  static const ColorScheme dynamicColorScheme = ColorScheme.fromSeed(
    seedColor: Color(0xFF1976D2),
    brightness: Brightness.light,
  );
}
```

### Adaptive Theme Management
```dart
abstract class ThemeRepository {
  Future<ThemeMode> getThemeMode();
  Future<void> setThemeMode(ThemeMode mode);
  Future<bool> getUseDynamicColors();
  Future<void> setUseDynamicColors(bool useDynamic);
  Stream<ThemeMode> watchThemeMode();
}

class AdaptiveThemeService {
  // Automatic theme switching based on time
  ThemeMode getTimeBasedTheme();
  
  // System brightness detection
  Future<ThemeMode> getSystemTheme();
  
  // Smooth theme transitions
  Future<void> animateThemeChange(ThemeMode newMode);
}
``` 