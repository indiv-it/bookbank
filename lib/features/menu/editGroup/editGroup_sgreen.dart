import 'package:bookbank/core/theme/app_theme.dart';
import 'package:bookbank/data/database.dart';
import 'package:bookbank/data/db_helper.dart';
import 'package:bookbank/features/menu/editGroup/group_edit_dialog.dart';
import 'package:flutter/material.dart';

class EditGroupSgreen extends StatefulWidget {
  const EditGroupSgreen({super.key});

  @override
  State<EditGroupSgreen> createState() => _EditGroupSgreenState();
}

class _EditGroupSgreenState extends State<EditGroupSgreen> {
  List<GroupSettings> _groupSettings = [];
  bool _isLoading = true;

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

  IconData _getIconFromCodePoint(int codePoint) {
    return _availableIcons.firstWhere(
      (icon) => icon.codePoint == codePoint,
      orElse: () => Icons.add,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadGroupSettings();
  }

  Future<void> _loadGroupSettings() async {
    final settings = await DatabaseHelper.instance.getAllGroupSettings();
    if (mounted) {
      setState(() {
        _groupSettings = settings;
        _isLoading = false;
      });
    }
  }

  Future<void> _editGroup(GroupSettings settings) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) =>
          Dialog(child: GroupEditDialog(groupSettings: settings)),
    );
    if (result == true) {
      await _loadGroupSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      constraints: BoxConstraints(maxHeight: 500),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.edit, size: AppSize.l),
              SizedBox(width: 8),
              Text('Edit Groups', style: TextStyle(fontSize: AppSize.m)),
            ],
          ),
          SizedBox(height: 16),

          // Group List
          if (_isLoading)
            Center(child: CircularProgressIndicator())
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _groupSettings.length,
                itemBuilder: (context, index) {
                  final group = _groupSettings[index];
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(5),
                      border: Border(
                        bottom: index == _groupSettings.length - 1
                            ? BorderSide.none
                            : BorderSide(
                                color: AppColors.grey.withValues(alpha: 0.3),
                                width: 1,
                              ),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Icon
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Color(group.colorValue)),
                            color: Color(
                              group.colorValue,
                            ).withValues(alpha: 0.3),
                          ),
                          child: Icon(
                            _getIconFromCodePoint(group.iconCodePoint),
                            color: Color(group.colorValue),
                            size: 18,
                          ),
                        ),
                        SizedBox(width: 16),

                        // Group Name
                        Expanded(
                          child: Text(
                            group.groupName,
                            style: TextStyle(
                              fontSize: AppSize.m,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        // Edit Button
                        IconButton(
                          icon: Icon(Icons.edit, color: AppColors.grey),
                          onPressed: () => _editGroup(group),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
