import 'package:bookbank/Widgets/lieChart.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookbank/core/theme/app_theme.dart';
import 'package:bookbank/data/database.dart';
import 'package:bookbank/data/db_helper.dart';
import 'package:bookbank/utils/calculations.dart';
import 'package:intl/intl.dart';

class PopupGroup extends StatefulWidget {
  final String groupName;
  final String groupId;
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
    required this.groupId,
    required this.groupColor,
    required this.transactions,
    required this.icon,
    required this.percentage,
    required this.savingsGoalAmount,
    required this.savingsGoalEnabled,
    required this.groupAmount,
  });

  @override
  State<PopupGroup> createState() => _PopupGroupState();
}

class _PopupGroupState extends State<PopupGroup> {
  List<MyData> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await DatabaseHelper.instance.getAllData();
    if (mounted) {
      setState(() {
        _transactions = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // สร้างข้อมูลกราฟสำหรับหมวดหมู่นี้
    final calc = FinancialCalculations(_transactions);
    final groupSpots = calc.generateMonthlySpotsForGroup(widget.groupId);

    // คำนวณรายรับ/รายจ่ายเฉพาะเดือนปัจจุบัน
    double totalIncome = calc.monthlyGroupIncome(widget.groupId);
    double totalExpense = calc.monthlyGroupExpense(widget.groupId);
    final net = totalIncome - totalExpense;

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
          // Close button
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

          // Header
          Row(
            children: [
              Row(
                children: [
                  Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: widget.groupColor),
                      borderRadius: BorderRadius.circular(10.r),
                      color: widget.groupColor.withValues(alpha: 0.2),
                    ),
                    child: Icon(widget.icon, color: widget.groupColor, size: 24.sp),
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.groupName,
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: AppSize.s.sp,
                        ),
                      ),
                      Text(
                        '฿ ${net.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: AppSize.l.sp),
                      ),
                      SizedBox(height: 8.h),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),

          Row(
            children: [
              Text(
                'This represents ',
                style: TextStyle(fontSize: AppSize.xs.sp, color: AppColors.grey),
              ),
              Text(
                '${widget.percentage.toStringAsFixed(1)}%',
                style: TextStyle(fontSize: AppSize.s.sp),
              ),
              Text(
                ' of the total amount.',
                style: TextStyle(fontSize: AppSize.xs.sp, color: AppColors.grey),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          if (widget.savingsGoalEnabled && widget.savingsGoalAmount! > 0) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Target', style: TextStyle(fontSize: AppSize.s.sp)),
                    const Spacer(),
                    Text(
                      '฿ ${widget.savingsGoalAmount?.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: AppSize.s.sp),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: (widget.groupAmount! / widget.savingsGoalAmount!)
                        .clamp(0.0, 1.0),
                    backgroundColor: AppColors.grey.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.groupColor,
                    ),
                    minHeight: 4.h,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
          ],

          // Income / Expense summary
          Row(
            children: [
              Text(
                'Monthly data: ',
                style: TextStyle(fontSize: AppSize.xs.sp, color: AppColors.grey),
              ),
              Text(
                '${DateFormat('MMMM').format(DateTime.now())} / ${DateTime.now().year}',
                style: TextStyle(fontSize: AppSize.xs.sp),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              SizedBox(
                width: 10.w,
                height: 10.h,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                'Income: ฿ ${totalIncome.toStringAsFixed(2)}',
                style: TextStyle(fontSize: AppSize.s.sp),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 10.w,
                height: 10.h,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                'Expense: ฿ ${totalExpense.toStringAsFixed(2)}',
                style: TextStyle(fontSize: AppSize.s.sp),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Line Chart
          SizedBox(
            height: 60.h,
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
