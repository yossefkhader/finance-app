import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_card.dart';

class CharityPage extends StatefulWidget {
  const CharityPage({super.key});

  @override
  State<CharityPage> createState() => _CharityPageState();
}

class _CharityPageState extends State<CharityPage> {
  String? _selectedCauseId;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Donation Summary Row
          _buildDonationSummary(),
          
          const SizedBox(height: AppTheme.spacingXl),
          
          // Causes and Impact Row
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 1024;
              
              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildCausesSection()),
                    const SizedBox(width: AppTheme.spacingXl),
                    Expanded(child: _buildImpactSummary()),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildCausesSection(),
                    const SizedBox(height: AppTheme.spacingXl),
                    _buildImpactSummary(),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDonationSummary() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 768;
        
        if (isWide) {
          return Row(
            children: [
              Expanded(child: _buildTotalDonatedCard()),
              const SizedBox(width: AppTheme.spacingLg),
              Expanded(child: _buildThisMonthCard()),
              const SizedBox(width: AppTheme.spacingLg),
              Expanded(child: _buildLastMonthCard()),
            ],
          );
        } else {
          return Column(
            children: [
              _buildTotalDonatedCard(),
              const SizedBox(height: AppTheme.spacingLg),
              Row(
                children: [
                  Expanded(child: _buildThisMonthCard()),
                  const SizedBox(width: AppTheme.spacingLg),
                  Expanded(child: _buildLastMonthCard()),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildTotalDonatedCard() {
    return StatCard(
      title: 'Total Donated',
      value: '\$1,247.83',
      subtitle: 'All time donations',
      icon: HeroIcons.heart,
      trend: TrendData(
        value: 15.7,
        isPositive: true,
        period: 'vs last year',
      ),
      isLarge: true,
    );
  }

  Widget _buildThisMonthCard() {
    return StatCard(
      title: 'This Month',
      value: '\$87.45',
      subtitle: 'Round-ups donated',
      icon: HeroIcons.arrowTrendingUp,
      sparklineData: [20, 25, 30, 35, 28, 42, 48],
    );
  }

  Widget _buildLastMonthCard() {
    return StatCard(
      title: 'Last Month',
      value: '\$92.30',
      subtitle: 'Round-ups donated',
      icon: HeroIcons.calendarDays,
    );
  }

  Widget _buildCausesSection() {
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
            Text(
              'Choose Your Cause',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            
            const SizedBox(height: AppTheme.spacingSm),
            
            Text(
              'Select a cause to support with your round-up donations',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            
            const SizedBox(height: AppTheme.spacingXl),
            
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
                crossAxisSpacing: AppTheme.spacingLg,
                mainAxisSpacing: AppTheme.spacingLg,
                childAspectRatio: 3.5,
              ),
              itemCount: _getCauses().length,
              itemBuilder: (context, index) {
                final cause = _getCauses()[index];
                return _buildCauseCard(cause);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCauseCard(Cause cause) {
    final isSelected = _selectedCauseId == cause.id;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCauseId = isSelected ? null : cause.id;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppTheme.accentColor.withOpacity(0.05)
              : AppTheme.backgroundColor,
          border: Border.all(
            color: isSelected 
                ? AppTheme.accentColor 
                : AppTheme.borderColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
        ),
        child: Row(
          children: [
            // Logo/Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: cause.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
              ),
              child: Center(
                child: HeroIcon(
                  cause.icon,
                  size: 24,
                  color: cause.color,
                ),
              ),
            ),
            
            const SizedBox(width: AppTheme.spacingMd),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    cause.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: isSelected ? AppTheme.accentColor : AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXs),
                  Text(
                    cause.description,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Selected indicator
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppTheme.accentColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: HeroIcon(
                    HeroIcons.check,
                    size: 16,
                    color: Colors.white,
                    style: HeroIconStyle.solid,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImpactSummary() {
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
            Text(
              'Your Impact',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            
            const SizedBox(height: AppTheme.spacingSm),
            
            Text(
              'See the real-world impact of your donations',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            
            const SizedBox(height: AppTheme.spacingXl),
            
            ...(_getImpactItems().map((item) => _buildImpactItem(item))),
            
            const SizedBox(height: AppTheme.spacingXl),
            
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
                border: Border.all(
                  color: AppTheme.accentColor.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  const HeroIcon(
                    HeroIcons.sparkles,
                    size: 20,
                    color: AppTheme.accentColor,
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                  Expanded(
                    child: Text(
                      'Every round-up counts! Your small changes make a big difference.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.accentColor,
                        fontWeight: FontWeight.w500,
                      ),
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

  Widget _buildImpactItem(ImpactItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingLg),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
            ),
            child: Center(
              child: HeroIcon(
                item.icon,
                size: 20,
                color: item.color,
              ),
            ),
          ),
          
          const SizedBox(width: AppTheme.spacingMd),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.value,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  item.description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Cause> _getCauses() {
    return [
      Cause(
        id: '1',
        name: 'Clean Water Access',
        description: 'Providing clean drinking water to communities in need',
        icon: HeroIcons.beaker,
        color: const Color(0xFF3B82F6),
      ),
      Cause(
        id: '2',
        name: 'Education for All',
        description: 'Supporting educational programs for underprivileged children',
        icon: HeroIcons.academicCap,
        color: const Color(0xFF8B5CF6),
      ),
      Cause(
        id: '3',
        name: 'Environmental Protection',
        description: 'Fighting climate change and protecting our planet',
        icon: HeroIcons.globeAlt,
        color: AppTheme.successColor,
      ),
      Cause(
        id: '4',
        name: 'Hunger Relief',
        description: 'Providing meals to families facing food insecurity',
        icon: HeroIcons.heart,
        color: const Color(0xFFEF4444),
      ),
      Cause(
        id: '5',
        name: 'Medical Research',
        description: 'Funding breakthrough medical research and treatments',
        icon: HeroIcons.sparkles,
        color: const Color(0xFFEC4899),
      ),
      Cause(
        id: '6',
        name: 'Disaster Relief',
        description: 'Emergency aid for communities affected by natural disasters',
        icon: HeroIcons.shieldCheck,
        color: const Color(0xFFF59E0B),
      ),
    ];
  }

  List<ImpactItem> _getImpactItems() {
    return [
      ImpactItem(
        value: '247',
        description: 'Meals provided to families in need',
        icon: HeroIcons.heart,
        color: AppTheme.errorColor,
      ),
      ImpactItem(
        value: '18',
        description: 'Children sponsored for school supplies',
        icon: HeroIcons.academicCap,
        color: const Color(0xFF8B5CF6),
      ),
      ImpactItem(
        value: '52',
        description: 'Trees planted for reforestation',
        icon: HeroIcons.globeAlt,
        color: AppTheme.successColor,
      ),
      ImpactItem(
        value: '8',
        description: 'Water filters installed in villages',
        icon: HeroIcons.beaker,
        color: const Color(0xFF3B82F6),
      ),
    ];
  }
}

class Cause {
  final String id;
  final String name;
  final String description;
  final HeroIcons icon;
  final Color color;

  Cause({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class ImpactItem {
  final String value;
  final String description;
  final HeroIcons icon;
  final Color color;

  ImpactItem({
    required this.value,
    required this.description,
    required this.icon,
    required this.color,
  });
}
