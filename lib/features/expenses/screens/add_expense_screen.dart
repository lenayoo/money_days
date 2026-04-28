import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/page_intro.dart';
import '../../../core/widgets/soft_section_card.dart';
import '../../../core/widgets/tone_pill.dart';
import '../../settings/controllers/settings_controller.dart';
import '../models/app_currency.dart';
import '../controllers/expenses_controller.dart';
import '../models/expense_category.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _memoController = TextEditingController();

  ExpenseCategory _selectedCategory = ExpenseCategory.food;
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;

  @override
  void dispose() {
    _amountController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(AppConstants.minimumExpenseYear),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      helpText: l10n.pickDate,
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  double? _parseAmount(String input) {
    final normalized = input.replaceAll(',', '.').trim();
    return double.tryParse(normalized);
  }

  Future<void> _saveExpense() async {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.read(settingsControllerProvider);
    final amount = _parseAmount(_amountController.text);

    if (!_formKey.currentState!.validate() || amount == null) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    await ref
        .read(expensesControllerProvider.notifier)
        .addExpense(
          amount: amount,
          category: _selectedCategory,
          date: _selectedDate,
          currency: settings.currency,
          memo: _memoController.text,
        );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.savedMessage)));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    final settings = ref.watch(settingsControllerProvider);
    final currency = settings.currency;

    return Scaffold(
      appBar: AppBar(),
      body: AppPage(
        topSafeArea: false,
        bottomSafeArea: true,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              PageIntro(
                eyebrow: AppFormatters.formatLongDate(_selectedDate, locale),
                title: l10n.addExpenseTitle,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  TonePill(
                    icon: Icons.calendar_today_rounded,
                    label: AppFormatters.formatLongDate(_selectedDate, locale),
                  ),
                  TonePill(icon: Icons.payments_outlined, label: currency.code),
                ],
              ),
              const SizedBox(height: 24),
              SoftSectionCard(
                color: AppColors.surfaceRaised,
                accentColor: AppColors.accentMuted,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.amountLabel, style: theme.textTheme.bodyMedium),
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
                        fontSize: 40,
                      ),
                      decoration: InputDecoration(
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        hintText: '0',
                        prefixText: '${currency.symbol} ',
                        suffixText: currency.code,
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
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SoftSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.categoryLabel, style: theme.textTheme.titleLarge),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        for (final category in ExpenseCategory.values)
                          ChoiceChip(
                            selected: category == _selectedCategory,
                            label: Text(category.label(l10n)),
                            avatar: Icon(
                              category.icon,
                              size: 18,
                              color: category.color,
                            ),
                            onSelected: (_) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SoftSectionCard(
                onTap: () => _pickDate(context),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceRaised,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.event_available_rounded,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.dateLabel,
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            AppFormatters.formatLongDate(_selectedDate, locale),
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SoftSectionCard(
                child: TextFormField(
                  controller: _memoController,
                  decoration: InputDecoration(
                    labelText: l10n.memoLabel,
                    hintText: l10n.memoHint,
                  ),
                  maxLength: 60,
                  maxLines: 2,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _isSaving ? null : _saveExpense,
                icon:
                    _isSaving
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Icon(Icons.check_rounded),
                label: Text(l10n.saveButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
