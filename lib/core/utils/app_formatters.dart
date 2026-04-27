import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../features/expenses/models/app_currency.dart';

class AppFormatters {
  const AppFormatters._();

  static String formatCurrency(
    double amount,
    AppCurrency currency,
    Locale locale,
  ) {
    return NumberFormat.currency(
      locale: locale.toLanguageTag(),
      name: currency.code,
      symbol: currency.symbol,
      decimalDigits: currency.decimalDigits,
    ).format(amount);
  }

  static String formatShortDate(DateTime date, Locale locale) {
    return DateFormat.MMMd(locale.toLanguageTag()).format(date);
  }

  static String formatLongDate(DateTime date, Locale locale) {
    return DateFormat.yMMMd(locale.toLanguageTag()).format(date);
  }

  static String formatDateRange(DateTime start, DateTime end, Locale locale) {
    final languageTag = locale.toLanguageTag();
    final startText = DateFormat.MMMd(languageTag).format(start);
    final endText = DateFormat.MMMd(languageTag).format(end);
    return '$startText - $endText';
  }

  static String formatMonthLabel(DateTime date, Locale locale) {
    return DateFormat.yMMMM(locale.toLanguageTag()).format(date);
  }
}
