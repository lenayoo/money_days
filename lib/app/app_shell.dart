import 'package:flutter/material.dart';

import '../features/expenses/screens/add_transaction_screen.dart';
import '../features/expenses/screens/day_transactions_screen.dart';
import '../features/expenses/screens/home_screen.dart';
import '../features/review/screens/monthly_review_screen.dart';
import '../features/settings/screens/settings_screen.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  Future<void> _openAddTransactionScreen(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const AddTransactionScreen()),
    );
  }

  Future<void> _openReviewScreen(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const MonthlyReviewScreen()),
    );
  }

  Future<void> _openSettingsScreen(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
    );
  }

  Future<void> _openDayTransactionsScreen(
    BuildContext context,
    DateTime date,
  ) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => DayTransactionsScreen(date: date),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen(
      onAddTransaction: () => _openAddTransactionScreen(context),
      onOpenReview: () => _openReviewScreen(context),
      onOpenSettings: () => _openSettingsScreen(context),
      onOpenDay: (date) => _openDayTransactionsScreen(context, date),
    );
  }
}
