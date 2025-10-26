import 'package:flutter/material.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';

/// Lightweight skeleton placeholders for note lists and grids.
class NoteListSkeleton extends StatelessWidget {
  const NoteListSkeleton({
    super.key,
    this.isGrid = false,
    this.itemCount = 8,
  });

  final bool isGrid;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    if (isGrid) {
      final crossAxisCount = MediaQuery.of(context).size.width >= 700 ? 3 : 2;
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontal,
          vertical: AppSpacing.sm,
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            childAspectRatio: 3 / 2,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) => const _SkeletonCard(),
        ),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.sm,
      ),
      itemBuilder: (context, index) => const _SkeletonTile(),
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemCount: itemCount,
    );
  }
}

class _SkeletonTile extends StatelessWidget {
  const _SkeletonTile();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmerBox(context, height: 18, widthFactor: 0.6),
          const SizedBox(height: AppSpacing.xs),
          _shimmerBox(context, height: 12, widthFactor: 0.9),
          const SizedBox(height: AppSpacing.xxs),
          _shimmerBox(context, height: 12, widthFactor: 0.8),
          const SizedBox(height: AppSpacing.sm),
          _shimmerBox(context, height: 10, widthFactor: 0.3),
        ],
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmerBox(context, height: 16, widthFactor: 0.7),
          const SizedBox(height: AppSpacing.xs),
          _shimmerBox(context, height: 12, widthFactor: 0.95),
          const SizedBox(height: AppSpacing.xxs),
          _shimmerBox(context, height: 12, widthFactor: 0.8),
          const Spacer(),
          _shimmerBox(context, height: 10, widthFactor: 0.4),
        ],
      ),
    );
  }
}

Widget _shimmerBox(BuildContext context, {required double height, double widthFactor = 1.0}) {
  final colorScheme = Theme.of(context).colorScheme;
  return FractionallySizedBox(
    widthFactor: widthFactor,
    child: Container(
      height: height,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
      ),
    ),
  );
}


