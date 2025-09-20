import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../models/lesson.dart';
import '../services/lesson_service.dart';

class LessonDetailPage extends StatefulWidget {
  final String lessonId;

  const LessonDetailPage({
    super.key,
    required this.lessonId,
  });

  @override
  State<LessonDetailPage> createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage> {
  Lesson? lesson;
  LessonProgress? progress;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLessonData();
  }

  Future<void> _loadLessonData() async {
    await LessonService.loadLessons();
    final loadedLesson = LessonService.getLessonById(widget.lessonId);
    final loadedProgress = LessonService.getProgress(widget.lessonId);

    setState(() {
      lesson = loadedLesson;
      progress = loadedProgress;
      isLoading = false;
    });
  }

  void _toggleChecklistItem(int index) {
    LessonService.toggleChecklistItem(widget.lessonId, index);
    setState(() {
      progress = LessonService.getProgress(widget.lessonId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (lesson == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.lessons),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const HeroIcon(
                HeroIcons.exclamationTriangle,
                size: 64,
                color: AppTheme.textSecondary,
              ),
              const SizedBox(height: AppTheme.spacingMd),
              Text(
                l10n.somethingWentWrong,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppTheme.spacingMd),
              ElevatedButton(
                onPressed: () => context.go('/lessons'),
                child: Text(l10n.backToLessons),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, l10n),
          SliverPadding(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildProgressCard(context, l10n),
                const SizedBox(height: AppTheme.spacingXl),
                _buildGoalCard(context, l10n),
                const SizedBox(height: AppTheme.spacingXl),
                _buildIntroductionCard(context, l10n),
                const SizedBox(height: AppTheme.spacingXl),
                _buildWhyCard(context, l10n),
                const SizedBox(height: AppTheme.spacingXl),
                _buildStepsCard(context, l10n),
                const SizedBox(height: AppTheme.spacingXl),
                _buildExampleCard(context, l10n),
                const SizedBox(height: AppTheme.spacingXl),
                _buildTipsCard(context, l10n),
                const SizedBox(height: AppTheme.spacingXl),
                _buildHomeworkCard(context, l10n),
                const SizedBox(height: AppTheme.spacingXl),
                _buildChecklistCard(context, l10n),
                const SizedBox(height: AppTheme.spacingXl),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AppLocalizations l10n) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: AppTheme.cardColor,
      foregroundColor: AppTheme.textPrimary,
      leading: IconButton(
        icon: const HeroIcon(HeroIcons.arrowRight),
        onPressed: () => context.go('/lessons'),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          lesson!.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        titlePadding: const EdgeInsets.only(
          right: AppTheme.spacingLg,
          bottom: AppTheme.spacingMd,
        ),
      ),
      actions: [
        if (progress!.isCompleted)
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingMd,
              vertical: AppTheme.spacingSm,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingSm,
              vertical: AppTheme.spacingXs,
            ),
            decoration: BoxDecoration(
              color: AppTheme.successColor,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusSm),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const HeroIcon(
                  HeroIcons.check,
                  size: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: AppTheme.spacingXs),
                Text(
                  l10n.lessonCompleted,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildProgressCard(BuildContext context, AppLocalizations l10n) {
    final completedItems = progress!.checklistStatus.where((item) => item).length;
    final totalItems = lesson!.details.checklist.length;
    final progressPercentage = totalItems > 0 ? completedItems / totalItems : 0.0;

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
                    HeroIcons.chartBarSquare,
                    size: 20,
                    color: AppTheme.accentColor,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: Text(
                    l10n.lessonProgress,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '${(progressPercentage * 100).round()}%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accentColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            LinearProgressIndicator(
              value: progressPercentage,
              backgroundColor: AppTheme.borderColor,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
              minHeight: 8,
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              '$completedItems من $totalItems مهام مكتملة',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard(BuildContext context, AppLocalizations l10n) {
    return _buildSectionCard(
      context,
      title: l10n.lessonGoal,
      icon: HeroIcons.flag,
      content: lesson!.goal,
      color: AppTheme.accentColor,
    );
  }

  Widget _buildIntroductionCard(BuildContext context, AppLocalizations l10n) {
    return _buildSectionCard(
      context,
      title: l10n.introduction,
      icon: HeroIcons.informationCircle,
      content: lesson!.details.introduction,
      color: const Color(0xFF3B82F6),
    );
  }

  Widget _buildWhyCard(BuildContext context, AppLocalizations l10n) {
    return _buildSectionCard(
      context,
      title: l10n.whyImportant,
      icon: HeroIcons.lightBulb,
      content: lesson!.details.why,
      color: const Color(0xFFF59E0B),
    );
  }

  Widget _buildStepsCard(BuildContext context, AppLocalizations l10n) {
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
                    color: const Color(0xFF8B5CF6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
                  ),
                  child: const HeroIcon(
                    HeroIcons.listBullet,
                    size: 20,
                    color: Color(0xFF8B5CF6),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Text(
                  l10n.steps,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            ...lesson!.details.steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingMd),
                    Expanded(
                      child: Text(
                        step,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleCard(BuildContext context, AppLocalizations l10n) {
    return _buildSectionCard(
      context,
      title: l10n.example,
      icon: HeroIcons.lightBulb,
      content: lesson!.details.example,
      color: const Color(0xFF10B981),
      backgroundColor: const Color(0xFF10B981).withOpacity(0.05),
    );
  }

  Widget _buildTipsCard(BuildContext context, AppLocalizations l10n) {
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
                    color: const Color(0xFFEC4899).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
                  ),
                  child: const HeroIcon(
                    HeroIcons.sparkles,
                    size: 20,
                    color: Color(0xFFEC4899),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Text(
                  l10n.tips,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            ...lesson!.details.tips.map((tip) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: HeroIcon(
                        HeroIcons.checkCircle,
                        size: 16,
                        color: Color(0xFFEC4899),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    Expanded(
                      child: Text(
                        tip,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeworkCard(BuildContext context, AppLocalizations l10n) {
    return _buildSectionCard(
      context,
      title: l10n.homework,
      icon: HeroIcons.pencilSquare,
      content: lesson!.details.homework,
      color: const Color(0xFFEF4444),
    );
  }

  Widget _buildChecklistCard(BuildContext context, AppLocalizations l10n) {
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
                    color: AppTheme.successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
                  ),
                  child: const HeroIcon(
                    HeroIcons.checkBadge,
                    size: 20,
                    color: AppTheme.successColor,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Text(
                  l10n.checklist,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            ...lesson!.details.checklist.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isCompleted = index < progress!.checklistStatus.length && 
                                 progress!.checklistStatus[index];
              
              return Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
                child: InkWell(
                  onTap: () => _toggleChecklistItem(index),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
                  child: Container(
                    padding: const EdgeInsets.all(AppTheme.spacingMd),
                    decoration: BoxDecoration(
                      color: isCompleted 
                          ? AppTheme.successColor.withOpacity(0.1)
                          : AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
                      border: Border.all(
                        color: isCompleted 
                            ? AppTheme.successColor
                            : AppTheme.borderColor,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: isCompleted 
                                ? AppTheme.successColor
                                : Colors.transparent,
                            border: Border.all(
                              color: isCompleted 
                                  ? AppTheme.successColor
                                  : AppTheme.borderColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: isCompleted
                              ? const Center(
                                  child: HeroIcon(
                                    HeroIcons.check,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: AppTheme.spacingMd),
                        Expanded(
                          child: Text(
                            item,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              decoration: isCompleted ? TextDecoration.lineThrough : null,
                              color: isCompleted 
                                  ? AppTheme.textSecondary
                                  : AppTheme.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required HeroIcons icon,
    required String content,
    required Color color,
    Color? backgroundColor,
  }) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppTheme.cardColor,
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
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
                  ),
                  child: HeroIcon(
                    icon,
                    size: 20,
                    color: color,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
