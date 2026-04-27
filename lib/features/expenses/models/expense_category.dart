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
