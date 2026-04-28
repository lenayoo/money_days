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
  String get todaySpending => 'Today\'s total';

  @override
  String get monthSpending => 'This month so far';

  @override
  String get monthlyBudget => 'Monthly budget';

  @override
  String budgetProgressUsed(int percent) {
    return '$percent% of the budget used';
  }

  @override
  String budgetRemaining(String amount) {
    return '$amount left for this month';
  }

  @override
  String budgetExceeded(String amount) {
    return '$amount above the budget';
  }

  @override
  String get budgetReached => 'This month\'s budget is fully used';

  @override
  String get setThisMonthBudget => 'Set this month\'s budget';

  @override
  String get startThisMonthWithBudget => 'Start this month with a simple budget.';

  @override
  String get editBudget => 'Edit budget';

  @override
  String get budgetNotSet => 'Not set yet';

  @override
  String get addTodaySpending => 'Add today\'s spending';

  @override
  String get recentExpenses => 'Recent spending';

  @override
  String get emptyRecentExpenses => 'Recent records will appear here.';

  @override
  String get monthlyReviewTitle => 'Monthly review';

  @override
  String get monthlyTotal => 'Monthly total';

  @override
  String get selectMonth => 'Select month';

  @override
  String get categoryBreakdown => 'By category';

  @override
  String get expenseListTitle => 'Spending list';

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
  String get currencyConversionNote => 'Uses fixed USD-based rates: 1 USD = 150 JPY, 1500 KRW, 1.35 SGD.';

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
