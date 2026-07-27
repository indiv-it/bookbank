import 'package:bookbank/Widgets/lieChart.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final theme = Theme.of(context);
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
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header / Exit button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close, size: 20.sp),
              ),
            ],
          ),
          Text('Total balance', style: TextStyle(fontSize: AppSize.s.sp)),

          // Balance display
          Row(
            children: [
              Text(
                '฿ ${totalBalance.toStringAsFixed(2)}',
                style: TextStyle(fontSize: AppSize.m.sp),
              ),
              SizedBox(width: 8.w),
              SizedBox(
                height: 20.h,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColors.green),
                    color: AppColors.green.withValues(alpha: 0.1),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.trending_up,
                        color: AppColors.green,
                        size: 12.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '$incomeExpensePct%',
                        style: TextStyle(
                          color: AppColors.green,
                          fontSize: AppSize.s.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Bank/Cash info
          Row(
            children: [
              Icon(Icons.account_balance_rounded, size: 16.sp),
              SizedBox(width: 8.w),
              Text(
                'Bank : ฿ ${bankBalance.toStringAsFixed(2)} / $bankPct%',
                style: TextStyle(fontSize: AppSize.s.sp),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.account_balance_wallet, size: 16.sp),
              SizedBox(width: 8.w),
              Text(
                'Cash : ฿ ${cashBalance.toStringAsFixed(2)} / $cashPct%',
                style: TextStyle(fontSize: AppSize.s.sp),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Monthly data info
          Row(
            children: [
              Text(
                'Monthly data: ',
                style: TextStyle(fontSize: AppSize.s.sp, color: AppColors.grey),
              ),
              Text(
                '${DateFormat('MMMM').format(DateTime.now())}/${DateTime.now().year}',
                style: TextStyle(fontSize: AppSize.s.sp),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Legend
          Row(
            children: [
              // Income indicator
              SizedBox(
                width: 10.w,
                height: 10.h,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: AppColors.green,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Income', style: TextStyle(fontSize: AppSize.xs.sp)),
                  Text(
                    '฿ ${monthlyIncome.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: AppSize.s.sp),
                  ),
                ],
              ),
              SizedBox(width: 20.w),

              // Expense indicator
              SizedBox(
                width: 10.w,
                height: 10.h,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: AppColors.red,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Expense', style: TextStyle(fontSize: AppSize.xs.sp)),
                  Text(
                    '฿ ${monthlyExpense.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: AppSize.s.sp),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Line chart
          SizedBox(
            height: 60.h,
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
