import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';

class TitleInput extends StatelessWidget {
  final TextEditingController controller;

  const TitleInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    if (isDesktop || isTablet) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Title',
          style: textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            fontSize: isTablet ? 14.sp : 12.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          height: 50.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: theme.colorScheme.outline),
            color: theme.colorScheme.surface,
          ),
          child: Row(
            children: [
              SizedBox(width: 16.w),
              Icon(
                Icons.text_fields,
                size: isTablet ? 20.sp : 16.sp,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: isTablet ? 16.sp : 14.sp,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Title',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelStyle: textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: isTablet ? 16.sp : 14.sp,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.arrow_drop_down,
                  size: isTablet ? 28.sp : 24.sp,
                ),
                offset: Offset(70.w, 50.h),
                color: theme.colorScheme.surface,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: theme.colorScheme.outline),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                onSelected: (String value) {
                  controller.text = value;
                },
                itemBuilder: (BuildContext context) {
                  return [
                        'Food',
                        'Transport',
                        'Shopping',
                        'Entertainment',
                        'Bills',
                      ]
                      .map(
                        (item) => PopupMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(fontWeight: FontWeight.w400),
                          ),
                        ),
                      )
                      .toList();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
