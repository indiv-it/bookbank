import 'package:flutter/material.dart';
import '../../../core/theme/app_style.dart';

class MoneyNumber extends StatelessWidget {
  final double amount;
  final Color color;
  final double? percentage;

  const MoneyNumber({
    super.key,
    required this.amount,
    required this.color,
    this.percentage,
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
        const SizedBox(width: 5),
        Text(
          percentage != null
              ? '${percentage!.toStringAsFixed(1)}%'
              : amount.toString(),
          style: AppSize.s,
        ),
      ],
    );
  }
}
