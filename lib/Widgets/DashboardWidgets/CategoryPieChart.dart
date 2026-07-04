import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:bookbank/Theme/app_style.dart';

class CategoryPieChart extends StatelessWidget {
  final Map<String, double> categoryExpenses;
  final double totalExpense;
  final Map<String, IconData> categoryIcons;
  final Map<String, Color> categoryColors;

  const CategoryPieChart({
    super.key,
    required this.categoryExpenses,
    required this.totalExpense,
    required this.categoryIcons,
    required this.categoryColors,
  });

  @override
  Widget build(BuildContext context) {
    if (totalExpense <= 0) {
      return Center(
        child: Text(
          'Not enough data',
          style: TextStyle(color: AppColors.grey, fontSize: AppSize.s.fontSize),
        ),
      );
    }

    return Row(
      children: [
        // Left: Pie Chart
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 150,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 10,
                sections: _buildPieSections(),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Right: Category list
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: categoryExpenses.entries.map((entry) {
              final category = entry.key;
              final amount = entry.value;
              final percentage = (amount / totalExpense) * 100;
              final icon = categoryIcons[category] ?? Icons.category;
              final color = categoryColors[category] ?? AppColors.grey;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(icon, color: color, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(category, style: AppSize.s),
                          Text(
                            '\฿${amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: AppSize.xs.fontSize,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: AppSize.s.fontSize,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildPieSections() {
    final List<PieChartSectionData> sections = [];
    int colorIndex = 0;
    final List<Color> colors = [
      AppColors.blue,
      AppColors.orange,
      AppColors.purple,
      AppColors.pink,
    ];

    for (final entry in categoryExpenses.entries) {
      final value = entry.value;
      final percentage = (value / totalExpense) * 100;
      final color =
          categoryColors[entry.key] ?? colors[colorIndex % colors.length];

      sections.add(
        PieChartSectionData(
          value: value,
          title: '${percentage.toStringAsFixed(0)}%',
          color: color,
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      colorIndex++;
    }

    return sections;
  }
}
