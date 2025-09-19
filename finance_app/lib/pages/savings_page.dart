import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:heroicons/heroicons.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_card.dart';

class SavingsPage extends StatefulWidget {
  const SavingsPage({super.key});

  @override
  State<SavingsPage> createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  bool _saveForMe = true; // true = Save for Me, false = Donate to Charity

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row - Savings Stats
          _buildSavingsStats(),
          
          const SizedBox(height: AppTheme.spacingXl),
          
          // Round-Up Explanation
          _buildRoundUpExplanation(),
          
          const SizedBox(height: AppTheme.spacingXl),
          
          // Main Content Row
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 1024;
              
              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildSavingsChart()),
                    const SizedBox(width: AppTheme.spacingXl),
                    Expanded(child: _buildSavingsGoals()),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildSavingsChart(),
                    const SizedBox(height: AppTheme.spacingXl),
                    _buildSavingsGoals(),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsStats() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 768;
        
        if (isWide) {
          return Row(
            children: [
              Expanded(child: _buildThisMonthCard()),
              const SizedBox(width: AppTheme.spacingLg),
              Expanded(child: _buildAllTimeCard()),
              const SizedBox(width: AppTheme.spacingLg),
              Expanded(child: _buildAllocationToggle()),
            ],
          );
        } else {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildThisMonthCard()),
                  const SizedBox(width: AppTheme.spacingLg),
                  Expanded(child: _buildAllTimeCard()),
                ],
              ),
              const SizedBox(height: AppTheme.spacingLg),
              _buildAllocationToggle(),
            ],
          );
        }
      },
    );
  }

  Widget _buildThisMonthCard() {
    return StatCard(
      title: 'Saved This Month',
      value: '\$127.45',
      subtitle: 'Round-ups only',
      icon: HeroIcons.arrowTrendingUp,
      trend: TrendData(
        value: 18.3,
        isPositive: true,
        period: 'vs last month',
      ),
    );
  }

  Widget _buildAllTimeCard() {
    return StatCard(
      title: 'Total Round-Up Savings',
      value: '\$2,847.92',
      subtitle: 'Since you started',
      icon: HeroIcons.currencyDollar,
      sparklineData: [200, 250, 300, 280, 350, 420, 480],
    );
  }

  Widget _buildAllocationToggle() {
    return Card(
      child: Container(
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
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingSm),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
                  ),
                  child: const HeroIcon(
                    HeroIcons.arrowPathRoundedSquare,
                    size: 20,
                    color: AppTheme.accentColor,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Text(
                  'Round-Up Allocation',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacingLg),
            
            Container(
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildToggleOption(
                      'Save for Me',
                      _saveForMe,
                      () => setState(() => _saveForMe = true),
                    ),
                  ),
                  Expanded(
                    child: _buildToggleOption(
                      'Donate to Charity',
                      !_saveForMe,
                      () => setState(() => _saveForMe = false),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingMd),
            
            Text(
              _saveForMe 
                  ? 'Round-ups will be saved to your savings account'
                  : 'Round-ups will be donated to your selected charity',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleOption(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical: AppTheme.spacingSm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.cardColor : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
          boxShadow: isSelected ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoundUpExplanation() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: AppTheme.accentColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
          border: Border.all(
            color: AppTheme.accentColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingSm),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
              ),
              child: const HeroIcon(
                HeroIcons.lightBulb,
                size: 24,
                color: AppTheme.accentColor,
              ),
            ),
            
            const SizedBox(width: AppTheme.spacingMd),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How Round-Ups Work',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppTheme.accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXs),
                  Text(
                    'Every purchase is rounded up to the nearest dollar. The difference is automatically saved or donated based on your preference.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
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

  Widget _buildSavingsChart() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Savings Growth Trend',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            
            const SizedBox(height: AppTheme.spacingXl),
            
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 50,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppTheme.borderColor,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                          if (value.toInt() >= 0 && value.toInt() < months.length) {
                            return Text(
                              months[value.toInt()],
                              style: Theme.of(context).textTheme.bodySmall,
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '\$${value.toInt()}',
                            style: Theme.of(context).textTheme.bodySmall,
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 50),
                        FlSpot(1, 80),
                        FlSpot(2, 120),
                        FlSpot(3, 160),
                        FlSpot(4, 200),
                        FlSpot(5, 240),
                      ],
                      isCurved: true,
                      color: AppTheme.accentColor,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppTheme.accentColor.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingsGoals() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Savings Goals',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            
            const SizedBox(height: AppTheme.spacingLg),
            
            _buildGoalItem('Emergency Fund', 5000, 2847.92),
            const SizedBox(height: AppTheme.spacingLg),
            _buildGoalItem('Vacation', 3000, 1250.00),
            const SizedBox(height: AppTheme.spacingLg),
            _buildGoalItem('New Car', 15000, 4200.00),
            
            const SizedBox(height: AppTheme.spacingXl),
            
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const HeroIcon(
                  HeroIcons.plus,
                  size: 16,
                ),
                label: const Text('Add New Goal'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalItem(String title, double target, double current) {
    final progress = current / target;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              '\$${current.toStringAsFixed(0)} / \$${target.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        
        const SizedBox(height: AppTheme.spacingSm),
        
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: AppTheme.borderColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.accentColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: AppTheme.spacingXs),
        
        Text(
          '${(progress * 100).toInt()}% complete',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
