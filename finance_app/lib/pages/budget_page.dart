import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../theme/app_theme.dart';
import '../widgets/transaction_list.dart';
import '../widgets/add_expense_modal.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  String _selectedCategory = 'All Categories';
  final List<String> _categories = [
    'All Categories',
    'Food & Dining',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Bills & Utilities',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Budget Overview Section
          _buildBudgetOverview(),
          
          const SizedBox(height: AppTheme.spacingXl),
          
          // Transactions Section
          _buildTransactionsSection(),
        ],
      ),
    );
  }

  Widget _buildBudgetOverview() {
    const monthlyBudget = 2750.0;
    const spent = 1870.0;
    const remaining = monthlyBudget - spent;
    const percentUsed = spent / monthlyBudget;

    return Card(
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Budget Overview',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            
            const SizedBox(height: AppTheme.spacingXl),
            
            // Budget Stats Row
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                
                if (isWide) {
                  return Row(
                    children: [
                      Expanded(child: _buildBudgetStat('Monthly Budget', '\$${monthlyBudget.toStringAsFixed(0)}')),
                      const SizedBox(width: AppTheme.spacingXl),
                      Expanded(child: _buildBudgetStat('Spent', '\$${spent.toStringAsFixed(0)}')),
                      const SizedBox(width: AppTheme.spacingXl),
                      Expanded(child: _buildBudgetStat('Remaining', '\$${remaining.toStringAsFixed(0)}')),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildBudgetStat('Monthly Budget', '\$${monthlyBudget.toStringAsFixed(0)}')),
                          const SizedBox(width: AppTheme.spacingLg),
                          Expanded(child: _buildBudgetStat('Spent', '\$${spent.toStringAsFixed(0)}')),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingLg),
                      _buildBudgetStat('Remaining', '\$${remaining.toStringAsFixed(0)}'),
                    ],
                  );
                }
              },
            ),
            
            const SizedBox(height: AppTheme.spacingXl),
            
            // Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Budget Usage',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      '${(percentUsed * 100).toInt()}%',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: percentUsed > 0.8 
                            ? AppTheme.errorColor 
                            : percentUsed > 0.6 
                                ? AppTheme.warningColor 
                                : AppTheme.successColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppTheme.spacingMd),
                
                Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppTheme.borderColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentUsed.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: percentUsed > 0.8 
                            ? AppTheme.errorColor 
                            : percentUsed > 0.6 
                                ? AppTheme.warningColor 
                                : AppTheme.successColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionsSection() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with filters and add button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transactions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddExpenseModal(context),
                  icon: const HeroIcon(
                    HeroIcons.plus,
                    size: 16,
                    style: HeroIconStyle.solid,
                  ),
                  label: const Text('Add Expense'),
                ),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacingLg),
            
            // Filters Row
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                
                if (isWide) {
                  return Row(
                    children: [
                      Expanded(child: _buildSearchField()),
                      const SizedBox(width: AppTheme.spacingLg),
                      SizedBox(
                        width: 200,
                        child: _buildCategoryFilter(),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildSearchField(),
                      const SizedBox(height: AppTheme.spacingMd),
                      _buildCategoryFilter(),
                    ],
                  );
                }
              },
            ),
            
            const SizedBox(height: AppTheme.spacingXl),
            
            // Transaction Table/List
            const TransactionList(showSearch: false),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Search transactions...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        // Implement search functionality
      },
    );
  }

  Widget _buildCategoryFilter() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: const InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
      ),
      items: _categories.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategory = value ?? 'All Categories';
        });
      },
    );
  }

  void _showAddExpenseModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddExpenseModal(),
    );
  }
}
