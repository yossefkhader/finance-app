import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../theme/app_theme.dart';

/// Loading state widget with skeleton placeholders
class LoadingState extends StatelessWidget {
  final LoadingType type;

  const LoadingState({super.key, this.type = LoadingType.cards});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case LoadingType.cards:
        return _buildCardSkeletons();
      case LoadingType.list:
        return _buildListSkeletons();
      case LoadingType.chart:
        return _buildChartSkeleton();
    }
  }

  Widget _buildCardSkeletons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildCardSkeleton(height: 120)),
            const SizedBox(width: AppTheme.spacingLg),
            Expanded(child: _buildCardSkeleton(height: 120)),
            const SizedBox(width: AppTheme.spacingLg),
            Expanded(child: _buildCardSkeleton(height: 120)),
          ],
        ),
        const SizedBox(height: AppTheme.spacingXl),
        Row(
          children: [
            Expanded(flex: 2, child: _buildCardSkeleton(height: 300)),
            const SizedBox(width: AppTheme.spacingXl),
            Expanded(child: _buildCardSkeleton(height: 300)),
          ],
        ),
      ],
    );
  }

  Widget _buildListSkeletons() {
    return Column(
      children: List.generate(5, (index) => 
        Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
          child: _buildListItemSkeleton(),
        ),
      ),
    );
  }

  Widget _buildChartSkeleton() {
    return _buildCardSkeleton(height: 300);
  }

  Widget _buildCardSkeleton({required double height}) {
    return Card(
      child: Container(
        height: height,
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildShimmer(width: 32, height: 32, borderRadius: AppTheme.borderRadiusMd),
                const SizedBox(width: AppTheme.spacingMd),
                _buildShimmer(width: 120, height: 16),
              ],
            ),
            const SizedBox(height: AppTheme.spacingLg),
            _buildShimmer(width: 160, height: 32),
            const SizedBox(height: AppTheme.spacingSm),
            _buildShimmer(width: 100, height: 14),
            const Spacer(),
            _buildShimmer(width: 80, height: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildListItemSkeleton() {
    return Row(
      children: [
        _buildShimmer(width: 40, height: 40, borderRadius: AppTheme.borderRadiusMd),
        const SizedBox(width: AppTheme.spacingMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildShimmer(width: 200, height: 16),
              const SizedBox(height: AppTheme.spacingXs),
              Row(
                children: [
                  _buildShimmer(width: 60, height: 12),
                  const SizedBox(width: AppTheme.spacingSm),
                  _buildShimmer(width: 80, height: 12),
                ],
              ),
            ],
          ),
        ),
        _buildShimmer(width: 60, height: 16),
      ],
    );
  }

  Widget _buildShimmer({
    required double width,
    required double height,
    double? borderRadius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.borderColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 4),
      ),
      child: const ShimmerEffect(),
    );
  }
}

/// Empty state widget
class EmptyState extends StatelessWidget {
  final HeroIcons icon;
  final String title;
  final String subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing2Xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.textTertiary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Center(
              child: HeroIcon(
                icon,
                size: 40,
                color: AppTheme.textTertiary,
              ),
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingXl),
          
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppTheme.spacingSm),
          
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          
          if (actionText != null && onAction != null) ...[
            const SizedBox(height: AppTheme.spacingXl),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionText!),
            ),
          ],
        ],
      ),
    );
  }
}

/// Error state widget
class ErrorState extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? retryText;
  final VoidCallback? onRetry;

  const ErrorState({
    super.key,
    this.title = 'Something went wrong',
    this.subtitle = 'We encountered an error while loading your data.',
    this.retryText = 'Try again',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing2Xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.errorColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Center(
              child: HeroIcon(
                HeroIcons.exclamationTriangle,
                size: 40,
                color: AppTheme.errorColor,
              ),
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingXl),
          
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppTheme.spacingSm),
          
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          
          if (retryText != null && onRetry != null) ...[
            const SizedBox(height: AppTheme.spacingXl),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(retryText!),
            ),
          ],
        ],
      ),
    );
  }
}

/// Shimmer effect for loading states
class ShimmerEffect extends StatefulWidget {
  const ShimmerEffect({super.key});

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                0.0,
                _animation.value,
                1.0,
              ],
              colors: [
                AppTheme.borderColor,
                AppTheme.borderColor.withOpacity(0.5),
                AppTheme.borderColor,
              ],
            ),
          ),
        );
      },
    );
  }
}

enum LoadingType {
  cards,
  list,
  chart,
}
