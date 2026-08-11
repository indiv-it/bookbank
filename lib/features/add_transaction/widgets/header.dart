import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:provider/provider.dart';
import 'package:bookbank/core/localization/localization_provider.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final theme = Theme.of(context);
    final loc = Provider.of<LocalizationProvider>(context).loc;

    return Column(
      children: [
        Center(
          child: Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 16.sp),
            SizedBox(width: 4.w),
            Text(
              loc.addList,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isTablet ? 18.sp : 16.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
