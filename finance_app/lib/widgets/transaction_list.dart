import 'package:finance_app/data/transactions.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import 'state_widgets.dart';

class TransactionList extends StatelessWidget {
  final int? maxItems;
  final bool showSearch;

  const TransactionList({
    super.key,
    this.maxItems,
    this.showSearch = false,
  });

  @override
  Widget build(BuildContext context) {
    final transactions = _getRecentTransactions();
    final displayTransactions = maxItems != null 
        ? transactions.take(maxItems!).toList()
        : transactions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showSearch) ...[
          _buildSearchBar(context),
          const SizedBox(height: AppTheme.spacingLg),
        ],
        
        if (displayTransactions.isEmpty)
          _buildEmptyState(context)
        else
          ...displayTransactions.map((transaction) => 
            _buildTransactionItem(context, transaction)
          ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Search transactions...',
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: (value) {
        // Implement search functionality
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return const EmptyState(
      icon: HeroIcons.banknotes,
      title: 'No transactions yet',
      subtitle: 'Your transactions will appear here',
      actionText: 'Add first expense',
    );
  }

  Widget _buildTransactionItem(BuildContext context, Transaction transaction) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: Row(
        children: [
          // Category Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: transaction.categoryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
            ),
            child: Center(
              child: HeroIcon(
                transaction.categoryIcon,
                size: 20,
                color: transaction.categoryColor,
              ),
            ),
          ),
          
          const SizedBox(width: AppTheme.spacingMd),
          
          // Transaction Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      DateFormat('MMM d').format(transaction.date),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingSm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: transaction.categoryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSm),
                      ),
                      child: Text(
                        transaction.category,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: transaction.categoryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Amount
          Text(
            '-₪${transaction.amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppTheme.errorColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  List<Transaction> _getRecentTransactions() {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final sorted = septTransactions..sort((a, b) => dateFormat.parse(b["date"]).compareTo(dateFormat.parse(a["date"])));

    return sorted.map((json) => Transaction.fromJson(json)).toList().take(5).toList();
  }
}

class Transaction {
  final String id;
  final String description;
  final double amount;
  final DateTime date;
  final String category;
  final HeroIcons categoryIcon;
  final Color categoryColor;

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
    required this.categoryIcon,
    required this.categoryColor,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    return Transaction(
      id: json['id'],
      description: json['description'],
      amount: json['amount'],
      date: dateFormat.parse(json['date']),
      category: json['category'],
      categoryIcon: getCategoryIcon(json['category']),
      categoryColor: getCategoryColor(json['category']),
    );
  }
}

HeroIcons getCategoryIcon(String category) {  
  switch (category) {
    case 'Food & Groceries':
      return HeroIcons.buildingStorefront;
    case 'Transport':
      return HeroIcons.truck;
    case 'Housing & Utilities':
      return HeroIcons.shoppingBag;
    case 'Education & Childcare':
      return HeroIcons.academicCap;
    case 'Health':
      return HeroIcons.heart;
    default:
      return HeroIcons.ellipsisHorizontal;
  }
}

Color getCategoryColor(String category) {
  switch (category) {
    case 'Food & Groceries':
      return AppTheme.accentColor;
    case 'Transport':
      return const Color(0xFF8B5CF6);
    case 'Housing & Utilities':
      return const Color(0xFFF59E0B);
    case 'Education & Childcare':
      return const Color(0xFFEF4444);
    case 'Health':
      return const Color(0xFF6B7280);
    default:
      return AppTheme.textSecondary;
  }
}

