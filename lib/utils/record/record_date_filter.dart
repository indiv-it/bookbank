import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bookbank/Core/Theme/app_style.dart';

/// Checks if a date range is currently selected.
bool hasDateRange(DateTime? startDate, DateTime? endDate) {
  return startDate != null && endDate != null;
}

/// Returns the label for the date range button.
String getDateRangeLabel(DateTime? startDate, DateTime? endDate) {
  if (!hasDateRange(startDate, endDate)) return 'dd/mm/yyyy';
  return '${DateFormat('dd/MM').format(startDate!)} - '
      '${DateFormat('dd/MM/yyyy').format(endDate!)}';
}

/// Opens the date range picker dialog.
Future<DateTimeRange?> selectDateRange(
  BuildContext context,
  DateTime? startDate,
  DateTime? endDate,
) async {
  final hasRange = hasDateRange(startDate, endDate);
  return await showDateRangePicker(
    context: context,
    initialDateRange: hasRange
        ? DateTimeRange(start: startDate!, end: endDate!)
        : DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 7)),
            end: DateTime.now(),
          ),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.black,
            onPrimary: Colors.white,
            surface: AppColors.card,
            onSurface: Colors.black,
          ),
          dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
        ),
        child: child!,
      );
    },
  );
}

/// Filters transactions by date range.
List<T> filterByDateRange<T>(
  List<T> items,
  DateTime? startDate,
  DateTime? endDate,
  String Function(T) getDate,
) {
  if (!hasDateRange(startDate, endDate)) return items;

  return items.where((item) {
    final dateString = getDate(item);
    if (dateString.isEmpty) return false;
    try {
      final itemDate = DateFormat('yyyy-MM-dd').parse(dateString);
      final start = DateTime(startDate!.year, startDate.month, startDate.day);
      final end = DateTime(endDate!.year, endDate.month, endDate.day);
      final normalized = DateTime(itemDate.year, itemDate.month, itemDate.day);
      if (normalized.isBefore(start) || normalized.isAfter(end)) {
        return false;
      }
      return true;
    } catch (_) {
      return false;
    }
  }).toList();
}
