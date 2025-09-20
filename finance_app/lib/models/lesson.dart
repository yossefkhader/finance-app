class Lesson {
  final String id;
  final String title;
  final String goal;
  final LessonDetails details;

  Lesson({
    required this.id,
    required this.title,
    required this.goal,
    required this.details,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      goal: json['goal'],
      details: LessonDetails.fromJson(json['details']),
    );
  }
}

class LessonDetails {
  final String introduction;
  final String why;
  final List<String> steps;
  final String example;
  final List<String> tips;
  final String homework;
  final List<String> checklist;

  LessonDetails({
    required this.introduction,
    required this.why,
    required this.steps,
    required this.example,
    required this.tips,
    required this.homework,
    required this.checklist,
  });

  factory LessonDetails.fromJson(Map<String, dynamic> json) {
    return LessonDetails(
      introduction: json['introduction'],
      why: json['why'],
      steps: List<String>.from(json['steps']),
      example: json['example'],
      tips: List<String>.from(json['tips']),
      homework: json['homework'],
      checklist: List<String>.from(json['checklist']),
    );
  }
}

class LessonProgress {
  final String lessonId;
  final bool isCompleted;
  final List<bool> checklistStatus;
  final DateTime? completedAt;

  LessonProgress({
    required this.lessonId,
    this.isCompleted = false,
    required this.checklistStatus,
    this.completedAt,
  });

  LessonProgress copyWith({
    bool? isCompleted,
    List<bool>? checklistStatus,
    DateTime? completedAt,
  }) {
    return LessonProgress(
      lessonId: lessonId,
      isCompleted: isCompleted ?? this.isCompleted,
      checklistStatus: checklistStatus ?? this.checklistStatus,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
