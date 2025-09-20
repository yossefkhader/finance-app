import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../theme/app_theme.dart';
import '../widgets/transaction_list.dart';
import '../widgets/add_expense_modal.dart';
import '../data/budget.dart';
import '../data/expenses.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  String _selectedCategory = 'جميع الفئات';
  final List<String> _categories = [
    'جميع الفئات',
    'الطعام والمطاعم',
    'النقل والمواصلات',
    'التسوق',
    'الترفيه',
    'الفواتير والمرافق',
    'متفرقات',
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
          
          // Budget Categories Section
          _buildBudgetCategoriesSection(),
          
          const SizedBox(height: AppTheme.spacingXl),
          
          // Transactions Section
          _buildTransactionsSection(),
        ],
      ),
    );
  }

  Widget _buildBudgetOverview() {
    final monthlyBudget = budget.values.reduce((a, b) => a + b);
    
    // Get September actual spending data
    final septemberData = monthlyExpenses.firstWhere((month) => month['month'] == 9);
    final spent = (septemberData['totalExpenses'] as num).toDouble();
    final remaining = monthlyBudget - spent;
    final percentUsed = spent / monthlyBudget;

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
              'نظرة عامة على الميزانية',
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
                      Expanded(child: _buildBudgetStat('الميزانية الشهرية', '${monthlyBudget.toStringAsFixed(0)} ₪')),
                      const SizedBox(width: AppTheme.spacingXl),
                      Expanded(child: _buildBudgetStat('المُنفق', '${spent.toStringAsFixed(0)} ₪')),
                      const SizedBox(width: AppTheme.spacingXl),
                      Expanded(child: _buildBudgetStat('المتبقي', '${remaining.toStringAsFixed(0)} ₪')),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildBudgetStat('الميزانية الشهرية', '${monthlyBudget.toStringAsFixed(0)} ₪')),
                          const SizedBox(width: AppTheme.spacingLg),
                          Expanded(child: _buildBudgetStat('المُنفق', '${spent.toStringAsFixed(0)} ₪')),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingLg),
                      _buildBudgetStat('المتبقي', '${remaining.toStringAsFixed(0)} ₪'),
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
                      'استخدام الميزانية',
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

  Widget _buildBudgetCategoriesSection() {
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
              'فئات الميزانية',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            
            const SizedBox(height: AppTheme.spacingXl),
            
            // Budget Categories Grid
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 800 ? 2 : 1;
                
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: AppTheme.spacingLg,
                    mainAxisSpacing: AppTheme.spacingLg,
                    childAspectRatio: 2.2, // Adjusted for taller cards with progress bars
                  ),
                  itemCount: budget.length,
                  itemBuilder: (context, index) {
                    final entry = budget.entries.elementAt(index);
                    return _buildBudgetCategoryCard(entry.key, entry.value);
                  },
                );
              },
            ),
            
            const SizedBox(height: AppTheme.spacingLg),
            
            // Total Budget Summary
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
                border: Border.all(
                  color: AppTheme.accentColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'إجمالي الميزانية الشهرية',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.accentColor,
                    ),
                  ),
                  Text(
                    '${budget.values.reduce((a, b) => a + b).toStringAsFixed(0)} ₪',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.accentColor,
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

  Widget _buildBudgetCategoryCard(String categoryKey, double amount) {
    final categoryName = _getCategoryName(categoryKey);
    final icon = _getCategoryIcon(categoryKey);
    final color = _getCategoryColor(categoryKey);
    
    // Get September data for actual spending
    final septemberData = monthlyExpenses.firstWhere((month) => month['month'] == 9);
    final actualSpent = (septemberData[categoryKey] as num).toDouble();
    final usagePercentage = amount > 0 ? (actualSpent / amount).clamp(0.0, 1.0) : 0.0;
    final remaining = amount - actualSpent;
    
    // Determine progress bar color based on usage
    Color progressColor;
    if (usagePercentage >= 1.0) {
      progressColor = AppTheme.errorColor; // Over budget
    } else if (usagePercentage > 0.8) {
      progressColor = AppTheme.warningColor; // High usage
    } else {
      progressColor = AppTheme.successColor; // Good usage
    }
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingSm),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusSm),
                ),
                child: HeroIcon(
                  icon,
                  size: 20,
                  color: color,
                ),
              ),
              
              const SizedBox(width: AppTheme.spacingMd),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoryName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppTheme.spacingXs),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${actualSpent.toStringAsFixed(0)} ₪',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: progressColor,
                          ),
                        ),
                        Text(
                          '/ ${amount.toStringAsFixed(0)} ₪',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingMd),
          
          // Progress bar
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(usagePercentage * 100).toInt()}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: progressColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    remaining >= 0 
                        ? 'متبقي ${remaining.toStringAsFixed(0)} ₪'
                        : 'تجاوز ${(-remaining).toStringAsFixed(0)} ₪',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: remaining >= 0 ? AppTheme.textSecondary : AppTheme.errorColor,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.spacingXs),
              
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: AppTheme.borderColor,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerRight,
                  widthFactor: usagePercentage > 1.0 ? 1.0 : usagePercentage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: progressColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getCategoryName(String categoryKey) {
    switch (categoryKey) {
      case 'housingUtilities':
        return 'السكن والمرافق';
      case 'foodGroceries':
        return 'الطعام والبقالة';
      case 'transport':
        return 'النقل والمواصلات';
      case 'educationChildcare':
        return 'التعليم ورعاية الأطفال';
      case 'health':
        return 'الصحة والطب';
      case 'other':
        return 'متفرقات';
      default:
        return categoryKey;
    }
  }

  HeroIcons _getCategoryIcon(String categoryKey) {
    switch (categoryKey) {
      case 'housingUtilities':
        return HeroIcons.home;
      case 'foodGroceries':
        return HeroIcons.shoppingBag;
      case 'transport':
        return HeroIcons.truck;
      case 'educationChildcare':
        return HeroIcons.academicCap;
      case 'health':
        return HeroIcons.heart;
      case 'other':
        return HeroIcons.ellipsisHorizontal;
      default:
        return HeroIcons.folder;
    }
  }

  Color _getCategoryColor(String categoryKey) {
    switch (categoryKey) {
      case 'housingUtilities':
        return const Color(0xFF3B82F6); // Blue
      case 'foodGroceries':
        return const Color(0xFF10B981); // Green
      case 'transport':
        return const Color(0xFF8B5CF6); // Purple
      case 'educationChildcare':
        return const Color(0xFFF59E0B); // Orange
      case 'health':
        return const Color(0xFFEF4444); // Red
      case 'other':
        return const Color(0xFF6B7280); // Gray
      default:
        return AppTheme.accentColor;
    }
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
                  'المعاملات',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddExpenseModal(context),
                  icon: const HeroIcon(
                    HeroIcons.plus,
                    size: 16,
                    style: HeroIconStyle.solid,
                  ),
                  label: const Text('إضافة مصروف'),
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
        hintText: 'البحث في المعاملات...',
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
        labelText: 'الفئة',
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
          _selectedCategory = value ?? 'جميع الفئات';
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
