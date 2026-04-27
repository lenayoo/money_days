import 'package:flutter/material.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';

enum ExpenseCategory {
  food,
  cafe,
  transport,
  shopping,
  health,
  home,
  subscription,
  other,
}

extension ExpenseCategoryX on ExpenseCategory {
  IconData get icon => switch (this) {
    ExpenseCategory.food => Icons.restaurant_rounded,
    ExpenseCategory.cafe => Icons.local_cafe_rounded,
    ExpenseCategory.transport => Icons.train_rounded,
    ExpenseCategory.shopping => Icons.shopping_bag_rounded,
    ExpenseCategory.health => Icons.favorite_rounded,
    ExpenseCategory.home => Icons.home_rounded,
    ExpenseCategory.subscription => Icons.repeat_rounded,
    ExpenseCategory.other => Icons.more_horiz_rounded,
  };

  Color get color => switch (this) {
    ExpenseCategory.food => const Color(0xFFB97B59),
    ExpenseCategory.cafe => const Color(0xFF9C765F),
    ExpenseCategory.transport => const Color(0xFF6D8897),
    ExpenseCategory.shopping => const Color(0xFF8D6E93),
    ExpenseCategory.health => const Color(0xFFB56F73),
    ExpenseCategory.home => const Color(0xFF8A8163),
    ExpenseCategory.subscription => const Color(0xFF6D7B6B),
    ExpenseCategory.other => const Color(0xFF8A827B),
  };

  Color get surfaceColor => switch (this) {
    ExpenseCategory.food => const Color(0xFFF4E5DA),
    ExpenseCategory.cafe => const Color(0xFFF1E4DC),
    ExpenseCategory.transport => const Color(0xFFE3EDF1),
    ExpenseCategory.shopping => const Color(0xFFEEE4F1),
    ExpenseCategory.health => const Color(0xFFF4E2E4),
    ExpenseCategory.home => const Color(0xFFEFEBE0),
    ExpenseCategory.subscription => const Color(0xFFE5ECE4),
    ExpenseCategory.other => const Color(0xFFECE9E5),
  };

  String label(AppLocalizations l10n) => switch (this) {
    ExpenseCategory.food => l10n.categoryFood,
    ExpenseCategory.cafe => l10n.categoryCafe,
    ExpenseCategory.transport => l10n.categoryTransport,
    ExpenseCategory.shopping => l10n.categoryShopping,
    ExpenseCategory.health => l10n.categoryHealth,
    ExpenseCategory.home => l10n.categoryHome,
    ExpenseCategory.subscription => l10n.categorySubscription,
    ExpenseCategory.other => l10n.categoryOther,
  };
}

ExpenseCategory expenseCategoryFromStorage(String? value) {
  return ExpenseCategory.values.firstWhere(
    (category) => category.name == value,
    orElse: () => ExpenseCategory.other,
  );
}
