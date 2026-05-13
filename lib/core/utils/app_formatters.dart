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

  static String formatMonthLabel(DateTime date, Locale locale) {
    return DateFormat.yMMMM(locale.toLanguageTag()).format(date);
  }

  static String formatMonthOnlyLabel(DateTime date, Locale locale) {
    return DateFormat.MMMM(locale.toLanguageTag()).format(date);
  }

  static String formatCompactCurrency(
    double amount,
    AppCurrency currency,
    Locale locale,
  ) {
    final compactNumber = NumberFormat.compact(
      locale: locale.toLanguageTag(),
    ).format(amount);
    return '${currency.symbol}$compactNumber';
  }

  static String formatCompactAmount(double amount, Locale locale) {
    return NumberFormat.compact(
      locale: locale.toLanguageTag(),
    ).format(amount.abs());
  }

  static String formatSignedAmountWithoutSymbol(
    double amount,
    AppCurrency currency,
    Locale locale, {
    required bool isIncome,
  }) {
    final prefix = isIncome ? '+' : '-';
    final formatted = NumberFormat.decimalPatternDigits(
      locale: locale.toLanguageTag(),
      decimalDigits: currency.decimalDigits,
    ).format(amount.abs());
    return '$prefix$formatted';
  }

  static String formatSignedCurrency(
    double amount,
    AppCurrency currency,
    Locale locale, {
    required bool isIncome,
  }) {
    final prefix = isIncome ? '+' : '-';
    return '$prefix${formatCurrency(amount.abs(), currency, locale)}';
  }

  static String formatWeekdayLabel(DateTime date, Locale locale) {
    return DateFormat.E(locale.toLanguageTag()).format(date);
  }

  static String formatDayWithWeekday(DateTime date, Locale locale) {
    return DateFormat('MM.dd EEEE', locale.toLanguageTag()).format(date);
  }
}
