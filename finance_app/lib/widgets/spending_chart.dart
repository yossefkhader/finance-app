import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../data/expenses.dart';

class SpendingChart extends StatelessWidget {
  const SpendingChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ..._buildLegend(context),
                  ],
              ),
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
                    '${category.amount.toStringAsFixed(0)} ₪ (%$percentage)',
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
    // Get current month data (September - month 9)
    final currentMonth = monthlyExpenses.lastWhere((month) => month['month'] == 9);
    
    return [
      SpendingCategory(
        name: 'السكن والخدمات',
        amount: (currentMonth['housingUtilities'] as num).toDouble(),
        color: const Color(0xFF6B7280),
      ),
      SpendingCategory(
        name: l10n.foodDining,
        amount: (currentMonth['foodGroceries'] as num).toDouble(),
        color: AppTheme.accentColor,
      ),
      SpendingCategory(
        name: l10n.transportation,
        amount: (currentMonth['transport'] as num).toDouble(),
        color: const Color(0xFF8B5CF6),
      ),
      SpendingCategory(
        name: 'التعليم ورعاية الأطفال',
        amount: (currentMonth['educationChildcare'] as num).toDouble(),
        color: const Color(0xFF3B82F6),
      ),
      SpendingCategory(
        name: l10n.healthcare,
        amount: (currentMonth['health'] as num).toDouble(),
        color: const Color(0xFFEC4899),
      ),
      SpendingCategory(
        name: l10n.other,
        amount: (currentMonth['other'] as num).toDouble(),
        color: const Color(0xFFF59E0B),
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
