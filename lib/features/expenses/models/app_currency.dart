import 'dart:ui';

// Existing MVP rates stay fixed. Additional display currencies use a fixed
// USD reference list seeded from ECB rates published on 15 May 2026.
enum AppCurrency {
  jpy(
    code: 'JPY',
    symbol: '¥',
    decimalDigits: 0,
    unitsPerUsd: 150,
    countryCodes: <String>{'JP'},
  ),
  usd(
    code: 'USD',
    symbol: r'$',
    decimalDigits: 2,
    unitsPerUsd: 1,
    countryCodes: <String>{'US'},
  ),
  krw(
    code: 'KRW',
    symbol: '₩',
    decimalDigits: 0,
    unitsPerUsd: 1500,
    countryCodes: <String>{'KR'},
  ),
  sgd(
    code: 'SGD',
    symbol: 'S\$',
    decimalDigits: 2,
    unitsPerUsd: 1.35,
    countryCodes: <String>{'SG'},
  ),
  eur(
    code: 'EUR',
    symbol: '€',
    decimalDigits: 2,
    unitsPerUsd: 0.859993,
    countryCodes: <String>{
      'AD',
      'AT',
      'BE',
      'CY',
      'DE',
      'EE',
      'ES',
      'FI',
      'FR',
      'GR',
      'HR',
      'IE',
      'IT',
      'LT',
      'LU',
      'LV',
      'MC',
      'ME',
      'MT',
      'NL',
      'PT',
      'SI',
      'SK',
      'SM',
      'VA',
    },
  ),
  aud(
    code: 'AUD',
    symbol: 'A\$',
    decimalDigits: 2,
    unitsPerUsd: 1.398779,
    countryCodes: <String>{'AU'},
  ),
  brl(
    code: 'BRL',
    symbol: 'R\$',
    decimalDigits: 2,
    unitsPerUsd: 5.032422,
    countryCodes: <String>{'BR'},
  ),
  cad(
    code: 'CAD',
    symbol: 'C\$',
    decimalDigits: 2,
    unitsPerUsd: 1.375559,
    countryCodes: <String>{'CA'},
  ),
  chf(
    code: 'CHF',
    symbol: 'CHF',
    decimalDigits: 2,
    unitsPerUsd: 0.786378,
    countryCodes: <String>{'CH', 'LI'},
  ),
  cny(
    code: 'CNY',
    symbol: 'CN¥',
    decimalDigits: 2,
    unitsPerUsd: 6.81063,
    countryCodes: <String>{'CN'},
  ),
  czk(
    code: 'CZK',
    symbol: 'Kč',
    decimalDigits: 2,
    unitsPerUsd: 20.926213,
    countryCodes: <String>{'CZ'},
  ),
  dkk(
    code: 'DKK',
    symbol: 'kr',
    decimalDigits: 2,
    unitsPerUsd: 6.426557,
    countryCodes: <String>{'DK'},
  ),
  gbp(
    code: 'GBP',
    symbol: '£',
    decimalDigits: 2,
    unitsPerUsd: 0.748624,
    countryCodes: <String>{'GB'},
  ),
  hkd(
    code: 'HKD',
    symbol: 'HK\$',
    decimalDigits: 2,
    unitsPerUsd: 7.831527,
    countryCodes: <String>{'HK'},
  ),
  huf(
    code: 'HUF',
    symbol: 'Ft',
    decimalDigits: 0,
    unitsPerUsd: 309.408325,
    countryCodes: <String>{'HU'},
  ),
  idr(
    code: 'IDR',
    symbol: 'Rp',
    decimalDigits: 0,
    unitsPerUsd: 17588.69969,
    countryCodes: <String>{'ID'},
  ),
  ils(
    code: 'ILS',
    symbol: '₪',
    decimalDigits: 2,
    unitsPerUsd: 2.921999,
    countryCodes: <String>{'IL'},
  ),
  inr(
    code: 'INR',
    symbol: '₹',
    decimalDigits: 2,
    unitsPerUsd: 95.970072,
    countryCodes: <String>{'IN'},
  ),
  isk(
    code: 'ISK',
    symbol: 'kr',
    decimalDigits: 0,
    unitsPerUsd: 123.495012,
    countryCodes: <String>{'IS'},
  ),
  mxn(
    code: 'MXN',
    symbol: 'MX\$',
    decimalDigits: 2,
    unitsPerUsd: 17.373925,
    countryCodes: <String>{'MX'},
  ),
  myr(
    code: 'MYR',
    symbol: 'RM',
    decimalDigits: 2,
    unitsPerUsd: 3.95098,
    countryCodes: <String>{'MY'},
  ),
  nok(
    code: 'NOK',
    symbol: 'kr',
    decimalDigits: 2,
    unitsPerUsd: 9.326625,
    countryCodes: <String>{'NO'},
  ),
  nzd(
    code: 'NZD',
    symbol: 'NZ\$',
    decimalDigits: 2,
    unitsPerUsd: 1.712074,
    countryCodes: <String>{'NZ'},
  ),
  php(
    code: 'PHP',
    symbol: '₱',
    decimalDigits: 2,
    unitsPerUsd: 61.694186,
    countryCodes: <String>{'PH'},
  ),
  pln(
    code: 'PLN',
    symbol: 'zł',
    decimalDigits: 2,
    unitsPerUsd: 3.651961,
    countryCodes: <String>{'PL'},
  ),
  ron(
    code: 'RON',
    symbol: 'lei',
    decimalDigits: 2,
    unitsPerUsd: 4.48624,
    countryCodes: <String>{'RO'},
  ),
  sek(
    code: 'SEK',
    symbol: 'kr',
    decimalDigits: 2,
    unitsPerUsd: 9.444444,
    countryCodes: <String>{'SE'},
  ),
  thb(
    code: 'THB',
    symbol: '฿',
    decimalDigits: 2,
    unitsPerUsd: 32.670279,
    countryCodes: <String>{'TH'},
  ),
  tryCurrency(
    code: 'TRY',
    symbol: '₺',
    decimalDigits: 2,
    unitsPerUsd: 45.545064,
    countryCodes: <String>{'TR'},
  ),
  zar(
    code: 'ZAR',
    symbol: 'R',
    decimalDigits: 2,
    unitsPerUsd: 16.661421,
    countryCodes: <String>{'ZA'},
  );

  const AppCurrency({
    required this.code,
    required this.symbol,
    required this.decimalDigits,
    required this.unitsPerUsd,
    required this.countryCodes,
  });

  final String code;
  final String symbol;
  final int decimalDigits;
  final double unitsPerUsd;
  final Set<String> countryCodes;

  String get label => symbol == code ? code : '$code ($symbol)';

  double toBaseAmount(double amount) => amount / unitsPerUsd;

  double fromBaseAmount(double amount) => amount * unitsPerUsd;
}

AppCurrency appCurrencyFromStorage(String? value) {
  return AppCurrency.values.firstWhere(
    (currency) => currency.name == value,
    orElse: () => AppCurrency.jpy,
  );
}

AppCurrency appCurrencyFromLocale(Locale locale) {
  final countryCode = locale.countryCode?.toUpperCase();
  if (countryCode != null) {
    for (final currency in AppCurrency.values) {
      if (currency.countryCodes.contains(countryCode)) {
        return currency;
      }
    }
  }

  return switch (locale.languageCode) {
    'en' => AppCurrency.usd,
    'ko' => AppCurrency.krw,
    'ja' => AppCurrency.jpy,
    _ => AppCurrency.jpy,
  };
}
