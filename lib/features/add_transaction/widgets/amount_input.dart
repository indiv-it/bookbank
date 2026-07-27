import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AmountInput extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final bool isTransferMode;
  final ValueChanged<String> onChanged;
  final FormFieldSetter<String>? onSaved;
  final VoidCallback onTransferModeToggle;

  const AmountInput({
    super.key,
    required this.controller,
    this.errorText,
    required this.isTransferMode,
    required this.onChanged,
    this.onSaved,
    required this.onTransferModeToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amount',
          style: textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            fontSize: isTablet ? 14.sp : 12.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          height: isTablet ? 56.h : 50.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: theme.colorScheme.outline),
            color: theme.colorScheme.surface,
          ),
          child: Row(
            children: [
              SizedBox(width: 16.w),
              Text(
                '฿',
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: isTablet ? 18.sp : 16.sp,
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: isTablet ? 16.sp : 14.sp,
                  ),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '00.00',
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
                  onChanged: onChanged,
                  onSaved: onSaved,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.autorenew_rounded,
                  size: isTablet ? 24.sp : 20.sp,
                ),
                onPressed: onTransferModeToggle,
              ),
            ],
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Text(
              errorText!,
              style: textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.error,
                fontSize: isTablet ? 12.sp : 10.sp,
              ),
            ),
          ),
      ],
    );
  }
}
