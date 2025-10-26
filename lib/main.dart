import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:ai_organizer/core/theme/app_theme.dart';
import 'package:ai_organizer/routes/app_router.dart';
import 'package:ai_organizer/config/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  debugPrint('🚀 === App Startup Beginning ===');
  try {
    debugPrint('📂 Loading .env file...');
    await dotenv.load();
    debugPrint('✅ Environment variables loaded successfully');
  } catch (e) {
    debugPrint('⚠️ Warning: .env file not found or error loading variables: $e');
    // Continue without .env - will use fallback API keys
  }

  // Initialize localization
  debugPrint('🌍 Initializing localization...');
  await EasyLocalization.ensureInitialized();
  debugPrint('✅ Localization initialized');

  // Initialize Supabase
  debugPrint('🔐 Initializing Supabase...');
  try {
    await SupabaseConfig.initialize();
    debugPrint('✅ ✅ ✅ Supabase initialized successfully! ✅ ✅ ✅');
  } catch (e) {
    debugPrint('❌ ❌ ❌ Error initializing Supabase: $e ❌ ❌ ❌');
    debugPrint('Stack trace: ${StackTrace.current}');
    // Continue without Supabase - app will work in offline mode
    // Note: Auth features will not work until Supabase is properly configured
  }

  debugPrint('🎨 Loading theme mode...');

  // Get saved theme mode
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  debugPrint('✅ Theme mode loaded');

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  debugPrint('🎯 Starting app...');
  debugPrint('🚀 === App Startup Complete ===');

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale('fr'),
        Locale('de'),
        Locale('ja'),
        Locale('zh'),
        Locale('ar'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: ProviderScope(
        child: MyApp(savedThemeMode: savedThemeMode),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({
    super.key,
    this.savedThemeMode,
  });

  final AdaptiveThemeMode? savedThemeMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    return AdaptiveTheme(
      light: AppTheme.light(
        languageCode: context.locale.languageCode,
      ),
      dark: AppTheme.dark(
        languageCode: context.locale.languageCode,
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp.router(
        title: 'AI Organizer',
        theme: theme,
        darkTheme: darkTheme,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
} 