import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/lesson.dart';

class LessonService {
  static const String _lessonsPath = 'assets/lessons.json';
  static List<Lesson>? _cachedLessons;
  static Map<String, LessonProgress> _progressMap = {};

  static Future<List<Lesson>> loadLessons() async {
    if (_cachedLessons != null) {
      return _cachedLessons!;
    }

    try {
      final String jsonString = await rootBundle.loadString(_lessonsPath);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> lessonsJson = jsonData['lessons'];

      _cachedLessons = lessonsJson.map((json) => Lesson.fromJson(json)).toList();

      // Initialize progress for each lesson
      for (final lesson in _cachedLessons!) {
        if (!_progressMap.containsKey(lesson.id)) {
          _progressMap[lesson.id] = LessonProgress(
            lessonId: lesson.id,
            checklistStatus: List.filled(lesson.details.checklist.length, false),
          );
        }
      }

      return _cachedLessons!;
    } catch (e) {
      print('Error loading lessons: $e');
      return [];
    }
  }

  static Lesson? getLessonById(String id) {
    return _cachedLessons?.firstWhere((lesson) => lesson.id == id);
  }

  static LessonProgress getProgress(String lessonId) {
    return _progressMap[lessonId] ?? LessonProgress(
      lessonId: lessonId,
      checklistStatus: [],
    );
  }

  static void updateProgress(String lessonId, LessonProgress progress) {
    _progressMap[lessonId] = progress;
    // Here you could save to SharedPreferences or local storage
  }

  static void toggleChecklistItem(String lessonId, int index) {
    final currentProgress = getProgress(lessonId);
    final newChecklist = List<bool>.from(currentProgress.checklistStatus);
    
    if (index < newChecklist.length) {
      newChecklist[index] = !newChecklist[index];
      
      final allCompleted = newChecklist.every((completed) => completed);
      
      updateProgress(lessonId, currentProgress.copyWith(
        checklistStatus: newChecklist,
        isCompleted: allCompleted,
        completedAt: allCompleted ? DateTime.now() : null,
      ));
    }
  }

  static int getCompletedLessonsCount() {
    return _progressMap.values.where((progress) => progress.isCompleted).length;
  }

  static double getOverallProgress() {
    if (_cachedLessons == null || _cachedLessons!.isEmpty) return 0.0;
    return getCompletedLessonsCount() / _cachedLessons!.length;
  }
}
