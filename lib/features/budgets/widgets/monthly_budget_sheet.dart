import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../core/widgets/soft_section_card.dart';
import '../../expenses/models/app_currency.dart';

Future<double?> showMonthlyBudgetSheet({
  required BuildContext context,
  required DateTime month,
  required AppCurrency currency,
  double? initialAmount,
}) {
  return showModalBottomSheet<double>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder:
        (context) => _MonthlyBudgetSheet(
          month: month,
          currency: currency,
          initialAmount: initialAmount,
        ),
  );
}

class _MonthlyBudgetSheet extends StatefulWidget {
  const _MonthlyBudgetSheet({
    required this.month,
    required this.currency,
    this.initialAmount,
  });

  final DateTime month;
  final AppCurrency currency;
  final double? initialAmount;

  @override
  State<_MonthlyBudgetSheet> createState() => _MonthlyBudgetSheetState();
}

class _MonthlyBudgetSheetState extends State<_MonthlyBudgetSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.initialAmount?.toStringAsFixed(
        widget.currency.decimalDigits,
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double? _parseAmount(String input) {
    final normalized = input.replaceAll(',', '.').trim();
    return double.tryParse(normalized);
  }

  void _save() {
    final amount = _parseAmount(_amountController.text);

    if (!_formKey.currentState!.validate() || amount == null) {
      return;
    }

    Navigator.of(context).pop(amount);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final theme = Theme.of(context);
    final title =
        widget.initialAmount == null
            ? l10n.setThisMonthBudget
            : l10n.editBudget;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: SoftSectionCard(
            color: AppColors.surface,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  AppFormatters.formatMonthLabel(widget.month, locale),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(l10n.monthlyBudget, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _amountController,
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 38,
                  ),
                  decoration: InputDecoration(
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    hintText: '0',
                    prefixText: '${widget.currency.symbol} ',
                    suffixText: widget.currency.code,
                    contentPadding: EdgeInsets.zero,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.validationAmountRequired;
                    }

                    final parsedAmount = _parseAmount(value);
                    if (parsedAmount == null || parsedAmount <= 0) {
                      return l10n.validationAmountInvalid;
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.check_rounded),
                  label: Text(l10n.saveButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
