import 'package:bookbank/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:bookbank/Widgets/popups/popup_main.dart';

class DashboardSummary extends StatelessWidget {
  final double totalBalance;
  final double bankBalance;
  final double cashBalance;
  final double incomeTotal;
  final double expenseTotal;
  final double monthlyIncome;
  final double monthlyExpense;
  final List<FlSpot> spots;

  const DashboardSummary({
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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return Dialog(
              child: PopupMain(
                totalBalance: totalBalance,
                bankBalance: bankBalance,
                cashBalance: cashBalance,
                incomeTotal: incomeTotal,
                expenseTotal: expenseTotal,
                monthlyIncome: monthlyIncome,
                monthlyExpense: monthlyExpense,
                spots: spots,
              ),
            );
          },
        );
      },
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            // Total Balance
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total balance", style: textTheme.bodySmall),
                    Text(
                      "\$ ${totalBalance.toStringAsFixed(2)}",
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
                // Line Chart
                SizedBox(
                  height: 40,
                  width: 160,
                  child: LineChart(
                    LineChartData(
                      lineBarsData: createSegmentsWithArea(spots),
                      minY: -5000,
                      maxY: 5000,
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      minX: 1,
                      maxX: 31,
                      lineTouchData: const LineTouchData(enabled: false),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Divider
            Divider(color: AppColors.border),
            // Money Position
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBalanceItem(
                  context,
                  icon: Icons.account_balance_rounded,
                  label: "Bank",
                  balance: bankBalance,
                  total: totalBalance,
                ),
                Container(width: 1, height: 60, color: AppColors.border),
                _buildBalanceItem(
                  context,
                  icon: Icons.account_balance_wallet,
                  label: "Cash",
                  balance: cashBalance,
                  total: totalBalance,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required double balance,
    required double total,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SizedBox(
      width: 120,
      height: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(icon, size: 16, color: theme.iconTheme.color),
              const SizedBox(width: 8),
              Text(label, style: textTheme.bodySmall),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "\$ ${balance.toStringAsFixed(2)}",
                style: textTheme.bodySmall,
              ),
              Text(
                "${total > 0 ? (balance / total * 100).toStringAsFixed(1) : 0}%",
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.black.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
