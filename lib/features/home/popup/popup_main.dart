import 'package:bookbank/Widgets/lieChart.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';

// ----- Display Widget -----
class PopupMain extends StatelessWidget {
  final double totalBalance;
  final double bankBalance;
  final double cashBalance;
  final double incomeTotal;
  final double expenseTotal;
  final double monthlyIncome;
  final double monthlyExpense;
  final List<FlSpot> spots;

  const PopupMain({
    super.key,
    required this.totalBalance,
    required this.bankBalance,
    required this.cashBalance,
    required this.incomeTotal,
    required this.expenseTotal,
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.spots,
  });

  @override
  Widget build(BuildContext context) {
    final bankPct = totalBalance != 0
        ? (bankBalance / totalBalance * 100).toStringAsFixed(1)
        : '0.0';
    final cashPct = totalBalance != 0
        ? (cashBalance / totalBalance * 100).toStringAsFixed(1)
        : '0.0';
    final incomeExpensePct = incomeTotal != 0
        ? ((incomeTotal - expenseTotal) / incomeTotal * 100).toStringAsFixed(1)
        : '0.0';

    return Container(
      width: 100,
      height: 300,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header / Exit button
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
          Text('Total balance', style: TextStyle(fontSize: AppSize.s)),

          // Balance display
          Row(
            children: [
              Text('฿ ${totalBalance.toStringAsFixed(2)}'),
              const SizedBox(width: 8),
              SizedBox(
                height: 20,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.green),
                    color: AppColors.green.withValues(alpha: 0.1),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.trending_up, color: AppColors.green, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        '$incomeExpensePct%',
                        style: TextStyle(
                          color: AppColors.green,
                          fontSize: AppSize.s,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Bank/Cash info
          Row(
            children: [
              Icon(Icons.account_balance_rounded, size: 16),
              const SizedBox(width: 8),
              Text(
                'Bank : ฿ ${bankBalance.toStringAsFixed(2)} / $bankPct%',
                style: TextStyle(fontSize: AppSize.s),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.account_balance_wallet, size: 16),
              const SizedBox(width: 8),
              Text(
                'Cash : ฿ ${cashBalance.toStringAsFixed(2)} / $cashPct%',
                style: TextStyle(fontSize: AppSize.s),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Monthly data info
          Row(
            children: [
              Text(
                'Monthly data: ',
                style: TextStyle(fontSize: AppSize.s, color: AppColors.grey),
              ),
              Text(
                '${DateFormat('MMMM').format(DateTime.now())}/${DateTime.now().year}',
                style: TextStyle(fontSize: AppSize.s),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Legend
          Row(
            children: [
              // Income indicator
              SizedBox(
                width: 10,
                height: 10,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.green,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Income', style: TextStyle(fontSize: AppSize.xs)),
                  Text(
                    '฿ ${monthlyIncome.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: AppSize.s),
                  ),
                ],
              ),
              const SizedBox(width: 20),

              // Expense indicator
              SizedBox(
                width: 10,
                height: 10,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.red,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Expense', style: TextStyle(fontSize: AppSize.xs)),
                  Text(
                    '฿ ${monthlyExpense.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: AppSize.s),
                  ),
                ],
              ),
            ],
          ),

          // Line chart
          SizedBox(
            height: 60,
            width: double.infinity,
            child: LineChart(
              LineChartData(
                lineBarsData: createSegmentsWithArea(spots),
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
