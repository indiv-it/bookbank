import 'package:bookbank/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:bookbank/core/localization/localization_provider.dart';

class AboutSgreen extends StatelessWidget {
  const AboutSgreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = context.watch<LocalizationProvider>().loc;

    return Container(
      width: 400,
      constraints: BoxConstraints(maxHeight: 600),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.onSurfaceVariant),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info, size: AppSize.l),
              SizedBox(width: 8),
              Text(loc.about, style: TextStyle(fontSize: AppSize.m)),
            ],
          ),
          SizedBox(height: 24),

          // App Icon and Name
          Center(
            child: Column(
              children: [
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return Image.asset(
                      themeProvider.isDarkMode
                          ? 'lib/core/icons/BookBank_Logo 3.png'
                          : 'lib/core/icons/BookBank_Logo 1.png',
                      width: 35.w,
                      height: 35.h,
                    );
                  },
                ),
                SizedBox(height: 12),
                Text(
                  'BookBank',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "${loc.appVersion} 1.0.0",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),

          // Description
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              loc.appDescription,
              style: TextStyle(
                fontSize: 14.sp,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),

          // Developer Info
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.developer,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Chockpipat Kongdee',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // Close Button
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              minimumSize: Size(double.infinity, 40.h),
              foregroundColor: theme.scaffoldBackgroundColor,
              backgroundColor: theme.colorScheme.onSurface,
            ),
            child: Text(loc.cancel),
          ),
        ],
      ),
    );
  }
}
