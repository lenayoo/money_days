import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_clock.dart';
import '../../../core/utils/app_date_utils.dart';
import 'app_currency.dart';
import 'expense.dart';
import 'expense_category.dart';
import 'transaction_type.dart';

class CategorySpending {
  const CategorySpending({
    required this.category,
    required this.totalInBaseCurrency,
    required this.share,
    required this.count,
  });

  final ExpenseCategory category;
  final double totalInBaseCurrency;
  final double share;
  final int count;

  double totalForCurrency(AppCurrency currency) {
    return currency.fromBaseAmount(totalInBaseCurrency);
  }
}

class CategoryTrendPoint {
  const CategoryTrendPoint({
    required this.date,
    required this.totalInBaseCurrency,
  });

  final DateTime date;
  final double totalInBaseCurrency;

  double totalForCurrency(AppCurrency currency) {
    return currency.fromBaseAmount(totalInBaseCurrency);
  }
}

class CalendarDaySummary {
  const CalendarDaySummary({
    required this.date,
    required this.incomeInBaseCurrency,
    required this.expenseInBaseCurrency,
  });

  final DateTime date;
  final double incomeInBaseCurrency;
  final double expenseInBaseCurrency;

  bool get hasActivity => incomeInBaseCurrency > 0 || expenseInBaseCurrency > 0;

  double incomeForCurrency(AppCurrency currency) {
    return currency.fromBaseAmount(incomeInBaseCurrency);
  }

  double expenseForCurrency(AppCurrency currency) {
    return currency.fromBaseAmount(expenseInBaseCurrency);
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
    return totalExpenseInBaseForDay(expenses, date);
  }

  static double totalExpenseInBaseForDay(
    List<Expense> expenses,
    DateTime date,
  ) {
    return _sumBaseAmounts(
      expenses.where(
        (expense) =>
            expense.isExpense && AppDateUtils.isSameDay(expense.date, date),
      ),
    );
  }

  static double totalIncomeInBaseForDay(List<Expense> expenses, DateTime date) {
    return _sumBaseAmounts(
      expenses.where(
        (expense) =>
            expense.isIncome && AppDateUtils.isSameDay(expense.date, date),
      ),
    );
  }

  static double totalInBaseForMonth(List<Expense> expenses, DateTime date) {
    return totalExpenseInBaseForMonth(expenses, date);
  }

  static double totalExpenseInBaseForMonth(
    List<Expense> expenses,
    DateTime date,
  ) {
    return _sumBaseAmounts(
      expenses.where(
        (expense) =>
            expense.isExpense && AppDateUtils.isSameMonth(expense.date, date),
      ),
    );
  }

  static double totalIncomeInBaseForMonth(
    List<Expense> expenses,
    DateTime date,
  ) {
    return _sumBaseAmounts(
      expenses.where(
        (expense) =>
            expense.isIncome && AppDateUtils.isSameMonth(expense.date, date),
      ),
    );
  }

  static List<Expense> expensesForMonth(List<Expense> expenses, DateTime date) {
    final monthlyExpenses = expenses
        .where(
          (expense) =>
              expense.isExpense && AppDateUtils.isSameMonth(expense.date, date),
        )
        .toList(growable: false);

    return sorted(monthlyExpenses);
  }

  static List<Expense> transactionsForMonth(
    List<Expense> expenses,
    DateTime date,
  ) {
    final monthlyTransactions = expenses
        .where((expense) => AppDateUtils.isSameMonth(expense.date, date))
        .toList(growable: false);

    return sorted(monthlyTransactions);
  }

  static List<Expense> transactionsForDay(List<Expense> expenses, DateTime date) {
    final dailyTransactions = expenses
        .where((expense) => AppDateUtils.isSameDay(expense.date, date))
        .toList(growable: false);

    return sorted(dailyTransactions);
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
    return sorted(
      expenses.where((expense) => expense.isExpense).toList(),
    ).take(limit).toList(growable: false);
  }

  static List<Expense> recentTransactions(
    List<Expense> expenses, {
    int limit = AppConstants.recentExpenseCount,
  }) {
    return sorted(expenses).take(limit).toList(growable: false);
  }

  static List<CalendarDaySummary> dailyTotalsForMonth(
    List<Expense> expenses,
    DateTime date,
  ) {
    final month = AppDateUtils.startOfMonth(date);
    final incomeTotals = <DateTime, double>{};
    final expenseTotals = <DateTime, double>{};

    for (final expense in expenses) {
      if (!AppDateUtils.isSameMonth(expense.date, month)) {
        continue;
      }

      final day = AppDateUtils.dateOnly(expense.date);
      final targetTotals =
          expense.type == TransactionType.income ? incomeTotals : expenseTotals;

      targetTotals.update(
        day,
        (value) => value + expense.amountInBaseCurrency,
        ifAbsent: () => expense.amountInBaseCurrency,
      );
    }

    final summaries = <CalendarDaySummary>[];
    final nextMonth = DateTime(month.year, month.month + 1);
    var cursor = month;

    while (cursor.isBefore(nextMonth)) {
      final day = AppDateUtils.dateOnly(cursor);
      summaries.add(
        CalendarDaySummary(
          date: day,
          incomeInBaseCurrency: incomeTotals[day] ?? 0,
          expenseInBaseCurrency: expenseTotals[day] ?? 0,
        ),
      );
      cursor = DateTime(cursor.year, cursor.month, cursor.day + 1);
    }

    return summaries;
  }

  static List<CategorySpending> categoryTotalsForMonth(
    List<Expense> expenses,
    DateTime date,
  ) {
    return categoryTotalsForMonthByType(expenses, date, TransactionType.expense);
  }

  static List<CategorySpending> categoryTotalsForMonthByType(
    List<Expense> expenses,
    DateTime date,
    TransactionType type,
  ) {
    final monthlyExpenses = expenses.where(
      (expense) =>
          expense.type == type && AppDateUtils.isSameMonth(expense.date, date),
    );

    final totals = <ExpenseCategory, double>{};
    final counts = <ExpenseCategory, int>{};
    for (final expense in monthlyExpenses) {
      totals.update(
        expense.category,
        (value) => value + expense.amountInBaseCurrency,
        ifAbsent: () => expense.amountInBaseCurrency,
      );
      counts.update(expense.category, (value) => value + 1, ifAbsent: () => 1);
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
                count: counts[entry.key] ?? 0,
              ),
            )
            .toList()
          ..sort(
            (left, right) =>
                right.totalInBaseCurrency.compareTo(left.totalInBaseCurrency),
          );

    return breakdown;
  }

  static List<CategoryTrendPoint> categoryTrendForMonth(
    List<Expense> expenses,
    DateTime date,
    ExpenseCategory category,
  ) {
    final month = AppDateUtils.startOfMonth(date);
    final totalsByDay = <DateTime, double>{};

    for (final expense in expenses) {
      if (!AppDateUtils.isSameMonth(expense.date, month) ||
          !expense.isExpense ||
          expense.category != category) {
        continue;
      }

      final day = AppDateUtils.dateOnly(expense.date);
      totalsByDay.update(
        day,
        (value) => value + expense.amountInBaseCurrency,
        ifAbsent: () => expense.amountInBaseCurrency,
      );
    }

    final nextMonth = DateTime(month.year, month.month + 1);
    final points = <CategoryTrendPoint>[];
    var cursor = month;

    while (cursor.isBefore(nextMonth)) {
      final day = AppDateUtils.dateOnly(cursor);
      points.add(
        CategoryTrendPoint(
          date: day,
          totalInBaseCurrency: totalsByDay[day] ?? 0,
        ),
      );
      cursor = DateTime(cursor.year, cursor.month, cursor.day + 1);
    }

    return points;
  }
}
