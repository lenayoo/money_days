import 'package:money_days/core/localization/generated/app_localizations.dart';

enum PaymentMethod { cash, card, bankTransfer, mobilePay, other }

extension PaymentMethodX on PaymentMethod {
  String label(AppLocalizations l10n) => switch (this) {
    PaymentMethod.cash => l10n.paymentMethodCash,
    PaymentMethod.card => l10n.paymentMethodCard,
    PaymentMethod.bankTransfer => l10n.paymentMethodBankTransfer,
    PaymentMethod.mobilePay => l10n.paymentMethodMobilePay,
    PaymentMethod.other => l10n.paymentMethodOther,
  };
}

PaymentMethod? paymentMethodFromStorage(String? value) {
  if (value == null) {
    return null;
  }

  for (final method in PaymentMethod.values) {
    if (method.name == value) {
      return method;
    }
  }

  return null;
}
