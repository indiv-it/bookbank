import 'package:bookbank/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:bookbank/features/add_transaction/widgets/list_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:bookbank/core/localization/localization_provider.dart';

class PositionSelector extends StatelessWidget {
  final String? selectedPosition;
  final ValueChanged<String> onChanged;

  const PositionSelector({
    super.key,
    required this.selectedPosition,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = Provider.of<LocalizationProvider>(context).loc;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.moneyPosition,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: AppSize.xs.sp,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          padding: EdgeInsets.symmetric(vertical: 3.w),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.onSurfaceVariant),
            borderRadius: BorderRadius.circular(10),
            color: theme.colorScheme.surface,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ListButton(
                buttonKey: 'Bank',
                titel: loc.bank,
                icon: Icons.account_balance_rounded,
                onKey: selectedPosition,
                function: () => onChanged('Bank'),
              ),
              ListButton(
                buttonKey: 'Cash',
                titel: loc.cash,
                icon: Icons.account_balance_wallet,
                onKey: selectedPosition,
                function: () => onChanged('Cash'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
