import 'package:bookbank/features/records/widgets/record_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

// Screens
import 'package:bookbank/features/add_transaction/add_transaction_screen.dart';

// Database / Style
import '../../../data/database.dart';
import '../../../data/db_helper.dart';
import '../../../core/theme/app_theme.dart';
import '../../../features/menu/editGroup/providers/group_settings_provider.dart';

/// Shows the record details dialog.
Future<void> viewRecord(BuildContext context, MyData item) async {
  final isIncome = item.moneyType == 'income';
  final isTransfer = item.moneyType == 'transfer';

  final fromLabel = item.moneyList == 'bank' ? 'Bank' : 'Cash';
  final toLabel = item.moneyGroup == 'bank' ? 'Bank' : 'Cash';

  // Get group settings to display dynamic group name
  final groupSettings = context.read<GroupSettingsProvider>().groupSettings;

  String getGroupName(String groupId) {
    final settings = groupSettings.firstWhere(
      (s) => s.groupId == groupId,
      orElse: () => GroupSettings(
        groupId: groupId,
        groupName: groupId,
        iconCodePoint: Icons.add.codePoint,
        colorValue: Colors.grey.toARGB32(),
        savingsGoalEnabled: false,
        savingsGoalAmount: 0,
      ),
    );
    return settings.groupName;
  }

  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header / Exit button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 10,
                    height: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: isIncome
                            ? AppColors.green
                            : item.moneyType == 'transfer'
                            ? AppColors.orange
                            : AppColors.red,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${item.moneyType == 'transfer' ? 'Alternative' : item.title}',
                    style: TextStyle(fontSize: AppSize.s),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close),
              ),
            ],
          ),
          Text(
            '฿${item.amount.toStringAsFixed(0)}',
            style: TextStyle(fontSize: AppSize.l),
          ),
          const SizedBox(height: 16),
          recondListView(
            isIncome
                ? Icons.trending_up
                : item.moneyType == 'transfer'
                ? Icons.swap_horiz
                : Icons.trending_down,
            'Money List',
            isIncome
                ? 'Income'
                : item.moneyType == 'transfer'
                ? 'Alternative'
                : 'Expense',
          ),
          const SizedBox(height: 8),
          recondListView(
            item.moneyList == 'bank'
                ? Icons.account_balance
                : Icons.account_balance_wallet,
            'Money Position',
            isTransfer
                ? '$fromLabel → $toLabel'
                : item.moneyList == 'bank'
                ? 'Bank'
                : 'Cash',
          ),
          const SizedBox(height: 8),
          recondListView(
            Icons.group_outlined,
            'Group',
            item.moneyType == 'transfer' ? '' : getGroupName(item.moneyGroup),
          ),
          const SizedBox(height: 8),
          recondListView(Icons.date_range, 'Date', item.date.toString()),
        ],
      ),
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
  final theme = Theme.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: theme.colorScheme.onSurfaceVariant),
      ),
      title: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: theme.colorScheme.error),
          const SizedBox(width: 8),
          const Text('Delete'),
        ],
      ),
      content: const Text('Are you sure you want to delete this record?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            'Cancel',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.red,
            foregroundColor: AppColors.card,
          ),
          child: const Text('Delete'),
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
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 16,
          right: 16,
        ),
        backgroundColor: AppColors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: AppColors.background, width: 3),
            ),
          ),
          padding: EdgeInsets.only(left: 8),
          child: Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: AppColors.background,
                size: 24,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Deleted successfully',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.background,
                  ),
                ),
              ),
            ],
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
