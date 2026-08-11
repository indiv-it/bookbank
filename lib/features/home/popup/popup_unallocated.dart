import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookbank/core/theme/app_theme.dart';
import 'package:bookbank/features/home/widgets/unallocated_bar.dart';
import 'package:bookbank/features/home/popup/popup_group_unallocated.dart';
import 'package:bookbank/utils/calculations.dart';
import 'package:provider/provider.dart';
import 'package:bookbank/core/localization/localization_provider.dart';

class PopupUnallocated extends StatelessWidget {
  final double totalIncome;
  final double group1Amount;
  final double group2Amount;
  final double group3Amount;
  final double group4Amount;
  final double unallocatedAmount;
  final Color group1Color;
  final Color group2Color;
  final Color group3Color;
  final Color group4Color;

  const PopupUnallocated({
    super.key,
    required this.totalIncome,
    required this.group1Amount,
    required this.group2Amount,
    required this.group3Amount,
    required this.group4Amount,
    required this.unallocatedAmount,
    required this.group1Color,
    required this.group2Color,
    required this.group3Color,
    required this.group4Color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locProvider = Provider.of<LocalizationProvider>(context);
    final loc = locProvider.loc;

    final pct = calculatePercentage(
      unallocatedAmount,
      totalIncome,
    ).toStringAsFixed(1);
    final p1 = calculatePercentage(
      group1Amount,
      totalIncome,
    ).toStringAsFixed(1);
    final p2 = calculatePercentage(
      group2Amount,
      totalIncome,
    ).toStringAsFixed(1);
    final p3 = calculatePercentage(
      group3Amount,
      totalIncome,
    ).toStringAsFixed(1);
    final p4 = calculatePercentage(
      group4Amount,
      totalIncome,
    ).toStringAsFixed(1);
    final pureUnallocated =
        unallocatedAmount -
        group1Amount -
        group2Amount -
        group3Amount -
        group4Amount;
    calculatePercentage(pureUnallocated, totalIncome).toStringAsFixed(1);

    final double barTotal = totalIncome > 0 ? totalIncome : 1.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: theme.colorScheme.onSurfaceVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title / Close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                loc.unallocatedFunds,
                style: TextStyle(fontSize: AppSize.xs.sp),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close, size: 24.sp),
              ),
            ],
          ),

          // Money display
          Row(
            children: [
              Text(
                locProvider.formatAmount(unallocatedAmount),
                style: TextStyle(fontSize: AppSize.m.sp),
              ),
              SizedBox(width: 8.w),
              SizedBox(
                height: 20.h,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColors.grey),
                    color: AppColors.grey.withValues(alpha: 0.1),
                  ),
                  child: Text(
                    '$pct%',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: AppSize.xs.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // All money in the group
          Text(
            loc.allMoneyInGroup,
            style: TextStyle(fontSize: AppSize.s.sp, color: AppColors.grey),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                width: double.infinity,
                height: 5.h,
                margin: EdgeInsets.only(top: 8.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.r)),
                  color: AppColors.grey.withValues(alpha: 0.2),
                ),
                child: Row(
                  children: [
                    MoneyBar(
                      width: calculateBarWidth(
                        group1Amount,
                        barTotal,
                        constraints.maxWidth,
                      ).toDouble(),
                      color: group1Color,
                    ),
                    MoneyBar(
                      width: calculateBarWidth(
                        group2Amount,
                        barTotal,
                        constraints.maxWidth,
                      ).toDouble(),
                      color: group2Color,
                    ),
                    MoneyBar(
                      width: calculateBarWidth(
                        group3Amount,
                        barTotal,
                        constraints.maxWidth,
                      ).toDouble(),
                      color: group3Color,
                    ),
                    MoneyBar(
                      width: calculateBarWidth(
                        group4Amount,
                        barTotal,
                        constraints.maxWidth,
                      ).toDouble(),
                      color: group4Color,
                    ),
                    MoneyBar(
                      width: calculateBarWidth(
                        pureUnallocated,
                        barTotal,
                        constraints.maxWidth,
                      ).toDouble(),
                      color: AppColors.grey,
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 8.h),

          // Group
          Column(
            children: [
              GroupUnallocatedPopup(
                title: 'Group 1',
                color: group1Color,
                amount: locProvider.formatAmount(group1Amount),
                percentage: '$p1%',
              ),
              GroupUnallocatedPopup(
                title: 'Group 2',
                color: group2Color,
                amount: locProvider.formatAmount(group2Amount),
                percentage: '$p2%',
              ),
              GroupUnallocatedPopup(
                title: 'Group 3',
                color: group3Color,
                amount: locProvider.formatAmount(group3Amount),
                percentage: '$p3%',
              ),
              GroupUnallocatedPopup(
                title: 'Group 4',
                color: group4Color,
                amount: locProvider.formatAmount(group4Amount),
                percentage: '$p4%',
              ),
              GroupUnallocatedPopup(
                title: loc.unallocated,
                color: AppColors.grey.withValues(alpha: 0.2),
                amount: locProvider.formatAmount(unallocatedAmount),
                percentage: '$pct%',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
