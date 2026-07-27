import 'package:flutter/material.dart';
import 'package:bookbank/features/add_transaction/widgets/list_button.dart';

class TypeSelector extends StatelessWidget {
  final String? selectedType;
  final ValueChanged<String> onChanged;

  const TypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Money List',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline),
            borderRadius: BorderRadius.circular(10),
            color: theme.colorScheme.surface,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ListButton(
                buttonKey: 'Income',
                titel: "Income",
                icon: Icons.trending_up,
                onKey: selectedType,
                function: () => onChanged('Income'),
              ),
              ListButton(
                buttonKey: 'Expense',
                titel: "Expense",
                icon: Icons.trending_down,
                onKey: selectedType,
                function: () => onChanged('Expense'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
