import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_days/features/expenses/models/app_currency.dart';

void main() {
  test('converts every currency through USD as the only base', () {
    expect(AppCurrency.usd.toBaseAmount(1), closeTo(1, 0.0001));
    expect(AppCurrency.jpy.toBaseAmount(150), closeTo(1, 0.0001));
    expect(AppCurrency.krw.toBaseAmount(1500), closeTo(1, 0.0001));
    expect(AppCurrency.sgd.toBaseAmount(1.35), closeTo(1, 0.0001));

    expect(AppCurrency.usd.fromBaseAmount(1), closeTo(1, 0.0001));
    expect(AppCurrency.jpy.fromBaseAmount(1), closeTo(150, 0.0001));
    expect(AppCurrency.krw.fromBaseAmount(1), closeTo(1500, 0.0001));
    expect(AppCurrency.sgd.fromBaseAmount(1), closeTo(1.35, 0.0001));
  });

  test('converts between currencies without double conversion', () {
    final sgdFromJpy = AppCurrency.jpy.convertAmount(150, AppCurrency.sgd);
    final krwFromSgd = AppCurrency.sgd.convertAmount(1.35, AppCurrency.krw);
    final jpyRoundTrip = AppCurrency.sgd.convertAmount(
      sgdFromJpy,
      AppCurrency.jpy,
    );

    expect(sgdFromJpy, closeTo(1.35, 0.0001));
    expect(krwFromSgd, closeTo(1500, 0.0001));
    expect(jpyRoundTrip, closeTo(150, 0.0001));
  });

  test('defaults Singapore locale to SGD', () {
    expect(appCurrencyFromLocale(const Locale('en', 'SG')), AppCurrency.sgd);
  });
}
