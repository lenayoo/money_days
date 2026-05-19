// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appName => 'Money Days';

  @override
  String get homeSubtitle => '이번 달 흐름을 조용히 볼 수 있어요.';

  @override
  String get monthlyIncome => '수입';

  @override
  String get monthlyExpense => '지출';

  @override
  String get monthlyBudget => '월 예산';

  @override
  String get remainingBudget => '남은 예산';

  @override
  String budgetProgressUsed(int percent) {
    return '예산의 $percent%를 사용했어요';
  }

  @override
  String budgetRemaining(String amount) {
    return '이번 달 $amount 남았어요';
  }

  @override
  String budgetExceeded(String amount) {
    return '예산보다 $amount 더 썼어요';
  }

  @override
  String get budgetReached => '이번 달 예산을 다 사용했어요';

  @override
  String get setThisMonthBudget => '이번 달 예산 설정';

  @override
  String get startThisMonthWithBudget => '이번 달은 가벼운 예산으로 시작해 보세요.';

  @override
  String get editBudget => '예산 수정';

  @override
  String get budgetNotSet => '아직 설정되지 않았어요';

  @override
  String get monthlyCalendarTitle => '월간 캘린더';

  @override
  String get recentTransactions => '최근 기록';

  @override
  String get emptyMonthTransactions => '이번 달 기록이 아직 없어요.';

  @override
  String get monthlyReviewTitle => '월간 돌아보기';

  @override
  String get monthlyReviewSubtitle => '이번 달 흐름을 차분하게 돌아보세요.';

  @override
  String get monthlyPeriodLabel => '월별';

  @override
  String get selectMonth => '월 선택';

  @override
  String get monthTransactions => '이번 달 기록';

  @override
  String get spendingByCategory => '카테고리별 지출';

  @override
  String get incomeByCategory => '카테고리별 수입';

  @override
  String get noCategoryData => '이번 달 카테고리 기록이 아직 없어요.';

  @override
  String get noReviewData => '이번 달에 기록된 지출이 아직 없어요.';

  @override
  String get emptyDayTransactions => '이 날의 기록이 아직 없어요.';

  @override
  String recordCount(int count) {
    return '$count건';
  }

  @override
  String topCategoryMessage(String category) {
    return '이번 달에는 $category 지출이 가장 많았어요.';
  }

  @override
  String get doneButton => '닫기';

  @override
  String get shareExpenseTitle => '이번달 지출 공유';

  @override
  String get shareIncomeTitle => '이번달 수입 공유';

  @override
  String get preparingShareCard => '카드를 준비하는 중...';

  @override
  String get shareSummaryButton => '카드 공유';

  @override
  String get shareFailedMessage => '공유 카드를 준비하지 못했어요.';

  @override
  String shareSummaryMessage(String month, String total) {
    return 'Money Days · $month · $total';
  }

  @override
  String get settingsTitle => '설정';

  @override
  String get languageSetting => '언어';

  @override
  String get languageSystem => '시스템 기본값';

  @override
  String languageSystemCurrent(String language) {
    return '시스템 ($language)';
  }

  @override
  String get currencySetting => '통화';

  @override
  String get currencyBaseNote => '기준 통화: USD';

  @override
  String get addTransactionTitle => '기록 추가';

  @override
  String get addTransactionSubtitle => '지출과 수입을 가볍게 남겨 보세요.';

  @override
  String get addTransactionButton => '기록 추가';

  @override
  String get amountLabel => '금액';

  @override
  String get memoLabel => '메모';

  @override
  String get memoHint => '선택 메모';

  @override
  String get paymentMethodLabel => '결제 수단';

  @override
  String get dateLabel => '날짜';

  @override
  String get categoryLabel => '카테고리';

  @override
  String get typeLabel => '구분';

  @override
  String get saveButton => '저장';

  @override
  String get pickDate => '날짜 선택';

  @override
  String get transactionSavedMessage => '저장했어요.';

  @override
  String get transactionUpdatedMessage => '수정했어요.';

  @override
  String get transactionDeletedMessage => '삭제했어요.';

  @override
  String get editRecord => '수정';

  @override
  String get deleteRecord => '삭제';

  @override
  String get deleteRecordTitle => '이 기록을 지울까요?';

  @override
  String get deleteRecordMessage => '이 작은 기록은 목록에서 사라져요.';

  @override
  String get cancelButton => '취소';

  @override
  String get validationAmountRequired => '금액을 입력해 주세요.';

  @override
  String get validationAmountInvalid => '올바른 금액을 입력해 주세요.';

  @override
  String amountDigitLimitMessage(int count) {
    return '$count자리까지만 입력할 수 있어요.';
  }

  @override
  String get navigationHome => '홈';

  @override
  String get navigationReview => '리뷰';

  @override
  String get navigationSettings => '설정';

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
  String get categoryFood => '식비';

  @override
  String get categoryCafe => '카페';

  @override
  String get categoryTransport => '교통';

  @override
  String get categoryShopping => '쇼핑';

  @override
  String get categoryHealth => '건강';

  @override
  String get categoryHome => '집';

  @override
  String get categorySubscription => '구독';

  @override
  String get categorySalary => '급여';

  @override
  String get categorySideIncome => '부수입';

  @override
  String get categoryBonus => '보너스';

  @override
  String get categoryOther => '기타';

  @override
  String get paymentMethodCash => '현금';

  @override
  String get paymentMethodCard => '카드';

  @override
  String get paymentMethodBankTransfer => '계좌이체';

  @override
  String get paymentMethodMobilePay => '모바일 결제';

  @override
  String get paymentMethodOther => '기타';

  @override
  String get transactionTypeExpense => '지출';

  @override
  String get transactionTypeIncome => '수입';
}
