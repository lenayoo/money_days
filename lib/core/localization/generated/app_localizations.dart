import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Money Days'**
  String get appName;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A quiet view of this month.'**
  String get homeSubtitle;

  /// No description provided for @monthlyIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get monthlyIncome;

  /// No description provided for @monthlyExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get monthlyExpense;

  /// No description provided for @monthlyBudget.
  ///
  /// In en, this message translates to:
  /// **'Monthly budget'**
  String get monthlyBudget;

  /// No description provided for @remainingBudget.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remainingBudget;

  /// No description provided for @budgetProgressUsed.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of the budget used'**
  String budgetProgressUsed(int percent);

  /// No description provided for @budgetRemaining.
  ///
  /// In en, this message translates to:
  /// **'{amount} left for this month'**
  String budgetRemaining(String amount);

  /// No description provided for @budgetExceeded.
  ///
  /// In en, this message translates to:
  /// **'{amount} above the budget'**
  String budgetExceeded(String amount);

  /// No description provided for @budgetReached.
  ///
  /// In en, this message translates to:
  /// **'This month\'s budget is fully used'**
  String get budgetReached;

  /// No description provided for @setThisMonthBudget.
  ///
  /// In en, this message translates to:
  /// **'Set this month\'s budget'**
  String get setThisMonthBudget;

  /// No description provided for @startThisMonthWithBudget.
  ///
  /// In en, this message translates to:
  /// **'Start this month with a simple budget.'**
  String get startThisMonthWithBudget;

  /// No description provided for @editBudget.
  ///
  /// In en, this message translates to:
  /// **'Edit budget'**
  String get editBudget;

  /// No description provided for @budgetNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set yet'**
  String get budgetNotSet;

  /// No description provided for @monthlyCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly calendar'**
  String get monthlyCalendarTitle;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent records'**
  String get recentTransactions;

  /// No description provided for @emptyMonthTransactions.
  ///
  /// In en, this message translates to:
  /// **'No records for this month yet.'**
  String get emptyMonthTransactions;

  /// No description provided for @monthlyReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly review'**
  String get monthlyReviewTitle;

  /// No description provided for @monthlyReviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See the month in a calm, simple way.'**
  String get monthlyReviewSubtitle;

  /// No description provided for @monthlyPeriodLabel.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthlyPeriodLabel;

  /// No description provided for @selectMonth.
  ///
  /// In en, this message translates to:
  /// **'Select month'**
  String get selectMonth;

  /// No description provided for @monthTransactions.
  ///
  /// In en, this message translates to:
  /// **'Monthly records'**
  String get monthTransactions;

  /// No description provided for @spendingByCategory.
  ///
  /// In en, this message translates to:
  /// **'Spending by category'**
  String get spendingByCategory;

  /// No description provided for @incomeByCategory.
  ///
  /// In en, this message translates to:
  /// **'Income by category'**
  String get incomeByCategory;

  /// No description provided for @noCategoryData.
  ///
  /// In en, this message translates to:
  /// **'No category records this month.'**
  String get noCategoryData;

  /// No description provided for @noReviewData.
  ///
  /// In en, this message translates to:
  /// **'No spending recorded this month.'**
  String get noReviewData;

  /// No description provided for @emptyDayTransactions.
  ///
  /// In en, this message translates to:
  /// **'No records for this day yet.'**
  String get emptyDayTransactions;

  /// No description provided for @recordCount.
  ///
  /// In en, this message translates to:
  /// **'{count} record'**
  String recordCount(int count);

  /// No description provided for @topCategoryMessage.
  ///
  /// In en, this message translates to:
  /// **'You spent most on {category} this month.'**
  String topCategoryMessage(String category);

  /// No description provided for @premiumTitle.
  ///
  /// In en, this message translates to:
  /// **'Money Days Premium'**
  String get premiumTitle;

  /// No description provided for @premiumSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A quiet upgrade for budget, insights, and sharing.'**
  String get premiumSubtitle;

  /// No description provided for @premiumActiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Premium is already ready on this device.'**
  String get premiumActiveSubtitle;

  /// No description provided for @premiumReadyOnDevice.
  ///
  /// In en, this message translates to:
  /// **'Premium is ready on this device.'**
  String get premiumReadyOnDevice;

  /// No description provided for @premiumActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Premium active'**
  String get premiumActiveLabel;

  /// No description provided for @premiumBadge.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premiumBadge;

  /// No description provided for @premiumOneTimePurchase.
  ///
  /// In en, this message translates to:
  /// **'One-time purchase'**
  String get premiumOneTimePurchase;

  /// No description provided for @premiumUnlockButton.
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium'**
  String get premiumUnlockButton;

  /// No description provided for @premiumOpeningStore.
  ///
  /// In en, this message translates to:
  /// **'Opening store...'**
  String get premiumOpeningStore;

  /// No description provided for @premiumRestoreButton.
  ///
  /// In en, this message translates to:
  /// **'Restore purchase'**
  String get premiumRestoreButton;

  /// No description provided for @premiumRestoring.
  ///
  /// In en, this message translates to:
  /// **'Checking purchases...'**
  String get premiumRestoring;

  /// No description provided for @premiumRestoreStartedMessage.
  ///
  /// In en, this message translates to:
  /// **'Checking past purchases.'**
  String get premiumRestoreStartedMessage;

  /// No description provided for @premiumAlreadyActiveMessage.
  ///
  /// In en, this message translates to:
  /// **'Premium is already active.'**
  String get premiumAlreadyActiveMessage;

  /// No description provided for @premiumStoreUnavailableMessage.
  ///
  /// In en, this message translates to:
  /// **'The store is not ready yet.'**
  String get premiumStoreUnavailableMessage;

  /// No description provided for @premiumProductUnavailableMessage.
  ///
  /// In en, this message translates to:
  /// **'Premium is being prepared in the store.'**
  String get premiumProductUnavailableMessage;

  /// No description provided for @premiumActionFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Premium could not be opened right now.'**
  String get premiumActionFailedMessage;

  /// No description provided for @premiumFeatureBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly budget'**
  String get premiumFeatureBudgetTitle;

  /// No description provided for @premiumFeatureBudgetDescription.
  ///
  /// In en, this message translates to:
  /// **'Set a monthly budget and keep the remaining amount in view.'**
  String get premiumFeatureBudgetDescription;

  /// No description provided for @premiumFeaturePieChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Pie chart analysis'**
  String get premiumFeaturePieChartTitle;

  /// No description provided for @premiumFeaturePieChartDescription.
  ///
  /// In en, this message translates to:
  /// **'See the month by category with a simple pie chart.'**
  String get premiumFeaturePieChartDescription;

  /// No description provided for @premiumFeatureInsightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Spending insights'**
  String get premiumFeatureInsightsTitle;

  /// No description provided for @premiumFeatureInsightsDescription.
  ///
  /// In en, this message translates to:
  /// **'Notice small patterns in your spending days.'**
  String get premiumFeatureInsightsDescription;

  /// No description provided for @premiumFeatureShareTitle.
  ///
  /// In en, this message translates to:
  /// **'Share cards'**
  String get premiumFeatureShareTitle;

  /// No description provided for @premiumFeatureShareDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a soft summary card when you want to share.'**
  String get premiumFeatureShareDescription;

  /// No description provided for @seePremium.
  ///
  /// In en, this message translates to:
  /// **'See Premium'**
  String get seePremium;

  /// No description provided for @doneButton.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneButton;

  /// No description provided for @spendingInsightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Spending insights'**
  String get spendingInsightsTitle;

  /// No description provided for @spendingInsightsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add a few records to see a gentle pattern.'**
  String get spendingInsightsEmpty;

  /// No description provided for @spendingInsightTopCategory.
  ///
  /// In en, this message translates to:
  /// **'Top category'**
  String get spendingInsightTopCategory;

  /// No description provided for @spendingInsightDays.
  ///
  /// In en, this message translates to:
  /// **'Spending days'**
  String get spendingInsightDays;

  /// No description provided for @spendingInsightDailyAverage.
  ///
  /// In en, this message translates to:
  /// **'Daily pace'**
  String get spendingInsightDailyAverage;

  /// No description provided for @dayCount.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String dayCount(int count);

  /// No description provided for @shareSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Share summary card'**
  String get shareSummaryTitle;

  /// No description provided for @shareSummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'A small card for this month.'**
  String get shareSummarySubtitle;

  /// No description provided for @preparingShareCard.
  ///
  /// In en, this message translates to:
  /// **'Preparing card...'**
  String get preparingShareCard;

  /// No description provided for @shareSummaryButton.
  ///
  /// In en, this message translates to:
  /// **'Share card'**
  String get shareSummaryButton;

  /// No description provided for @shareFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'The share card could not be prepared.'**
  String get shareFailedMessage;

  /// No description provided for @shareSummaryMessage.
  ///
  /// In en, this message translates to:
  /// **'Money Days · {month} · {total}'**
  String shareSummaryMessage(String month, String total);

  /// No description provided for @shareCardCaption.
  ///
  /// In en, this message translates to:
  /// **'A quiet record of this month.'**
  String get shareCardCaption;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep the app quiet and local.'**
  String get settingsSubtitle;

  /// No description provided for @languageSetting.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSetting;

  /// No description provided for @currencySetting.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currencySetting;

  /// No description provided for @currencyConversionNote.
  ///
  /// In en, this message translates to:
  /// **'Uses fixed USD-based rates: 1 USD = 150 JPY, 1500 KRW, 1.35 SGD.'**
  String get currencyConversionNote;

  /// No description provided for @appInfo.
  ///
  /// In en, this message translates to:
  /// **'App information'**
  String get appInfo;

  /// No description provided for @privacyNote.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacyNote;

  /// No description provided for @privacyMessage.
  ///
  /// In en, this message translates to:
  /// **'Your records are stored on this device.'**
  String get privacyMessage;

  /// No description provided for @appInfoMessage.
  ///
  /// In en, this message translates to:
  /// **'Money Days is a calm calendar for everyday money records.'**
  String get appInfoMessage;

  /// No description provided for @addTransactionTitle.
  ///
  /// In en, this message translates to:
  /// **'Add record'**
  String get addTransactionTitle;

  /// No description provided for @addTransactionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep it light. Add income or spending.'**
  String get addTransactionSubtitle;

  /// No description provided for @addTransactionButton.
  ///
  /// In en, this message translates to:
  /// **'Add record'**
  String get addTransactionButton;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// No description provided for @memoLabel.
  ///
  /// In en, this message translates to:
  /// **'Memo'**
  String get memoLabel;

  /// No description provided for @memoHint.
  ///
  /// In en, this message translates to:
  /// **'Optional note'**
  String get memoHint;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @typeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get typeLabel;

  /// No description provided for @paymentMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethodLabel;

  /// No description provided for @paymentMethodOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get paymentMethodOptional;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @pickDate.
  ///
  /// In en, this message translates to:
  /// **'Choose date'**
  String get pickDate;

  /// No description provided for @transactionSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Saved.'**
  String get transactionSavedMessage;

  /// No description provided for @validationAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount.'**
  String get validationAmountRequired;

  /// No description provided for @validationAmountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount.'**
  String get validationAmountInvalid;

  /// No description provided for @navigationHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navigationHome;

  /// No description provided for @navigationReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get navigationReview;

  /// No description provided for @navigationSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navigationSettings;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageJapanese.
  ///
  /// In en, this message translates to:
  /// **'日本語'**
  String get languageJapanese;

  /// No description provided for @languageKorean.
  ///
  /// In en, this message translates to:
  /// **'한국어'**
  String get languageKorean;

  /// No description provided for @currencyJpy.
  ///
  /// In en, this message translates to:
  /// **'JPY'**
  String get currencyJpy;

  /// No description provided for @currencyUsd.
  ///
  /// In en, this message translates to:
  /// **'USD'**
  String get currencyUsd;

  /// No description provided for @currencyKrw.
  ///
  /// In en, this message translates to:
  /// **'KRW'**
  String get currencyKrw;

  /// No description provided for @currencySgd.
  ///
  /// In en, this message translates to:
  /// **'SGD'**
  String get currencySgd;

  /// No description provided for @categoryFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get categoryFood;

  /// No description provided for @categoryCafe.
  ///
  /// In en, this message translates to:
  /// **'Cafe'**
  String get categoryCafe;

  /// No description provided for @categoryTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get categoryTransport;

  /// No description provided for @categoryShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get categoryShopping;

  /// No description provided for @categoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get categoryHealth;

  /// No description provided for @categoryHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get categoryHome;

  /// No description provided for @categorySubscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get categorySubscription;

  /// No description provided for @categorySalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get categorySalary;

  /// No description provided for @categoryBonus.
  ///
  /// In en, this message translates to:
  /// **'Bonus'**
  String get categoryBonus;

  /// No description provided for @categoryGift.
  ///
  /// In en, this message translates to:
  /// **'Gift'**
  String get categoryGift;

  /// No description provided for @categoryRefund.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get categoryRefund;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @paymentMethodCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get paymentMethodCash;

  /// No description provided for @paymentMethodCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get paymentMethodCard;

  /// No description provided for @paymentMethodBankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank transfer'**
  String get paymentMethodBankTransfer;

  /// No description provided for @paymentMethodMobilePay.
  ///
  /// In en, this message translates to:
  /// **'Mobile pay'**
  String get paymentMethodMobilePay;

  /// No description provided for @paymentMethodOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get paymentMethodOther;

  /// No description provided for @transactionTypeExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get transactionTypeExpense;

  /// No description provided for @transactionTypeIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get transactionTypeIncome;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ja', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ja': return AppLocalizationsJa();
    case 'ko': return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
