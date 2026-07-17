import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bookbank/core/theme/app_theme.dart';
import 'package:bookbank/data/database.dart';
import 'package:bookbank/data/db_helper.dart';
import 'package:bookbank/features/menu/editGroup/providers/group_settings_provider.dart';

class GroupEditDialog extends StatefulWidget {
  final GroupSettings groupSettings;

  const GroupEditDialog({super.key, required this.groupSettings});

  @override
  State<GroupEditDialog> createState() => _GroupEditDialogState();
}

class _GroupEditDialogState extends State<GroupEditDialog> {
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late IconData _selectedIcon;
  late Color _selectedColor;
  late bool _savingsGoalEnabled;

  final List<IconData> _availableIcons = [
    Icons.add,
    Icons.shopping_cart,
    Icons.food_bank,
    Icons.home,
    Icons.directions_car,
    Icons.flight,
    Icons.movie,
    Icons.music_note,
    Icons.book,
    Icons.sports_soccer,
    Icons.health_and_safety,
    Icons.work,
    Icons.school,
    Icons.pets,
    Icons.restaurant,
    Icons.coffee,
    Icons.card_giftcard,
    Icons.celebration,
    Icons.favorite,
    Icons.star,
  ];

  final List<Color> _availableColors = [
    Colors.blue,
    const Color.fromARGB(255, 8, 192, 14),
    Colors.purple,
    Colors.pink,
    Colors.red,
    Colors.orange,
    Colors.teal,
    Colors.cyan,
    Colors.indigo,
    Colors.amber,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.groupSettings.groupName,
    );
    _amountController = TextEditingController(
      text: widget.groupSettings.savingsGoalAmount.toStringAsFixed(2),
    );
    // Find the icon from the available list that matches the codePoint
    _selectedIcon = _availableIcons.firstWhere(
      (icon) => icon.codePoint == widget.groupSettings.iconCodePoint,
      orElse: () => Icons.add,
    );
    _selectedColor = Color(widget.groupSettings.colorValue);
    _savingsGoalEnabled = widget.groupSettings.savingsGoalEnabled;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    final updatedSettings = GroupSettings(
      id: widget.groupSettings.id,
      groupId: widget.groupSettings.groupId,
      groupName: _nameController.text,
      iconCodePoint: _selectedIcon.codePoint,
      colorValue: _selectedColor.toARGB32(),
      savingsGoalEnabled: _savingsGoalEnabled,
      savingsGoalAmount: _savingsGoalEnabled
          ? double.tryParse(_amountController.text) ?? 0
          : 0,
    );

    await DatabaseHelper.instance.updateGroupSettings(updatedSettings);

    // Notify provider to refresh group settings across all screens
    if (mounted) {
      final groupProvider = Provider.of<GroupSettingsProvider>(
        context,
        listen: false,
      );
      await groupProvider.updateGroupSettings(updatedSettings);
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Edit Group',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey,
                ),
              ),
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(Icons.close, color: AppColors.grey),
              ),
            ],
          ),
          SizedBox(height: 24),

          // Group Name
          Text(
            'Group Name',
            style: TextStyle(fontSize: 14, color: AppColors.grey),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.card,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.border),
              ),
            ),
          ),
          SizedBox(height: 16),

          // Icon Selection
          Text('Icon', style: TextStyle(fontSize: 14, color: AppColors.grey)),
          SizedBox(height: 8),
          Container(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _availableIcons.length,
              itemBuilder: (context, index) {
                final icon = _availableIcons[index];
                final isSelected = icon.codePoint == _selectedIcon.codePoint;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIcon = icon;
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _selectedColor.withValues(alpha: 0.3)
                          : AppColors.card,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? _selectedColor : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Icon(icon, color: _selectedColor),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),

          // Color Selection
          Text('Color', style: TextStyle(fontSize: 14, color: AppColors.grey)),
          SizedBox(height: 8),
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _availableColors.length,
              itemBuilder: (context, index) {
                final color = _availableColors[index];
                final isSelected = color.value == _selectedColor.value;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? AppColors.grey : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),

          // Savings Goal Switch
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Enable Savings Goal',
                style: TextStyle(fontSize: 14, color: AppColors.grey),
              ),
              Switch(
                value: _savingsGoalEnabled,
                onChanged: (value) {
                  setState(() {
                    _savingsGoalEnabled = value;
                  });
                },
                activeColor: _selectedColor,
              ),
            ],
          ),
          SizedBox(height: 16),

          // Savings Goal Amount
          if (_savingsGoalEnabled) ...[
            Text(
              'Savings Goal Amount',
              style: TextStyle(fontSize: 14, color: AppColors.grey),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                prefixText: '฿ ',
                filled: true,
                fillColor: AppColors.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],

          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedColor,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
