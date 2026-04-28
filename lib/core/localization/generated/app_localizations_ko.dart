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
  String get homeSubtitle => '돈의 흐름을 차분하게 돌아보세요.';

  @override
  String get todaySpending => '오늘 합계';

  @override
  String get monthSpending => '이번 달 누적';

  @override
  String get monthlyBudget => '월 예산';

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
  String get addExpenseSubtitle => '오늘의 작은 기록 하나.';

  @override
  String get addTodaySpending => '오늘 지출 추가';

  @override
  String get recentExpenses => '최근 기록';

  @override
  String get emptyRecentExpenses => '최근 기록이 여기에 표시됩니다.';

  @override
  String get monthlyReviewTitle => '월간 돌아보기';

  @override
  String get monthlyReviewSubtitle => '이번 달 돈의 흐름을 부드럽게 살펴보세요.';

  @override
  String get monthlyTotal => '이번 달 합계';

  @override
  String get selectMonth => '월 선택';

  @override
  String get categoryBreakdown => '카테고리별';

  @override
  String get expenseListTitle => '지출 목록';

  @override
  String get noReviewData => '이번 달에 기록된 지출이 아직 없어요.';

  @override
  String topCategoryMessage(String category) {
    return '이번 달에는 $category 지출이 가장 많았어요.';
  }

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsSubtitle => '단순하고, 조용하게 유지하세요.';

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
  String get appInfoMessage => 'Money Days는 일상의 지출을 차분하게 적어 두는 앱입니다.';

  @override
  String get addExpenseTitle => '지출 추가';

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
  String get saveButton => '저장';

  @override
  String get pickDate => '날짜 선택';

  @override
  String get savedMessage => '오늘 기록했어요.';

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
  String get categoryOther => '기타';
}
