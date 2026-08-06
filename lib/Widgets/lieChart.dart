// TODO Implement this library.
import 'package:fl_chart/fl_chart.dart';
import 'package:bookbank/core/theme/app_theme.dart';

// ----- Line Chart Helper Functions -----

List<LineChartBarData> createSegmentsWithArea(List<FlSpot> spots) {
  List<LineChartBarData> segments = [];

  for (int i = 0; i < spots.length - 1; i++) {
    final start = spots[i];
    final end = spots[i + 1];

    if ((start.y >= 0 && end.y >= 0) || (start.y < 0 && end.y < 0)) {
      final color = start.y >= 0 ? AppColors.green : AppColors.red;

      segments.add(
        LineChartBarData(
          spots: [start, end],
          isCurved: true,
          color: color,
          barWidth: 1.5,
          dotData: FlDotData(show: false),

          belowBarData: BarAreaData(
            show: true,
            color: color.withValues(alpha: 0.2),
          ),
        ),
      );
      continue;
    }

    final ratio = start.y / (start.y - end.y);
    final x0 = start.x + (end.x - start.x) * ratio;
    final zeroPoint = FlSpot(x0, 0);

    final color1 = start.y >= 0 ? AppColors.green : AppColors.red;

    segments.add(
      LineChartBarData(
        spots: [start, zeroPoint],
        isCurved: true,
        color: color1,
        barWidth: 1.5,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: color1.withValues(alpha: 0.2),
        ),
      ),
    );

    final color2 = end.y >= 0 ? AppColors.green : AppColors.red;

    segments.add(
      LineChartBarData(
        spots: [zeroPoint, end],
        isCurved: true,
        color: color2,
        barWidth: 1.5,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: color2.withValues(alpha: 0.25),
        ),
      ),
    );
  }

  return segments;
}