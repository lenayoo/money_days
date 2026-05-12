import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_days/features/expenses/models/app_currency.dart';
import 'package:money_days/features/expenses/models/expense.dart';
import 'package:money_days/features/expenses/models/expense_category.dart';
import 'package:money_days/features/expenses/models/transaction_type.dart';
import 'package:money_days/features/expenses/repositories/expenses_repository.dart';

void main() {
  late Directory tempDir;
  late Box<dynamic> box;
  const boxName = 'money_days_expenses_test_box';

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('money_days_expenses_');
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
    'LocalExpensesRepository reloads saved expenses after reopening Hive',
    () async {
      final repository = LocalExpensesRepository(box);
      final createdAt = DateTime(2026, 4, 27, 8, 45);
      final expense = Expense(
        id: 'expense_42',
        type: TransactionType.expense,
        amount: 2400,
        category: ExpenseCategory.food,
        memo: 'Lunch set',
        date: DateTime(2026, 4, 27),
        currency: AppCurrency.jpy,
        createdAt: createdAt,
        updatedAt: createdAt,
      );

      await repository.saveExpenses([expense]);

      await box.close();
      box = await Hive.openBox<dynamic>(boxName);

      final reloadedRepository = LocalExpensesRepository(box);
      final loadedExpenses = reloadedRepository.loadExpenses();

      expect(loadedExpenses, hasLength(1));
      expect(loadedExpenses.single.toMap(), expense.toMap());
    },
  );
}
