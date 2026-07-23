import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:bookbank/core/theme/app_theme.dart';

class TransferMode extends StatelessWidget {
  final String transferFrom;
  final String transferTo;
  final ValueChanged<String> onTransferFromChanged;

  const TransferMode({
    super.key,
    required this.transferFrom,
    required this.transferTo,
    required this.onTransferFromChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              transferFrom,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isTablet ? 18.sp : 16.sp,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Icon(
                Icons.arrow_forward,
                size: isTablet ? 24.sp : 20.sp,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ),
            Text(
              transferTo,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isTablet ? 18.sp : 16.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 8.w : 5.w,
                vertical: isTablet ? 4.h : 2.h,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.border, width: 1),
                color: AppColors.card,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                    onPressed: () => onTransferFromChanged('Bank'),
                    style: FilledButton.styleFrom(
                      backgroundColor: transferFrom == 'Bank'
                          ? AppColors.black
                          : AppColors.card,
                      foregroundColor: transferFrom == 'Bank'
                          ? AppColors.card
                          : AppColors.black,
                      minimumSize: Size(
                        isTablet ? 170.w : 145.w,
                        isTablet ? 48.h : 40.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      'Bank',
                      style: TextStyle(fontSize: isTablet ? 16.sp : 14.sp),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  FilledButton(
                    onPressed: () => onTransferFromChanged('Cash'),
                    style: FilledButton.styleFrom(
                      backgroundColor: transferFrom == 'Cash'
                          ? AppColors.black
                          : AppColors.card,
                      foregroundColor: transferFrom == 'Cash'
                          ? AppColors.card
                          : AppColors.black,
                      minimumSize: Size(
                        isTablet ? 170.w : 145.w,
                        isTablet ? 48.h : 40.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      'Cash',
                      style: TextStyle(fontSize: isTablet ? 16.sp : 14.sp),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
