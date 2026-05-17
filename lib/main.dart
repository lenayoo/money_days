import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app.dart';
import 'core/constants/storage_keys.dart';
import 'features/ads/models/admob_ids.dart';
import 'features/budgets/repositories/monthly_budgets_repository.dart';
import 'features/expenses/repositories/expenses_repository.dart';
import 'features/settings/repositories/settings_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (AdMobIds.supportsMobileAds) {
    unawaited(MobileAds.instance.initialize());
  }
  await Hive.initFlutter();

  final appBox = await Hive.openBox<dynamic>(StorageKeys.appBox);

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
