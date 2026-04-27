import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

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
    Locale('ja')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Money Days'**
  String get appName;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review your money days calmly.'**
  String get homeSubtitle;

  /// No description provided for @todaySpending.
  ///
  /// In en, this message translates to:
  /// **'Today\'s total'**
  String get todaySpending;

  /// No description provided for @monthSpending.
  ///
  /// In en, this message translates to:
  /// **'This month so far'**
  String get monthSpending;

  /// No description provided for @addExpenseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A small record for today.'**
  String get addExpenseSubtitle;

  /// No description provided for @addTodaySpending.
  ///
  /// In en, this message translates to:
  /// **'Add today\'s spending'**
  String get addTodaySpending;

  /// No description provided for @recentExpenses.
  ///
  /// In en, this message translates to:
  /// **'Recent spending'**
  String get recentExpenses;

  /// No description provided for @emptyRecentExpenses.
  ///
  /// In en, this message translates to:
  /// **'Recent records will appear here.'**
  String get emptyRecentExpenses;

  /// No description provided for @monthlyReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly review'**
  String get monthlyReviewTitle;

  /// No description provided for @monthlyReviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See where your money went this month.'**
  String get monthlyReviewSubtitle;

  /// No description provided for @monthlyTotal.
  ///
  /// In en, this message translates to:
  /// **'Monthly total'**
  String get monthlyTotal;

  /// No description provided for @categoryBreakdown.
  ///
  /// In en, this message translates to:
  /// **'By category'**
  String get categoryBreakdown;

  /// No description provided for @noReviewData.
  ///
  /// In en, this message translates to:
  /// **'No spending recorded this month.'**
  String get noReviewData;

  /// No description provided for @topCategoryMessage.
  ///
  /// In en, this message translates to:
  /// **'You spent most on {category} this month.'**
  String topCategoryMessage(String category);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep things simple and private.'**
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
  /// **'Money Days is a calm place to note everyday spending.'**
  String get appInfoMessage;

  /// No description provided for @addExpenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get addExpenseTitle;

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

  /// No description provided for @savedMessage.
  ///
  /// In en, this message translates to:
  /// **'Saved for today.'**
  String get savedMessage;

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

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageJapanese.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get languageJapanese;

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

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ja': return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
