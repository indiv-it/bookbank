import 'package:bookbank/features/charts/dashboard_widgets/_build_summary_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:bookbank/core/theme/app_theme.dart';
import 'package:bookbank/features/charts/dashboard_widgets/category_pie_chart.dart';

class MonthlyChart extends StatelessWidget {
  final int selectedYear;
  final int selectedMonth;
  final List<FlSpot> spots;
  final Function(int, int) onMonthChanged;
  final Map<String, double> categoryExpenses;
  final double totalExpense;
  final Map<String, IconData> categoryIcons;
  final Map<String, Color> categoryColors;
  final Map<String, String> categoryNames;
  final double monthlyIncome;
  final double monthlyExpense;
  final double monthlyNet;

  const MonthlyChart({
    super.key,
    required this.selectedYear,
    required this.selectedMonth,
    required this.spots,
    required this.onMonthChanged,
    required this.categoryExpenses,
    required this.totalExpense,
    required this.categoryIcons,
    required this.categoryColors,
    required this.categoryNames,
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.monthlyNet,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final DateFormat monthFormat = DateFormat('MMM yyyy');
    final DateTime selectedDate = DateTime(selectedYear, selectedMonth);

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
          // Month selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Data for the month',
                style: TextStyle(fontSize: AppSize.s.sp, color: AppColors.grey),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left, size: 20.sp),
                    onPressed: () {
                      DateTime newDate = DateTime(
                        selectedYear,
                        selectedMonth - 1,
                      );
                      onMonthChanged(newDate.year, newDate.month);
                    },
                  ),
                  Text(
                    monthFormat.format(selectedDate),
                    style: TextStyle(fontSize: AppSize.s.sp),
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right, size: 20.sp),
                    onPressed: () {
                      DateTime newDate = DateTime(
                        selectedYear,
                        selectedMonth + 1,
                      );
                      onMonthChanged(newDate.year, newDate.month);
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BuildSummaryItem(
                icon: Icons.trending_up,
                title: 'Income',
                amount: monthlyIncome,
                color: AppColors.green,
              ),
              BuildSummaryItem(
                icon: Icons.trending_down,
                title: 'Expense',
                amount: monthlyExpense,
                color: AppColors.red,
              ),
              BuildSummaryItem(
                icon: Icons.account_balance_wallet,
                title: 'Net',
                amount: monthlyNet,
                color: monthlyNet >= 0 ? AppColors.green : AppColors.red,
              ),
            ],
          ),
          SizedBox(height: 34.h),

          // Chart
          SizedBox(
            height: 200.h,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppColors.blue,
                    barWidth: 3.w,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.blue.withValues(alpha: 0.3),
                    ),
                  ),
                ],
                minY: spots.isEmpty ? 0 : _calculateMinY(spots),
                maxY: spots.isEmpty ? 0 : _calculateMaxY(spots),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _calculateInterval(spots),
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: theme.colorScheme.outline,
                      strokeWidth: 1.w,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30.h,
                      interval: _calculateDayInterval(spots),
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(fontSize: AppSize.xs.sp),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50.w,
                      interval: _calculateInterval(spots),
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '฿${value.toInt()}',
                          style: TextStyle(fontSize: AppSize.xs.sp),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => AppColors.black,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '฿${spot.y.toStringAsFixed(2)}',
                          TextStyle(color: Colors.white, fontSize: 12.sp),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Divider
          Divider(color: theme.colorScheme.outline, height: 1.h),
          SizedBox(height: 16.h),

          // Category title
          Text(
            'Income and expenses by category',
            style: TextStyle(fontSize: AppSize.s.sp),
          ),
          SizedBox(height: 16.h),

          // Category Pie Chart
          CategoryPieChart(
            categoryExpenses: categoryExpenses,
            totalExpense: totalExpense,
            categoryIcons: categoryIcons,
            categoryColors: categoryColors,
            categoryNames: categoryNames,
          ),
        ],
      ),
    );
  }

  double _calculateMinY(List<FlSpot> spots) {
    if (spots.isEmpty) return 0;
    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    return minY < 0 ? minY : 0;
  }

  double _calculateMaxY(List<FlSpot> spots) {
    if (spots.isEmpty) return 0;
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    return maxY > 0 ? maxY : 0;
  }

  double _calculateInterval(List<FlSpot> spots) {
    if (spots.isEmpty) return 100;
    final range = _calculateMaxY(spots) - _calculateMinY(spots);
    if (range == 0) return 100;
    return range / 5;
  }

  double _calculateDayInterval(List<FlSpot> spots) {
    if (spots.isEmpty) return 1;
    final maxX = spots.map((s) => s.x).reduce((a, b) => a > b ? a : b);
    if (maxX <= 7) return 1;
    if (maxX <= 15) return 2;
    return 5;
  }
}
