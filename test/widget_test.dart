import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';
import 'package:money_days/core/theme/app_theme.dart';
import 'package:money_days/core/utils/app_clock.dart';
import 'package:money_days/core/utils/app_date_utils.dart';
import 'package:money_days/core/utils/app_formatters.dart';
import 'package:money_days/features/budgets/models/monthly_budget.dart';
import 'package:money_days/features/budgets/repositories/monthly_budgets_repository.dart';
import 'package:money_days/features/expenses/models/app_currency.dart';
import 'package:money_days/features/expenses/models/expense.dart';
import 'package:money_days/features/expenses/models/expense_category.dart';
import 'package:money_days/features/expenses/models/payment_method.dart';
import 'package:money_days/features/expenses/models/transaction_type.dart';
import 'package:money_days/features/expenses/repositories/expenses_repository.dart';
import 'package:money_days/features/expenses/screens/home_screen.dart';
import 'package:money_days/features/review/screens/monthly_review_screen.dart';
import 'package:money_days/features/settings/models/app_language.dart';
import 'package:money_days/features/settings/models/app_settings.dart';
import 'package:money_days/features/settings/repositories/settings_repository.dart';
import 'package:money_days/features/settings/screens/settings_screen.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
    await initializeDateFormatting('ja');
    await initializeDateFormatting('ko');
  });

  tearDown(() {
    AppClock.testNow = null;
  });

  testWidgets('home screen shows month summary, calendar, and records', (
    tester,
  ) async {
    AppClock.testNow = DateTime(2026, 5, 3, 10);

    final mayDate = DateTime(2026, 5, 3);
    final expensesRepository = InMemoryExpensesRepository();
    final monthlyBudgetsRepository = InMemoryMonthlyBudgetsRepository();
    final settingsRepository = InMemorySettingsRepository();

    await expensesRepository.saveExpenses([
      Expense(
        id: 'expense_may',
        type: TransactionType.expense,
        amount: 1500,
        category: ExpenseCategory.food,
        memo: 'Lunch',
        date: mayDate,
        currency: AppCurrency.jpy,
        createdAt: mayDate,
        updatedAt: mayDate,
        paymentMethod: PaymentMethod.card,
      ),
      Expense(
        id: 'income_may',
        type: TransactionType.income,
        amount: 300,
        category: ExpenseCategory.salary,
        memo: 'Salary',
        date: DateTime(2026, 5, 1),
        currency: AppCurrency.usd,
        createdAt: DateTime(2026, 5, 1, 9),
        updatedAt: DateTime(2026, 5, 1, 9),
      ),
    ]);
    await monthlyBudgetsRepository.saveBudgets({
      AppDateUtils.monthKey(mayDate): MonthlyBudget(
        monthKey: AppDateUtils.monthKey(mayDate),
        amountInBaseCurrency: 200,
        createdAt: mayDate,
        updatedAt: mayDate,
      ),
    });
    await settingsRepository.saveSettings(
      const AppSettings(currency: AppCurrency.usd),
    );

    await tester.pumpWidget(
      _buildTestApp(
        expensesRepository: expensesRepository,
        monthlyBudgetsRepository: monthlyBudgetsRepository,
        settingsRepository: settingsRepository,
        child: HomeScreen(
          onAddTransaction: _noop,
          onOpenReview: _noop,
          onOpenSettings: _noop,
          onOpenDay: _noopDay,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('May'), findsOneWidget);
    expect(find.text('\$300.00'), findsWidgets);
    expect(find.text('\$10.00'), findsWidgets);
    expect(find.text('\$200.00'), findsOneWidget);
    expect(find.text('\$190.00'), findsOneWidget);
    expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
  });

  testWidgets('review screen switches months and updates records', (
    tester,
  ) async {
    AppClock.testNow = DateTime(2026, 5, 3, 10);

    final aprilDate = DateTime(2026, 4, 28);
    final mayDate = DateTime(2026, 5, 2);
    final expensesRepository = InMemoryExpensesRepository();
    final monthlyBudgetsRepository = InMemoryMonthlyBudgetsRepository();
    final settingsRepository = InMemorySettingsRepository();

    await expensesRepository.saveExpenses([
      Expense(
        id: 'expense_april',
        type: TransactionType.expense,
        amount: 3000,
        category: ExpenseCategory.food,
        memo: 'April lunch',
        date: aprilDate,
        currency: AppCurrency.jpy,
        createdAt: aprilDate,
        updatedAt: aprilDate,
      ),
      Expense(
        id: 'expense_may',
        type: TransactionType.expense,
        amount: 2400,
        category: ExpenseCategory.cafe,
        memo: 'May coffee',
        date: mayDate,
        currency: AppCurrency.jpy,
        createdAt: mayDate,
        updatedAt: mayDate,
      ),
    ]);
    await monthlyBudgetsRepository.saveBudgets({
      AppDateUtils.monthKey(aprilDate): MonthlyBudget(
        monthKey: AppDateUtils.monthKey(aprilDate),
        amountInBaseCurrency: AppCurrency.jpy.toBaseAmount(50000),
        createdAt: aprilDate,
        updatedAt: aprilDate,
        enteredAmount: 50000,
        enteredCurrency: AppCurrency.jpy,
      ),
    });
    await settingsRepository.saveSettings(
      const AppSettings(currency: AppCurrency.jpy),
    );

    final aprilLabel = AppFormatters.formatMonthLabel(
      aprilDate,
      const Locale('en'),
    );

    await tester.pumpWidget(
      _buildTestApp(
        expensesRepository: expensesRepository,
        monthlyBudgetsRepository: monthlyBudgetsRepository,
        settingsRepository: settingsRepository,
        child: const MonthlyReviewScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Monthly'), findsOneWidget);
    expect(find.text('Spending by category'), findsOneWidget);
    expect(find.text('¥2,400'), findsOneWidget);

    await tester.tap(find.text(AppFormatters.formatMonthLabel(mayDate, const Locale('en'))));
    await tester.pumpAndSettle();
    await tester.tap(find.text(aprilLabel).last);
    await tester.pumpAndSettle();

    expect(find.text('¥3,000'), findsOneWidget);
    expect(find.text('¥2,400'), findsNothing);
    expect(find.textContaining('¥47,000'), findsOneWidget);
  });

  testWidgets('settings stays localized for Japanese and Korean', (
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
    expect(find.text('通貨'), findsOneWidget);

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
      theme: AppTheme.light(),
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: child,
    ),
  );
}

void _noop() {}

void _noopDay(DateTime _) {}
