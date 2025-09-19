import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../theme/app_theme.dart';

class TrendData {
  final double value;
  final bool isPositive;
  final String period;

  TrendData({
    required this.value,
    required this.isPositive,
    required this.period,
  });
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final HeroIcons icon;
  final TrendData? trend;
  final List<double>? sparklineData;
  final bool isLarge;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    this.trend,
    this.sparklineData,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(isLarge ? AppTheme.spacingXl : AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingSm),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
                  ),
                  child: HeroIcon(
                    icon,
                    size: isLarge ? 24 : 20,
                    color: AppTheme.accentColor,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: isLarge ? AppTheme.spacingXl : AppTheme.spacingLg),
            
            // Main value
            Text(
              value,
              style: isLarge 
                ? Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  )
                : Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            
            const SizedBox(height: AppTheme.spacingSm),
            
            // Subtitle
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            
            if (trend != null || sparklineData != null)
              const SizedBox(height: AppTheme.spacingMd),
            
            // Trend or Sparkline
            Row(
              children: [
                if (trend != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingSm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: (trend!.isPositive 
                          ? AppTheme.successColor 
                          : AppTheme.errorColor).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusSm),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HeroIcon(
                          trend!.isPositive 
                              ? HeroIcons.arrowUp 
                              : HeroIcons.arrowDown,
                          size: 12,
                          color: trend!.isPositive 
                              ? AppTheme.successColor 
                              : AppTheme.errorColor,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${trend!.value.toStringAsFixed(1)}%',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: trend!.isPositive 
                                ? AppTheme.successColor 
                                : AppTheme.errorColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                  Expanded(
                    child: Text(
                      trend!.period,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
                
                if (sparklineData != null) ...[
                  Expanded(
                    child: Container(
                      height: 32,
                      child: CustomPaint(
                        painter: SparklinePainter(
                          data: sparklineData!,
                          color: AppTheme.accentColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;

  SparklinePainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final minValue = data.reduce((a, b) => a < b ? a : b);
    final range = maxValue - minValue;

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - ((data[i] - minValue) / range) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
