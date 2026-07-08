import 'package:bookbank/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:bookbank/Widgets/popups/popup_unallocated.dart';
import 'package:bookbank/Widgets/unallocated_bar.dart';
import 'package:bookbank/Widgets/unallocated_number.dart';
import 'package:bookbank/utils/calculations.dart';

class UnallocatedSummary extends StatelessWidget {
  final double incomeTotal;
  final double totalBalance;
  final double unallocatedAmount;
  final double group1Amount;
  final double group2Amount;
  final double group3Amount;
  final double group4Amount;
  final double group1Percentage;
  final double group2Percentage;
  final double group3Percentage;
  final double group4Percentage;
  final double unallocatedPercentage;

  const UnallocatedSummary({
    super.key,
    required this.incomeTotal,
    required this.totalBalance,
    required this.unallocatedAmount,
    required this.group1Amount,
    required this.group2Amount,
    required this.group3Amount,
    required this.group4Amount,
    required this.group1Percentage,
    required this.group2Percentage,
    required this.group3Percentage,
    required this.group4Percentage,
    required this.unallocatedPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final pureUnallocated =
        unallocatedAmount -
        group1Amount -
        group2Amount -
        group3Amount -
        group4Amount;
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
                unallocatedAmount: unallocatedAmount,
              ),
            );
          },
        );
      },
      child: Container(
        width: double.infinity,
        height: 80,
        margin: const EdgeInsets.symmetric(vertical: 11),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "Unallocated ",
                  style: textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                Text(
                  '฿ ${unallocatedAmount.toStringAsFixed(2)}',
                  style: textTheme.bodySmall,
                ),
                Text(
                  ' from ',
                  style: textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                Text(
                  '฿ ${totalBalance.toStringAsFixed(2)}',
                  style: textTheme.bodySmall,
                ),
              ],
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  width: double.infinity,
                  height: 5,
                  margin: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: AppColors.border,
                  ),
                  child: Row(
                    children: [
                      MoneyBar(
                        width: calculateBarWidth(
                          group1Amount,
                          barTotal,
                          constraints.maxWidth,
                        ).toDouble(),
                        color: AppColors.blue,
                      ),
                      MoneyBar(
                        width: calculateBarWidth(
                          group2Amount,
                          barTotal,
                          constraints.maxWidth,
                        ).toDouble(),
                        color: AppColors.orange,
                      ),
                      MoneyBar(
                        width: calculateBarWidth(
                          group3Amount,
                          barTotal,
                          constraints.maxWidth,
                        ).toDouble(),
                        color: AppColors.purple,
                      ),
                      MoneyBar(
                        width: calculateBarWidth(
                          group4Amount,
                          barTotal,
                          constraints.maxWidth,
                        ).toDouble(),
                        color: AppColors.pink,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MoneyNumber(
                  amount: group1Amount,
                  color: AppColors.blue,
                  percentage: group1Percentage,
                ),
                MoneyNumber(
                  amount: group2Amount,
                  color: AppColors.orange,
                  percentage: group2Percentage,
                ),
                MoneyNumber(
                  amount: group3Amount,
                  color: AppColors.purple,
                  percentage: group3Percentage,
                ),
                MoneyNumber(
                  amount: group4Amount,
                  color: AppColors.pink,
                  percentage: group4Percentage,
                ),
                MoneyNumber(
                  amount: unallocatedAmount,
                  color: AppColors.border,
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
