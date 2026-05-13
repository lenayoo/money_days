import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_clock.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/round_icon_button.dart';
import '../../settings/controllers/settings_controller.dart';
import '../controllers/expenses_controller.dart';
import '../models/app_currency.dart';
import '../models/expense.dart';
import '../models/expense_category.dart';
import '../models/payment_method.dart';
import '../models/transaction_type.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key, this.expense});

  final Expense? expense;

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  static const _maxAmountDigits = 7;
  static const _maxMemoLength = 20;

  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _memoController = TextEditingController();

  TransactionType _selectedType = TransactionType.expense;
  late ExpenseCategory _selectedCategory;
  PaymentMethod _selectedPaymentMethod = PaymentMethod.card;
  DateTime _selectedDate = AppClock.now();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final existingExpense = widget.expense;
    if (existingExpense == null) {
      _selectedCategory = expenseCategoriesForType(_selectedType).first;
      return;
    }

    _selectedType = existingExpense.type;
    final categories = expenseCategoriesForType(_selectedType);
    _selectedCategory =
        categories.contains(existingExpense.category)
            ? existingExpense.category
            : categories.first;
    _selectedPaymentMethod =
        existingExpense.paymentMethod ?? PaymentMethod.card;
    _selectedDate = existingExpense.date;
    _amountController.text = _formatEditableAmount(
      existingExpense.amount,
      existingExpense.currency,
    );
    _memoController.text = existingExpense.memo ?? '';
  }

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
      lastDate: AppClock.now().add(const Duration(days: 3650)),
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

  void _changeType(TransactionType type) {
    final categories = expenseCategoriesForType(type);

    setState(() {
      _selectedType = type;
      if (!categories.contains(_selectedCategory)) {
        _selectedCategory = categories.first;
      }
    });
  }

  Future<void> _saveTransaction() async {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.read(settingsControllerProvider);
    final activeCurrency = widget.expense?.currency ?? settings.currency;
    final amount = _parseAmount(_amountController.text);

    if (!_formKey.currentState!.validate() || amount == null) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final controller = ref.read(expensesControllerProvider.notifier);
    if (widget.expense case final expense?) {
      await controller.updateTransaction(
        id: expense.id,
        type: _selectedType,
        amount: amount,
        category: _selectedCategory,
        date: _selectedDate,
        currency: activeCurrency,
        paymentMethod: _selectedPaymentMethod,
        memo: _memoController.text,
      );
    } else {
      await controller.addTransaction(
        type: _selectedType,
        amount: amount,
        category: _selectedCategory,
        date: _selectedDate,
        currency: activeCurrency,
        paymentMethod: _selectedPaymentMethod,
        memo: _memoController.text,
      );
    }

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.expense == null
              ? l10n.transactionSavedMessage
              : l10n.transactionUpdatedMessage,
        ),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    final settings = ref.watch(settingsControllerProvider);
    final currency = widget.expense?.currency ?? settings.currency;
    final categories = expenseCategoriesForType(_selectedType);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AppPage(
        maxWidth: 560,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            children: [
              Row(
                children: [
                  RoundIconButton(
                    icon: Icons.close_rounded,
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  const Spacer(),
                  RoundIconButton(
                    icon:
                        _isSaving
                            ? Icons.more_horiz_rounded
                            : Icons.check_rounded,
                    onPressed: _isSaving ? null : _saveTransaction,
                  ),
                ],
              ),
              const SizedBox(height: 26),
              Center(
                child: SegmentedButton<TransactionType>(
                  segments: [
                    ButtonSegment(
                      value: TransactionType.expense,
                      label: Text(l10n.transactionTypeExpense),
                    ),
                    ButtonSegment(
                      value: TransactionType.income,
                      label: Text(l10n.transactionTypeIncome),
                    ),
                  ],
                  selected: {_selectedType},
                  onSelectionChanged: (selection) {
                    _changeType(selection.first);
                  },
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _pickDate(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppFormatters.formatDayWithWeekday(
                            _selectedDate,
                            locale,
                          ),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: SizedBox(
                  width: 220,
                  child: TextFormField(
                    controller: _amountController,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                      _DigitCountLimitingTextInputFormatter(_maxAmountDigits),
                    ],
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontSize: 42,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      prefixText: currency.symbol,
                      prefixStyle: theme.textTheme.displaySmall?.copyWith(
                        fontSize: 42,
                        color: AppColors.textPrimary,
                      ),
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
                ),
              ),
              const SizedBox(height: 22),
              Text(
                l10n.paymentMethodLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final method in PaymentMethod.values) ...[
                      _PaymentMethodChip(
                        label: method.label(l10n),
                        selected: method == _selectedPaymentMethod,
                        onTap: () {
                          setState(() {
                            _selectedPaymentMethod = method;
                          });
                        },
                      ),
                      if (method != PaymentMethod.values.last)
                        const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 26),
              Container(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.categoryLabel,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: categories.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.82,
                          ),
                      itemBuilder: (context, index) {
                        final category = categories[index];

                        return _CategoryGridItem(
                          category: category,
                          label: category.label(l10n),
                          selected: category == _selectedCategory,
                          isIncome: _selectedType.isIncome,
                          onTap: () {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l10n.memoLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _memoController,
                      decoration: InputDecoration(
                        hintText: l10n.memoHint,
                        filled: false,
                        fillColor: Colors.transparent,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        counterText: '',
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(_maxMemoLength),
                      ],
                      maxLength: _maxMemoLength,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      buildCounter:
                          (
                            context, {
                            required currentLength,
                            required isFocused,
                            required maxLength,
                          }) => null,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatEditableAmount(double amount, AppCurrency currency) {
  final fixedAmount = amount.toStringAsFixed(currency.decimalDigits);
  if (!fixedAmount.contains('.')) {
    return fixedAmount;
  }

  return fixedAmount
      .replaceFirst(RegExp(r'0+$'), '')
      .replaceFirst(RegExp(r'\.$'), '');
}

class _DigitCountLimitingTextInputFormatter extends TextInputFormatter {
  const _DigitCountLimitingTextInputFormatter(this.maxDigits);

  final int maxDigits;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digitCount = 0;
    final buffer = StringBuffer();

    for (final character in newValue.text.split('')) {
      final isDigit = RegExp(r'\d').hasMatch(character);
      if (isDigit) {
        if (digitCount >= maxDigits) {
          continue;
        }
        digitCount += 1;
      }
      buffer.write(character);
    }

    final limitedText = buffer.toString();
    if (limitedText == newValue.text) {
      return newValue;
    }

    final selectionOffset =
        newValue.selection.baseOffset > limitedText.length
            ? limitedText.length
            : newValue.selection.baseOffset;

    return TextEditingValue(
      text: limitedText,
      selection: TextSelection.collapsed(offset: selectionOffset),
    );
  }
}

class _PaymentMethodChip extends StatelessWidget {
  const _PaymentMethodChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.accentMuted : AppColors.surface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected ? AppColors.accent : AppColors.border,
            ),
          ),
          child: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color:
                  selected ? AppColors.accentStrong : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryGridItem extends StatelessWidget {
  const _CategoryGridItem({
    required this.category,
    required this.label,
    required this.selected,
    required this.isIncome,
    required this.onTap,
  });

  final ExpenseCategory category;
  final String label;
  final bool selected;
  final bool isIncome;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = isIncome ? AppColors.income : category.color;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color:
                selected
                    ? (isIncome ? AppColors.incomeSoft : category.surfaceColor)
                    : AppColors.surfaceRaised,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
                  selected ? accent.withValues(alpha: 0.5) : AppColors.border,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color:
                      selected
                          ? Colors.white.withValues(alpha: 0.85)
                          : AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(category.icon, color: accent, size: 20),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
