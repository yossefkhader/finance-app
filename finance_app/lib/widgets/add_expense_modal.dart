import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class AddExpenseModal extends StatefulWidget {
  final double? initialAmount;
  final String? initialCategory;
  final String? initialDescription;

  const AddExpenseModal({
    super.key,
    this.initialAmount,
    this.initialCategory,
    this.initialDescription,
  });

  @override
  State<AddExpenseModal> createState() => _AddExpenseModalState();
}

class _AddExpenseModalState extends State<AddExpenseModal> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _selectedCategory = 'foodDining';
  DateTime _selectedDate = DateTime.now();
  
  final List<String> _categories = [
    'foodDining',
    'transportation',
    'shopping',
    'entertainment',
    'billsUtilities',
    'healthcare',
    'education',
    'travel',
    'personalCare',
    'other',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with current date
    _selectedDate = DateTime.now();
    
    // Set initial values if provided
    if (widget.initialAmount != null) {
      _amountController.text = widget.initialAmount!.toString();
    }
    if (widget.initialDescription != null) {
      _descriptionController.text = widget.initialDescription!;
    }
    if (widget.initialCategory != null && _categories.contains(widget.initialCategory)) {
      _selectedCategory = widget.initialCategory!;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _getCategoryLabel(BuildContext context, String categoryKey) {
    final l10n = AppLocalizations.of(context)!;
    switch (categoryKey) {
      case 'foodDining':
        return l10n.foodDining;
      case 'transportation':
        return l10n.transportation;
      case 'shopping':
        return l10n.shopping;
      case 'entertainment':
        return l10n.entertainment;
      case 'billsUtilities':
        return l10n.billsUtilities;
      case 'healthcare':
        return l10n.healthcare;
      case 'education':
        return l10n.education;
      case 'travel':
        return l10n.travel;
      case 'personalCare':
        return l10n.personalCare;
      case 'other':
        return l10n.other;
      default:
        return categoryKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width > 600 ? 500 : double.infinity,
        margin: const EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            _buildForm(),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingXl),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.borderColor,
            width: 1,
          ),
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
              HeroIcons.plus,
              size: 20,
              color: AppTheme.accentColor,
            ),
          ),
          
          const SizedBox(width: AppTheme.spacingMd),
          
          Expanded(
            child: Text(
              l10n.addExpense,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const HeroIcon(
              HeroIcons.xMark,
              size: 20,
            ),
            color: AppTheme.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingXl),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount Field
            Text(
              'Amount',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: AppTheme.spacingSm),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                hintText: '0.00',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
              autofocus: true,
            ),
            
            const SizedBox(height: AppTheme.spacingLg),
            
            // Description Field
            Text(
              'Description',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: AppTheme.spacingSm),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'What did you spend on?',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
              textCapitalization: TextCapitalization.sentences,
            ),
            
            const SizedBox(height: AppTheme.spacingLg),
            
            // Category Field
            Text(
              'Category',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: AppTheme.spacingSm),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Row(
                    children: [
                      HeroIcon(
                        _getCategoryIcon(category),
                        size: 16,
                        color: _getCategoryColor(category),
                      ),
                      const SizedBox(width: AppTheme.spacingSm),
                      Text(category),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            
            const SizedBox(height: AppTheme.spacingLg),
            
            // Date Field
            Text(
              'Date',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: AppTheme.spacingSm),
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  DateFormat('MMM d, yyyy').format(_selectedDate),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingXl),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppTheme.borderColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ),
          
          const SizedBox(width: AppTheme.spacingMd),
          
          Expanded(
            child: ElevatedButton(
              onPressed: _saveExpense,
              child: const Text('Save Expense'),
            ),
          ),
        ],
      ),
    );
  }

  HeroIcons _getCategoryIcon(String category) {
    switch (category) {
      case 'Food & Dining':
        return HeroIcons.buildingStorefront;
      case 'Transportation':
        return HeroIcons.truck;
      case 'Shopping':
        return HeroIcons.shoppingBag;
      case 'Entertainment':
        return HeroIcons.playCircle;
      case 'Bills & Utilities':
        return HeroIcons.bolt;
      case 'Healthcare':
        return HeroIcons.heart;
      case 'Education':
        return HeroIcons.academicCap;
      case 'Travel':
        return HeroIcons.globeAlt;
      case 'Personal Care':
        return HeroIcons.sparkles;
      default:
        return HeroIcons.ellipsisHorizontal;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Food & Dining':
        return AppTheme.accentColor;
      case 'Transportation':
        return const Color(0xFF8B5CF6);
      case 'Shopping':
        return const Color(0xFFF59E0B);
      case 'Entertainment':
        return const Color(0xFFEF4444);
      case 'Bills & Utilities':
        return const Color(0xFF6B7280);
      case 'Healthcare':
        return const Color(0xFFEC4899);
      case 'Education':
        return const Color(0xFF3B82F6);
      case 'Travel':
        return AppTheme.successColor;
      case 'Personal Care':
        return const Color(0xFF14B8A6);
      default:
        return AppTheme.textSecondary;
    }
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.accentColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      // Here you would typically save the expense to your data store
      // For now, we'll just close the modal
      
      final amount = double.parse(_amountController.text);
      final description = _descriptionController.text.trim();
      
      // TODO: Implement actual save logic
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Expense of \$${amount.toStringAsFixed(2)} saved successfully'),
          backgroundColor: AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
      
      Navigator.of(context).pop();
    }
  }
}
