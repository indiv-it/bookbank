import 'package:flutter/material.dart';

// Theme / Database
import '../Core/Theme/app_style.dart';
import '../data/database.dart';

// Functions
import '../utils/record/record_utils.dart';
import '../utils/record/record_filter.dart';

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
            style: TextStyle(
              fontSize: AppSize.s.fontSize,
              color: AppColors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(value, style: TextStyle(fontSize: AppSize.s.fontSize)),
        ),
      ],
    ),
  );
}

/// Builds a filter tab widget for the record filter bar.
Widget buildFilterTab({
  required RecordFilter value,
  required RecordFilter selectedFilter,
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  final isSelected = selectedFilter == value;

  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected) ...[
              Icon(icon, size: AppSize.m.fontSize, color: AppColors.card),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: AppSize.s.fontSize,
                color: isSelected ? AppColors.card : AppColors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Builds a single record row in the list.
Widget buildRecordRow(MyData item, void Function(String) onMenuAction) {
  final isTransfer = item.moneyType == 'transfer';

  // ===== Money Position row (special yellow UI) =====
  if (isTransfer) {
    final fromLabel = item.moneyList == 'bank' ? 'Bank' : 'Cash';
    final toLabel = item.moneyGroup == 'bank' ? 'Bank' : 'Cash';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFDE7), // yellow[50]
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFFFD54F), width: 1), // amber[300]
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD54F),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.swap_horiz_rounded,
                  size: 16,
                  color: Color(0xFF5D4037),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Money Position',
                      style: TextStyle(
                        fontSize: AppSize.xs.fontSize,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF5D4037),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          fromLabel,
                          style: TextStyle(
                            fontSize: (AppSize.xs.fontSize ?? 12) - 1,
                            color: const Color(0xFF8D6E63),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            Icons.arrow_forward,
                            size: 12,
                            color: Color(0xFF8D6E63),
                          ),
                        ),
                        Text(
                          toLabel,
                          style: TextStyle(
                            fontSize: (AppSize.xs.fontSize ?? 12) - 1,
                            color: const Color(0xFF8D6E63),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  '฿ ${item.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: AppSize.xs.fontSize,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF5D4037),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  formatDisplayDate(item.date),
                  style: TextStyle(
                    fontSize: AppSize.xs.fontSize,
                    color: const Color(0xFF8D6E63),
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.more_horiz, size: 18, color: Color(0xFF8D6E63)),
                color: AppColors.card,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: AppColors.border),
                ),
                onSelected: onMenuAction,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'view',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.visibility, size: AppSize.l.fontSize),
                        const SizedBox(width: 8),
                        Text('View', style: TextStyle(fontSize: AppSize.s.fontSize)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.delete, color: AppColors.red, size: AppSize.l.fontSize),
                        const SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: AppColors.red, fontSize: AppSize.s.fontSize)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 1,
          child: Divider(color: AppColors.border),
        ),
      ],
    );
  }

  // ===== Normal Income / Expense row =====
  final isIncome = item.moneyType == 'income';

  return Column(
    children: [
      Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: isIncome ? AppColors.green : AppColors.red,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              '฿ ${item.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: AppSize.xs.fontSize,
                color: AppColors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              item.moneyList == 'bank' ? 'Bank' : 'Cash',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: AppSize.xs.fontSize),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              formatDisplayDate(item.date),
              style: TextStyle(
                fontSize: AppSize.xs.fontSize,
                color: AppColors.grey,
              ),
              textAlign: TextAlign.end,
            ),
          ),
          PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.more_horiz, size: 18),
            color: AppColors.card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: AppColors.border),
            ),
            onSelected: onMenuAction,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'view',
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.visibility, size: AppSize.l.fontSize),
                    const SizedBox(width: 8),
                    Text(
                      'View',
                      style: TextStyle(fontSize: AppSize.s.fontSize),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit, size: AppSize.l.fontSize),
                    const SizedBox(width: 8),
                    Text(
                      'Edit',
                      style: TextStyle(fontSize: AppSize.s.fontSize),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.delete,
                      color: AppColors.red,
                      size: AppSize.l.fontSize,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Delete',
                      style: TextStyle(
                        color: AppColors.red,
                        fontSize: AppSize.s.fontSize,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      SizedBox(
        width: double.infinity,
        height: 1,
        child: Divider(color: AppColors.border),
      ),
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
