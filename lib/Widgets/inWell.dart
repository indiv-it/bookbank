import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DateSelectorInkWell extends StatelessWidget {
  final DateTime? selectedDate;
  final String Function(DateTime) formatDate;
  final VoidCallback onTap;
  final ThemeData theme;
  final TextTheme textTheme;
  final bool isTablet;

  const DateSelectorInkWell({
    super.key,
    required this.selectedDate,
    required this.formatDate,
    required this.onTap,
    required this.theme,
    required this.textTheme,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        height: isTablet ? 56.h : 50.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(10.r),
          color: theme.colorScheme.surface,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                selectedDate != null ? formatDate(selectedDate!) : 'Select',
                style: textTheme.bodySmall?.copyWith(
                  color: selectedDate != null
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: isTablet ? 16.sp : 14.sp,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.calendar_today,
              size: isTablet ? 22.sp : 18.sp,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
