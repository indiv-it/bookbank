import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Theme / Database
import '../../../core/theme/app_theme.dart';
import '../../../data/database.dart';

// Functions
import '../utils/record_utils.dart';
import '../utils/record_filter.dart';

/// Builds a detail row for the record details dialog.
Widget buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: TextStyle(fontSize: AppSize.s, color: AppColors.grey),
          ),
        ),
        Expanded(
          child: Text(value, style: TextStyle(fontSize: AppSize.s)),
        ),
      ],
    ),
  );
}

/// Builds a filter tab widget for the record filter bar.
Widget buildFilterTab({
  required BuildContext context,
  required RecordFilter value,
  required RecordFilter selectedFilter,
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  final theme = Theme.of(context);
  final isSelected = selectedFilter == value;

  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.onSurface : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected) ...[
              Icon(icon, size: AppSize.s, color: theme.colorScheme.surface),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: AppSize.xs,
                color: isSelected ? theme.colorScheme.surface : AppColors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget recondListView(IconData icon, String title, String data) {
  return Row(
    children: [
      Icon(icon, size: AppSize.xl),
      const SizedBox(width: 8),
      Text(
        '$title :',
        style: TextStyle(fontSize: AppSize.s, color: AppColors.grey),
      ),
      const SizedBox(width: 8),
      Text(data),
    ],
  );
}

/// Builds a single record row in the list.
Widget buildRecordRow(
  BuildContext context,
  MyData item,
  void Function(String) onMenuAction,
) {
  final theme = Theme.of(context);
  final isTransfer = item.moneyType == 'transfer';
  final isIncome = item.moneyType == 'income';

  final fromLabel = item.moneyList == 'bank' ? 'Bank' : 'Cash';
  final toLabel = item.moneyGroup == 'bank' ? 'Bank' : 'Cash';

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isTransfer
                      ? AppColors.amber
                      : (isIncome ? AppColors.green : AppColors.red),
                  width: 1,
                ),
                color: isIncome
                    ? AppColors.green.withValues(alpha: 0.2)
                    : isTransfer
                    ? AppColors.amber.withValues(alpha: 0.2)
                    : AppColors.red.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isIncome
                    ? Icons.trending_up
                    : isTransfer
                    ? Icons.swap_horiz
                    : Icons.trending_down,
                size: 16,
                color: isTransfer
                    ? AppColors.amber
                    : (isIncome ? AppColors.green : AppColors.red),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '฿ ${item.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: AppSize.s - 1,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    isTransfer ? 'Alternate' : '${item.title}',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                isTransfer
                    ? '$fromLabel → $toLabel'
                    : isIncome
                    ? 'Income'
                    : 'Expense',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                formatDisplayDate(item.date),
                style: TextStyle(
                  fontSize: 10.sp,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.end,
              ),
            ),
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.more_horiz,
                size: 18,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              color: theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: theme.colorScheme.outline),
              ),
              onSelected: onMenuAction,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'view',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.visibility, size: AppSize.l),
                      const SizedBox(width: 8),
                      Text('View', style: TextStyle(fontSize: AppSize.s)),
                    ],
                  ),
                ),
                if (!isTransfer) ...[
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit, size: AppSize.l),
                        const SizedBox(width: 8),
                        Text('Edit', style: TextStyle(fontSize: AppSize.s)),
                      ],
                    ),
                  ),
                ],
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.delete, color: AppColors.red, size: AppSize.l),
                      const SizedBox(width: 8),
                      Text(
                        'Delete',
                        style: TextStyle(
                          color: AppColors.red,
                          fontSize: AppSize.s,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      const Divider(height: 1),
    ],
  );
}

/// Menu item widgets for better organization.
class ViewMenuItem extends StatelessWidget {
  const ViewMenuItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('View');
  }
}

class EditMenuItem extends StatelessWidget {
  const EditMenuItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Edit');
  }
}

class DeleteMenuItem extends StatelessWidget {
  const DeleteMenuItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Delete');
  }
}
