import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';
import 'package:money_days/core/utils/app_formatters.dart';
import 'package:money_days/features/expenses/models/app_currency.dart';
import 'package:money_days/features/expenses/models/expense.dart';
import 'package:money_days/features/expenses/models/expense_category.dart';
import 'package:money_days/features/expenses/repositories/expenses_repository.dart';
import 'package:money_days/features/expenses/screens/home_screen.dart';
import 'package:money_days/features/review/screens/monthly_review_screen.dart';
import 'package:money_days/features/settings/models/app_settings.dart';
import 'package:money_days/features/settings/repositories/settings_repository.dart';

void main() {
  testWidgets('renders saved expenses on Home and Monthly Review', (
    tester,
  ) async {
    final today = DateTime.now();
    final savedExpense = Expense(
      id: 'expense_saved',
      amount: 1200,
      category: ExpenseCategory.food,
      memo: 'Lunch',
      date: DateTime(today.year, today.month, today.day),
      currency: AppCurrency.jpy,
      createdAt: today,
      updatedAt: today,
    );

    final expensesRepository = InMemoryExpensesRepository();
    final settingsRepository = InMemorySettingsRepository();

    await expensesRepository.saveExpenses([savedExpense]);
    await settingsRepository.saveSettings(
      const AppSettings(currency: AppCurrency.jpy),
    );

    final formattedAmount = AppFormatters.formatCurrency(
      savedExpense.amount,
      savedExpense.currency,
      const Locale('en'),
    );

    await tester.pumpWidget(
      _buildTestApp(
        expensesRepository: expensesRepository,
        settingsRepository: settingsRepository,
        child: HomeScreen(onAddExpense: () {}),
      ),
    );
    await tester.pump();

    expect(find.text('Money Days'), findsOneWidget);
    expect(find.text(savedExpense.memo!), findsOneWidget);
    expect(find.text(formattedAmount), findsWidgets);

    await tester.pumpWidget(
      _buildTestApp(
        expensesRepository: expensesRepository,
        settingsRepository: settingsRepository,
        child: const MonthlyReviewScreen(),
      ),
    );
    await tester.pump();

    expect(find.text('Monthly review'), findsOneWidget);
    expect(find.text('Food'), findsWidgets);
    expect(find.text(formattedAmount), findsWidgets);
  });
}

Widget _buildTestApp({
  required ExpensesRepository expensesRepository,
  required SettingsRepository settingsRepository,
  required Widget child,
}) {
  return ProviderScope(
    overrides: [
      expensesRepositoryProvider.overrideWithValue(expensesRepository),
      settingsRepositoryProvider.overrideWithValue(settingsRepository),
    ],
    child: MaterialApp(
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: child,
    ),
  );
}
