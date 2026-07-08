import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';
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
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 16.sp),
                SizedBox(width: 4.w),
                Text(
                  'Add List',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: isTablet ? 18.sp : 16.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

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
                      fontSize: isTablet ? 14.sp : 12.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    height: isTablet ? 56.h : 50.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppColors.border),
                      color: theme.colorScheme.surface,
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 16.w),
                        Text(
                          '฿',
                          style: textTheme.bodyMedium?.copyWith(
                            fontSize: isTablet ? 18.sp : 16.sp,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _amountController,
                            style: textTheme.bodySmall?.copyWith(
                              fontSize: isTablet ? 16.sp : 14.sp,
                            ),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: '00.00',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelStyle: textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
                                fontSize: isTablet ? 16.sp : 14.sp,
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
                          icon: Icon(
                            Icons.autorenew_rounded,
                            size: isTablet ? 24.sp : 20.sp,
                          ),
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
                      padding: EdgeInsets.only(top: 4.h),
                      child: Text(
                        _amountError!,
                        style: textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.error,
                          fontSize: isTablet ? 12.sp : 10.sp,
                        ),
                      ),
                    ),
                  SizedBox(height: 20.h),

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
                                fontSize: isTablet ? 18.sp : 16.sp,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Icon(
                                Icons.arrow_forward,
                                size: isTablet ? 24.sp : 20.sp,
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            Text(
                              _transferTo,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: isTablet ? 18.sp : 16.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 8.w : 5.w,
                                vertical: isTablet ? 4.h : 2.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: AppColors.border,
                                  width: 1,
                                ),
                                color: AppColors.card,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                      minimumSize: Size(
                                        isTablet ? 170.w : 145.w,
                                        isTablet ? 48.h : 40.h,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Bank',
                                      style: TextStyle(
                                        fontSize: isTablet ? 16.sp : 14.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
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
                                      minimumSize: Size(
                                        isTablet ? 170.w : 145.w,
                                        isTablet ? 48.h : 40.h,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Cash',
                                      style: TextStyle(
                                        fontSize: isTablet ? 16.sp : 14.sp,
                                      ),
                                    ),
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
                    if (!isDesktop || !isTablet) ...[
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Title',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.5),
                                    fontSize: isTablet ? 14.sp : 12.sp,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Container(
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(color: AppColors.border),
                                    color: theme.colorScheme.surface,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 16.w),
                                      Icon(
                                        Icons.text_fields,
                                        size: isTablet ? 20.sp : 16.sp,
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.5),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller: _titleController,
                                          style: textTheme.bodySmall?.copyWith(
                                            fontSize: isTablet ? 16.sp : 14.sp,
                                          ),
                                          decoration: InputDecoration(
                                            labelText: 'Title',
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never,
                                            labelStyle: textTheme.bodySmall
                                                ?.copyWith(
                                                  color: theme
                                                      .colorScheme
                                                      .onSurface
                                                      .withValues(alpha: 0.5),
                                                  fontSize: isTablet
                                                      ? 16.sp
                                                      : 14.sp,
                                                ),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                          ),
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                          size: isTablet ? 28.sp : 24.sp,
                                        ),
                                        offset: Offset(70.w, 50.h),
                                        color: theme.colorScheme.surface,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
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
                                                  child: Text(
                                                    item,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
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
                          SizedBox(width: 16.w),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.5),
                                    fontSize: isTablet ? 14.sp : 12.sp,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                InkWell(
                                  onTap: () => _selectDate(context),
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: Container(
                                    height: isTablet ? 56.h : 50.h,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.border,
                                      ),
                                      borderRadius: BorderRadius.circular(10.r),
                                      color: theme.colorScheme.surface,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            selectedDate != null
                                                ? _formatDate(selectedDate!)
                                                : 'Select',
                                            style: textTheme.bodySmall
                                                ?.copyWith(
                                                  color: selectedDate != null
                                                      ? theme
                                                            .colorScheme
                                                            .onSurface
                                                      : theme
                                                            .colorScheme
                                                            .onSurface
                                                            .withValues(
                                                              alpha: 0.5,
                                                            ),
                                                  fontSize: isTablet
                                                      ? 16.sp
                                                      : 14.sp,
                                                ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Icon(
                                          Icons.calendar_today,
                                          size: isTablet ? 22.sp : 18.sp,
                                          color: theme.colorScheme.onSurface
                                              .withValues(alpha: 0.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                    SizedBox(height: 16.h),

                    TypeSelector(
                      selectedType: selectedOption,
                      onChanged: (val) => setState(() => selectedOption = val),
                    ),
                    SizedBox(height: 20.h),

                    PositionSelector(
                      selectedPosition: selectedType,
                      onChanged: (val) => setState(() => selectedType = val),
                    ),
                    SizedBox(height: 20.h),

                    CategorySelector(
                      selectedGroup: selectedGroup,
                      onChanged: (val) => setState(() => selectedGroup = val),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 30.h),

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
                  // บันทึกเพียง 1 รายการ โดย moneyList = from, moneyGroup = to
                  final transferItem = MyData(
                    amount: _number,
                    moneyType: 'transfer',
                    moneyList: _transferFrom == 'Bank' ? 'bank' : 'cash',
                    moneyGroup: _transferTo == 'Bank' ? 'bank' : 'cash',
                    date: dateStr,
                    title: 'Money Position',
                  );
                  await DatabaseHelper.instance.insertData(transferItem);
                } else {
                  final newItem = MyData(
                    id: widget.existingItem?.id,
                    amount: _number,
                    moneyType: selectedOption == 'Income'
                        ? 'income'
                        : 'expense',
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
                      bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
                      left: 16.w,
                      right: 16.w,
                    ),
                    backgroundColor: theme.colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    content: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(color: AppColors.green, width: 3),
                        ),
                      ),
                      padding: EdgeInsets.only(left: 8.w),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                            size: isTablet ? 24.sp : 20.sp,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              widget.existingItem == null
                                  ? 'Added successfully'
                                  : 'Updated successfully',
                              style: textTheme.bodySmall?.copyWith(
                                fontSize: isTablet ? 16.sp : 14.sp,
                              ),
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
                minimumSize: Size(
                  isTablet ? 500.w : 400.w,
                  isTablet ? 56.h : 50.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: isTablet ? 24.sp : 20.sp),
                  SizedBox(width: 10.w),
                  Text(
                    'Save',
                    style: TextStyle(fontSize: isTablet ? 18.sp : 16.sp),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
          ],
        );
      },
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
      final isTablet = ResponsiveBreakpoints.of(context).isTablet;
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          padding: EdgeInsets.all(isTablet ? 24.r : 20.r),
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
