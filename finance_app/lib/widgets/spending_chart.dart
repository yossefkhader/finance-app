import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class SpendingChart extends StatelessWidget {
  const SpendingChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Row(
        children: [
          // Pie Chart
          Expanded(
            flex: 3,
            child:               PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 60,
                  sections: _buildPieChartSections(context),
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                  ),
                ),
              ),
          ),
          
          const SizedBox(width: AppTheme.spacingXl),
          
          // Legend
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildLegend(context),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(BuildContext context) {
    final categories = _getSpendingCategories(context);
    
    return categories.map((category) {
      return PieChartSectionData(
        color: category.color,
        value: category.amount,
        title: '',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  List<Widget> _buildLegend(BuildContext context) {
    final categories = _getSpendingCategories(context);
    final total = categories.fold<double>(0, (sum, cat) => sum + cat.amount);
    
    return categories.map((category) {
      final percentage = (category.amount / total * 100).round();
      
      return Padding(
        padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: category.color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: AppTheme.spacingSm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${category.amount.toStringAsFixed(0)} ر.س (%$percentage)',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<SpendingCategory> _getSpendingCategories(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      SpendingCategory(
        name: l10n.foodDining,
        amount: 850,
        color: AppTheme.accentColor,
      ),
      SpendingCategory(
        name: l10n.transportation,
        amount: 420,
        color: const Color(0xFF8B5CF6),
      ),
      SpendingCategory(
        name: l10n.shopping,
        amount: 320,
        color: const Color(0xFFF59E0B),
      ),
      SpendingCategory(
        name: l10n.entertainment,
        amount: 180,
        color: const Color(0xFFEF4444),
      ),
      SpendingCategory(
        name: l10n.billsUtilities,
        amount: 650,
        color: const Color(0xFF6B7280),
      ),
      SpendingCategory(
        name: l10n.other,
        amount: 130,
        color: const Color(0xFF14B8A6),
      ),
    ];
  }
}

class SpendingCategory {
  final String name;
  final double amount;
  final Color color;

  SpendingCategory({
    required this.name,
    required this.amount,
    required this.color,
  });
}
