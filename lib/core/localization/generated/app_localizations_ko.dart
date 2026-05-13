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
  String get premiumTitle => 'Money Days Premium';

  @override
  String get premiumSubtitle => '예산과 분석을 조용히 더해 주는 작은 업그레이드예요.';

  @override
  String get premiumActiveSubtitle => '이 기기에서 Premium을 사용할 수 있어요.';

  @override
  String get premiumReadyOnDevice => '이 기기에서 Premium을 사용할 수 있어요.';

  @override
  String get premiumActiveLabel => 'Premium 사용 중';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get premiumOneTimePurchase => '1회 구매';

  @override
  String get premiumUnlockButton => 'Premium 열기';

  @override
  String get premiumOpeningStore => '스토어를 여는 중...';

  @override
  String get premiumRestoreButton => '구매 복원';

  @override
  String get premiumRestoring => '구매를 확인하는 중...';

  @override
  String get premiumRestoreStartedMessage => '이전 구매를 확인하고 있어요.';

  @override
  String get premiumAlreadyActiveMessage => 'Premium이 이미 활성화되어 있어요.';

  @override
  String get premiumStoreUnavailableMessage => '스토어가 아직 준비되지 않았어요.';

  @override
  String get premiumProductUnavailableMessage => 'Premium 상품을 스토어에서 준비 중이에요.';

  @override
  String get premiumActionFailedMessage => '지금은 Premium을 열 수 없었어요.';

  @override
  String get premiumFeatureBudgetTitle => '월 예산';

  @override
  String get premiumFeatureBudgetDescription => '월 예산을 두고 남은 금액을 차분하게 볼 수 있어요.';

  @override
  String get premiumFeaturePieChartTitle => '원형 차트 분석';

  @override
  String get premiumFeaturePieChartDescription => '카테고리 흐름을 부드러운 원형 차트로 볼 수 있어요.';

  @override
  String get premiumFeatureInsightsTitle => '지출 인사이트';

  @override
  String get premiumFeatureInsightsDescription => '지출한 날의 작은 패턴을 살펴볼 수 있어요.';

  @override
  String get premiumFeatureShareTitle => '공유 카드';

  @override
  String get premiumFeatureShareDescription => '원할 때만 차분한 월간 카드를 공유할 수 있어요.';

  @override
  String get seePremium => 'Premium 보기';

  @override
  String get doneButton => '닫기';

  @override
  String get spendingInsightsTitle => '지출 인사이트';

  @override
  String get spendingInsightsEmpty => '기록이 조금 쌓이면 작은 흐름을 볼 수 있어요.';

  @override
  String get spendingInsightTopCategory => '가장 큰 카테고리';

  @override
  String get spendingInsightDays => '지출한 날';

  @override
  String get spendingInsightDailyAverage => '하루 평균';

  @override
  String dayCount(int count) {
    return '$count일';
  }

  @override
  String get shareSummaryTitle => '요약 카드 공유';

  @override
  String get shareSummarySubtitle => '이번 달을 작은 카드로 나눠 보세요.';

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
  String get shareCardCaption => '이번 달의 조용한 기록.';

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsSubtitle => '단순하게, 이 기기 안에서만.';

  @override
  String get languageSetting => '언어';

  @override
  String get currencySetting => '통화';

  @override
  String get currencyConversionNote => '표시 환산은 USD 기준 고정 환율을 사용합니다: 1 USD = 150 JPY, 1500 KRW, 1.35 SGD.';

  @override
  String get appInfo => '앱 정보';

  @override
  String get privacyNote => '개인정보';

  @override
  String get privacyMessage => '기록은 이 기기에 저장됩니다.';

  @override
  String get appInfoMessage => 'Money Days는 일상의 돈 흐름을 조용히 남기는 캘린더예요.';

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
  String get dateLabel => '날짜';

  @override
  String get categoryLabel => '카테고리';

  @override
  String get typeLabel => '구분';

  @override
  String get paymentMethodLabel => '결제 수단';

  @override
  String get paymentMethodOptional => '선택';

  @override
  String get saveButton => '저장';

  @override
  String get pickDate => '날짜 선택';

  @override
  String get transactionSavedMessage => '저장했어요.';

  @override
  String get validationAmountRequired => '금액을 입력해 주세요.';

  @override
  String get validationAmountInvalid => '올바른 금액을 입력해 주세요.';

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
  String get categoryBonus => '보너스';

  @override
  String get categoryGift => '선물';

  @override
  String get categoryRefund => '환급';

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
