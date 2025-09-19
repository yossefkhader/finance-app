import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';

/// Callers can lookup localized strings with Localizations.of<AppLocalizations>(context)!.
///
/// This is only intended to be used from within the localization package via
/// the AppLocalizations.of static method.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
  ];

  // App Name
  String get appName;

  // Navigation
  String get dashboard;
  String get budgetExpenses;
  String get savings;
  String get charityImpact;
  String get profileSettings;

  // Dashboard
  String get totalBalance;
  String get acrossAllAccounts;
  String get savingsThisMonth;
  String get roundUpsPlusManual;
  String get budgetUsed;
  String get remaining;
  String get spendingByCategory;
  String get recentTransactions;
  String get viewAll;
  String get addExpense;
  String get vsLastMonth;

  // Budget Page
  String get budgetOverview;
  String get monthlyBudget;
  String get spent;
  String get budgetUsage;
  String get transactions;
  String get searchTransactions;
  String get category;
  String get allCategories;

  // Savings Page
  String get savedThisMonth;
  String get roundUpsOnly;
  String get totalRoundUpSavings;
  String get sinceYouStarted;
  String get roundUpAllocation;
  String get saveForMe;
  String get donateToCharity;
  String get roundUpsSavedToAccount;
  String get roundUpsDonatedToCharity;
  String get howRoundUpsWork;
  String get roundUpsExplanation;
  String get savingsGrowthTrend;
  String get savingsGoals;
  String get emergencyFund;
  String get vacation;
  String get newCar;
  String get addNewGoal;
  String get complete;

  // Charity Page
  String get totalDonated;
  String get allTimeDonations;
  String get thisMonth;
  String get roundUpsDonated;
  String get lastMonth;
  String get chooseYourCause;
  String get selectCauseToSupport;
  String get cleanWaterAccess;
  String get cleanWaterDescription;
  String get educationForAll;
  String get educationDescription;
  String get environmentalProtection;
  String get environmentDescription;
  String get hungerRelief;
  String get hungerDescription;
  String get medicalResearch;
  String get medicalDescription;
  String get disasterRelief;
  String get disasterDescription;
  String get yourImpact;
  String get seeRealWorldImpact;
  String get mealsProvided;
  String get childrenSponsored;
  String get treesPlanted;
  String get waterFiltersInstalled;
  String get everyRoundUpCounts;

  // Profile Page
  String get account;
  String get profilePicture;
  String get clickToUpload;
  String get change;
  String get displayName;
  String get enterYourName;
  String get emailAddress;
  String get enterYourEmail;
  String get saveChanges;
  String get signOut;
  String get savingsAndRoundUps;
  String get enableRoundUps;
  String get enableRoundUpsDescription;
  String get monthlySavingsGoal;
  String get savePreferences;
  String get notifications;
  String get budgetAlerts;
  String get budgetAlertsDescription;
  String get weeklySummary;
  String get weeklySummaryDescription;
  String get linkedAccounts;
  String get checkingAccount;
  String get savingsAccount;
  String get creditCard;
  String get connected;
  String get disconnected;
  String get linkNewAccount;

  // Add Expense Modal
  String get amount;
  String get description;
  String get whatDidYouSpendOn;
  String get date;
  String get cancel;
  String get saveExpense;
  String get pleaseEnterAmount;
  String get pleaseEnterValidAmount;
  String get pleaseEnterDescription;
  String expenseSavedSuccessfully(String amount);

  // Categories
  String get foodDining;
  String get transportation;
  String get shopping;
  String get entertainment;
  String get billsUtilities;
  String get healthcare;
  String get education;
  String get travel;
  String get personalCare;
  String get other;

  // Empty States
  String get noTransactionsYet;
  String get transactionsWillAppearHere;
  String get addFirstExpense;

  // Error States
  String get somethingWentWrong;
  String get errorLoadingData;
  String get tryAgain;

  // Months
  String get january;
  String get february;
  String get march;
  String get april;
  String get may;
  String get june;
  String get july;
  String get august;
  String get september;
  String get october;
  String get november;
  String get december;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(
      _lookupAppLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations _lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue on GitHub with a '
    'reproducible sample app and the gen-l10n configuration that was used.',
  );
}
