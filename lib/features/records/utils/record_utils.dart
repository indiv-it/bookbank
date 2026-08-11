import 'package:intl/intl.dart';
import '../../../data/database.dart';

/// Returns the display name for a transaction item.
String getItemName(MyData item, {String anonymousText = 'Anonymous'}) {
  final parts = <String>[];
  if (item.title != null &&
      item.title!.isNotEmpty &&
      item.title != 'Anonymous') {
    parts.add(item.title!);
  } else if (item.title == 'Anonymous') {
    parts.add(anonymousText);
  }
  if (item.moneyGroup.isNotEmpty) {
    parts.add(item.moneyGroup);
  }
  parts.add('${item.moneyList} ${item.moneyType}');
  return parts.join(' ');
}

/// Formats a date string from 'yyyy-MM-dd' to 'dd/MM/yyyy'.
String formatDisplayDate(String? date) {
  if (date == null || date.isEmpty) return '-';
  try {
    final dt = DateFormat('yyyy-MM-dd').parse(date);
    return DateFormat('dd/MM/yyyy').format(dt);
  } catch (_) {
    return date;
  }
}
