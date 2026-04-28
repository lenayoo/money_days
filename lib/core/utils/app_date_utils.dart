class AppDateUtils {
  const AppDateUtils._();

  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month);
  }

  static bool isSameDay(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }

  static bool isSameMonth(DateTime left, DateTime right) {
    return left.year == right.year && left.month == right.month;
  }

  static String monthKey(DateTime date) {
    final normalizedDate = startOfMonth(date);
    final year = normalizedDate.year.toString().padLeft(4, '0');
    final month = normalizedDate.month.toString().padLeft(2, '0');
    return '$year-$month';
  }

  static DateTime monthFromKey(String key) {
    final parts = key.split('-');
    if (parts.length != 2) {
      return startOfMonth(DateTime.now());
    }

    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    if (year == null || month == null || month < 1 || month > 12) {
      return startOfMonth(DateTime.now());
    }

    return DateTime(year, month);
  }

  static List<DateTime> monthsInRange(DateTime start, DateTime end) {
    final firstMonth = startOfMonth(start);
    final lastMonth = startOfMonth(end);

    if (firstMonth.isAfter(lastMonth)) {
      return const [];
    }

    final months = <DateTime>[];
    var cursor = firstMonth;
    while (!cursor.isAfter(lastMonth)) {
      months.add(cursor);
      cursor = DateTime(cursor.year, cursor.month + 1);
    }

    return months;
  }
}
