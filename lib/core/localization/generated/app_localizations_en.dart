// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Money Days';

  @override
  String get homeSubtitle => 'Review your money days calmly.';

  @override
  String get todaySpending => 'Today\'s total';

  @override
  String get monthSpending => 'This month so far';

  @override
  String get addExpenseSubtitle => 'A small record for today.';

  @override
  String get addTodaySpending => 'Add today\'s spending';

  @override
  String get recentExpenses => 'Recent spending';

  @override
  String get emptyRecentExpenses => 'Recent records will appear here.';

  @override
  String get monthlyReviewTitle => 'Monthly review';

  @override
  String get monthlyReviewSubtitle => 'See where your money went this month.';

  @override
  String get monthlyTotal => 'Monthly total';

  @override
  String get categoryBreakdown => 'By category';

  @override
  String get noReviewData => 'No spending recorded this month.';

  @override
  String topCategoryMessage(String category) {
    return 'You spent most on $category this month.';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSubtitle => 'Keep things simple and private.';

  @override
  String get languageSetting => 'Language';

  @override
  String get currencySetting => 'Currency';

  @override
  String get appInfo => 'App information';

  @override
  String get privacyNote => 'Privacy';

  @override
  String get privacyMessage => 'Your records are stored on this device.';

  @override
  String get appInfoMessage => 'Money Days is a calm place to note everyday spending.';

  @override
  String get addExpenseTitle => 'Add expense';

  @override
  String get amountLabel => 'Amount';

  @override
  String get memoLabel => 'Memo';

  @override
  String get memoHint => 'Optional note';

  @override
  String get dateLabel => 'Date';

  @override
  String get categoryLabel => 'Category';

  @override
  String get saveButton => 'Save';

  @override
  String get pickDate => 'Choose date';

  @override
  String get savedMessage => 'Saved for today.';

  @override
  String get validationAmountRequired => 'Enter an amount.';

  @override
  String get validationAmountInvalid => 'Enter a valid amount.';

  @override
  String get navigationHome => 'Home';

  @override
  String get navigationReview => 'Review';

  @override
  String get navigationSettings => 'Settings';

  @override
  String get languageSystem => 'System';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageJapanese => 'Japanese';

  @override
  String get currencyJpy => 'JPY';

  @override
  String get currencyUsd => 'USD';

  @override
  String get currencyKrw => 'KRW';

  @override
  String get categoryFood => 'Food';

  @override
  String get categoryCafe => 'Cafe';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryHome => 'Home';

  @override
  String get categorySubscription => 'Subscription';

  @override
  String get categoryOther => 'Other';
}
