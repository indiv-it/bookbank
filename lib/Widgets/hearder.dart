import 'package:flutter/material.dart';
import 'package:bookbank/features/menu/editGroup/editGroup_sgreen.dart';
import 'package:bookbank/core/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Column(
      children: [
        // Header app
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  "BookBank",
                  style: textTheme.titleLarge?.copyWith(fontSize: 20.sp),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 35.w,
                  height: 35.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: theme.colorScheme.outline),
                    color: theme.colorScheme.surface,
                  ),
                  child: Icon(
                    Icons.notifications_none,
                    color: theme.colorScheme.onSurface,
                    size: 18.sp,
                  ),
                ),
                SizedBox(width: 8.w),

                PopupMenuButton<String>(
                  icon: Icon(Icons.menu, size: 20.sp),
                  offset: Offset(70.w, 50.h),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      theme.colorScheme.surface,
                    ),
                    side: WidgetStatePropertyAll(
                      BorderSide(color: theme.colorScheme.outline),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    side: BorderSide(color: theme.colorScheme.outline),
                  ),
                  onSelected: (String value) {
                    final menuItems = [
                      {
                        'name': 'Edit Group',
                        'icon': Icons.edit,
                        'popup': EditGroupSgreen(),
                      },
                      {
                        'name': 'Dark Theme',
                        'icon': Icons.nightlight_round_rounded,
                        'switch': true,
                      },
                      {'name': 'Change language', 'icon': Icons.language},
                      {
                        'name': 'Change currency',
                        'icon': Icons.currency_exchange,
                      },
                      {'name': 'About', 'icon': Icons.info},
                    ];
                    final selectedItem = menuItems.firstWhere(
                      (item) => item['name'] == value,
                    );
                    if (selectedItem['popup'] != null) {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            Dialog(child: selectedItem['popup'] as Widget),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    ...[
                      {
                        'name': 'Edit Group',
                        'icon': Icons.edit,
                        'popup': EditGroupSgreen(),
                      },
                      {
                        'name': 'Dark Theme',
                        'icon': Icons.nightlight_round_rounded,
                        'switch': true,
                      },
                      {'name': 'Change language', 'icon': Icons.language},
                      {
                        'name': 'Change currency',
                        'icon': Icons.currency_exchange,
                      },
                      {'name': 'About', 'icon': Icons.info},
                    ].map((item) {
                      return PopupMenuItem<String>(
                        value: item['name'] as String,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(item['icon'] as IconData, size: 16.sp),
                                SizedBox(width: 10.w),
                                Text(
                                  item['name'] as String,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                if (item['switch'] == true) ...[
                                  const Spacer(),
                                  Transform.scale(
                                    scale: 0.6,
                                    child: Consumer<ThemeProvider>(
                                      builder: (context, themeProvider, child) {
                                        return Switch(
                                          value: themeProvider.isDarkMode,
                                          onChanged: (value) {
                                            themeProvider.toggleTheme();
                                          },
                                          activeThumbColor: Colors.white,
                                          activeTrackColor:
                                              const Color.fromARGB(
                                                255,
                                                75,
                                                87,
                                                255,
                                              ),
                                          inactiveThumbColor:
                                              Colors.grey.shade400,
                                          inactiveTrackColor:
                                              Colors.grey.shade200,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
