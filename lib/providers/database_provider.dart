import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_organizer/data/database/app_database.dart';
import 'package:ai_organizer/data/repositories/note_repository.dart';
import 'package:ai_organizer/data/repositories/backlink_repository.dart';

/// Database provider - singleton instance
final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  // Ensure the database is properly disposed
  ref.onDispose(() => database.close());
  return database;
});

/// Backlink repository provider
final backlinkRepositoryProvider = Provider<BacklinkRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return BacklinkRepository(database);
});

/// Note repository provider
final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  final database = ref.watch(databaseProvider);
  final backlinkRepository = ref.watch(backlinkRepositoryProvider);
  return NoteRepository(database, backlinkRepository);
}); 