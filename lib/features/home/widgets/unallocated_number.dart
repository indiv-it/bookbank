import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_theme.dart';

class MoneyNumber extends StatelessWidget {
  final double amount;
  final Color color;
  final double? percentage;

  const MoneyNumber({
    super.key,
    required this.amount,
    required this.color,
    this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 10.w,
          height: 10.h,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
        ),
        SizedBox(width: 5.w),
        Text(
          percentage != null
              ? '${percentage!.toStringAsFixed(1)}%'
              : amount.toString(),
          style: TextStyle(fontSize: AppSize.s.sp),
        ),
      ],
    );
  }
}
