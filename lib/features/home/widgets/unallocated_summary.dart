import 'package:bookbank/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:bookbank/features/home/widgets/unallocated_bar.dart';
import 'package:bookbank/features/home/widgets/unallocated_number.dart';
import 'package:bookbank/utils/calculations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:bookbank/core/localization/localization_provider.dart';
import 'package:bookbank/features/home/popup/popup_unallocated.dart';

class UnallocatedSummary extends StatelessWidget {
  final double incomeTotal;
  final double totalBalance;
  final double unallocatedAmount;
  final double group1Amount;
  final double group2Amount;
  final double group3Amount;
  final double group4Amount;
  final double group1Income;
  final double group2Income;
  final double group3Income;
  final double group4Income;
  final double group1Percentage;
  final double group2Percentage;
  final double group3Percentage;
  final double group4Percentage;
  final double unallocatedPercentage;
  final Color group1Color;
  final Color group2Color;
  final Color group3Color;
  final Color group4Color;

  const UnallocatedSummary({
    super.key,
    required this.incomeTotal,
    required this.totalBalance,
    required this.unallocatedAmount,
    required this.group1Amount,
    required this.group2Amount,
    required this.group3Amount,
    required this.group4Amount,
    required this.group1Income,
    required this.group2Income,
    required this.group3Income,
    required this.group4Income,
    required this.group1Percentage,
    required this.group2Percentage,
    required this.group3Percentage,
    required this.group4Percentage,
    required this.unallocatedPercentage,
    required this.group1Color,
    required this.group2Color,
    required this.group3Color,
    required this.group4Color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final locProvider = Provider.of<LocalizationProvider>(context);
    final loc = locProvider.loc;

    final pureUnallocated = unallocatedAmount;
    final double barTotal = incomeTotal > 0 ? incomeTotal : 1.0;
    final pct = calculatePercentage(
      unallocatedAmount,
      incomeTotal,
    ).toStringAsFixed(1);

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return Dialog(
              child: PopupUnallocated(
                totalIncome: incomeTotal,
                group1Amount: group1Amount,
                group2Amount: group2Amount,
                group3Amount: group3Amount,
                group4Amount: group4Amount,
                group1Income: group1Income,
                group2Income: group2Income,
                group3Income: group3Income,
                group4Income: group4Income,
                unallocatedAmount: unallocatedAmount,
                group1Color: group1Color,
                group2Color: group2Color,
                group3Color: group3Color,
                group4Color: group4Color,
              ),
            );
          },
        );
      },
      child: Container(
        width: double.infinity,
        height: 82.h,
        margin: EdgeInsets.symmetric(vertical: 11.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "${loc.unallocated} ",
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: AppSize.xs.sp,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                Text(
                  locProvider.formatAmount(unallocatedAmount),
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: AppSize.s.sp,
                  ),
                ),
                Text(
                  ' ${loc.from} ',
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: AppSize.xs.sp,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                Text(
                  locProvider.formatAmount(totalBalance),
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: AppSize.s.sp,
                  ),
                ),
              ],
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
                          group1Income,
                          barTotal,
                          constraints.maxWidth,
                        ).toDouble(),
                        color: group1Color,
                      ),
                      MoneyBar(
                        width: calculateBarWidth(
                          group2Income,
                          barTotal,
                          constraints.maxWidth,
                        ).toDouble(),
                        color: group2Color,
                      ),
                      MoneyBar(
                        width: calculateBarWidth(
                          group3Income,
                          barTotal,
                          constraints.maxWidth,
                        ).toDouble(),
                        color: group3Color,
                      ),
                      MoneyBar(
                        width: calculateBarWidth(
                          group4Income,
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
                        color: AppColors.grey.withValues(alpha: 0.2),
                      ),
                    ],
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MoneyNumber(
                  amount: group1Amount,
                  color: group1Color,
                  percentage: group1Percentage,
                ),
                MoneyNumber(
                  amount: group2Amount,
                  color: group2Color,
                  percentage: group2Percentage,
                ),
                MoneyNumber(
                  amount: group3Amount,
                  color: group3Color,
                  percentage: group3Percentage,
                ),
                MoneyNumber(
                  amount: group4Amount,
                  color: group4Color,
                  percentage: group4Percentage,
                ),
                MoneyNumber(
                  amount: unallocatedAmount,
                  color: AppColors.grey.withValues(alpha: 0.2),
                  percentage: double.parse(pct),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
