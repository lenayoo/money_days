import 'package:flutter/material.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';

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
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: NavigationBar(
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
    );
  }
}
