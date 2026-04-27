import '../../../core/constants/app_constants.dart';
import 'expense.dart';
import 'expense_category.dart';

class CategorySpending {
  const CategorySpending({
    required this.category,
    required this.total,
    required this.share,
  });

  final ExpenseCategory category;
  final double total;
  final double share;
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

  static double totalForDay(List<Expense> expenses, DateTime date) {
    return expenses
        .where(
          (expense) =>
              expense.date.year == date.year &&
              expense.date.month == date.month &&
              expense.date.day == date.day,
        )
        .fold(0, (sum, expense) => sum + expense.amount);
  }

  static double totalForMonth(List<Expense> expenses, DateTime date) {
    return expenses
        .where(
          (expense) =>
              expense.date.year == date.year &&
              expense.date.month == date.month,
        )
        .fold(0, (sum, expense) => sum + expense.amount);
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
      (expense) =>
          expense.date.year == date.year && expense.date.month == date.month,
    );

    final totals = <ExpenseCategory, double>{};
    for (final expense in monthlyExpenses) {
      totals.update(
        expense.category,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
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
                total: entry.value,
                share: entry.value / overallTotal,
              ),
            )
            .toList()
          ..sort((left, right) => right.total.compareTo(left.total));

    return breakdown;
  }
}
