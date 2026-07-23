import 'package:flutter/material.dart';
import 'package:bookbank/core/theme/app_theme.dart';

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
        Icon(icon, size: AppSize.xl),
        const SizedBox(height: 4),
        Text(title, style: TextStyle(fontSize: AppSize.s)),
        const SizedBox(height: 4),
        Text(
          '฿${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: AppSize.s,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
