import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:provider/provider.dart';
import 'package:bookbank/core/localization/localization_provider.dart';

class SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final loc = Provider.of<LocalizationProvider>(context).loc;

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: theme.colorScheme.onSurface,
        foregroundColor: theme.colorScheme.surface,
        minimumSize: Size(
          isTablet ? 500.w : 400.w,
          isTablet ? 56.h : 50.h,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, size: isTablet ? 24.sp : 20.sp),
          SizedBox(width: 10.w),
          Text(
            loc.save,
            style: TextStyle(fontSize: isTablet ? 18.sp : 16.sp),
          ),
        ],
      ),
    );
  }
}
