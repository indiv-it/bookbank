import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bookbank/data/database.dart';
import 'package:bookbank/data/db_helper.dart';

import 'package:bookbank/features/add_transaction/widgets/type_selector.dart';
import 'package:bookbank/features/add_transaction/widgets/position_selector.dart';
import 'package:bookbank/features/add_transaction/widgets/category_selector.dart';
import 'package:bookbank/core/theme/app_theme.dart';

class AddTransactionScreen extends StatefulWidget {
  final MyData? existingItem;

  const AddTransactionScreen({super.key, this.existingItem});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  num _number = 0;
  DateTime? selectedDate;
  String? selectedOption = 'Expense';
  String? selectedType = 'Bank';
  String? selectedGroup;
  String? _amountError;
  bool _isTransferMode = false;
  String _transferFrom = 'Bank';
  String _transferTo = 'Cash';

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    if (widget.existingItem != null) {
      _number = widget.existingItem!.amount;
      selectedOption = widget.existingItem!.moneyType == 'income'
          ? 'Income'
          : 'Expense';
      selectedType = widget.existingItem!.moneyList == 'bank' ? 'Bank' : 'Cash';
      selectedGroup = widget.existingItem!.moneyGroup.isEmpty
          ? null
          : widget.existingItem!.moneyGroup;
      _amountController.text = _number.toString();
      _titleController.text = widget.existingItem!.title ?? '';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, size: 16),
            const SizedBox(width: 4),
            Text(
              'Add List',
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Form
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount Input
              Text(
                'Amount',
                style: textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                  color: theme.colorScheme.surface,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Text('฿', style: textTheme.bodyMedium),
                    Expanded(
                      child: TextFormField(
                        controller: _amountController,
                        style: textTheme.bodySmall,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: '00.00',
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelStyle: textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _amountError = value.isEmpty
                                ? '*Please enter an amount'
                                : null;
                          });
                        },
                        onSaved: (value) {
                          if (value != null && value.isNotEmpty) {
                            _number = num.tryParse(value) ?? 0;
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.autorenew_rounded, size: AppSize.xl),
                      onPressed: () {
                        setState(() {
                          _isTransferMode = !_isTransferMode;
                          if (_isTransferMode) {
                            _transferFrom = selectedType ?? 'Bank';
                            _transferTo = _transferFrom == 'Bank'
                                ? 'Cash'
                                : 'Bank';
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              if (_amountError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _amountError!,
                    style: textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              if (_isTransferMode) ...[
                // Transfer UI
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _transferFrom,
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Icon(
                            Icons.arrow_forward,
                            size: 20,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        Text(
                          _transferTo,
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.border,
                              width: 1,
                            ),
                            color: AppColors.card,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FilledButton(
                                onPressed: () {
                                  setState(() {
                                    _transferFrom = 'Bank';
                                    _transferTo = 'Cash';
                                  });
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: _transferFrom == 'Bank'
                                      ? AppColors.black
                                      : AppColors.card,
                                  foregroundColor: _transferFrom == 'Bank'
                                      ? AppColors.card
                                      : AppColors.black,
                                  minimumSize: const Size(145, 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('Bank'),
                              ),
                              const SizedBox(width: 10),
                              FilledButton(
                                onPressed: () {
                                  setState(() {
                                    _transferFrom = 'Cash';
                                    _transferTo = 'Bank';
                                  });
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: _transferFrom == 'Cash'
                                      ? AppColors.black
                                      : AppColors.card,
                                  foregroundColor: _transferFrom == 'Cash'
                                      ? AppColors.card
                                      : AppColors.black,
                                  minimumSize: const Size(145, 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('Cash'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ] else ...[
                // Title and Date
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Title',
                            style: textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.border),
                              color: theme.colorScheme.surface,
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                Icon(
                                  Icons.text_fields,
                                  size: 16,
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _titleController,
                                    style: textTheme.bodySmall,
                                    decoration: InputDecoration(
                                      labelText: 'Title',
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      labelStyle: textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.5),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  icon: const Icon(Icons.arrow_drop_down),
                                  offset: const Offset(70, 50),
                                  color: theme.colorScheme.surface,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  onSelected: (String value) {
                                    setState(() {
                                      _titleController.text = value;
                                    });
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return [
                                          'Food',
                                          'Transport',
                                          'Shopping',
                                          'Bills',
                                          'Entertainment',
                                        ]
                                        .map(
                                          (item) => PopupMenuItem<String>(
                                            value: item,
                                            child: Text(item),
                                          ),
                                        )
                                        .toList();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date',
                          style: textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => _selectDate(context),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 48,
                            width: 140,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.circular(10),
                              color: theme.colorScheme.surface,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedDate != null
                                      ? _formatDate(selectedDate!)
                                      : 'Select',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: selectedDate != null
                                        ? theme.colorScheme.onSurface
                                        : theme.colorScheme.onSurface
                                              .withValues(alpha: 0.5),
                                  ),
                                ),
                                Icon(
                                  Icons.calendar_today,
                                  size: 18,
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                TypeSelector(
                  selectedType: selectedOption,
                  onChanged: (val) => setState(() => selectedOption = val),
                ),
                const SizedBox(height: 20),

                PositionSelector(
                  selectedPosition: selectedType,
                  onChanged: (val) => setState(() => selectedType = val),
                ),
                const SizedBox(height: 20),

                CategorySelector(
                  selectedGroup: selectedGroup,
                  onChanged: (val) => setState(() => selectedGroup = val),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 30),

        // Save Button
        FilledButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;

            if (_amountController.text.isEmpty) {
              setState(() {
                _amountError = '*Please enter an amount';
              });
              return;
            }

            _formKey.currentState!.save();

            if (_isTransferMode) {
              final dateStr = DateFormat(
                'yyyy-MM-dd',
              ).format(selectedDate ?? DateTime.now());
              final expenseItem = MyData(
                amount: _number,
                moneyType: 'transfer',
                moneyList: _transferFrom == 'Bank' ? 'bank' : 'cash',
                moneyGroup: 'Transfer',
                date: dateStr,
                title: 'Transfer to $_transferTo',
              );
              final incomeItem = MyData(
                amount: _number,
                moneyType: 'transfer',
                moneyList: _transferTo == 'Bank' ? 'bank' : 'cash',
                moneyGroup: 'Transfer',
                date: dateStr,
                title: 'Transfer from $_transferFrom',
              );
              await DatabaseHelper.instance.insertData(expenseItem);
              await DatabaseHelper.instance.insertData(incomeItem);
            } else {
              final newItem = MyData(
                id: widget.existingItem?.id,
                amount: _number,
                moneyType: selectedOption == 'Income' ? 'income' : 'expense',
                moneyList: selectedType == 'Bank' ? 'bank' : 'cash',
                moneyGroup: selectedGroup ?? '',
                date: DateFormat(
                  'yyyy-MM-dd',
                ).format(selectedDate ?? DateTime.now()),
                title: _titleController.text.isNotEmpty
                    ? _titleController.text
                    : 'Anonymous',
              );
              if (widget.existingItem == null) {
                await DatabaseHelper.instance.insertData(newItem);
              } else {
                await DatabaseHelper.instance.updateData(newItem);
              }
            }

            if (!context.mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.width * 1.4,
                  left: MediaQuery.of(context).size.width * 0.5,
                  right: 16,
                ),
                backgroundColor: theme.colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                content: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: AppColors.green,
                        width: 3,
                      ), // Using green from app_theme
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.existingItem == null
                              ? 'Added successfully'
                              : 'Updated successfully',
                          style: textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
                duration: const Duration(seconds: 2),
              ),
            );

            if (Navigator.canPop(context)) {
              Navigator.pop(context, true);
            } else {
              _formKey.currentState!.reset();
              setState(() {
                selectedOption = null;
                selectedType = null;
                selectedGroup = null;
                _number = 0;
              });
            }
          },
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.onSurface,
            foregroundColor: theme.colorScheme.surface,
            minimumSize: const Size(400, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.add), SizedBox(width: 10), Text('Save')],
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

Future<void> showAddItemBottomSheet(
  BuildContext context, {
  MyData? existingItem,
  VoidCallback? onSaved,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      final theme = Theme.of(context);
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: AddTransactionScreen(existingItem: existingItem),
          ),
        ),
      );
    },
  );

  if (result == true && onSaved != null) {
    onSaved();
  }
}
