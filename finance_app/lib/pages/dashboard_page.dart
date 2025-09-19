import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_card.dart';
import '../widgets/transaction_list.dart';
import '../widgets/spending_chart.dart';
import '../l10n/app_localizations.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

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
        final isWide = constraints.maxWidth > 768;
        
         if (isWide) {
           return Row(
             children: [
               Expanded(flex: 2, child: _buildTotalBalanceCard(context)),
               const SizedBox(width: AppTheme.spacingLg),
               Expanded(child: _buildSavingsSummaryCard(context)),
               const SizedBox(width: AppTheme.spacingLg),
               Expanded(child: _buildBudgetUsedCard(context)),
             ],
           );
         } else {
           return Column(
             children: [
               _buildTotalBalanceCard(context),
               const SizedBox(height: AppTheme.spacingLg),
               Row(
                 children: [
                   Expanded(child: _buildSavingsSummaryCard(context)),
                   const SizedBox(width: AppTheme.spacingLg),
                   Expanded(child: _buildBudgetUsedCard(context)),
                 ],
               ),
             ],
           );
         }
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
    return StatCard(
      title: l10n.totalBalance,
      value: '١٢٬٨٤٧.٣٢ ر.س',
      subtitle: l10n.acrossAllAccounts,
      icon: HeroIcons.banknotes,
      trend: TrendData(
        value: 4.2,
        isPositive: true,
        period: l10n.vsLastMonth,
      ),
      isLarge: true,
    );
  }

  Widget _buildSavingsSummaryCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return StatCard(
      title: l10n.savingsThisMonth,
      value: '٤٨٢.١٥ ر.س',
      subtitle: l10n.roundUpsPlusManual,
      icon: HeroIcons.arrowTrendingUp,
      trend: TrendData(
        value: 12.5,
        isPositive: true,
        period: l10n.vsLastMonth,
      ),
      sparklineData: [20, 25, 30, 35, 28, 42, 48],
    );
  }

  Widget _buildBudgetUsedCard(BuildContext context) {
    const budgetUsed = 0.68;
    const remaining = 1850.00;
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
              decoration: BoxDecoration(
                color: AppTheme.borderColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
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
               '${remaining.toStringAsFixed(0)} ر.س ${l10n.remaining}',
               style: Theme.of(context).textTheme.bodyMedium,
             ),
          ],
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
