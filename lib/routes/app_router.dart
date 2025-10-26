import 'package:ai_organizer/presentation/screens/auth/login_screen.dart';
import 'package:ai_organizer/presentation/screens/auth/signup_screen.dart';
import 'package:ai_organizer/presentation/screens/home/home_screen.dart';
import 'package:ai_organizer/presentation/screens/notes/note_detail_screen.dart';
import 'package:ai_organizer/presentation/screens/notes/note_edit_screen.dart';
import 'package:ai_organizer/presentation/screens/notes/notes_list_screen.dart';
import 'package:ai_organizer/presentation/screens/profile/profile_screen.dart';
import 'package:ai_organizer/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Router configuration provider
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: '/notes',
    redirect: (context, state) {
      // Check if the user is logged in
      final isAuthenticated = ref.read(authActionsProvider).isAuthenticated;

      // Auth routes that don't require authentication
      final isAuthRoute = state.uri.path == '/login' || state.uri.path == '/signup';

      // If not authenticated and not on auth route, redirect to login
      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }

      // If authenticated and on auth route, redirect to home
      if (isAuthenticated && isAuthRoute) {
        return '/notes';
      }

      // No redirection needed
      return null;
    },
    routes: [
      // Auth routes
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),

      // Home route
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),

      // Notes routes
      GoRoute(
        path: '/notes',
        builder: (context, state) => const NotesListScreen(),
        routes: [
          GoRoute(path: 'new', builder: (context, state) => const NoteEditScreen()),
          GoRoute(
            path: ':noteId',
            builder: (context, state) {
              final noteId = state.pathParameters['noteId']!;
              return NoteDetailScreen(noteId: noteId);
            },
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) {
                  final noteId = state.pathParameters['noteId']!;
                  return NoteEditScreen(noteId: noteId);
                },
              ),
            ],
          ),
        ],
      ),

      // Profile route
      GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
    ],
    // Error page
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('The page you are looking for does not exist.'),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => context.go('/'), child: const Text('Go Home')),
          ],
        ),
      ),
    ),
    // Debug log
    debugLogDiagnostics: true,
  );
});
