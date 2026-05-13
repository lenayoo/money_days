import 'package:flutter/material.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';

import 'transaction_type.dart';

enum ExpenseCategory {
  food,
  cafe,
  transport,
  shopping,
  health,
  home,
  subscription,
  salary,
  bonus,
  gift,
  refund,
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
    ExpenseCategory.salary => Icons.account_balance_wallet_rounded,
    ExpenseCategory.bonus => Icons.auto_awesome_rounded,
    ExpenseCategory.gift => Icons.card_giftcard_rounded,
    ExpenseCategory.refund => Icons.undo_rounded,
    ExpenseCategory.other => Icons.more_horiz_rounded,
  };

  Color get color => switch (this) {
    ExpenseCategory.food => const Color(0xFF7E746B),
    ExpenseCategory.cafe => const Color(0xFF7B706D),
    ExpenseCategory.transport => const Color(0xFF6F7C86),
    ExpenseCategory.shopping => const Color(0xFF7B7680),
    ExpenseCategory.health => const Color(0xFF87747A),
    ExpenseCategory.home => const Color(0xFF7A7871),
    ExpenseCategory.subscription => const Color(0xFF707C76),
    ExpenseCategory.salary => const Color(0xFF6E8572),
    ExpenseCategory.bonus => const Color(0xFF7C8668),
    ExpenseCategory.gift => const Color(0xFF73858C),
    ExpenseCategory.refund => const Color(0xFF6D877D),
    ExpenseCategory.other => const Color(0xFF88888C),
  };

  Color get chartColor => switch (this) {
    ExpenseCategory.food => const Color(0xFFF3B7A2),
    ExpenseCategory.cafe => const Color(0xFFE8C6AE),
    ExpenseCategory.transport => const Color(0xFFBFD9F6),
    ExpenseCategory.shopping => const Color(0xFFD6C5F4),
    ExpenseCategory.health => const Color(0xFFF1B7C9),
    ExpenseCategory.home => const Color(0xFFCDE3C4),
    ExpenseCategory.subscription => const Color(0xFFBDE5D8),
    ExpenseCategory.salary => const Color(0xFFBFE5C2),
    ExpenseCategory.bonus => const Color(0xFFF1DF9F),
    ExpenseCategory.gift => const Color(0xFFC7E7EC),
    ExpenseCategory.refund => const Color(0xFFBEE4D7),
    ExpenseCategory.other => const Color(0xFFD8DFEB),
  };

  Color get surfaceColor => switch (this) {
    ExpenseCategory.food => const Color(0xFFF3F0ED),
    ExpenseCategory.cafe => const Color(0xFFF3F0EF),
    ExpenseCategory.transport => const Color(0xFFEEF2F4),
    ExpenseCategory.shopping => const Color(0xFFF1EFF3),
    ExpenseCategory.health => const Color(0xFFF4EFF1),
    ExpenseCategory.home => const Color(0xFFF3F2EF),
    ExpenseCategory.subscription => const Color(0xFFEEF3F0),
    ExpenseCategory.salary => const Color(0xFFF2F6F1),
    ExpenseCategory.bonus => const Color(0xFFF5F6EE),
    ExpenseCategory.gift => const Color(0xFFF0F5F6),
    ExpenseCategory.refund => const Color(0xFFF0F6F4),
    ExpenseCategory.other => const Color(0xFFF4F4F5),
  };

  String label(AppLocalizations l10n) => switch (this) {
    ExpenseCategory.food => l10n.categoryFood,
    ExpenseCategory.cafe => l10n.categoryCafe,
    ExpenseCategory.transport => l10n.categoryTransport,
    ExpenseCategory.shopping => l10n.categoryShopping,
    ExpenseCategory.health => l10n.categoryHealth,
    ExpenseCategory.home => l10n.categoryHome,
    ExpenseCategory.subscription => l10n.categorySubscription,
    ExpenseCategory.salary => l10n.categorySalary,
    ExpenseCategory.bonus => l10n.categoryBonus,
    ExpenseCategory.gift => l10n.categoryGift,
    ExpenseCategory.refund => l10n.categoryRefund,
    ExpenseCategory.other => l10n.categoryOther,
  };

  bool supportsType(TransactionType type) => switch (type) {
    TransactionType.expense => switch (this) {
      ExpenseCategory.food ||
      ExpenseCategory.cafe ||
      ExpenseCategory.transport ||
      ExpenseCategory.shopping ||
      ExpenseCategory.health ||
      ExpenseCategory.home ||
      ExpenseCategory.subscription ||
      ExpenseCategory.other => true,
      ExpenseCategory.salary ||
      ExpenseCategory.bonus ||
      ExpenseCategory.gift ||
      ExpenseCategory.refund => false,
    },
    TransactionType.income => switch (this) {
      ExpenseCategory.salary ||
      ExpenseCategory.bonus ||
      ExpenseCategory.gift ||
      ExpenseCategory.refund ||
      ExpenseCategory.other => true,
      ExpenseCategory.food ||
      ExpenseCategory.cafe ||
      ExpenseCategory.transport ||
      ExpenseCategory.shopping ||
      ExpenseCategory.health ||
      ExpenseCategory.home ||
      ExpenseCategory.subscription => false,
    },
  };
}

ExpenseCategory expenseCategoryFromStorage(String? value) {
  return ExpenseCategory.values.firstWhere(
    (category) => category.name == value,
    orElse: () => ExpenseCategory.other,
  );
}

List<ExpenseCategory> expenseCategoriesForType(TransactionType type) {
  return [
    for (final category in ExpenseCategory.values)
      if (category.supportsType(type)) category,
  ];
}
