import 'package:bookbank/data/database.dart';
import 'package:bookbank/Widgets/popups/popup_group.dart';
import 'package:flutter/material.dart';
import '../Core/Theme/app_style.dart';

class GroupCard extends StatelessWidget {
  final String groupName;
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
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return Dialog(
              child: PopupGroup(
                groupName: groupName,
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
        height: 140,
        width: 150,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 45,
                  height: 45,
                  margin: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: groupColor),
                    color: groupColor.withValues(alpha: 0.3),
                  ),
                  child: Icon(groupIcon, color: groupColor),
                ),
                Icon(
                  Icons.arrow_outward_sharp,
                  size: 20,
                  color: AppColors.grey,
                ),
              ],
            ),
            Text(
              groupName,
              style: TextStyle(
                color: AppColors.grey,
                fontSize: AppSize.s.fontSize,
              ),
            ),
            Row(
              children: [
                Text('\$${groupAmount.toStringAsFixed(2)}', style: AppSize.m),
                Spacer(),
                if (savingsGoalEnabled && savingsGoalAmount > 0) ...[
                  Text(
                    '฿${savingsGoalAmount.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: AppSize.s.fontSize,
                    ),
                  ),
                ],
              ],
            ),
            if (savingsGoalEnabled && savingsGoalAmount > 0) ...[
              SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (groupAmount / savingsGoalAmount).clamp(0.0, 1.0),
                      backgroundColor: AppColors.grey.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(groupColor),
                      minHeight: 4,
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
