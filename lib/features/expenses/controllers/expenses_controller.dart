import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_currency.dart';
import '../models/expense.dart';
import '../models/expense_category.dart';
import '../models/expense_insights.dart';
import '../models/payment_method.dart';
import '../models/transaction_type.dart';
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
    await addTransaction(
      type: TransactionType.expense,
      amount: amount,
      category: category,
      date: date,
      currency: currency,
      memo: memo,
    );
  }

  Future<void> addTransaction({
    required TransactionType type,
    required double amount,
    required ExpenseCategory category,
    required DateTime date,
    required AppCurrency currency,
    PaymentMethod? paymentMethod,
    String? memo,
  }) async {
    final expense = Expense.create(
      type: type,
      amount: amount,
      category: category,
      date: date,
      currency: currency,
      paymentMethod: paymentMethod,
      memo: memo,
    );

    final updatedExpenses = ExpenseInsights.sorted([...state, expense]);
    state = updatedExpenses;
    await _repository.saveExpenses(updatedExpenses);
  }
}
