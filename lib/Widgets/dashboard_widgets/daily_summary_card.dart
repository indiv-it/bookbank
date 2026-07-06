import 'package:bookbank/Widgets/dashboard_widgets/_build_summary_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bookbank/Core/Theme/app_style.dart';
import 'package:bookbank/Widgets/dashboard_widgets/category_pie_chart.dart';

class DailySummaryCard extends StatelessWidget {
  final DateTime selectedDate;
  final double dailyIncome;
  final double dailyExpense;
  final double dailyNet;
  final Function(DateTime) onDateChanged;
  final Map<String, double> categoryExpenses;
  final Map<String, IconData> categoryIcons;
  final Map<String, Color> categoryColors;

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
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd MMM yyyy');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
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
                style: TextStyle(
                  fontSize: AppSize.s.fontSize,
                  color: AppColors.grey,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
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
                        fontSize: AppSize.s.fontSize,
                        color: AppColors.black,
                      ),
                    ),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        onDateChanged(picked);
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () => onDateChanged(
                      selectedDate.add(const Duration(days: 1)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

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
          const SizedBox(height: 16),

          // Divider
          Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 16),

          // Category title
          Text(
            'Income and expenses by category',
            style: TextStyle(fontSize: AppSize.s.fontSize),
          ),
          const SizedBox(height: 16),

          // Category Pie Chart
          CategoryPieChart(
            categoryExpenses: categoryExpenses,
            totalExpense: dailyExpense,
            categoryIcons: categoryIcons,
            categoryColors: categoryColors,
          ),
        ],
      ),
    );
  }
}
