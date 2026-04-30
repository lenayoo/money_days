import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_clock.dart';
import '../../../core/utils/app_date_utils.dart';
import 'app_currency.dart';
import 'expense.dart';
import 'expense_category.dart';

class CategorySpending {
  const CategorySpending({
    required this.category,
    required this.totalInBaseCurrency,
    required this.share,
  });

  final ExpenseCategory category;
  final double totalInBaseCurrency;
  final double share;

  double totalForCurrency(AppCurrency currency) {
    return currency.fromBaseAmount(totalInBaseCurrency);
  }
}

class ExpenseInsights {
  const ExpenseInsights._();

  static List<Expense> sorted(List<Expense> expenses) {
    final sortedExpenses = [...expenses]..sort((left, right) {
      final byDate = right.date.compareTo(left.date);
      if (byDate != 0) {
        return byDate;
      }
      return right.createdAt.compareTo(left.createdAt);
    });
    return sortedExpenses;
  }

  static double totalInBaseForDay(List<Expense> expenses, DateTime date) {
    return _sumBaseAmounts(
      expenses.where((expense) => AppDateUtils.isSameDay(expense.date, date)),
    );
  }

  static double totalInBaseForMonth(List<Expense> expenses, DateTime date) {
    return _sumBaseAmounts(
      expenses.where((expense) => AppDateUtils.isSameMonth(expense.date, date)),
    );
  }

  static List<Expense> expensesForMonth(List<Expense> expenses, DateTime date) {
    final monthlyExpenses = expenses
        .where((expense) => AppDateUtils.isSameMonth(expense.date, date))
        .toList(growable: false);

    return sorted(monthlyExpenses);
  }

  static List<DateTime> availableMonths(
    List<Expense> expenses, {
    Iterable<DateTime> budgetMonths = const [],
    DateTime? anchorMonth,
  }) {
    final normalizedMonths = <DateTime>[
      AppDateUtils.startOfMonth(anchorMonth ?? AppClock.now()),
      ...expenses.map((expense) => AppDateUtils.startOfMonth(expense.date)),
      ...budgetMonths.map(AppDateUtils.startOfMonth),
    ];

    if (normalizedMonths.isEmpty) {
      return const [];
    }

    DateTime earliestMonth = normalizedMonths.first;
    DateTime latestMonth = normalizedMonths.first;

    for (final month in normalizedMonths.skip(1)) {
      if (month.isBefore(earliestMonth)) {
        earliestMonth = month;
      }
      if (month.isAfter(latestMonth)) {
        latestMonth = month;
      }
    }

    return AppDateUtils.monthsInRange(
      earliestMonth,
      latestMonth,
    ).reversed.toList(growable: false);
  }

  static double _sumBaseAmounts(Iterable<Expense> expenses) {
    return expenses.fold(
      0.0,
      (sum, expense) => sum + expense.amountInBaseCurrency,
    );
  }

  static List<Expense> recentExpenses(
    List<Expense> expenses, {
    int limit = AppConstants.recentExpenseCount,
  }) {
    return sorted(expenses).take(limit).toList(growable: false);
  }

  static List<CategorySpending> categoryTotalsForMonth(
    List<Expense> expenses,
    DateTime date,
  ) {
    final monthlyExpenses = expenses.where(
      (expense) => AppDateUtils.isSameMonth(expense.date, date),
    );

    final totals = <ExpenseCategory, double>{};
    for (final expense in monthlyExpenses) {
      totals.update(
        expense.category,
        (value) => value + expense.amountInBaseCurrency,
        ifAbsent: () => expense.amountInBaseCurrency,
      );
    }

    final overallTotal = totals.values.fold(0.0, (sum, amount) => sum + amount);
    if (overallTotal == 0) {
      return const [];
    }

    final breakdown =
        totals.entries
            .map(
              (entry) => CategorySpending(
                category: entry.key,
                totalInBaseCurrency: entry.value,
                share: entry.value / overallTotal,
              ),
            )
            .toList()
          ..sort(
            (left, right) =>
                right.totalInBaseCurrency.compareTo(left.totalInBaseCurrency),
          );

    return breakdown;
  }
}
