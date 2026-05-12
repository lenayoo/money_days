import 'package:flutter/material.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';

import '../theme/app_colors.dart';
import '../utils/app_formatters.dart';
import 'soft_section_card.dart';

Future<DateTime?> showMonthPickerSheet({
  required BuildContext context,
  required List<DateTime> months,
  required DateTime selectedMonth,
}) {
  return showModalBottomSheet<DateTime>(
    context: context,
    backgroundColor: Colors.transparent,
    builder:
        (context) =>
            _MonthPickerSheet(months: months, selectedMonth: selectedMonth),
  );
}

class _MonthPickerSheet extends StatelessWidget {
  const _MonthPickerSheet({required this.months, required this.selectedMonth});

  final List<DateTime> months;
  final DateTime selectedMonth;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: SafeArea(
        top: false,
        child: SoftSectionCard(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.selectMonth, style: theme.textTheme.titleLarge),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: months.length,
                    separatorBuilder:
                        (_, __) =>
                            const Divider(height: 1, color: AppColors.border),
                    itemBuilder: (context, index) {
                      final month = months[index];
                      final isSelected =
                          month.year == selectedMonth.year &&
                          month.month == selectedMonth.month;

                      return ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        onTap: () => Navigator.of(context).pop(month),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        tileColor:
                            isSelected
                                ? AppColors.surfaceMuted
                                : Colors.transparent,
                        title: Text(
                          AppFormatters.formatMonthLabel(month, locale),
                          style: theme.textTheme.titleMedium,
                        ),
                        trailing:
                            isSelected
                                ? const Icon(
                                  Icons.check_rounded,
                                  size: 18,
                                  color: AppColors.textPrimary,
                                )
                                : null,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
