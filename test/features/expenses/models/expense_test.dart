import 'package:flutter_test/flutter_test.dart';
import 'package:money_days/features/expenses/models/app_currency.dart';
import 'package:money_days/features/expenses/models/expense.dart';
import 'package:money_days/features/expenses/models/expense_category.dart';

void main() {
  test('Expense round-trips all persisted fields', () {
    final createdAt = DateTime(2026, 4, 27, 9, 30);
    final updatedAt = DateTime(2026, 4, 27, 10, 15);
    final expense = Expense(
      id: 'expense_1',
      amount: 1280,
      category: ExpenseCategory.cafe,
      memo: 'Morning coffee',
      date: DateTime(2026, 4, 27),
      currency: AppCurrency.jpy,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );

    final restoredExpense = Expense.fromMap(expense.toMap());

    expect(restoredExpense.toMap(), expense.toMap());
  });

  test('Expense converts through the fixed base currency without mutation', () {
    final expense = Expense(
      id: 'expense_usd',
      amount: 12.5,
      category: ExpenseCategory.cafe,
      memo: 'Coffee beans',
      date: DateTime(2026, 4, 27),
      currency: AppCurrency.usd,
      createdAt: DateTime(2026, 4, 27, 9, 30),
      updatedAt: DateTime(2026, 4, 27, 9, 30),
    );

    expect(expense.amountInBaseCurrency, closeTo(1875, 0.0001));
    expect(expense.amountForCurrency(AppCurrency.jpy), closeTo(1875, 0.0001));
    expect(expense.amountForCurrency(AppCurrency.krw), closeTo(18750, 0.0001));
  });
}
