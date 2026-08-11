import 'package:bookbank/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:bookbank/features/add_transaction/widgets/list_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:bookbank/core/localization/localization_provider.dart';

class CategorySelector extends StatelessWidget {
  final String? selectedGroup;
  final ValueChanged<String?> onChanged;
  final Map<String, String> categoryNames;

  const CategorySelector({
    super.key,
    required this.selectedGroup,
    required this.onChanged,
    required this.categoryNames,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = Provider.of<LocalizationProvider>(context).loc;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.category,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: AppSize.xs.sp,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline),
            borderRadius: BorderRadius.circular(10),
            color: theme.colorScheme.surface,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ListButton(
                    buttonKey: 'Group1',
                    titel: categoryNames['Group1'] ?? 'Group1',
                    onKey: selectedGroup,
                    function: () {
                      onChanged(selectedGroup == 'Group1' ? null : 'Group1');
                    },
                  ),
                  ListButton(
                    buttonKey: 'Group2',
                    titel: categoryNames['Group2'] ?? 'Group2',
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
                    buttonKey: 'Group3',
                    titel: categoryNames['Group3'] ?? 'Group3',
                    onKey: selectedGroup,
                    function: () {
                      onChanged(selectedGroup == 'Group3' ? null : 'Group3');
                    },
                  ),
                  ListButton(
                    buttonKey: 'Group4',
                    titel: categoryNames['Group4'] ?? 'Group4',
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
