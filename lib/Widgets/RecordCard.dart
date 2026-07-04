import 'package:flutter/material.dart';

class RecordCard extends StatelessWidget {
  final String title;
  final String date;
  final String amount;

  const RecordCard({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.green,
            ),
          ),

          Text(amount),
          Text(title),
          Text(date),
        ],
      ),
    );
  }
}
