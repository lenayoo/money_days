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
  String get homeSubtitle => 'お金のある毎日を、落ち着いて振り返りましょう。';

  @override
  String get todaySpending => '今日の合計';

  @override
  String get weekSpending => '今週';

  @override
  String get monthSpending => '今月ここまで';

  @override
  String get monthlyBudget => '今月の予算';

  @override
  String get setThisMonthBudget => '今月の予算を設定';

  @override
  String get startThisMonthWithBudget => '今月は、シンプルな予算から始めましょう。';

  @override
  String get editBudget => '予算を編集';

  @override
  String get budgetNotSet => 'まだ設定されていません';

  @override
  String get addExpenseSubtitle => '今日の小さな記録です。';

  @override
  String get addTodaySpending => '今日の支出を追加';

  @override
  String get recentExpenses => '最近の記録';

  @override
  String get emptyRecentExpenses => '最近の記録がここに表示されます。';

  @override
  String get monthlyReviewTitle => '月のふり返り';

  @override
  String get monthlyReviewSubtitle => '今月のお金の流れをやさしく見てみましょう。';

  @override
  String get monthlyTotal => '今月の合計';

  @override
  String get selectMonth => '月を選択';

  @override
  String get categoryBreakdown => 'カテゴリ別';

  @override
  String get expenseListTitle => '支出一覧';

  @override
  String get noReviewData => '今月の支出はまだありません。';

  @override
  String topCategoryMessage(String category) {
    return '今月は$categoryの支出がいちばん多いです。';
  }

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsSubtitle => 'シンプルで、安心できるままに。';

  @override
  String get languageSetting => '言語';

  @override
  String get currencySetting => '通貨';

  @override
  String get currencyConversionNote => '表示の換算には固定レートを使います: 1 USD = 150 JPY = 1500 KRW。';

  @override
  String get appInfo => 'アプリについて';

  @override
  String get privacyNote => 'プライバシー';

  @override
  String get privacyMessage => '記録はこの端末に保存されます。';

  @override
  String get appInfoMessage => 'Money Days は、毎日の支出を静かに残すためのアプリです。';

  @override
  String get addExpenseTitle => '支出を追加';

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
  String get saveButton => '保存';

  @override
  String get pickDate => '日付を選ぶ';

  @override
  String get savedMessage => '記録しました。';

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
  String get languageSystem => 'システム';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageJapanese => '日本語';

  @override
  String get currencyJpy => 'JPY';

  @override
  String get currencyUsd => 'USD';

  @override
  String get currencyKrw => 'KRW';

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
  String get categoryOther => 'その他';
}
