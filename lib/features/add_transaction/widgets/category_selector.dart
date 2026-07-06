import 'package:bookbank/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:bookbank/Widgets/list_button.dart';

class CategorySelector extends StatelessWidget {
  final String? selectedGroup;
  final ValueChanged<String?> onChanged;

  const CategorySelector({
    super.key,
    required this.selectedGroup,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(10),
            color: theme.colorScheme.surface,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ListButton(
                    titel: 'Group1',
                    onKey: selectedGroup,
                    function: () {
                      onChanged(selectedGroup == 'Group1' ? null : 'Group1');
                    },
                  ),
                  ListButton(
                    titel: 'Group2',
                    onKey: selectedGroup,
                    function: () {
                      onChanged(selectedGroup == 'Group2' ? null : 'Group2');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ListButton(
                    titel: 'Group3',
                    onKey: selectedGroup,
                    function: () {
                      onChanged(selectedGroup == 'Group3' ? null : 'Group3');
                    },
                  ),
                  ListButton(
                    titel: 'Group4',
                    onKey: selectedGroup,
                    function: () {
                      onChanged(selectedGroup == 'Group4' ? null : 'Group4');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
