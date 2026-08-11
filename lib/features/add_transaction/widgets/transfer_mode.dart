import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:provider/provider.dart';
import 'package:bookbank/core/localization/localization_provider.dart';

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
    final loc = Provider.of<LocalizationProvider>(context).loc;

    final fromDisplay = transferFrom == 'Bank' ? loc.bank : loc.cash;
    final toDisplay = transferTo == 'Bank' ? loc.bank : loc.cash;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              fromDisplay,
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
              toDisplay,
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
                border: Border.all(color: theme.colorScheme.outline, width: 1),
                color: theme.colorScheme.surface,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                    onPressed: () => onTransferFromChanged('Bank'),
                    style: FilledButton.styleFrom(
                      backgroundColor: transferFrom == 'Bank'
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.surface,
                      foregroundColor: transferFrom == 'Bank'
                          ? theme.colorScheme.surface
                          : theme.colorScheme.onSurface,
                      minimumSize: Size(
                        isTablet ? 170.w : 145.w,
                        isTablet ? 48.h : 40.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      loc.bank,
                      style: TextStyle(fontSize: isTablet ? 16.sp : 14.sp),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  FilledButton(
                    onPressed: () => onTransferFromChanged('Cash'),
                    style: FilledButton.styleFrom(
                      backgroundColor: transferFrom == 'Cash'
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.surface,
                      foregroundColor: transferFrom == 'Cash'
                          ? theme.colorScheme.surface
                          : theme.colorScheme.onSurface,
                      minimumSize: Size(
                        isTablet ? 170.w : 145.w,
                        isTablet ? 48.h : 40.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      loc.cash,
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
