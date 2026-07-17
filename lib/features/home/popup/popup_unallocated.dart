import 'package:flutter/material.dart';
import 'package:bookbank/core/theme/app_style.dart';
import 'package:bookbank/features/home/widgets/unallocated_bar.dart';
import 'package:bookbank/features/home/popup/popup_group_unallocated.dart';
import 'package:bookbank/utils/calculations.dart';

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
      width: 100,
      height: 280,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title / Close button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close),
              ),
            ],
          ),
          Text('Unallocated Funds', style: AppSize.s),
          const SizedBox(height: 8),

          // Money display
          Row(
            children: [
              Text(
                '฿ ${unallocatedAmount.toStringAsFixed(2)}',
                style: AppSize.m,
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 20,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.grey),
                    color: AppColors.grey.withValues(alpha: 0.1),
                  ),
                  child: Text(
                    '$pct%',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: AppSize.s.fontSize,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // All money in the group
          Text(
            'All money in the group',
            style: AppSize.s.copyWith(color: AppColors.grey),
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
          const SizedBox(height: 8),

          // Group
          Column(
            children: [
              GroupUnallocatedPopup(
                title: 'Group 1',
                color: group1Color,
                amount: '฿ ${group1Amount.toStringAsFixed(2)}',
                percentage: '$p1%',
              ),
              GroupUnallocatedPopup(
                title: 'Group 2',
                color: group2Color,
                amount: '฿ ${group2Amount.toStringAsFixed(2)}',
                percentage: '$p2%',
              ),
              GroupUnallocatedPopup(
                title: 'Group 3',
                color: group3Color,
                amount: '฿ ${group3Amount.toStringAsFixed(2)}',
                percentage: '$p3%',
              ),
              GroupUnallocatedPopup(
                title: 'Group 4',
                color: group4Color,
                amount: '฿ ${group4Amount.toStringAsFixed(2)}',
                percentage: '$p4%',
              ),
              GroupUnallocatedPopup(
                title: 'Unallocated',
                color: AppColors.border,
                amount: '฿ ${unallocatedAmount.toStringAsFixed(2)}',
                percentage: '$pct%',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
