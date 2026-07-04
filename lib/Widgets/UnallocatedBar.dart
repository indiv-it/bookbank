import 'package:flutter/material.dart';

class MoneyBar extends StatelessWidget {
  final double width;
  final Color color;

  const MoneyBar({super.key, required this.width, required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: width.clamp(0.0, constraints.maxWidth),
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color,
          ),
        );
      },
    );
  }
}
