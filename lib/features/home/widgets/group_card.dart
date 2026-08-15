import 'package:bookbank/data/database.dart';
import 'package:bookbank/features/home/popup/popup_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:bookbank/core/localization/localization_provider.dart';

class GroupCard extends StatelessWidget {
  final String groupName;
  final String groupId;
  final int groupCount;
  final double groupAmount;
  final Color groupColor;
  final IconData groupIcon;
  final List<MyData> transactions;
  final double percentage;
  final bool savingsGoalEnabled;
  final double savingsGoalAmount;

  const GroupCard({
    super.key,
    required this.groupName,
    required this.groupId,
    required this.groupCount,
    required this.groupAmount,
    required this.groupColor,
    required this.groupIcon,
    required this.transactions,
    required this.percentage,
    this.savingsGoalEnabled = false,
    this.savingsGoalAmount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locProvider = Provider.of<LocalizationProvider>(context);

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return Dialog(
              child: PopupGroup(
                groupName: groupName,
                groupId: groupId,
                groupColor: groupColor,
                transactions: transactions,
                icon: groupIcon,
                percentage: percentage,
                savingsGoalAmount: savingsGoalAmount,
                savingsGoalEnabled: savingsGoalEnabled,
                groupAmount: groupAmount,
              ),
            );
          },
        );
      },
      child: Container(
        height: 140.h,
        width: double.infinity,
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 45.w,
                  height: 45.h,
                  margin: EdgeInsets.only(bottom: 8.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: groupColor),
                    color: groupColor.withValues(alpha: 0.3),
                  ),
                  child: Icon(groupIcon, color: groupColor, size: 22.sp),
                ),
                Icon(
                  Icons.arrow_outward_sharp,
                  size: 20.sp,
                  color: AppColors.grey,
                ),
              ],
            ),
            Text(
              groupName,
              style: TextStyle(color: AppColors.grey, fontSize: AppSize.xs.sp),
            ),
            Row(
              children: [
                Text(
                  locProvider.formatAmount(groupAmount),
                  style: TextStyle(fontSize: AppSize.m.sp),
                ),
                Spacer(),
                if (savingsGoalEnabled && savingsGoalAmount > 0) ...[
                  Text(
                    locProvider.formatAmount(savingsGoalAmount),
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ],
            ),
            if (savingsGoalEnabled && savingsGoalAmount > 0) ...[
              SizedBox(height: 8.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: (groupAmount / savingsGoalAmount).clamp(0.0, 1.0),
                      backgroundColor: AppColors.grey.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(groupColor),
                      minHeight: 4.h,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
