// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'Money Days';

  @override
  String get homeSubtitle => '今月のお金を静かに見渡せます。';

  @override
  String get monthlyIncome => '収入';

  @override
  String get monthlyExpense => '支出';

  @override
  String get monthlyBudget => '今月の予算';

  @override
  String get remainingBudget => '残り予算';

  @override
  String budgetProgressUsed(int percent) {
    return '予算の$percent%を使っています';
  }

  @override
  String budgetRemaining(String amount) {
    return '今月はあと$amount使えます';
  }

  @override
  String budgetExceeded(String amount) {
    return '予算より$amount多めです';
  }

  @override
  String get budgetReached => '今月の予算をちょうど使いました';

  @override
  String get setThisMonthBudget => '今月の予算を設定';

  @override
  String get startThisMonthWithBudget => '今月は、シンプルな予算から始めましょう。';

  @override
  String get editBudget => '予算を編集';

  @override
  String get budgetNotSet => 'まだ設定されていません';

  @override
  String get monthlyCalendarTitle => '月間カレンダー';

  @override
  String get recentTransactions => '最近の記録';

  @override
  String get emptyMonthTransactions => '今月の記録はまだありません。';

  @override
  String get monthlyReviewTitle => '月のふり返り';

  @override
  String get monthlyReviewSubtitle => '今月の流れを落ち着いて見返せます。';

  @override
  String get monthlyPeriodLabel => '月別';

  @override
  String get selectMonth => '月を選択';

  @override
  String get monthTransactions => '今月の記録';

  @override
  String get spendingByCategory => 'カテゴリ別の支出';

  @override
  String get incomeByCategory => 'カテゴリ別の収入';

  @override
  String get noCategoryData => '今月のカテゴリ記録はまだありません。';

  @override
  String get noReviewData => '今月の支出はまだありません。';

  @override
  String get emptyDayTransactions => 'この日の記録はまだありません。';

  @override
  String recordCount(int count) {
    return '$count件';
  }

  @override
  String topCategoryMessage(String category) {
    return '今月は$categoryの支出がいちばん多いです。';
  }

  @override
  String get doneButton => '閉じる';

  @override
  String get spendingInsightsTitle => '支出インサイト';

  @override
  String get spendingInsightsEmpty => 'いくつか記録すると、やさしい気づきが見えてきます。';

  @override
  String get spendingInsightTopCategory => 'いちばん多いカテゴリ';

  @override
  String get spendingInsightDays => '支出した日';

  @override
  String get spendingInsightDailyAverage => '1日あたり';

  @override
  String dayCount(int count) {
    return '$count日';
  }

  @override
  String get shareSummaryTitle => '共有カード';

  @override
  String get shareSummarySubtitle => '今月を小さなカードにまとめます。';

  @override
  String get preparingShareCard => 'カードを準備しています...';

  @override
  String get shareSummaryButton => 'カードを共有';

  @override
  String get shareFailedMessage => '共有カードを準備できませんでした。';

  @override
  String shareSummaryMessage(String month, String total) {
    return 'Money Days · $month · $total';
  }

  @override
  String get shareCardCaption => '今月の静かな記録。';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsSubtitle => 'シンプルに、この端末だけで。';

  @override
  String get languageSetting => '言語';

  @override
  String get currencySetting => '通貨';

  @override
  String get currencyConversionNote => '表示の換算には USD 基準の固定レートを使います: 1 USD = 150 JPY、1500 KRW、1.35 SGD。';

  @override
  String get appInfo => 'アプリについて';

  @override
  String get privacyNote => 'プライバシー';

  @override
  String get privacyMessage => '記録はこの端末に保存されます。';

  @override
  String get appInfoMessage => 'Money Days は、日々のお金を静かに記録するカレンダーです。';

  @override
  String get addTransactionTitle => '記録を追加';

  @override
  String get addTransactionSubtitle => '支出も収入も、軽く残しましょう。';

  @override
  String get addTransactionButton => '記録を追加';

  @override
  String get amountLabel => '金額';

  @override
  String get memoLabel => 'メモ';

  @override
  String get memoHint => 'メモは任意です';

  @override
  String get dateLabel => '日付';

  @override
  String get categoryLabel => 'カテゴリ';

  @override
  String get typeLabel => '種類';

  @override
  String get paymentMethodLabel => '支払い方法';

  @override
  String get paymentMethodOptional => '任意';

  @override
  String get saveButton => '保存';

  @override
  String get pickDate => '日付を選ぶ';

  @override
  String get transactionSavedMessage => '保存しました。';

  @override
  String get validationAmountRequired => '金額を入力してください。';

  @override
  String get validationAmountInvalid => '正しい金額を入力してください。';

  @override
  String get navigationHome => 'ホーム';

  @override
  String get navigationReview => 'ふり返り';

  @override
  String get navigationSettings => '設定';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageJapanese => '日本語';

  @override
  String get languageKorean => '한국어';

  @override
  String get currencyJpy => 'JPY';

  @override
  String get currencyUsd => 'USD';

  @override
  String get currencyKrw => 'KRW';

  @override
  String get currencySgd => 'SGD';

  @override
  String get categoryFood => '食費';

  @override
  String get categoryCafe => 'カフェ';

  @override
  String get categoryTransport => '交通';

  @override
  String get categoryShopping => '買い物';

  @override
  String get categoryHealth => '健康';

  @override
  String get categoryHome => '家';

  @override
  String get categorySubscription => 'サブスク';

  @override
  String get categorySalary => '給与';

  @override
  String get categoryBonus => 'ボーナス';

  @override
  String get categoryGift => '贈り物';

  @override
  String get categoryRefund => '返金';

  @override
  String get categoryOther => 'その他';

  @override
  String get paymentMethodCash => '現金';

  @override
  String get paymentMethodCard => 'カード';

  @override
  String get paymentMethodBankTransfer => '振込';

  @override
  String get paymentMethodMobilePay => 'モバイル決済';

  @override
  String get paymentMethodOther => 'その他';

  @override
  String get transactionTypeExpense => '支出';

  @override
  String get transactionTypeIncome => '収入';
}
