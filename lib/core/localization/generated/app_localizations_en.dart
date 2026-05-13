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
  String get homeSubtitle => 'A quiet view of this month.';

  @override
  String get monthlyIncome => 'Income';

  @override
  String get monthlyExpense => 'Expense';

  @override
  String get monthlyBudget => 'Monthly budget';

  @override
  String get remainingBudget => 'Remaining';

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
  String get monthlyCalendarTitle => 'Monthly calendar';

  @override
  String get recentTransactions => 'Recent records';

  @override
  String get emptyMonthTransactions => 'No records for this month yet.';

  @override
  String get monthlyReviewTitle => 'Monthly review';

  @override
  String get monthlyReviewSubtitle => 'See the month in a calm, simple way.';

  @override
  String get monthlyPeriodLabel => 'Monthly';

  @override
  String get selectMonth => 'Select month';

  @override
  String get monthTransactions => 'Monthly records';

  @override
  String get spendingByCategory => 'Spending by category';

  @override
  String get incomeByCategory => 'Income by category';

  @override
  String get noCategoryData => 'No category records this month.';

  @override
  String get noReviewData => 'No spending recorded this month.';

  @override
  String get emptyDayTransactions => 'No records for this day yet.';

  @override
  String recordCount(int count) {
    return '$count record';
  }

  @override
  String topCategoryMessage(String category) {
    return 'You spent most on $category this month.';
  }

  @override
  String get doneButton => 'Done';

  @override
  String get spendingInsightsTitle => 'Spending insights';

  @override
  String get spendingInsightsEmpty => 'Add a few records to see a gentle pattern.';

  @override
  String get spendingInsightTopCategory => 'Top category';

  @override
  String get spendingInsightDays => 'Spending days';

  @override
  String get spendingInsightDailyAverage => 'Daily pace';

  @override
  String dayCount(int count) {
    return '$count days';
  }

  @override
  String get shareSummaryTitle => 'Share summary card';

  @override
  String get shareSummarySubtitle => 'A small card for this month.';

  @override
  String get preparingShareCard => 'Preparing card...';

  @override
  String get shareSummaryButton => 'Share card';

  @override
  String get shareFailedMessage => 'The share card could not be prepared.';

  @override
  String shareSummaryMessage(String month, String total) {
    return 'Money Days · $month · $total';
  }

  @override
  String get shareCardCaption => 'A quiet record of this month.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSubtitle => 'Keep the app quiet and local.';

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
  String get appInfoMessage => 'Money Days is a calm calendar for everyday money records.';

  @override
  String get addTransactionTitle => 'Add record';

  @override
  String get addTransactionSubtitle => 'Keep it light. Add income or spending.';

  @override
  String get addTransactionButton => 'Add record';

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
  String get typeLabel => 'Type';

  @override
  String get paymentMethodLabel => 'Payment method';

  @override
  String get paymentMethodOptional => 'Optional';

  @override
  String get saveButton => 'Save';

  @override
  String get pickDate => 'Choose date';

  @override
  String get transactionSavedMessage => 'Saved.';

  @override
  String get transactionUpdatedMessage => 'Updated.';

  @override
  String get transactionDeletedMessage => 'Deleted.';

  @override
  String get editRecord => 'Edit';

  @override
  String get deleteRecord => 'Delete';

  @override
  String get deleteRecordTitle => 'Delete this record?';

  @override
  String get deleteRecordMessage => 'This quiet record will be removed.';

  @override
  String get cancelButton => 'Cancel';

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
  String get categorySalary => 'Salary';

  @override
  String get categoryBonus => 'Bonus';

  @override
  String get categoryGift => 'Gift';

  @override
  String get categoryRefund => 'Refund';

  @override
  String get categoryOther => 'Other';

  @override
  String get paymentMethodCash => 'Cash';

  @override
  String get paymentMethodCard => 'Card';

  @override
  String get paymentMethodBankTransfer => 'Bank transfer';

  @override
  String get paymentMethodMobilePay => 'Mobile pay';

  @override
  String get paymentMethodOther => 'Other';

  @override
  String get transactionTypeExpense => 'Expense';

  @override
  String get transactionTypeIncome => 'Income';
}
