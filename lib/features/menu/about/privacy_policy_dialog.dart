import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:bookbank/core/localization/localization_provider.dart';

class PrivacyPolicyDialog extends StatelessWidget {
  const PrivacyPolicyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = context.watch<LocalizationProvider>().loc;

    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      title: Row(
        children: [
          Icon(Icons.security, color: theme.colorScheme.primary),
          SizedBox(width: 8),
          Text(loc.privacyPolicyTitle),
        ],
      ),
      content: SingleChildScrollView(
        child: Text(
          loc.privacyPolicyContent,
          style: TextStyle(
            fontSize: 14.sp,
            color: theme.colorScheme.onSurface,
            height: 1.5,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(loc.privacyPolicyClose),
        ),
      ],
    );
  }
}