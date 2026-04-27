import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/storage_keys.dart';
import '../models/expense.dart';
import '../models/expense_insights.dart';

abstract class ExpensesRepository {
  List<Expense> loadExpenses();

  Future<void> saveExpenses(List<Expense> expenses);
}

final expensesRepositoryProvider = Provider<ExpensesRepository>(
  (ref) => InMemoryExpensesRepository(),
);

class InMemoryExpensesRepository implements ExpensesRepository {
  List<Expense> _expenses = const [];

  @override
  List<Expense> loadExpenses() => ExpenseInsights.sorted(_expenses);

  @override
  Future<void> saveExpenses(List<Expense> expenses) async {
    _expenses = ExpenseInsights.sorted(expenses);
  }
}

class LocalExpensesRepository implements ExpensesRepository {
  LocalExpensesRepository(this._box);

  final Box<dynamic> _box;

  @override
  List<Expense> loadExpenses() {
    return ExpenseInsights.sorted(_readStoredExpenses());
  }

  @override
  Future<void> saveExpenses(List<Expense> expenses) {
    return _box.put(
      StorageKeys.expenses,
      expenses.map((expense) => expense.toMap()).toList(growable: false),
    );
  }

  List<Expense> _readStoredExpenses() {
    final rawExpenses = _box.get(
      StorageKeys.expenses,
      defaultValue: const <dynamic>[],
    );

    if (rawExpenses is! List) {
      return const [];
    }

    final expenses = <Expense>[];
    for (final rawExpense in rawExpenses) {
      if (rawExpense is! Map) {
        continue;
      }

      expenses.add(
        Expense.fromMap(
          rawExpense.map((key, value) => MapEntry(key.toString(), value)),
        ),
      );
    }

    return expenses;
  }
}
