import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../models/lesson.dart';
import '../services/lesson_service.dart';

class LessonsPage extends StatefulWidget {
  const LessonsPage({super.key});

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  List<Lesson> lessons = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    final loadedLessons = await LessonService.loadLessons();
    setState(() {
      lessons = loadedLessons;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, l10n),
          const SizedBox(height: AppTheme.spacingXl),
          _buildProgressCard(context, l10n),
          const SizedBox(height: AppTheme.spacingXl),
          _buildLessonsGrid(context, l10n),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.lessonsTitle,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Text(
          l10n.lessonsSubtitle,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard(BuildContext context, AppLocalizations l10n) {
    final overallProgress = LessonService.getOverallProgress();
    final completedCount = LessonService.getCompletedLessonsCount();
    final totalCount = lessons.length;

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
                    color: AppTheme.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
                  ),
                  child: const HeroIcon(
                    HeroIcons.academicCap,
                    size: 24,
                    color: AppTheme.accentColor,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.lessonProgress,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$completedCount من $totalCount ${l10n.completedLessons}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${(overallProgress * 100).round()}%',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accentColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            LinearProgressIndicator(
              value: overallProgress,
              backgroundColor: AppTheme.borderColor,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
              minHeight: 8,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonsGrid(BuildContext context, AppLocalizations l10n) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1200 ? 3 : 
                              constraints.maxWidth > 800 ? 2 : 1;
        
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppTheme.spacingLg,
            mainAxisSpacing: AppTheme.spacingLg,
            childAspectRatio: 1.2,
          ),
          itemCount: lessons.length,
          itemBuilder: (context, index) {
            final lesson = lessons[index];
            final progress = LessonService.getProgress(lesson.id);
            return _buildLessonCard(context, lesson, progress, l10n);
          },
        );
      },
    );
  }

  Widget _buildLessonCard(
    BuildContext context,
    Lesson lesson,
    LessonProgress progress,
    AppLocalizations l10n,
  ) {
    final isCompleted = progress.isCompleted;
    final completedItems = progress.checklistStatus.where((item) => item).length;
    final totalItems = lesson.details.checklist.length;
    final progressPercentage = totalItems > 0 ? completedItems / totalItems : 0.0;

    return Card(
      child: InkWell(
        onTap: () => context.go('/lessons/${lesson.id}'),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
            boxShadow: AppTheme.cardShadow,
            border: isCompleted
                ? Border.all(color: AppTheme.successColor, width: 2)
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppTheme.successColor
                          : AppTheme.accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: isCompleted
                          ? const HeroIcon(
                              HeroIcons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : Text(
                              lesson.id.replaceAll('L', ''),
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppTheme.accentColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  if (isCompleted) ...[
                    const SizedBox(width: AppTheme.spacingSm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingSm,
                        vertical: AppTheme.spacingXs,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSm),
                      ),
                      child: Text(
                        l10n.lessonCompleted,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.successColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppTheme.spacingMd),
              Text(
                lesson.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppTheme.spacingSm),
              Text(
                lesson.goal,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              if (totalItems > 0) ...[
                const SizedBox(height: AppTheme.spacingMd),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: progressPercentage,
                        backgroundColor: AppTheme.borderColor,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isCompleted ? AppTheme.successColor : AppTheme.accentColor,
                        ),
                        minHeight: 4,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    Text(
                      '$completedItems/$totalItems',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppTheme.spacingMd),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/lessons/${lesson.id}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCompleted ? AppTheme.successColor : AppTheme.accentColor,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    isCompleted ? l10n.continueLesson : l10n.startLesson,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
