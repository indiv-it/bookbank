import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_theme.dart';

class GroupUnallocatedPopup extends StatelessWidget {
  final Color color;
  final String amount;
  final String percentage;
  final String title;

  const GroupUnallocatedPopup({
    super.key,
    required this.color,
    required this.amount,
    required this.percentage,
    required this.title,
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
        SizedBox(width: 10.w),
        Text(title, style: TextStyle(fontSize: AppSize.m.sp)),
        SizedBox(width: 10.w),
        Text(
          '($amount / $percentage)',
          style: TextStyle(fontSize: AppSize.s.sp, color: AppColors.grey),
        ),
      ],
    );
  }
}
