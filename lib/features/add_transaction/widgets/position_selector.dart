import 'package:bookbank/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:bookbank/features/add_transaction/widgets/list_button.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Money Position',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(10),
            color: theme.colorScheme.surface,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ListButton(
                buttonKey: 'Bank',
                titel: 'Bank',
                icon: Icons.account_balance_rounded,
                onKey: selectedPosition,
                function: () => onChanged('Bank'),
              ),
              ListButton(
                buttonKey: 'Cash',
                titel: 'Cash',
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
