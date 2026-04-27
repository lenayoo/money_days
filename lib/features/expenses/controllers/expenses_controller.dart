import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_currency.dart';
import '../models/expense.dart';
import '../models/expense_category.dart';
import '../models/expense_insights.dart';
import '../repositories/expenses_repository.dart';

final expensesControllerProvider =
    NotifierProvider<ExpensesController, List<Expense>>(ExpensesController.new);

class ExpensesController extends Notifier<List<Expense>> {
  ExpensesRepository get _repository => ref.read(expensesRepositoryProvider);

  @override
  List<Expense> build() {
    return ExpenseInsights.sorted(_repository.loadExpenses());
  }

  Future<void> addExpense({
    required double amount,
    required ExpenseCategory category,
    required DateTime date,
    required AppCurrency currency,
    String? memo,
  }) async {
    final expense = Expense.create(
      amount: amount,
      category: category,
      date: date,
      currency: currency,
      memo: memo,
    );

    final updatedExpenses = ExpenseInsights.sorted([...state, expense]);
    state = updatedExpenses;
    await _repository.saveExpenses(updatedExpenses);
  }

  Future<void> updateCurrency(AppCurrency currency) async {
    final now = DateTime.now();
    final updatedExpenses = ExpenseInsights.sorted([
      for (final expense in state)
        expense.copyWith(currency: currency, updatedAt: now),
    ]);

    state = updatedExpenses;
    await _repository.saveExpenses(updatedExpenses);
  }
}
