import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'theme/app_theme.dart';
import 'widgets/sidebar_navigation.dart';
import 'widgets/add_expense_modal.dart';
import 'l10n/app_localizations.dart';

class AppShell extends StatefulWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _isSidebarCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;
    
    // Auto-collapse sidebar on smaller screens
    if (!isDesktop && !_isSidebarCollapsed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _isSidebarCollapsed = true;
        });
      });
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Row(
        children: [
          // Sidebar Navigation
          if (isDesktop || isTablet)
            SidebarNavigation(
              isCollapsed: _isSidebarCollapsed,
              onToggleCollapsed: () {
                setState(() {
                  _isSidebarCollapsed = !_isSidebarCollapsed;
                });
              },
            ),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top Header Bar
                _buildTopHeader(context),
                
                // Page Content
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppTheme.spacingLg),
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      
      // Mobile drawer
      drawer: !isDesktop && !isTablet
          ? _buildMobileDrawer(context)
          : null,
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.path;
    final pageTitle = _getPageTitle(context, currentRoute);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.borderColor,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
        child: Row(
          children: [
            // Menu button for mobile/tablet
            if (MediaQuery.of(context).size.width < 1024)
              IconButton(
                icon: const HeroIcon(HeroIcons.bars3),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                color: AppTheme.textSecondary,
              ),
            
            if (MediaQuery.of(context).size.width < 1024)
              const SizedBox(width: AppTheme.spacingMd),

            // Page Title
            Expanded(
              child: Text(
                pageTitle,
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
            ),

            // Quick Actions
            if (currentRoute == '/dashboard' || currentRoute == '/budget')
              ElevatedButton.icon(
                onPressed: () => context.go('/ai-chat'),
                icon: const HeroIcon(
                  HeroIcons.plus,
                  size: 16,
                  style: HeroIconStyle.solid,
                ),
                label: Text(l10n.addExpense),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.cardColor,
      child: SidebarNavigation(
        isCollapsed: false,
        onToggleCollapsed: () {},
        isMobile: true,
      ),
    );
  }

  String _getPageTitle(BuildContext context, String route) {
    final l10n = AppLocalizations.of(context)!;
    switch (route) {
      case '/dashboard':
        return l10n.dashboard;
      case '/budget':
        return l10n.budgetExpenses;
      case '/savings':
        return l10n.savings;
      case '/charity':
        return l10n.charityImpact;
      case '/profile':
        return l10n.profileSettings;
      case '/ai-chat':
        return 'المساعد الذكي';
      case '/lessons':
        return l10n.lessons;
      default:
        if (route.startsWith('/lessons/')) {
          return l10n.lessons;
        }
        return l10n.appName;
    }
  }

  void _showAddExpenseModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddExpenseModal(),
    );
  }
}
