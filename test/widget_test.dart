import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';
import 'package:money_days/core/utils/app_date_utils.dart';
import 'package:money_days/core/utils/app_formatters.dart';
import 'package:money_days/features/budgets/models/monthly_budget.dart';
import 'package:money_days/features/budgets/repositories/monthly_budgets_repository.dart';
import 'package:money_days/features/expenses/models/app_currency.dart';
import 'package:money_days/features/expenses/models/expense.dart';
import 'package:money_days/features/expenses/models/expense_category.dart';
import 'package:money_days/features/expenses/repositories/expenses_repository.dart';
import 'package:money_days/features/expenses/screens/home_screen.dart';
import 'package:money_days/features/expenses/widgets/summary_card.dart';
import 'package:money_days/features/review/screens/monthly_review_screen.dart';
import 'package:money_days/features/settings/models/app_language.dart';
import 'package:money_days/features/settings/models/app_settings.dart';
import 'package:money_days/features/settings/repositories/settings_repository.dart';
import 'package:money_days/features/settings/screens/settings_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
    await initializeDateFormatting('ja');
    await initializeDateFormatting('ko');
  });

  testWidgets('renders converted totals, monthly budget, and month selection', (
    tester,
  ) async {
    final today = DateTime.now();
    final currentMonthExpense = Expense(
      id: 'expense_current',
      amount: 1500,
      category: ExpenseCategory.food,
      memo: 'Lunch',
      date: DateTime(today.year, today.month, today.day),
      currency: AppCurrency.jpy,
      createdAt: today,
      updatedAt: today,
    );
    final previousMonthDate = DateTime(today.year, today.month - 1, 12);
    final previousMonthExpense = Expense(
      id: 'expense_previous',
      amount: 3000,
      category: ExpenseCategory.transport,
      memo: 'Train pass',
      date: previousMonthDate,
      currency: AppCurrency.jpy,
      createdAt: previousMonthDate,
      updatedAt: previousMonthDate,
    );

    final expensesRepository = InMemoryExpensesRepository();
    final monthlyBudgetsRepository = InMemoryMonthlyBudgetsRepository();
    final settingsRepository = InMemorySettingsRepository();

    await expensesRepository.saveExpenses([
      currentMonthExpense,
      previousMonthExpense,
    ]);
    await monthlyBudgetsRepository.saveBudgets({
      AppDateUtils.monthKey(today): MonthlyBudget(
        monthKey: AppDateUtils.monthKey(today),
        amountInBaseCurrency: 200,
        createdAt: today,
        updatedAt: today,
      ),
      AppDateUtils.monthKey(previousMonthDate): MonthlyBudget(
        monthKey: AppDateUtils.monthKey(previousMonthDate),
        amountInBaseCurrency: 300,
        createdAt: previousMonthDate,
        updatedAt: previousMonthDate,
      ),
    });
    await settingsRepository.saveSettings(
      const AppSettings(currency: AppCurrency.usd),
    );

    final currentExpenseAmount = AppFormatters.formatCurrency(
      currentMonthExpense.amountForCurrency(AppCurrency.usd),
      AppCurrency.usd,
      const Locale('en'),
    );
    final currentBudgetAmount = AppFormatters.formatCurrency(
      AppCurrency.usd.fromBaseAmount(200),
      AppCurrency.usd,
      const Locale('en'),
    );
    final currentBudgetProgress = '5% of the budget used';
    final previousBudgetAmount = AppFormatters.formatCurrency(
      AppCurrency.usd.fromBaseAmount(300),
      AppCurrency.usd,
      const Locale('en'),
    );
    final previousMonthLabel = AppFormatters.formatMonthLabel(
      previousMonthDate,
      const Locale('en'),
    );

    await tester.pumpWidget(
      _buildTestApp(
        expensesRepository: expensesRepository,
        monthlyBudgetsRepository: monthlyBudgetsRepository,
        settingsRepository: settingsRepository,
        child: HomeScreen(onAddExpense: () {}),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Money Days'), findsOneWidget);
    expect(find.byType(SummaryCard), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text(currentBudgetAmount),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
    expect(find.text(currentBudgetAmount), findsOneWidget);
    expect(find.text(currentBudgetProgress), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text(currentMonthExpense.memo!),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
    expect(find.text(currentMonthExpense.memo!), findsOneWidget);
    expect(find.text(currentExpenseAmount), findsWidgets);

    await tester.pumpWidget(
      _buildTestApp(
        expensesRepository: expensesRepository,
        monthlyBudgetsRepository: monthlyBudgetsRepository,
        settingsRepository: settingsRepository,
        child: const MonthlyReviewScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Monthly review'), findsOneWidget);
    expect(find.text(currentBudgetAmount), findsOneWidget);

    await tester.tap(find.text('Select month'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(previousMonthLabel).last);
    await tester.pumpAndSettle();

    expect(find.text(previousBudgetAmount), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Train pass'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
    expect(find.text('Train pass'), findsOneWidget);
    expect(find.text('Lunch'), findsNothing);
  });

  testWidgets('renders localized settings copy for Japanese and Korean', (
    tester,
  ) async {
    final expensesRepository = InMemoryExpensesRepository();
    final monthlyBudgetsRepository = InMemoryMonthlyBudgetsRepository();
    final settingsRepository = InMemorySettingsRepository();

    await settingsRepository.saveSettings(
      const AppSettings(
        currency: AppCurrency.jpy,
        language: AppLanguage.japanese,
      ),
    );

    await tester.pumpWidget(
      _buildTestApp(
        locale: const Locale('ja'),
        expensesRepository: expensesRepository,
        monthlyBudgetsRepository: monthlyBudgetsRepository,
        settingsRepository: settingsRepository,
        child: const SettingsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('設定'), findsOneWidget);
    expect(find.text('言語'), findsOneWidget);
    expect(find.text('日本語'), findsWidgets);

    await settingsRepository.saveSettings(
      const AppSettings(
        currency: AppCurrency.krw,
        language: AppLanguage.korean,
      ),
    );

    await tester.pumpWidget(
      _buildTestApp(
        locale: const Locale('ko'),
        expensesRepository: expensesRepository,
        monthlyBudgetsRepository: monthlyBudgetsRepository,
        settingsRepository: settingsRepository,
        child: const SettingsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('설정'), findsOneWidget);
    expect(find.text('언어'), findsOneWidget);
    expect(find.text('통화'), findsOneWidget);
  });
}

Widget _buildTestApp({
  Locale locale = const Locale('en'),
  required ExpensesRepository expensesRepository,
  required MonthlyBudgetsRepository monthlyBudgetsRepository,
  required SettingsRepository settingsRepository,
  required Widget child,
}) {
  return ProviderScope(
    overrides: [
      expensesRepositoryProvider.overrideWithValue(expensesRepository),
      monthlyBudgetsRepositoryProvider.overrideWithValue(
        monthlyBudgetsRepository,
      ),
      settingsRepositoryProvider.overrideWithValue(settingsRepository),
    ],
    child: MaterialApp(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: child,
    ),
  );
}
