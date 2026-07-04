import 'package:bookbank/Widgets/DashboardWidgets/_buildSummaryItem.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:bookbank/Theme/app_style.dart';
import 'package:bookbank/Widgets/DashboardWidgets/CategoryPieChart.dart';

class MonthlyChart extends StatelessWidget {
  final int selectedYear;
  final int selectedMonth;
  final List<FlSpot> spots;
  final Function(int, int) onMonthChanged;
  final Map<String, double> categoryExpenses;
  final double totalExpense;
  final Map<String, IconData> categoryIcons;
  final Map<String, Color> categoryColors;
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
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.monthlyNet,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat monthFormat = DateFormat('MMM yyyy');
    final DateTime selectedDate = DateTime(selectedYear, selectedMonth);

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
          // Month selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Data for the month',
                style: TextStyle(
                  fontSize: AppSize.s.fontSize,
                  color: AppColors.grey,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
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
                    style: TextStyle(fontSize: AppSize.s.fontSize),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
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
          const SizedBox(height: 8),

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
          const SizedBox(height: 34),

          // Chart
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppColors.blue,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.blue.withOpacity(0.3),
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
                      color: AppColors.border.withOpacity(0.5),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: _calculateDayInterval(spots),
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: AppSize.xs,
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      interval: _calculateInterval(spots),
                      getTitlesWidget: (value, meta) {
                        return Text('\฿${value.toInt()}', style: AppSize.xs);
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
                          TextStyle(color: Colors.white, fontSize: 12),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

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
            totalExpense: totalExpense,
            categoryIcons: categoryIcons,
            categoryColors: categoryColors,
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
