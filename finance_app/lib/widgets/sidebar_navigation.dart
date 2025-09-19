import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class SidebarNavigation extends StatelessWidget {
  final bool isCollapsed;
  final VoidCallback onToggleCollapsed;
  final bool isMobile;

  const SidebarNavigation({
    super.key,
    required this.isCollapsed,
    required this.onToggleCollapsed,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.path;
    final width = isCollapsed ? 72.0 : 256.0;
    final l10n = AppLocalizations.of(context)!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        border: Border(
          right: BorderSide(
            color: AppTheme.borderColor,
            width: 1,
          ),
        ),
        boxShadow: isMobile ? [] : AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo and Toggle
          _buildHeader(context),
          
          const SizedBox(height: AppTheme.spacingLg),
          
          // Navigation Items
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isCollapsed ? AppTheme.spacingSm : AppTheme.spacingMd,
              ),
              child: Column(
                children: [
                  _buildNavItem(
                    context,
                    icon: HeroIcons.home,
                    label: l10n.dashboard,
                    route: '/dashboard',
                    isActive: currentRoute == '/dashboard',
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  _buildNavItem(
                    context,
                    icon: HeroIcons.wallet,
                    label: l10n.budgetExpenses,
                    route: '/budget',
                    isActive: currentRoute == '/budget',
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  _buildNavItem(
                    context,
                    icon: HeroIcons.arrowTrendingUp,
                    label: l10n.savings,
                    route: '/savings',
                    isActive: currentRoute == '/savings',
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  _buildNavItem(
                    context,
                    icon: HeroIcons.heart,
                    label: l10n.charityImpact,
                    route: '/charity',
                    isActive: currentRoute == '/charity',
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  _buildNavItem(
                    context,
                    icon: HeroIcons.user,
                    label: l10n.profileSettings,
                    route: '/profile',
                    isActive: currentRoute == '/profile',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(
        horizontal: isCollapsed ? AppTheme.spacingSm : AppTheme.spacingMd,
        vertical: AppTheme.spacingMd,
      ),
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
          // Logo
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.accentColor,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
            ),
            child: const Center(
              child: Text(
                'M',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          
          if (!isCollapsed) ...[
            const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Text(
                  l10n.appName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
          ],
          
          // Toggle button (only show on desktop)
          if (!isMobile)
            IconButton(
              onPressed: onToggleCollapsed,
              icon: HeroIcon(
                isCollapsed ? HeroIcons.chevronLeft : HeroIcons.chevronRight,
                size: 16,
              ),
              iconSize: 16,
              constraints: const BoxConstraints(
                minWidth: 24,
                minHeight: 24,
              ),
              padding: EdgeInsets.zero,
              color: AppTheme.textSecondary,
            ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required HeroIcons icon,
    required String label,
    required String route,
    required bool isActive,
  }) {
    return Semantics(
      label: label,
      button: true,
      child: InkWell(
        onTap: () {
          context.go(route);
          // Close drawer on mobile after navigation
          if (isMobile) {
            Navigator.of(context).pop();
          }
        },
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
        child: Container(
          height: 44,
          padding: EdgeInsets.symmetric(
            horizontal: isCollapsed ? 0 : AppTheme.spacingMd,
            vertical: AppTheme.spacingSm,
          ),
          decoration: BoxDecoration(
            color: isActive ? AppTheme.accentColor.withOpacity(0.1) : null,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                child: HeroIcon(
                  icon,
                  size: 20,
                  style: isActive ? HeroIconStyle.solid : HeroIconStyle.outline,
                  color: isActive ? AppTheme.accentColor : AppTheme.textSecondary,
                ),
              ),
              
              if (!isCollapsed) ...[
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: isActive ? AppTheme.accentColor : AppTheme.textPrimary,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
