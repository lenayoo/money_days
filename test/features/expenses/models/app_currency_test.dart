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

  test('converts between currencies through USD base amounts', () {
    final sgdFromJpy = AppCurrency.sgd.fromBaseAmount(
      AppCurrency.jpy.toBaseAmount(150),
    );
    final krwFromSgd = AppCurrency.krw.fromBaseAmount(
      AppCurrency.sgd.toBaseAmount(1.35),
    );
    final jpyRoundTrip = AppCurrency.jpy.fromBaseAmount(
      AppCurrency.sgd.toBaseAmount(sgdFromJpy),
    );

    expect(sgdFromJpy, closeTo(1.35, 0.0001));
    expect(krwFromSgd, closeTo(1500, 0.0001));
    expect(jpyRoundTrip, closeTo(150, 0.0001));
  });

  test('defaults Singapore locale to SGD', () {
    expect(appCurrencyFromLocale(const Locale('en', 'SG')), AppCurrency.sgd);
  });
}
