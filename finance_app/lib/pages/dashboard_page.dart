import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_card.dart';
import '../widgets/transaction_list.dart';
import '../widgets/spending_chart.dart';
import '../l10n/app_localizations.dart';
import '../data/expenses.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  // Helper methods to calculate data from expenses.dart
  Map<String, num> get _currentMonthData {
    // Get the latest month data (September - month 9)
    return budget.lastWhere((month) => month['month'] == 9);
  }

  Map<String, num> get _previousMonthData {
    // Get August data (month 8) for comparison
    return budget.lastWhere((month) => month['month'] == 8);
  }

  double get _totalBalance {
    // Calculate total balance as sum of net income minus deficits over time
    double balance = 0;
    for (var monthData in budget) {
      balance += (monthData['surplusDeficit'] as num).toDouble();
    }
    // Start with a base balance and add the accumulated surplus/deficit
    return 25000 + balance; // Base savings + accumulated
  }

  double get _thisMonthSavings {
    // Calculate savings based on round-ups and surplus (if positive)
    final currentMonth = _currentMonthData;
    final surplus = (currentMonth['surplusDeficit'] as num).toDouble();
    // Simulate round-ups savings
    return surplus > 0 ? surplus + 150 : 150; // Always have some round-up savings
  }

  double get _savingsTrend {
    final currentSavings = _thisMonthSavings;
    final prevMonth = _previousMonthData;
    final prevSurplus = (prevMonth['surplusDeficit'] as num).toDouble();
    final prevSavings = prevSurplus > 0 ? prevSurplus + 120 : 120;
    
    if (prevSavings == 0) return 0;
    return ((currentSavings - prevSavings) / prevSavings * 100);
  }

  double get _budgetUsedPercentage {
    final currentMonth = _currentMonthData;
    final totalExpenses = (currentMonth['totalExpenses'] as num).toDouble();
    final netIncome = (currentMonth['netIncome'] as num).toDouble();
    return totalExpenses / netIncome;
  }

  double get _remainingBudget {
    final currentMonth = _currentMonthData;
    final netIncome = (currentMonth['netIncome'] as num).toDouble();
    final totalExpenses = (currentMonth['totalExpenses'] as num).toDouble();
    return netIncome - totalExpenses;
  }

  double get _incomeTrend {
    final currentIncome = (_currentMonthData['netIncome'] as num).toDouble();
    final prevIncome = (_previousMonthData['netIncome'] as num).toDouble();
    return ((currentIncome - prevIncome) / prevIncome * 100);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Row - Main Stats
          _buildHeroRow(context),
          
          const SizedBox(height: AppTheme.spacingXl),
          
          // Second Row - Charts and Transactions
          _buildSecondRow(context),
        ],
      ),
    );
  }

  Widget _buildHeroRow(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
             children: [
               Expanded(flex: 1, child: _buildTotalBalanceCard(context)),
               const SizedBox(width: AppTheme.spacingLg),
               Expanded(child: _buildSavingsSummaryCard(context)),
               const SizedBox(width: AppTheme.spacingLg),
               Expanded(child: _buildBudgetUsedCard(context)),
             ],
           );
      },
    );
  }

  Widget _buildSecondRow(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 1024;
        
        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildSpendingChart(context)),
              const SizedBox(width: AppTheme.spacingXl),
              Expanded(flex: 3, child: _buildRecentTransactions(context)),
            ],
          );
        } else {
          return Column(
            children: [
              _buildSpendingChart(context),
              const SizedBox(height: AppTheme.spacingXl),
              _buildRecentTransactions(context),
            ],
          );
        }
      },
    );
  }

  Widget _buildTotalBalanceCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final balance = _totalBalance;
    final trend = _incomeTrend;
    
    return SizedBox(
      height: 250,
      width: 250,
      child: StatCard(
        title: l10n.totalBalance,
        value: '${balance} ₪',
        subtitle: l10n.acrossAllAccounts,
        icon: HeroIcons.banknotes,
        trend: TrendData(
          value: trend.abs(),
          isPositive: trend >= 0,
          period: l10n.vsLastMonth,
        ),
        isLarge: true,
      ),
    );
  }

  Widget _buildSavingsSummaryCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final savings = _thisMonthSavings;
    final trend = _savingsTrend;
    
    return SizedBox(
      height: 250,
      width: 250,
      child: StatCard(
        title: l10n.savingsThisMonth,
        value: '${savings} ₪',
        subtitle: l10n.roundUpsPlusManual,
        icon: HeroIcons.arrowTrendingUp,
        trend: TrendData(
          value: trend.abs(),
          isPositive: trend >= 0,
          period: l10n.vsLastMonth,
        ),
        isLarge: true,
      ),
    );
  }

  Widget _buildBudgetUsedCard(BuildContext context) {
    final budgetUsed = _budgetUsedPercentage;
    final remaining = _remainingBudget;
    final l10n = AppLocalizations.of(context)!;
    
    return SizedBox(
      height: 250,
      width: 250,
      child: Card(
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
                      color: AppTheme.warningColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
                    ),
                    child: HeroIcon(
                      HeroIcons.wallet,
                      size: 20,
                      color: AppTheme.warningColor,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMd),
                   Expanded(
                     child: Text(
                       l10n.budgetUsed,
                       style: Theme.of(context).textTheme.titleMedium?.copyWith(
                         color: AppTheme.textSecondary,
                       ),
                     ),
                   ),
                ],
              ),
              
              const SizedBox(height: AppTheme.spacingLg),
              
              Text(
                '${(budgetUsed * 100).toInt()}%',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              
              const SizedBox(height: AppTheme.spacingMd),
              
              // Progress Bar
              Container(
                height: 8,
                width: 200,
                decoration: BoxDecoration(
                  color: AppTheme.borderColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerRight,
                  widthFactor: budgetUsed,
                  child: Container(
                    decoration: BoxDecoration(
                      color: budgetUsed > 0.8 
                          ? AppTheme.errorColor 
                          : budgetUsed > 0.6 
                              ? AppTheme.warningColor 
                              : AppTheme.successColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: AppTheme.spacingMd),
              
                Text(
                  remaining >= 0 
                      ? '${remaining} ₪ ${l10n.remaining}'
                      : '${remaining.abs()} ₪ عجز',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: remaining >= 0 ? null : AppTheme.errorColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpendingChart(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
              l10n.spendingByCategory,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            
            const SizedBox(height: AppTheme.spacingXl),
            
            const SpendingChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.recentTransactions,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(l10n.viewAll),
                ),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacingLg),
            
            const TransactionList(maxItems: 5),
          ],
        ),
      ),
    );
  }
}