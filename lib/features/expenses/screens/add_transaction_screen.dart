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
  static const _maxAmountDigits = 10;
  static const _maxMemoLength = 20;

  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _memoController = TextEditingController();

  TransactionType _selectedType = TransactionType.expense;
  late ExpenseCategory _selectedCategory;
  PaymentMethod _selectedPaymentMethod = PaymentMethod.card;
  DateTime _selectedDate = AppClock.now();
  bool _isSaving = false;
  bool _showAmountDigitLimitMessage = false;

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

  int _amountDigitCount(String input) {
    return RegExp(r'\d').allMatches(input).length;
  }

  void _handleAmountChanged(String value) {
    if (_showAmountDigitLimitMessage &&
        _amountDigitCount(value) < _maxAmountDigits) {
      setState(() {
        _showAmountDigitLimitMessage = false;
      });
    }
  }

  void _handleAmountDigitLimitReached() {
    if (_showAmountDigitLimitMessage) {
      return;
    }

    setState(() {
      _showAmountDigitLimitMessage = true;
    });
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
        paymentMethod: _selectedType.isExpense ? _selectedPaymentMethod : null,
        memo: _memoController.text,
      );
    } else {
      await controller.addTransaction(
        type: _selectedType,
        amount: amount,
        category: _selectedCategory,
        date: _selectedDate,
        currency: activeCurrency,
        paymentMethod: _selectedType.isExpense ? _selectedPaymentMethod : null,
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
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final settings = ref.watch(settingsControllerProvider);
    final currency = widget.expense?.currency ?? settings.currency;
    final categories = expenseCategoriesForType(_selectedType);
    final activeColor =
        _selectedType.isIncome ? AppColors.income : AppColors.expense;
    final activeSoftColor =
        _selectedType.isIncome ? AppColors.incomeSoft : AppColors.expenseSoft;
    final activeBorderColor = activeColor.withValues(alpha: 0.34);
    final categoryChildAspectRatio =
        categories.length > 4
            ? (textScale > 1.05 ? 0.68 : 0.74)
            : (textScale > 1.05 ? 0.78 : 0.86);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AppPage(
        maxWidth: 560,
        child: Form(
          key: _formKey,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(20, 20, 20, viewInsets.bottom + 32),
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
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return activeColor;
                      }
                      return AppColors.surfaceMuted;
                    }),
                    foregroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.white;
                      }
                      return AppColors.textPrimary;
                    }),
                    side: const WidgetStatePropertyAll(
                      BorderSide(color: AppColors.border),
                    ),
                    padding: const WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    textStyle: const WidgetStatePropertyAll(
                      TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
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
              TextFormField(
                controller: _amountController,
                autofocus: true,
                onChanged: _handleAmountChanged,
                cursorColor: activeColor,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  _DigitCountLimitingTextInputFormatter(
                    _maxAmountDigits,
                    onLimitReached: _handleAmountDigitLimitReached,
                  ),
                ],
                style: theme.textTheme.displaySmall?.copyWith(
                  fontSize: 42,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  labelText: l10n.amountLabel,
                  labelStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  floatingLabelStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: activeColor,
                    fontWeight: FontWeight.w600,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  alignLabelWithHint: true,
                  prefixText: '${currency.symbol} ',
                  prefixStyle: theme.textTheme.displaySmall?.copyWith(
                    fontSize: 42,
                    color: AppColors.textPrimary,
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.fromLTRB(12, 16, 12, 18),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.borderStrong),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: activeColor, width: 1.6),
                  ),
                  errorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.expense,
                      width: 1.2,
                    ),
                  ),
                  focusedErrorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.expense,
                      width: 1.6,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.validationAmountRequired;
                  }

                  if (_amountDigitCount(value) > _maxAmountDigits) {
                    return l10n.amountDigitLimitMessage(_maxAmountDigits);
                  }

                  final parsedAmount = _parseAmount(value);
                  if (parsedAmount == null || parsedAmount <= 0) {
                    return l10n.validationAmountInvalid;
                  }

                  return null;
                },
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 160),
                child:
                    _showAmountDigitLimitMessage
                        ? Padding(
                          key: const ValueKey('amount-digit-limit-message'),
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            l10n.amountDigitLimitMessage(_maxAmountDigits),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: activeColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                        : const SizedBox.shrink(),
              ),
              if (_selectedType.isExpense) ...[
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
                          activeColor: activeColor,
                          activeSoftColor: activeSoftColor,
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
              ],
              const SizedBox(height: 26),
              Container(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: activeBorderColor),
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
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 14,
                        childAspectRatio: categoryChildAspectRatio,
                      ),
                      itemBuilder: (context, index) {
                        final category = categories[index];

                        return _CategoryGridItem(
                          category: category,
                          label: category.label(l10n),
                          selected: category == _selectedCategory,
                          activeColor: activeColor,
                          activeSoftColor: activeSoftColor,
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
  _DigitCountLimitingTextInputFormatter(
    this.maxDigits, {
    required this.onLimitReached,
  });

  final int maxDigits;
  final VoidCallback onLimitReached;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digitCount = 0;
    var limitReached = false;
    final buffer = StringBuffer();

    for (final character in newValue.text.split('')) {
      final isDigit = RegExp(r'\d').hasMatch(character);
      if (isDigit) {
        if (digitCount >= maxDigits) {
          limitReached = true;
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

    if (limitReached) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onLimitReached();
      });
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
    required this.activeColor,
    required this.activeSoftColor,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color activeColor;
  final Color activeSoftColor;
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
            color: selected ? activeSoftColor : AppColors.surface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color:
                  selected
                      ? activeColor.withValues(alpha: 0.45)
                      : AppColors.border,
            ),
          ),
          child: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: selected ? activeColor : AppColors.textSecondary,
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
    required this.activeColor,
    required this.activeSoftColor,
    required this.onTap,
  });

  final ExpenseCategory category;
  final String label;
  final bool selected;
  final Color activeColor;
  final Color activeSoftColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = selected ? activeColor : category.color;
    final textScale = MediaQuery.textScalerOf(context).scale(1);

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 92 || textScale > 1.05;
        final iconSize = compact ? 34.0 : 40.0;
        final iconRadius = compact ? 12.0 : 14.0;
        final iconGlyphSize = compact ? 18.0 : 20.0;
        final verticalPadding = compact ? 8.0 : 10.0;
        final labelGap = compact ? 8.0 : 10.0;
        final labelStyle = theme.textTheme.bodySmall?.copyWith(
          fontSize: compact ? 11 : null,
          color: selected ? accent : AppColors.textSecondary,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
        );

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Ink(
              padding: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: verticalPadding,
              ),
              decoration: BoxDecoration(
                color: selected ? activeSoftColor : AppColors.surfaceRaised,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      selected
                          ? accent.withValues(alpha: 0.5)
                          : AppColors.border,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: iconSize,
                    height: iconSize,
                    decoration: BoxDecoration(
                      color:
                          selected
                              ? Colors.white.withValues(alpha: 0.85)
                              : AppColors.surface,
                      borderRadius: BorderRadius.circular(iconRadius),
                    ),
                    child: Icon(
                      category.icon,
                      color: accent,
                      size: iconGlyphSize,
                    ),
                  ),
                  SizedBox(height: labelGap),
                  Expanded(
                    child: Center(
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: labelStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
