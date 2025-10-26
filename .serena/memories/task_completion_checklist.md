# Task Completion Checklist

When completing a task in this project, follow this checklist:

## 1. Code Generation
If you modified any of these, run code generation:
- [ ] Freezed classes (`@freezed` annotation)
- [ ] JSON serializable models (`@JsonSerializable()`)
- [ ] Drift database schema (tables, columns, schema version)
- [ ] Added/modified assets in `assets/` directories

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 2. Code Quality

### Run Analysis
```bash
flutter analyze
```
- [ ] No analysis errors
- [ ] No analysis warnings (or justified exceptions)

### Format Code
```bash
dart format .
```
- [ ] All code is properly formatted

## 3. Testing

### Run Tests
```bash
flutter test
```
- [ ] All existing tests pass
- [ ] New functionality has appropriate tests (if applicable)
- [ ] Test coverage is maintained or improved

## 4. Database Changes

If you modified the database schema:
- [ ] Incremented `schemaVersion` in `AppDatabase`
- [ ] Updated `migration` callback if needed for data migration
- [ ] Ran code generation
- [ ] Tested upgrade path from previous schema version

## 5. Dependencies

If you added/removed dependencies:
- [ ] Updated `pubspec.yaml`
- [ ] Ran `flutter pub get`
- [ ] Documented new dependencies in relevant memory files if significant

## 6. Environment Variables

If you added new environment variables:
- [ ] Updated `.env.example` with placeholder
- [ ] Documented in README.md or CLAUDE.md
- [ ] Never committed actual `.env` file

## 7. Localization

If you added user-facing strings:
- [ ] Added translation keys to `assets/translations/*.json`
- [ ] Used `context.tr('key')` or `'key'.tr()` in code
- [ ] Provided translations for all supported languages

## 8. State Management

If you modified providers:
- [ ] Properly invalidate dependent providers after mutations
- [ ] Handle loading and error states with `AsyncValue`
- [ ] Follow data provider vs action provider pattern

## 9. Navigation

If you added new screens/routes:
- [ ] Added route to `lib/core/navigation/app_router.dart`
- [ ] Added navigation extension method if needed
- [ ] Updated bottom navigation if it's a main tab

## 10. Assets

If you added new assets:
- [ ] Assets are in correct directories (`assets/images/`, `assets/animations/`, etc.)
- [ ] Assets are referenced in `pubspec.yaml` (if not already covered by existing patterns)
- [ ] Run `flutter pub get` to regenerate asset code

## 11. Documentation

If you made significant architectural changes:
- [ ] Updated CLAUDE.md if needed
- [ ] Updated relevant Serena memory files
- [ ] Added code comments for complex logic

## 12. Final Verification

Before marking task as complete:
- [ ] App runs without errors: `flutter run`
- [ ] No runtime errors in intended workflows
- [ ] Features work as expected on target platforms
- [ ] Code follows project conventions and style guide
