class AiResponse {
  final String text;
  final List<AiCommand> commands;
  final AiResponseType type;
  final Map<String, dynamic>? metadata;

  AiResponse({
    required this.text,
    this.commands = const [],
    this.type = AiResponseType.text,
    this.metadata,
  });

  factory AiResponse.fromJson(Map<String, dynamic> json) {
    return AiResponse(
      text: json['text'] ?? '',
      commands: (json['commands'] as List<dynamic>?)
          ?.map((cmd) => AiCommand.fromJson(cmd))
          .toList() ?? [],
      type: AiResponseType.values.firstWhere(
        (type) => type.toString().split('.').last == json['type'],
        orElse: () => AiResponseType.text,
      ),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'commands': commands.map((cmd) => cmd.toJson()).toList(),
      'type': type.toString().split('.').last,
      'metadata': metadata,
    };
  }
}

class AiCommand {
  final AiCommandType type;
  final String action;
  final Map<String, dynamic> parameters;
  final String? label;
  final String? description;

  AiCommand({
    required this.type,
    required this.action,
    this.parameters = const {},
    this.label,
    this.description,
  });

  factory AiCommand.fromJson(Map<String, dynamic> json) {
    return AiCommand(
      type: AiCommandType.values.firstWhere(
        (type) => type.toString().split('.').last == json['type'],
        orElse: () => AiCommandType.navigate,
      ),
      action: json['action'] ?? '',
      parameters: json['parameters'] as Map<String, dynamic>? ?? {},
      label: json['label'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'action': action,
      'parameters': parameters,
      'label': label,
      'description': description,
    };
  }
}

enum AiResponseType {
  text,
  actionable,
  financial,
  educational,
  error,
  loading,
}

enum AiCommandType {
  navigate,        // Navigate to a page (e.g., "/budget", "/savings")
  addExpense,      // Add a new expense
  createBudget,    // Create or modify budget
  showChart,       // Display specific chart or visualization
  setGoal,         // Set financial goal
  reminder,        // Set reminder or notification
  calculate,       // Perform financial calculation
  analyze,         // Analyze financial data
  suggest,         // Provide suggestions
  export,          // Export data
  share,           // Share information
  learn,           // Navigate to lesson or educational content
}

// Predefined command templates for common financial actions
class AiCommandTemplates {
  static AiCommand navigateToPage(String page, {String? label}) {
    return AiCommand(
      type: AiCommandType.navigate,
      action: 'navigate',
      parameters: {'page': page},
      label: label ?? 'انتقل إلى $page',
    );
  }

  static AiCommand addExpense(double amount, String category, String description) {
    return AiCommand(
      type: AiCommandType.addExpense,
      action: 'add_expense',
      parameters: {
        'amount': amount,
        'category': category,
        'description': description,
      },
      label: 'إضافة مصروف',
    );
  }

  static AiCommand setBudget(String category, double amount) {
    return AiCommand(
      type: AiCommandType.createBudget,
      action: 'set_budget',
      parameters: {
        'category': category,
        'amount': amount,
      },
      label: 'تعديل الميزانية',
    );
  }

  static AiCommand showChart(String chartType, {Map<String, dynamic>? filters}) {
    return AiCommand(
      type: AiCommandType.showChart,
      action: 'show_chart',
      parameters: {
        'chart_type': chartType,
        'filters': filters ?? {},
      },
      label: 'عرض الرسم البياني',
    );
  }

  static AiCommand setGoal(String goalType, double amount, DateTime? deadline) {
    return AiCommand(
      type: AiCommandType.setGoal,
      action: 'set_goal',
      parameters: {
        'goal_type': goalType,
        'amount': amount,
        'deadline': deadline?.toIso8601String(),
      },
      label: 'تحديد هدف مالي',
    );
  }

  static AiCommand openLesson(String lessonId) {
    return AiCommand(
      type: AiCommandType.learn,
      action: 'open_lesson',
      parameters: {'lesson_id': lessonId},
      label: 'فتح الدرس',
    );
  }

  static AiCommand calculateSavings(double monthlyAmount, int months) {
    return AiCommand(
      type: AiCommandType.calculate,
      action: 'calculate_savings',
      parameters: {
        'monthly_amount': monthlyAmount,
        'months': months,
      },
      label: 'حساب المدخرات',
    );
  }
}
