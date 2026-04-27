import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/storage_keys.dart';
import '../models/monthly_budget.dart';

abstract class MonthlyBudgetsRepository {
  Map<String, MonthlyBudget> loadBudgets();

  Future<void> saveBudgets(Map<String, MonthlyBudget> budgets);
}

final monthlyBudgetsRepositoryProvider = Provider<MonthlyBudgetsRepository>(
  (ref) => InMemoryMonthlyBudgetsRepository(),
);

class InMemoryMonthlyBudgetsRepository implements MonthlyBudgetsRepository {
  Map<String, MonthlyBudget> _budgets = const {};

  @override
  Map<String, MonthlyBudget> loadBudgets() => _budgets;

  @override
  Future<void> saveBudgets(Map<String, MonthlyBudget> budgets) async {
    _budgets = Map<String, MonthlyBudget>.unmodifiable(budgets);
  }
}

class LocalMonthlyBudgetsRepository implements MonthlyBudgetsRepository {
  LocalMonthlyBudgetsRepository(this._box);

  final Box<dynamic> _box;

  @override
  Map<String, MonthlyBudget> loadBudgets() {
    final rawBudgets = _box.get(
      StorageKeys.monthlyBudgets,
      defaultValue: const <String, dynamic>{},
    );

    if (rawBudgets is! Map) {
      return const {};
    }

    final budgets = <String, MonthlyBudget>{};
    for (final entry in rawBudgets.entries) {
      final monthKey = entry.key.toString();
      final rawBudget = entry.value;
      if (rawBudget is! Map) {
        continue;
      }

      final budgetMap = rawBudget.map(
        (key, value) => MapEntry(key.toString(), value),
      );
      budgetMap.putIfAbsent('monthKey', () => monthKey);
      budgets[monthKey] = MonthlyBudget.fromMap(budgetMap);
    }

    return Map<String, MonthlyBudget>.unmodifiable(budgets);
  }

  @override
  Future<void> saveBudgets(Map<String, MonthlyBudget> budgets) {
    return _box.put(StorageKeys.monthlyBudgets, {
      for (final entry in budgets.entries) entry.key: entry.value.toMap(),
    });
  }
}
