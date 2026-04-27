import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
        amountInBaseCurrency: 80000,
        createdAt: createdAt,
        updatedAt: createdAt,
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
}
