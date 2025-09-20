import 'package:finance_app/data/transactions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/ai_response.dart';
import '../widgets/add_expense_modal.dart';

class CommandHandlerService {
  static Future<void> executeCommand(
    BuildContext context,
    AiCommand command,
  ) async {
    try {
      switch (command.type) {
        case AiCommandType.navigate:
          await _handleNavigation(context, command);
          break;
        
        case AiCommandType.addExpense:
          await _handleAddExpense(context, command);
          break;
        
        case AiCommandType.createBudget:
          await _handleCreateBudget(context, command);
          break;
        
        case AiCommandType.showChart:
          await _handleShowChart(context, command);
          break;
        
        case AiCommandType.setGoal:
          await _handleSetGoal(context, command);
          break;
        
        case AiCommandType.calculate:
          await _handleCalculate(context, command);
          break;
        
        case AiCommandType.analyze:
          await _handleAnalyze(context, command);
          break;
        
        case AiCommandType.learn:
          await _handleLearn(context, command);
          break;
        
        case AiCommandType.reminder:
          await _handleReminder(context, command);
          break;
        
        case AiCommandType.export:
          await _handleExport(context, command);
          break;
        
        case AiCommandType.share:
          await _handleShare(context, command);
          break;
        
        case AiCommandType.suggest:
          await _handleSuggest(context, command);
          break;
      }
    } catch (e) {
      _showErrorSnackBar(context, 'حدث خطأ أثناء تنفيذ الأمر: ${e.toString()}');
    }
  }

  static Future<void> _handleNavigation(BuildContext context, AiCommand command) async {
    final page = command.parameters['page'] as String?;
    if (page != null) {
      context.go(page);
    }
  }

  static Future<void> _handleAddExpense(BuildContext context, AiCommand command) async {
    // Show the add expense modal with pre-filled data if provided
    final amount = command.parameters['amount'] as double?;
    final category = command.parameters['category'] as String?;
    final description = command.parameters['description'] as String?;
    final date = DateTime.now();

    final expense = {
      'id' : '${date.year}-${date.month}-${date.day}-${category}',
      'date' : '${date.year}-${date.month}-${date.day}',
      'category' : category,
      'description' : description,
      'amount' : amount,
    };

    septTransactions.add(expense);

  }

  static Future<void> _handleCreateBudget(BuildContext context, AiCommand command) async {
    // Navigate to budget page with specific category or action
    final category = command.parameters['category'] as String?;
    final amount = command.parameters['amount'] as double?;
    
    context.go('/budget');
    
    // Show a snackbar with the suggested budget action
    if (category != null && amount != null) {
      _showInfoSnackBar(
        context,
        'اقتراح: تعديل ميزانية $category إلى $amount شاقل',
      );
    }
  }

  static Future<void> _handleShowChart(BuildContext context, AiCommand command) async {
    final chartType = command.parameters['chart_type'] as String?;
    
    // Navigate to appropriate page based on chart type
    switch (chartType) {
      case 'spending':
      case 'expenses':
        context.go('/dashboard');
        break;
      case 'savings':
        context.go('/savings');
        break;
      case 'budget':
        context.go('/budget');
        break;
      default:
        context.go('/dashboard');
    }
  }

  static Future<void> _handleSetGoal(BuildContext context, AiCommand command) async {
    final goalType = command.parameters['goal_type'] as String?;
    final amount = command.parameters['amount'] as double?;
    
    // Navigate to savings page where goals are managed
    context.go('/savings');
    
    if (goalType != null && amount != null) {
      _showInfoSnackBar(
        context,
        'اقتراح: تحديد هدف $goalType بقيمة $amount شاقل',
      );
    }
  }

  static Future<void> _handleCalculate(BuildContext context, AiCommand command) async {
    final calculationType = command.action;
    
    switch (calculationType) {
      case 'calculate_savings':
        final monthlyAmount = command.parameters['monthly_amount'] as double?;
        final months = command.parameters['months'] as int?;
        
        if (monthlyAmount != null && months != null) {
          final total = monthlyAmount * months;
          _showInfoSnackBar(
            context,
            'نتيجة الحساب: $monthlyAmount شاقل × $months شهر = $total شاقل',
          );
        }
        break;
      
      default:
        _showInfoSnackBar(context, 'تم تنفيذ عملية الحساب');
    }
  }

  static Future<void> _handleAnalyze(BuildContext context, AiCommand command) async {
    // Navigate to dashboard for financial analysis
    context.go('/dashboard');
    _showInfoSnackBar(context, 'عرض تحليل البيانات المالية');
  }

  static Future<void> _handleLearn(BuildContext context, AiCommand command) async {
    final lessonId = command.parameters['lesson_id'] as String?;
    
    if (lessonId != null) {
      context.go('/lessons/$lessonId');
    } else {
      context.go('/lessons');
    }
  }

  static Future<void> _handleReminder(BuildContext context, AiCommand command) async {
    final reminderText = command.parameters['text'] as String?;
    
    _showInfoSnackBar(
      context,
      reminderText ?? 'تم إنشاء تذكير',
    );
  }

  static Future<void> _handleExport(BuildContext context, AiCommand command) async {
    _showInfoSnackBar(context, 'سيتم تنفيذ تصدير البيانات قريباً');
  }

  static Future<void> _handleShare(BuildContext context, AiCommand command) async {
    _showInfoSnackBar(context, 'سيتم تنفيذ مشاركة البيانات قريباً');
  }

  static Future<void> _handleSuggest(BuildContext context, AiCommand command) async {
    final suggestion = command.parameters['suggestion'] as String?;
    
    _showInfoSnackBar(
      context,
      suggestion ?? 'اقتراح: راجع نصائح الادخار في صفحة المدخرات',
    );
  }

  static void _showInfoSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // Check if a command can be executed
  static bool canExecuteCommand(AiCommand command) {
    switch (command.type) {
      case AiCommandType.navigate:
        return command.parameters.containsKey('page');
      
      case AiCommandType.addExpense:
        return true; // Can always show the modal
      
      case AiCommandType.learn:
        return true; // Can navigate to lessons
      
      default:
        return true; // Most commands can be attempted
    }
  }

  // Get a user-friendly description of what a command will do
  static String getCommandDescription(AiCommand command) {
    switch (command.type) {
      case AiCommandType.navigate:
        final page = command.parameters['page'] as String?;
        return 'الانتقال إلى $page';
      
      case AiCommandType.addExpense:
        return 'إضافة مصروف جديد';
      
      case AiCommandType.createBudget:
        return 'إنشاء أو تعديل الميزانية';
      
      case AiCommandType.setGoal:
        return 'تحديد هدف مالي';
      
      case AiCommandType.learn:
        return 'فتح درس تعليمي';
      
      default:
        return command.label ?? command.action;
    }
  }
}
