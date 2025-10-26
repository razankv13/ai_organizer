import 'package:ai_organizer/core/navigation/app_router.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:ai_organizer/presentation/widgets/app_bottom_nav.dart';
import 'package:ai_organizer/presentation/widgets/empty_state.dart';
import 'package:ai_organizer/providers/notes_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Home screen - main dashboard of the app
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

enum HomeFilter { all, pinned, favorites, recent }

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isAiButtonPressed = false;
  bool _isFabPressed = false;
  HomeFilter _selectedFilter = HomeFilter.all;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar.large(
            backgroundColor: colorScheme.surface,
            pinned: true,
            elevation: 0,
            title: Text(
              'hero.greeting'.tr(),
              style: textTheme.displaySmall,
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search, color: colorScheme.onSurface),
                onPressed: () => context.go('/notes'),
                tooltip: 'navigation.search'.tr(),
              ),
              IconButton(
                icon: Icon(Icons.person_outline, color: colorScheme.onSurface),
                onPressed: () => context.go('/profile'),
                tooltip: 'navigation.profile'.tr(),
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.only(
                  left: AppSpacing.screenHorizontal,
                  right: AppSpacing.screenHorizontal,
                  bottom: AppSpacing.md,
                ),
                child: Text(
                  'hero.subtitle'.tr(),
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
              vertical: AppSpacing.screenVertical,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Quick Capture Chips Row
                _buildQuickCaptureChips(context, colorScheme, textTheme),
                const SizedBox(height: AppSpacing.xl),

                // Filter Chips
                _buildFilterChips(context, colorScheme, textTheme),
                const SizedBox(height: AppSpacing.lg),

                // Pinned + Recent Sections
                _buildPinnedAndRecentSections(context, ref, colorScheme, textTheme),
                const SizedBox(height: AppSpacing.xl),

                // Statistics Card
                _buildStatisticsCard(context, ref, colorScheme, textTheme),
                const SizedBox(height: AppSpacing.xl),

                // AI Insights Card
                _buildAiInsightsCard(context, colorScheme, textTheme),

                // Extra padding at bottom for FAB
                const SizedBox(height: AppSpacing.xxxl + AppSpacing.fabMargin),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(context, colorScheme),
      bottomNavigationBar: AppBottomNav.fromRoute('/'),
    );
  }

  Widget _buildQuickCaptureChips(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return SizedBox(
      height: AppSpacing.minTouchTarget,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCaptureChip(
            context: context,
            colorScheme: colorScheme,
            textTheme: textTheme,
            icon: Icons.note_add,
            label: 'capture.quickText'.tr(),
            background: colorScheme.primaryContainer,
            foreground: colorScheme.onPrimaryContainer,
            onTap: () => context.go('/notes/create'),
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildCaptureChip(
            context: context,
            colorScheme: colorScheme,
            textTheme: textTheme,
            icon: Icons.mic,
            label: 'capture.quickVoice'.tr(),
            background: colorScheme.secondaryContainer,
            foreground: colorScheme.onSecondaryContainer,
            onTap: () => context.goVoiceNote(),
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildCaptureChip(
            context: context,
            colorScheme: colorScheme,
            textTheme: textTheme,
            icon: Icons.camera_alt,
            label: 'capture.quickPhoto'.tr(),
            background: colorScheme.primaryContainer,
            foreground: colorScheme.onPrimaryContainer,
            onTap: () => _showCameraOptions(context, colorScheme, textTheme),
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildCaptureChip(
            context: context,
            colorScheme: colorScheme,
            textTheme: textTheme,
            icon: Icons.link,
            label: 'capture.quickWeb'.tr(),
            background: colorScheme.primaryContainer,
            foreground: colorScheme.onPrimaryContainer,
            onTap: () => _showWebClipDialog(context, colorScheme, textTheme),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptureChip({
    required BuildContext context,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required IconData icon,
    required String label,
    required Color background,
    required Color foreground,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            boxShadow: AppShadows.cardShadow,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: foreground, size: AppSpacing.iconSizeSmall),
              const SizedBox(width: AppSpacing.xs),
              Text(
                label,
                style: textTheme.labelLarge?.copyWith(color: foreground),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final labels = {
      HomeFilter.all: 'filters.all'.tr(),
      HomeFilter.pinned: 'filters.pinned'.tr(),
      HomeFilter.favorites: 'filters.favorites'.tr(),
      HomeFilter.recent: 'filters.recent'.tr(),
    };

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: HomeFilter.values.map((filter) {
        final bool selected = _selectedFilter == filter;
        return ChoiceChip(
          label: Text(labels[filter] ?? ''),
          selected: selected,
          onSelected: (_) => setState(() => _selectedFilter = filter),
          labelStyle: (selected
                  ? textTheme.labelLarge?.copyWith(color: colorScheme.onPrimaryContainer)
                  : textTheme.labelLarge?.copyWith(color: colorScheme.onSurface)) ??
              textTheme.labelLarge!,
          selectedColor: colorScheme.primaryContainer,
          backgroundColor: colorScheme.surfaceContainerHighest,
          side: BorderSide(
            color: selected ? colorScheme.primary : colorScheme.outlineVariant,
          ),
          showCheckmark: false,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      }).toList(),
    );
  }

  Widget _buildPinnedAndRecentSections(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final recentNotesAsync = ref.watch(recentNotesProvider);

    return recentNotesAsync.when(
      data: (notes) {
        final List<dynamic> pinned =
            notes.where((n) => (n.isPinned == true)).toList();
        final List<dynamic> others =
            notes.where((n) => (n.isPinned != true)).toList();

        // Apply filter
        List<dynamic> filtered = notes;
        switch (_selectedFilter) {
          case HomeFilter.pinned:
            filtered = pinned;
            break;
          case HomeFilter.favorites:
            filtered = notes.where((n) => (n.isFavorite == true)).toList();
            break;
          case HomeFilter.recent:
            filtered = notes; // already recent
            break;
          case HomeFilter.all:
            filtered = notes;
            break;
        }

        List<Widget> children = [];

        if (_selectedFilter == HomeFilter.all || _selectedFilter == HomeFilter.pinned) {
          if ((_selectedFilter == HomeFilter.all ? pinned : filtered).isNotEmpty) {
            children.add(_buildSectionHeader(
              context,
              colorScheme,
              textTheme,
              title: 'sections.pinned'.tr(),
            ));
            children.add(const SizedBox(height: AppSpacing.md));
            final source = _selectedFilter == HomeFilter.all ? pinned : filtered;
            children.add(
              GridView.builder(
                itemCount: source.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: 1.6,
                ),
                itemBuilder: (context, index) => _buildNoteCard(
                  context,
                  colorScheme,
                  textTheme,
                  source[index],
                ),
              ),
            );
            children.add(const SizedBox(height: AppSpacing.xl));
          }
        }

        if (_selectedFilter == HomeFilter.all || _selectedFilter == HomeFilter.recent) {
          final List<dynamic> recentList = _selectedFilter == HomeFilter.all ? others : filtered;
          children.add(_buildSectionHeader(
            context,
            colorScheme,
            textTheme,
            title: 'sections.recent'.tr(),
            trailing: TextButton(
              onPressed: () => context.go('/notes'),
              style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
              child: Text('common.all'.tr(), style: textTheme.labelLarge?.copyWith(color: colorScheme.primary)),
            ),
          ));
          children.add(const SizedBox(height: AppSpacing.md));

          if (recentList.isEmpty) {
            children.add(EmptyState(
              icon: Icons.note_outlined,
              title: 'notes.empty'.tr(),
              message: 'notes.emptyDescription'.tr(),
              actionText: 'notes.create'.tr(),
              onAction: () => context.go('/notes/create'),
            ));
          } else {
            children.add(
              Column(
                children: recentList
                    .map((note) => _buildNoteCard(context, colorScheme, textTheme, note))
                    .toList(),
              ),
            );
          }
        }

        if (_selectedFilter == HomeFilter.favorites) {
          if (filtered.isEmpty) {
            children.add(EmptyState(
              icon: Icons.favorite_outline,
              title: 'notes.noFavorites'.tr(),
              message: 'notes.noFavoritesDescription'.tr(),
              actionText: 'notes.create'.tr(),
              onAction: () => context.go('/notes/create'),
            ));
          } else {
            children.add(_buildSectionHeader(
              context,
              colorScheme,
              textTheme,
              title: 'filters.favorites'.tr(),
            ));
            children.add(const SizedBox(height: AppSpacing.md));
            children.add(
              Column(
                children: filtered
                    .map((note) => _buildNoteCard(context, colorScheme, textTheme, note))
                    .toList(),
              ),
            );
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        );
      },
      loading: () => _buildLoadingState(colorScheme),
      error: (error, stackTrace) => _buildErrorState(
        context,
        colorScheme,
        textTheme,
        error.toString(),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme, {
    required String title,
    Widget? trailing,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(title, style: textTheme.titleLarge),
          ],
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  

  Widget _buildNoteCard(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
    dynamic note,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.cardMargin),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go('/notes/${note.id}'),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        note.title.isNotEmpty ? note.title : 'Untitled',
                        style: textTheme.titleLarge,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (note.isPinned)
                      Icon(
                        Icons.push_pin,
                        size: AppSpacing.iconSizeSmall,
                        color: colorScheme.primary,
                      ),
                    if (note.isPinned && note.isFavorite)
                      const SizedBox(width: AppSpacing.xs),
                    if (note.isFavorite)
                      Icon(
                        Icons.favorite,
                        size: AppSpacing.iconSizeSmall,
                        color: colorScheme.error,
                      ),
                  ],
                ),

                // Content preview
                if (note.content.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    note.preview,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                const SizedBox(height: AppSpacing.sm),

                // Metadata row
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // Timestamp
                    Text(
                      _formatDateTime(note.updatedAt),
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    // Tags as pills
                    ...note.tags.take(2).map((tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: AppSpacing.xxs,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                      ),
                      child: Text(
                        '#$tag',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsCard(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final statsAsync = ref.watch(noteStatisticsProvider);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Icon(
                    Icons.analytics_outlined,
                    color: colorScheme.onPrimaryContainer,
                    size: AppSpacing.iconSize,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  'statistics.title'.tr(),
                  style: textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            statsAsync.when(
              data: (stats) => Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      colorScheme,
                      textTheme,
                      'Total',
                      stats['total'] ?? 0,
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: colorScheme.outlineVariant,
                  ),
                  Expanded(
                    child: _buildStatItem(
                      colorScheme,
                      textTheme,
                      'Pinned',
                      stats['pinned'] ?? 0,
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: colorScheme.outlineVariant,
                  ),
                  Expanded(
                    child: _buildStatItem(
                      colorScheme,
                      textTheme,
                      'Favorites',
                      stats['favorites'] ?? 0,
                    ),
                  ),
                ],
              ),
              loading: () => _buildLoadingState(colorScheme),
              error: (error, stackTrace) => Text(
                'Error loading statistics',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    ColorScheme colorScheme,
    TextTheme textTheme,
    String label,
    int value,
  ) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: textTheme.displayMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildAiInsightsCard(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    color: colorScheme.onSecondaryContainer,
                    size: AppSpacing.iconSize,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  'ai.title'.tr(),
                  style: textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'ai.ctaSubtitle'.tr(),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AnimatedScale(
              scale: _isAiButtonPressed ? 0.98 : 1.0,
              duration: AppSpacing.fastAnimation,
              curve: Curves.easeInOut,
              child: GestureDetector(
                onTapDown: (_) => setState(() => _isAiButtonPressed = true),
                onTapUp: (_) => setState(() => _isAiButtonPressed = false),
                onTapCancel: () => setState(() => _isAiButtonPressed = false),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.secondary,
                      foregroundColor: colorScheme.onSecondary,
                      padding: AppSpacing.buttonPadding,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                    ),
                    icon: const Icon(Icons.auto_awesome, size: AppSpacing.iconSizeSmall),
                    label: Text(
                      'ai.ctaButton'.tr(),
                      style: textTheme.labelLarge,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
    String error,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: colorScheme.error,
            size: 32,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Error loading data',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.error,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            error,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFAB(BuildContext context, ColorScheme colorScheme) {
    return AnimatedScale(
      scale: _isFabPressed ? 0.9 : 1.0,
      duration: AppSpacing.fastAnimation,
      curve: Curves.easeInOut,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          shape: BoxShape.circle,
          boxShadow: AppShadows.cardElevatedShadow,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showQuickCaptureOptions(context, colorScheme),
            onTapDown: (_) => setState(() => _isFabPressed = true),
            onTapUp: (_) => setState(() => _isFabPressed = false),
            onTapCancel: () => setState(() => _isFabPressed = false),
            borderRadius: BorderRadius.circular(28),
            splashColor: colorScheme.onPrimary.withOpacity(0.2),
            child: Center(
              child: Icon(
                Icons.add,
                size: 24,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showQuickCaptureOptions(BuildContext context, ColorScheme colorScheme) {
    final textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusMd),
        ),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle indicator
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Text(
                'capture.title'.tr(),
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.xl),

              _buildCaptureOption(
                context,
                colorScheme,
                textTheme,
                icon: Icons.note_add,
                label: 'capture.textNote'.tr(),
                onTap: () {
                  Navigator.of(context).pop();
                  context.go('/notes/create');
                },
              ),
              _buildCaptureOption(
                context,
                colorScheme,
                textTheme,
                icon: Icons.mic,
                label: 'capture.voiceNote'.tr(),
                onTap: () {
                  Navigator.of(context).pop();
                  context.goVoiceNote();
                },
              ),
              _buildCaptureOption(
                context,
                colorScheme,
                textTheme,
                icon: Icons.camera_alt,
                label: 'capture.photoNote'.tr(),
                onTap: () {
                  Navigator.of(context).pop();
                  _showCameraOptions(context, colorScheme, textTheme);
                },
              ),
              _buildCaptureOption(
                context,
                colorScheme,
                textTheme,
                icon: Icons.link,
                label: 'capture.webClip'.tr(),
                onTap: () {
                  Navigator.of(context).pop();
                  _showWebClipDialog(context, colorScheme, textTheme);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCaptureOption(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.xs,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(
                  icon,
                  color: colorScheme.onPrimaryContainer,
                  size: AppSpacing.iconSize,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                label,
                style: textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _showCameraOptions(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusMd),
        ),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle indicator
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Text(
                'capture.photoNote'.tr(),
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.xl),

              _buildCaptureOption(
                context,
                colorScheme,
                textTheme,
                icon: Icons.camera_alt,
                label: 'capture.fromCamera'.tr(),
                onTap: () => Navigator.of(context).pop(),
              ),
              _buildCaptureOption(
                context,
                colorScheme,
                textTheme,
                icon: Icons.photo_library,
                label: 'capture.fromGallery'.tr(),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWebClipDialog(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'capture.webClip'.tr(),
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.xl),
              TextField(
                style: textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Enter URL...',
                  hintStyle: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    borderSide: BorderSide(
                      color: colorScheme.outline,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    borderSide: BorderSide(
                      color: colorScheme.outline,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.sm,
                    horizontal: AppSpacing.md,
                  ),
                ),
                cursorColor: colorScheme.primary,
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.onSurfaceVariant,
                    ),
                    child: Text('common.cancel'.tr()),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: AppSpacing.buttonPadding,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                    ),
                    child: Text(
                      'common.save'.tr(),
                      style: textTheme.labelLarge,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
