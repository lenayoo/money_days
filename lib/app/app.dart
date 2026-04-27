import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';

import '../core/theme/app_theme.dart';
import '../features/settings/controllers/settings_controller.dart';
import 'app_shell.dart';

class MoneyDaysApp extends ConsumerWidget {
  const MoneyDaysApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
      theme: AppTheme.light(),
      locale: settings.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: const AppShell(),
    );
  }
}
