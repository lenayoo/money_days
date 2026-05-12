import 'package:flutter_test/flutter_test.dart';
import 'package:money_days/features/expenses/models/app_currency.dart';
import 'package:money_days/features/expenses/models/expense.dart';
import 'package:money_days/features/expenses/models/expense_category.dart';
import 'package:money_days/features/expenses/models/expense_insights.dart';
import 'package:money_days/features/expenses/models/transaction_type.dart';

void main() {
  test('dailyTotalsForMonth separates income and expense totals', () {
    final records = [
      Expense(
        id: 'expense_jpy',
        type: TransactionType.expense,
        amount: 300,
        category: ExpenseCategory.food,
        memo: null,
        date: DateTime(2026, 5, 2),
        currency: AppCurrency.jpy,
        createdAt: DateTime(2026, 5, 2, 8),
        updatedAt: DateTime(2026, 5, 2, 8),
      ),
      Expense(
        id: 'income_usd',
        type: TransactionType.income,
        amount: 3,
        category: ExpenseCategory.salary,
        memo: null,
        date: DateTime(2026, 5, 2),
        currency: AppCurrency.usd,
        createdAt: DateTime(2026, 5, 2, 9),
        updatedAt: DateTime(2026, 5, 2, 9),
      ),
      Expense(
        id: 'expense_krw',
        type: TransactionType.expense,
        amount: 1500,
        category: ExpenseCategory.cafe,
        memo: null,
        date: DateTime(2026, 5, 30),
        currency: AppCurrency.krw,
        createdAt: DateTime(2026, 5, 30, 12),
        updatedAt: DateTime(2026, 5, 30, 12),
      ),
    ];

    final totals = ExpenseInsights.dailyTotalsForMonth(
      records,
      DateTime(2026, 5, 1),
    );

    expect(totals, hasLength(31));
    expect(totals[1].date.day, 2);
    expect(totals[1].expenseForCurrency(AppCurrency.jpy), closeTo(300, 0.0001));
    expect(totals[1].incomeForCurrency(AppCurrency.usd), closeTo(3, 0.0001));
    expect(totals.last.date.day, 31);
    expect(totals[29].expenseForCurrency(AppCurrency.usd), closeTo(1, 0.0001));
  });

  test('category totals ignore income records', () {
    final records = [
      Expense(
        id: 'food',
        type: TransactionType.expense,
        amount: 1500,
        category: ExpenseCategory.food,
        memo: null,
        date: DateTime(2026, 4, 2),
        currency: AppCurrency.jpy,
        createdAt: DateTime(2026, 4, 2, 8),
        updatedAt: DateTime(2026, 4, 2, 8),
      ),
      Expense(
        id: 'cafe',
        type: TransactionType.expense,
        amount: 1500,
        category: ExpenseCategory.cafe,
        memo: null,
        date: DateTime(2026, 4, 3),
        currency: AppCurrency.jpy,
        createdAt: DateTime(2026, 4, 3, 8),
        updatedAt: DateTime(2026, 4, 3, 8),
      ),
      Expense(
        id: 'salary',
        type: TransactionType.income,
        amount: 100,
        category: ExpenseCategory.salary,
        memo: null,
        date: DateTime(2026, 4, 1),
        currency: AppCurrency.usd,
        createdAt: DateTime(2026, 4, 1, 8),
        updatedAt: DateTime(2026, 4, 1, 8),
      ),
    ];

    final breakdown = ExpenseInsights.categoryTotalsForMonth(
      records,
      DateTime(2026, 4, 1),
    );

    expect(breakdown, hasLength(2));
    expect(breakdown.first.share, closeTo(0.5, 0.0001));
    expect(breakdown.last.share, closeTo(0.5, 0.0001));
  });
}
