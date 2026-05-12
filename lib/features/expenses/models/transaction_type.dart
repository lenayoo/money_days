import 'package:money_days/core/localization/generated/app_localizations.dart';

enum TransactionType { expense, income }

extension TransactionTypeX on TransactionType {
  String label(AppLocalizations l10n) => switch (this) {
    TransactionType.expense => l10n.transactionTypeExpense,
    TransactionType.income => l10n.transactionTypeIncome,
  };

  bool get isExpense => this == TransactionType.expense;
  bool get isIncome => this == TransactionType.income;
}

TransactionType transactionTypeFromStorage(String? value) {
  return TransactionType.values.firstWhere(
    (type) => type.name == value,
    orElse: () => TransactionType.expense,
  );
}
