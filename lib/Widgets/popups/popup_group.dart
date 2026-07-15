import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:bookbank/Core/Theme/app_style.dart';
import 'package:bookbank/data/database.dart';
import 'package:bookbank/utils/calculations.dart';
import 'package:bookbank/Widgets/popups/popup_main.dart';
import 'package:intl/intl.dart';

class PopupGroup extends StatelessWidget {
  final String groupName;
  final Color groupColor;
  final List<MyData> transactions;
  final IconData icon;
  final double percentage;
  final double? savingsGoalAmount;
  final bool savingsGoalEnabled;
  final double? groupAmount;

  const PopupGroup({
    super.key,
    required this.groupName,
    required this.groupColor,
    required this.transactions,
    required this.icon,
    required this.percentage,
    required this.savingsGoalAmount,
    required this.savingsGoalEnabled,
    required this.groupAmount,
  });

  @override
  Widget build(BuildContext context) {
    // สร้างข้อมูลกราฟสำหรับหมวดหมู่นี้
    final calc = FinancialCalculations(transactions);
    final groupSpots = calc.generateMonthlySpotsForGroup(groupName);

    // คำนวณรายรับ/รายจ่ายเฉพาะเดือนปัจจุบัน
    double totalIncome = calc.monthlyGroupIncome(groupName);
    double totalExpense = calc.monthlyGroupExpense(groupName);
    final net = totalIncome - totalExpense;

    return Container(
      width: 100,
      height: savingsGoalEnabled && savingsGoalAmount! > 0 ? 320 : 300,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Close button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close),
              ),
            ],
          ),

          // Header
          Row(
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: BoxBorder.all(color: groupColor),
                      borderRadius: BorderRadius.circular(10),
                      color: groupColor.withValues(alpha: 0.2),
                    ),
                    child: Icon(icon, color: groupColor),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        groupName,
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: AppSize.s.fontSize,
                        ),
                      ),
                      Text(
                        '฿ ${net.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: AppSize.l.fontSize),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Text(
                'This represents ',
                style: TextStyle(
                  fontSize: AppSize.xs.fontSize,
                  color: AppColors.grey,
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: TextStyle(fontSize: AppSize.s.fontSize),
              ),
              Text(
                ' of the total amount.',
                style: TextStyle(
                  fontSize: AppSize.xs.fontSize,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (savingsGoalEnabled && savingsGoalAmount! > 0) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Target',
                      style: TextStyle(fontSize: AppSize.s.fontSize),
                    ),
                    const Spacer(),
                    Text(
                      '฿ ${savingsGoalAmount?.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: AppSize.s.fontSize),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (groupAmount! / savingsGoalAmount!).clamp(0.0, 1.0),
                    backgroundColor: AppColors.grey.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(groupColor),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Income / Expense summary
          Row(
            children: [
              Text(
                'Monthly data: ',
                style: TextStyle(
                  fontSize: AppSize.xs.fontSize,
                  color: AppColors.grey,
                ),
              ),
              Text(
                '${DateFormat('MMMM').format(DateTime.now())} / ${DateTime.now().year}',
                style: TextStyle(fontSize: AppSize.xs.fontSize),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              SizedBox(
                width: 10,
                height: 10,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Income: ฿ ${totalIncome.toStringAsFixed(2)}',
                style: AppSize.s,
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 10,
                height: 10,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Expense: ฿ ${totalExpense.toStringAsFixed(2)}',
                style: AppSize.s,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Line Chart
          SizedBox(
            height: 60,
            width: double.infinity,
            child: LineChart(
              LineChartData(
                lineBarsData: createSegmentsWithArea(groupSpots),
                minY: -5000,
                maxY: 5000,
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 1,
                maxX: 31,
                lineTouchData: LineTouchData(enabled: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
