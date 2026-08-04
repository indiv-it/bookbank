import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookbank/core/theme/app_theme.dart';

class BuildSummaryItem extends StatelessWidget {
  const BuildSummaryItem({
    super.key,
    required this.icon,
    required this.title,
    required this.amount,
    required this.color,
  });

  final IconData icon;
  final String title;
  final double amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: AppSize.xl.sp),
        SizedBox(height: 4.h),
        Text(title, style: TextStyle(fontSize: AppSize.xs.sp)),
        SizedBox(height: 4.h),
        Text(
          '฿${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: AppSize.xs.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
