import 'package:bookbank/Widgets/dashboard_widgets/_build_summary_item.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:bookbank/Core/Theme/app_style.dart';
import 'package:bookbank/Widgets/dashboard_widgets/category_pie_chart.dart';

class YearlyChart extends StatelessWidget {
  final int selectedYear;
  final List<FlSpot> spots;
  final Function(int) onYearChanged;
  final Map<String, double> categoryExpenses;
  final double totalExpense;
  final Map<String, IconData> categoryIcons;
  final Map<String, Color> categoryColors;
  final double yearlyIncome;
  final double yearlyExpense;
  final double yearlyNet;

  const YearlyChart({
    super.key,
    required this.selectedYear,
    required this.spots,
    required this.onYearChanged,
    required this.categoryExpenses,
    required this.totalExpense,
    required this.categoryIcons,
    required this.categoryColors,
    required this.yearlyIncome,
    required this.yearlyExpense,
    required this.yearlyNet,
  });

  @override
  Widget build(BuildContext context) {
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
          // Year selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Data for the year',
                style: TextStyle(
                  fontSize: AppSize.s.fontSize,
                  color: AppColors.grey,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => onYearChanged(selectedYear - 1),
                  ),
                  Text(
                    '$selectedYear',
                    style: TextStyle(fontSize: AppSize.s.fontSize),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () => onYearChanged(selectedYear + 1),
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
                amount: yearlyIncome,
                color: AppColors.green,
              ),
              BuildSummaryItem(
                icon: Icons.trending_down,
                title: 'Expense',
                amount: yearlyExpense,
                color: AppColors.red,
              ),
              BuildSummaryItem(
                icon: Icons.account_balance_wallet,
                title: 'Net',
                amount: yearlyNet,
                color: yearlyNet >= 0 ? AppColors.green : AppColors.red,
              ),
            ],
          ),
          const SizedBox(height: 34),

          // Chart
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: spots.isEmpty ? 0 : _calculateMaxY(spots),
                minY: spots.isEmpty ? 0 : _calculateMinY(spots),
                barGroups: _buildBarGroups(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _calculateInterval(spots),
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.border.withValues(alpha: 1),
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
                      getTitlesWidget: (value, meta) {
                        final months = [
                          'J',
                          'F',
                          'M',
                          'A',
                          'M',
                          'J',
                          'J',
                          'A',
                          'S',
                          'O',
                          'N',
                          'D',
                        ];
                        if (value.toInt() >= 1 && value.toInt() <= 12) {
                          return Text(
                            months[value.toInt() - 1],
                            style: AppSize.xs,
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      interval: _calculateInterval(spots),
                      getTitlesWidget: (value, meta) {
                        return Text('฿${value.toInt()}', style: AppSize.xs);
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
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => AppColors.black,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final months = [
                        'Jan',
                        'Feb',
                        'Mar',
                        'Apr',
                        'May',
                        'Jun',
                        'Jul',
                        'Aug',
                        'Sep',
                        'Oct',
                        'Nov',
                        'Dec',
                      ];
                      return BarTooltipItem(
                        '${months[group.x.toInt() - 1]}\n',
                        TextStyle(color: Colors.white, fontSize: 12),
                        children: [
                          TextSpan(
                            text: '฿${rod.toY.toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      );
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

  List<BarChartGroupData> _buildBarGroups() {
    return spots.map((spot) {
      return BarChartGroupData(
        x: spot.x.toInt(),
        barRods: [
          BarChartRodData(
            toY: spot.y,
            color: spot.y >= 0 ? AppColors.green : AppColors.red,
            width: 10,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
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
}
