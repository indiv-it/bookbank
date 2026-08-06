import 'package:bookbank/features/charts/chart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookbank/features/home/home_screen.dart';
import 'package:bookbank/features/add_transaction/add_transaction_screen.dart';
import 'package:bookbank/features/records/record_screen.dart';
import 'package:bookbank/features/notebook/noteBook_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0; // Current selected index

  // Key สำหรับ Home / Record widget เพื่อ force rebuild หลังบันทึก
  Key _homeKey = UniqueKey();
  Key _recordKey = UniqueKey();

  // Pages to navigate
  List<Widget> get pages => [
    HomeScreen(key: _homeKey),
    RecordScreen(key: _recordKey),
    const Scaffold(body: Center(child: Text('Add'))),
    ChartScreen(),
    NoteBookScreen(),
  ];

  // Build navigation item
  Widget _buildNavItem(int index, IconData icon) {
    bool isSelected = currentIndex == index;
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 50.w,
        height: 50.h,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurfaceVariant,
              size: 23.sp,
            ),
            if (isSelected) ...[
              SizedBox(height: 6.h),
              Container(
                width: 24.w,
                height: 3.h,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(1.5.r),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Build the navigation bar
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBody: true,
      body: pages[currentIndex],
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 80.h,
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Black bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 65.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceBright,
                    borderRadius: BorderRadius.circular(35.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildNavItem(0, Icons.home),
                      _buildNavItem(1, Icons.list_alt),
                      SizedBox(width: 80.w), // Space for center button
                      _buildNavItem(3, Icons.area_chart),
                      _buildNavItem(4, Icons.edit_square),
                    ],
                  ),
                ),
              ),

              // Center button
              Positioned(
                top: 0,
                child: GestureDetector(
                  onTap: () {
                    showAddItemBottomSheet(
                      context,
                      onSaved: () {
                        setState(() {
                          _homeKey = UniqueKey();
                          _recordKey = UniqueKey();
                        });
                      },
                    );
                  },
                  child: Container(
                    height: 70.h,
                    width: 70.w,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onPrimary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.surfaceBright,
                        width: 10,
                      ),
                    ),
                    child: Icon(
                      Icons.add,
                      color: theme.colorScheme.surfaceBright,
                      size: 24.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
