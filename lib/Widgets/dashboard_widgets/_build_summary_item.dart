import 'package:flutter/material.dart';
import 'package:bookbank/Core/Theme/app_style.dart';

class BuildSummaryItem extends StatelessWidget {
  const BuildSummaryItem({
    super.key,
    required this.icon,
    required this.title,
    required this.amount,
    required this.color,
  });

  final IconData icon;
  final String title;
  final double amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: AppSize.xl.fontSize),
        const SizedBox(height: 4),
        Text(title, style: AppSize.s),
        const SizedBox(height: 4),
        Text(
          '฿${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: AppSize.s.fontSize,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
