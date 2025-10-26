# Suggested Commands

## Development Setup

### Initial Setup
```bash
# Install dependencies
flutter pub get

# Create environment file from example
cp .env.example .env
# Then edit .env with actual API keys
```

## Running the App

```bash
# Run on default device
flutter run

# Run on specific device
flutter run -d chrome              # Web (Chrome)
flutter run -d macos               # macOS
flutter run -d <device-id>         # Specific device (use flutter devices to list)

# List available devices
flutter devices

# Run in debug mode (default)
flutter run

# Run in profile mode (performance testing)
flutter run --profile

# Run in release mode
flutter run --release
```

## Code Generation

```bash
# Generate code for Freezed, JSON serialization, Drift, and assets
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode - automatically regenerate on file changes
flutter pub run build_runner watch --delete-conflicting-outputs

# Clean generated files before regenerating
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

**Run code generation after:**
- Adding/modifying Freezed classes (`@freezed`)
- Changing JSON serializable classes (`@JsonSerializable()`)
- Modifying Drift database schema
- Adding new assets to `assets/` folders

## Testing

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/path/to/test_file.dart

# Run tests with coverage
flutter test --coverage

# Run tests in watch mode (requires external tool)
# Note: Flutter doesn't have built-in watch mode
```

## Analysis & Linting

```bash
# Run static analysis
flutter analyze

# Fix auto-fixable issues
dart fix --apply

# Format code
dart format .

# Format specific file/directory
dart format lib/
```

## Build Commands

```bash
# Build APK (Android)
flutter build apk

# Build App Bundle (Android - for Play Store)
flutter build appbundle

# Build iOS (requires macOS)
flutter build ios

# Build for web
flutter build web

# Build for macOS (requires macOS)
flutter build macos

# Build for Windows (requires Windows)
flutter build windows

# Build for Linux (requires Linux)
flutter build linux
```

## Cleaning & Maintenance

```bash
# Clean build artifacts
flutter clean

# Re-fetch dependencies (after clean)
flutter pub get

# Upgrade dependencies to latest compatible versions
flutter pub upgrade

# Outdated packages check
flutter pub outdated
```

## Database Management

```bash
# After modifying Drift database schema, always run:
flutter pub run build_runner build --delete-conflicting-outputs

# The database will auto-migrate on app startup if schema version changed
```

## Useful Flutter Commands

```bash
# Show Flutter version and environment
flutter doctor

# Check for Flutter updates
flutter upgrade

# Create new screen/widget (manual - no generator)
# Create file in lib/presentation/screens/<feature>/

# Check dependencies tree
flutter pub deps
```

## macOS-Specific System Commands

Since the project is on Darwin (macOS):
```bash
# List directory contents
ls -la

# Find files
find . -name "*.dart" -type f

# Search in files (use ripgrep if available, otherwise grep)
grep -r "searchTerm" lib/
# or
rg "searchTerm" lib/

# View file contents
cat path/to/file

# Change directory
cd path/to/directory

# Current directory path
pwd

# Git operations (if using git)
git status
git add .
git commit -m "message"
git push
```
