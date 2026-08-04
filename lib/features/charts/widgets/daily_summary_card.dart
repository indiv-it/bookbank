import 'package:bookbank/features/charts/widgets/_build_summary_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:bookbank/core/theme/app_theme.dart';
import 'package:bookbank/features/charts/widgets/category_pie_chart.dart';

class DailySummaryCard extends StatelessWidget {
  final DateTime selectedDate;
  final double dailyIncome;
  final double dailyExpense;
  final double dailyNet;
  final Function(DateTime) onDateChanged;
  final Map<String, double> categoryExpenses;
  final Map<String, IconData> categoryIcons;
  final Map<String, Color> categoryColors;
  final Map<String, String> categoryNames;

  const DailySummaryCard({
    super.key,
    required this.selectedDate,
    required this.dailyIncome,
    required this.dailyExpense,
    required this.dailyNet,
    required this.onDateChanged,
    required this.categoryExpenses,
    required this.categoryIcons,
    required this.categoryColors,
    required this.categoryNames,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final DateFormat dateFormat = DateFormat('dd MMM yyyy');

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Date selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'data for this day',
                style: TextStyle(fontSize: AppSize.xs.sp, color: AppColors.grey),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left, size: 20.sp),
                    onPressed: () => onDateChanged(
                      selectedDate.subtract(const Duration(days: 1)),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      dateFormat.format(selectedDate),
                      style: TextStyle(
                        fontSize: AppSize.xs.sp,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        onDateChanged(picked);
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right, size: 20.sp),
                    onPressed: () => onDateChanged(
                      selectedDate.add(const Duration(days: 1)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Row 2: Income, Expense, Net
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BuildSummaryItem(
                icon: Icons.trending_up,
                title: 'Income',
                amount: dailyIncome,
                color: AppColors.green,
              ),
              BuildSummaryItem(
                icon: Icons.trending_down,
                title: 'Expense',
                amount: dailyExpense,
                color: AppColors.red,
              ),
              BuildSummaryItem(
                icon: Icons.account_balance_wallet,
                title: 'Net',
                amount: dailyNet,
                color: dailyNet >= 0 ? AppColors.green : AppColors.red,
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Divider
          Divider(color: theme.colorScheme.outline, height: 1),
          SizedBox(height: 16.h),

          // Category title
          Text(
            'Income and expenses by category',
            style: TextStyle(fontSize: AppSize.xs.sp),
          ),
          SizedBox(height: 16.h),

          // Category Pie Chart
          CategoryPieChart(
            categoryExpenses: categoryExpenses,
            totalExpense: dailyExpense,
            categoryIcons: categoryIcons,
            categoryColors: categoryColors,
            categoryNames: categoryNames,
          ),
        ],
      ),
    );
  }
}
