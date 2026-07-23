import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class GroupUnallocatedPopup extends StatelessWidget {
  final Color color;
  final String amount;
  final String percentage;
  final String title;

  const GroupUnallocatedPopup({
    super.key,
    required this.color,
    required this.amount,
    required this.percentage,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 10,
          height: 10,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(title, style: TextStyle(fontSize: AppSize.m)),
        const SizedBox(width: 10),
        Text(
          '($amount / $percentage)',
          style: TextStyle(fontSize: AppSize.s, color: AppColors.grey),
        ),
      ],
    );
  }
}
