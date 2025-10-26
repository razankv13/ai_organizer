import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:ai_organizer/providers/auth_provider.dart';

/// Language Settings Screen - manage language preferences
class LanguageSettingsScreen extends ConsumerStatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  ConsumerState<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends ConsumerState<LanguageSettingsScreen> {
  String _selectedLanguage = 'en';
  bool _isLoading = true;
  bool _isSaving = false;

  final List<Map<String, String>> _languages = [
    {
      'code': 'en',
      'name': 'English',
      'nativeName': 'English',
    },
    {
      'code': 'es',
      'name': 'Spanish',
      'nativeName': 'Español',
    },
    {
      'code': 'fr',
      'name': 'French',
      'nativeName': 'Français',
    },
    {
      'code': 'de',
      'name': 'German',
      'nativeName': 'Deutsch',
    },
    {
      'code': 'it',
      'name': 'Italian',
      'nativeName': 'Italiano',
    },
    {
      'code': 'pt',
      'name': 'Portuguese',
      'nativeName': 'Português',
    },
    {
      'code': 'zh',
      'name': 'Chinese',
      'nativeName': '中文',
    },
    {
      'code': 'ja',
      'name': 'Japanese',
      'nativeName': '日本語',
    },
    {
      'code': 'ko',
      'name': 'Korean',
      'nativeName': '한국어',
    },
    {
      'code': 'ar',
      'name': 'Arabic',
      'nativeName': 'العربية',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authActions = ref.read(authActionsProvider);
      final profileData = await authActions.getUserProfile();

      if (profileData != null && profileData['preferences'] != null) {
        final preferences = profileData['preferences'] as Map<String, dynamic>?;
        if (preferences != null) {
          setState(() {
            _selectedLanguage = preferences['language'] as String? ?? 'en';
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Failed to load preferences: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _savePreferences() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final authActions = ref.read(authActionsProvider);

      // Get existing preferences first
      final profileData = await authActions.getUserProfile();
      final existingPreferences = (profileData?['preferences'] as Map<String, dynamic>?) ?? {};

      // Update language preference
      existingPreferences['language'] = _selectedLanguage;

      // Save updated preferences
      await authActions.updateUserProfile({
        'preferences': existingPreferences,
        'updated_at': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        _showSnackBar('Language settings saved');
        // Note: Actual language switching would require easy_localization integration
        // This is a simplified version - you'd need to wire this up to your localization provider
      }
    } catch (e) {
      debugPrint('Failed to save preferences: $e');
      if (mounted) {
        _showSnackBar('Failed to save settings', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: textTheme.bodyMedium?.copyWith(
            color: isError ? colorScheme.onError : colorScheme.onInverseSurface,
          ),
        ),
        backgroundColor: isError ? colorScheme.error : colorScheme.inverseSurface,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: colorScheme.onSurface,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Language',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (!_isLoading)
            TextButton(
              onPressed: _isSaving ? null : _savePreferences,
              child: _isSaving
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.primary,
                        ),
                      ),
                    )
                  : Text(
                      'Save',
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
            ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: colorScheme.primary,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Languages Section
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.cardPadding),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      boxShadow: AppShadows.cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.language_outlined,
                              color: colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Select Language',
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Language options
                        ..._languages.asMap().entries.map((entry) {
                          final index = entry.key;
                          final language = entry.value;
                          final isLast = index == _languages.length - 1;

                          return _buildLanguageOption(
                            name: language['name']!,
                            nativeName: language['nativeName']!,
                            code: language['code']!,
                            colorScheme: colorScheme,
                            textTheme: textTheme,
                            isLast: isLast,
                          );
                        }).toList(),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Info card
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'Language changes will take effect after you save and restart the app',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildLanguageOption({
    required String name,
    required String nativeName,
    required String code,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    bool isLast = false,
  }) {
    final isSelected = _selectedLanguage == code;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedLanguage = code;
          });
        },
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
        child: Container(
          constraints: const BoxConstraints(minHeight: AppSpacing.minTouchTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            border: !isLast
                ? Border(
                    bottom: BorderSide(
                      color: colorScheme.outlineVariant,
                      width: 1,
                    ),
                  )
                : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    if (name != nativeName) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        nativeName,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  size: 20,
                  color: colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
