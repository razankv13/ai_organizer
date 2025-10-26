import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:ai_organizer/providers/auth_provider.dart';

/// Edit Profile Screen - allows users to update their profile information
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _bioController = TextEditingController();

  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;
  File? _selectedImage;
  String? _currentAvatarUrl;
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authActions = ref.read(authActionsProvider);
      final profileData = await authActions.getUserProfile();

      if (profileData != null) {
        setState(() {
          _fullNameController.text = profileData['full_name'] as String? ?? '';
          _bioController.text = profileData['bio'] as String? ?? '';
          _currentAvatarUrl = profileData['avatar_url'] as String?;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Failed to load profile data: $e');
      setState(() {
        _errorMessage = 'Failed to load profile data';
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Failed to pick image: $e', isError: true);
      }
    }
  }

  Future<void> _removeAvatar() async {
    setState(() {
      _selectedImage = null;
      _currentAvatarUrl = null;
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      String? avatarUrl = _currentAvatarUrl;

      // Upload new avatar if selected
      if (_selectedImage != null) {
        final user = ref.read(currentUserProvider);
        if (user != null) {
          final fileName = 'avatar_${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
          final filePath = '${user.id}/$fileName';

          // Upload to Supabase storage
          final supabase = Supabase.instance.client;
          await supabase.storage.from('attachments').upload(
            filePath,
            _selectedImage!,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: true,
            ),
          );

          // Get public URL
          avatarUrl = supabase.storage.from('attachments').getPublicUrl(filePath);
        }
      }

      // Update profile
      final authActions = ref.read(authActionsProvider);
      await authActions.updateUserProfile({
        'full_name': _fullNameController.text.trim(),
        'bio': _bioController.text.trim().isEmpty ? null : _bioController.text.trim(),
        'avatar_url': avatarUrl,
        'updated_at': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        _showSnackBar('Profile updated successfully');
        context.pop();
      }
    } catch (e) {
      debugPrint('Failed to save profile: $e');
      setState(() {
        _errorMessage = 'Failed to save profile: $e';
        _isSaving = false;
      });
      if (mounted) {
        _showSnackBar('Failed to save profile', isError: true);
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
    final user = ref.watch(currentUserProvider);

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
          'Edit Profile',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (!_isLoading)
            TextButton(
              onPressed: _isSaving ? null : _saveProfile,
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Avatar section
                    Center(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              // Avatar
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorScheme.primaryContainer,
                                  image: _selectedImage != null
                                      ? DecorationImage(
                                          image: FileImage(_selectedImage!),
                                          fit: BoxFit.cover,
                                        )
                                      : _currentAvatarUrl != null
                                          ? DecorationImage(
                                              image: NetworkImage(_currentAvatarUrl!),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                ),
                                child: _selectedImage == null && _currentAvatarUrl == null
                                    ? Center(
                                        child: Text(
                                          _getInitials(_fullNameController.text),
                                          style: textTheme.headlineLarge?.copyWith(
                                            color: colorScheme.onPrimaryContainer,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                              // Edit button
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary,
                                    shape: BoxShape.circle,
                                    boxShadow: AppShadows.cardShadow,
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.camera_alt,
                                      size: 18,
                                      color: colorScheme.onPrimary,
                                    ),
                                    onPressed: _pickImage,
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_selectedImage != null || _currentAvatarUrl != null) ...[
                            const SizedBox(height: AppSpacing.sm),
                            TextButton.icon(
                              onPressed: _removeAvatar,
                              icon: Icon(
                                Icons.delete_outline,
                                size: 18,
                                color: colorScheme.error,
                              ),
                              label: Text(
                                'Remove Photo',
                                style: textTheme.labelMedium?.copyWith(
                                  color: colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xxxl),

                    // Email (read-only)
                    Text(
                      'Email',
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm + 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        border: Border.all(
                          color: colorScheme.outline,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        user?.email ?? '',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Full Name
                    Text(
                      'Full Name',
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    TextFormField(
                      controller: _fullNameController,
                      style: textTheme.bodyLarge,
                      decoration: InputDecoration(
                        hintText: 'Enter your full name',
                        hintStyle: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          borderSide: BorderSide(
                            color: colorScheme.outline,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          borderSide: BorderSide(
                            color: colorScheme.outline,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          borderSide: BorderSide(
                            color: colorScheme.primary,
                            width: 1.5,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          borderSide: BorderSide(
                            color: colorScheme.error,
                            width: 1.5,
                          ),
                        ),
                        filled: true,
                        fillColor: colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm + 4,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Bio
                    Text(
                      'Bio',
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    TextFormField(
                      controller: _bioController,
                      style: textTheme.bodyLarge,
                      maxLines: 4,
                      maxLength: 200,
                      decoration: InputDecoration(
                        hintText: 'Tell us about yourself',
                        hintStyle: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          borderSide: BorderSide(
                            color: colorScheme.outline,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          borderSide: BorderSide(
                            color: colorScheme.outline,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          borderSide: BorderSide(
                            color: colorScheme.primary,
                            width: 1.5,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          borderSide: BorderSide(
                            color: colorScheme.error,
                            width: 1.5,
                          ),
                        ),
                        filled: true,
                        fillColor: colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm + 4,
                        ),
                      ),
                    ),

                    if (_errorMessage != null) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: colorScheme.error,
                              size: 20,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onErrorContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final nameParts = name.trim().split(' ');
    if (nameParts.length > 1) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}
