import 'package:bookbank/Widgets/lieChart.dart';
import 'package:bookbank/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:bookbank/features/home/popup/popup_main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        height: 150.h,
        padding: EdgeInsets.all(16.r),
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: theme.colorScheme.outline),
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
                      style: TextStyle(fontSize: AppSize.l.sp),
                    ),
                  ],
                ),
                // Line Chart
                SizedBox(
                  height: 40.h,
                  width: 160.w,
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
            SizedBox(height: 8.h),
            // Divider
            Divider(color: theme.colorScheme.onSurfaceVariant),
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
                Container(
                  width: 1,
                  height: 60.h,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
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
      width: 120.w,
      height: 60.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(icon, size: 16.sp, color: theme.iconTheme.color),
              SizedBox(width: 8.w),
              Text(label, style: textTheme.bodySmall),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "\$ ${balance.toStringAsFixed(2)}",
                style: TextStyle(fontSize: AppSize.m.sp),
              ),
              Text(
                "${total > 0 ? (balance / total * 100).toStringAsFixed(1) : 0}%",
                style: textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
