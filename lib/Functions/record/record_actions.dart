import 'package:flutter/material.dart';

// Functions
import 'record_utils.dart';
import '../../Widgets/record_widgets.dart';

// Screens
import 'package:bookbank/Screens/AddItem.dart';

// Database / Style
import '../../Server/database.dart';
import '../../Server/db_helper.dart';
import '../../Theme/app_style.dart';

/// Shows the record details dialog.
Future<void> viewRecord(BuildContext context, MyData item) async {
  final isIncome = item.moneyType == 'income';
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.card,
      title: const Text('Record Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildDetailRow(
            'Amount',
            '${isIncome ? '+' : '-'}฿ ${item.amount.toStringAsFixed(2)}',
          ),
          buildDetailRow('Name', item.title ?? 'Anonymous'),
          buildDetailRow('Type', isIncome ? 'Income' : 'Expense'),
          buildDetailRow(
            'Category',
            item.moneyList == 'bank' ? 'Bank' : 'Cash',
          ),
          if (item.moneyGroup.isNotEmpty)
            buildDetailRow('Group', item.moneyGroup),
          buildDetailRow('Date', formatDisplayDate(item.date)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

/// Opens the edit bottom sheet for a record.
Future<void> editRecord(
  BuildContext context,
  MyData item,
  VoidCallback onSaved,
) async {
  await showAddItemBottomSheet(context, existingItem: item, onSaved: onSaved);
}

/// Deletes a record after confirmation.
Future<void> deleteRecord(
  BuildContext context,
  MyData item,
  VoidCallback onDeleted,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.card,
      title: const Text('Delete'),
      content: const Text('Are you sure you want to delete this record?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('Delete', style: TextStyle(color: AppColors.red)),
        ),
      ],
    ),
  );

  if (confirmed != true || item.id == null) return;

  await DatabaseHelper.instance.deleteData(item.id!);
  onDeleted();
  if (context.mounted) {
    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.width * 1.4,
          left: MediaQuery.of(context).size.width * 0.5,
          right: 16,
        ),
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: AppColors.red, width: 3)),
          ),
          padding: EdgeInsets.only(left: 8),
          child: Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.red),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Deleted successfully',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: AppSize.s.fontSize,
                  ),
                ),
              ),
            ],
          ),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
