import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_days/core/utils/app_clock.dart';

import 'app/app.dart';
import 'core/constants/storage_keys.dart';
import 'features/budgets/repositories/monthly_budgets_repository.dart';
import 'features/expenses/repositories/expenses_repository.dart';
import 'features/settings/repositories/settings_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final appBox = await Hive.openBox<dynamic>(StorageKeys.appBox);

  AppClock.testNow = DateTime(2026, 5, 3);

  runApp(
    ProviderScope(
      overrides: [
        expensesRepositoryProvider.overrideWithValue(
          LocalExpensesRepository(appBox),
        ),
        monthlyBudgetsRepositoryProvider.overrideWithValue(
          LocalMonthlyBudgetsRepository(appBox),
        ),
        settingsRepositoryProvider.overrideWithValue(
          LocalSettingsRepository(appBox),
        ),
      ],
      child: const MoneyDaysApp(),
    ),
  );
}
