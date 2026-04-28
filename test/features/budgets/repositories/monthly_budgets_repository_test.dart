import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_days/core/constants/storage_keys.dart';
import 'package:money_days/features/expenses/models/app_currency.dart';
import 'package:money_days/features/budgets/models/monthly_budget.dart';
import 'package:money_days/features/budgets/repositories/monthly_budgets_repository.dart';

void main() {
  late Directory tempDir;
  late Box<dynamic> box;
  const boxName = 'money_days_budgets_test_box';

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('money_days_budgets_');
    Hive.init(tempDir.path);
    box = await Hive.openBox<dynamic>(boxName);
  });

  tearDown(() async {
    await box.close();
    await Hive.deleteBoxFromDisk(boxName);
    await Hive.close();

    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test(
    'LocalMonthlyBudgetsRepository reloads saved budgets after reopening Hive',
    () async {
      final repository = LocalMonthlyBudgetsRepository(box);
      final createdAt = DateTime(2026, 4, 1, 8, 45);
      final budget = MonthlyBudget(
        monthKey: '2026-04',
        amountInBaseCurrency: AppCurrency.krw.toBaseAmount(12000000),
        createdAt: createdAt,
        updatedAt: createdAt,
        enteredAmount: 12000000,
        enteredCurrency: AppCurrency.krw,
      );

      await repository.saveBudgets({'2026-04': budget});

      await box.close();
      box = await Hive.openBox<dynamic>(boxName);

      final reloadedRepository = LocalMonthlyBudgetsRepository(box);
      final loadedBudget = reloadedRepository.loadBudgets()['2026-04'];

      expect(loadedBudget, isNotNull);
      expect(loadedBudget!.toMap(), budget.toMap());
    },
  );

  test(
    'LocalMonthlyBudgetsRepository migrates legacy JPY-base budgets on load',
    () async {
      await box.put(StorageKeys.monthlyBudgets, {
        '2026-04': {
          'monthKey': '2026-04',
          'amountInBaseCurrency': 30000.0,
          'createdAt': DateTime(2026, 4, 1, 8, 45).toIso8601String(),
          'updatedAt': DateTime(2026, 4, 1, 8, 45).toIso8601String(),
        },
      });

      final repository = LocalMonthlyBudgetsRepository(box);
      final loadedBudget = repository.loadBudgets()['2026-04'];

      expect(loadedBudget, isNotNull);
      expect(
        loadedBudget!.amountInBaseCurrency,
        closeTo(AppCurrency.jpy.toBaseAmount(30000), 0.0001),
      );
      expect(
        loadedBudget.amountForCurrency(AppCurrency.jpy),
        closeTo(30000, 0.0001),
      );
    },
  );

  test(
    'MonthlyBudget prefers the original entered amount and currency when present',
    () {
      final budget = MonthlyBudget.fromMap({
        'monthKey': '2026-04',
        'amountInBaseCurrency': 99999.0,
        'baseCurrency': 'usd',
        'enteredAmount': 50000.0,
        'enteredCurrency': AppCurrency.jpy.name,
        'createdAt': DateTime(2026, 4, 1, 8, 45).toIso8601String(),
        'updatedAt': DateTime(2026, 4, 1, 8, 45).toIso8601String(),
      });

      expect(
        budget.amountInBaseCurrency,
        closeTo(AppCurrency.jpy.toBaseAmount(50000), 0.0001),
      );
      expect(budget.amountForCurrency(AppCurrency.sgd), closeTo(450, 0.0001));
    },
  );
}
