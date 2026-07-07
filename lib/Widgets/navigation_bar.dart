import 'package:bookbank/features/charts/chart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:bookbank/features/home/home_screen.dart';
import 'package:bookbank/core/theme/app_theme.dart';
import 'package:bookbank/features/add_transaction/add_transaction_screen.dart';
import 'package:bookbank/features/records/record_screen.dart';

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
    const Scaffold(body: Center(child: Text('Edit'))),
  ];

  // Build navigation item
  Widget _buildNavItem(int index, IconData icon) {
    bool isSelected = currentIndex == index;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: isTablet ? 60.w : 50.w,
        height: isTablet ? 60.h : 50.h,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.card : AppColors.grey,
              size: isTablet ? 28.sp : 23.sp,
            ),
            if (isSelected) ...[
              SizedBox(height: isTablet ? 8.h : 6.h),
              Container(
                width: isTablet ? 28.w : 24.w,
                height: isTablet ? 4.h : 3.h,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(isTablet ? 2.r : 1.5.r),
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
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    return Scaffold(
      extendBody: true,
      body: pages[currentIndex],
      bottomNavigationBar: SafeArea(
        child: Container(
          height: isTablet ? 100.h : 80.h,
          margin: EdgeInsets.symmetric(
            horizontal: isTablet ? 24.w : 20.w,
            vertical: isTablet ? 20.h : 15.h,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Black bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: isTablet ? 75.h : 65.h,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(isTablet ? 40.r : 35.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildNavItem(0, Icons.home),
                      _buildNavItem(1, Icons.list_alt),
                      SizedBox(
                        width: isTablet ? 100.w : 80.w,
                      ), // Space for center button
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
                    height: isTablet ? 84.h : 70.h,
                    width: isTablet ? 84.w : 70.w,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.black,
                        width: isTablet ? 10 : 8,
                      ),
                    ),
                    child: Icon(
                      Icons.add,
                      color: AppColors.black,
                      size: isTablet ? 28.sp : 24.sp,
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
