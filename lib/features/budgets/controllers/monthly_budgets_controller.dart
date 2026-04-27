import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/app_date_utils.dart';
import '../../expenses/models/app_currency.dart';
import '../models/monthly_budget.dart';
import '../repositories/monthly_budgets_repository.dart';

final monthlyBudgetsControllerProvider =
    NotifierProvider<MonthlyBudgetsController, Map<String, MonthlyBudget>>(
      MonthlyBudgetsController.new,
    );

class MonthlyBudgetsController extends Notifier<Map<String, MonthlyBudget>> {
  MonthlyBudgetsRepository get _repository =>
      ref.read(monthlyBudgetsRepositoryProvider);

  @override
  Map<String, MonthlyBudget> build() {
    return _repository.loadBudgets();
  }

  Future<void> setBudget({
    required DateTime month,
    required double amount,
    required AppCurrency currency,
  }) async {
    final monthKey = AppDateUtils.monthKey(month);
    final existingBudget = state[monthKey];
    final now = DateTime.now();

    final budget = MonthlyBudget(
      monthKey: monthKey,
      amountInBaseCurrency: currency.toBaseAmount(amount),
      createdAt: existingBudget?.createdAt ?? now,
      updatedAt: now,
    );

    final updatedBudgets = Map<String, MonthlyBudget>.unmodifiable({
      ...state,
      monthKey: budget,
    });

    state = updatedBudgets;
    await _repository.saveBudgets(updatedBudgets);
  }
}
