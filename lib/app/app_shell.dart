import 'package:flutter/material.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';
import 'package:money_days/core/theme/app_colors.dart';

import '../features/expenses/screens/add_expense_screen.dart';
import '../features/expenses/screens/home_screen.dart';
import '../features/review/screens/monthly_review_screen.dart';
import '../features/settings/screens/settings_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  Future<void> _openAddExpenseScreen(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const AddExpenseScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final screens = <Widget>[
      HomeScreen(onAddExpense: () => _openAddExpenseScreen(context)),
      const MonthlyReviewScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(18, 0, 18, 16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.borderStrong),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 30,
                offset: Offset(0, 18),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home_rounded),
                  label: l10n.navigationHome,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.bar_chart_outlined),
                  selectedIcon: const Icon(Icons.bar_chart_rounded),
                  label: l10n.navigationReview,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.settings_outlined),
                  selectedIcon: const Icon(Icons.settings_rounded),
                  label: l10n.navigationSettings,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
