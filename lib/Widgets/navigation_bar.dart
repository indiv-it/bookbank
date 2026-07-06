import 'package:bookbank/features/charts/chart_screen.dart';
import 'package:flutter/material.dart';
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
    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 50,
        height: 50,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.card : AppColors.grey,
              size: 23,
            ),
            if (isSelected) ...[
              const SizedBox(height: 6),
              Container(
                width: 24,
                height: 3,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(1.5),
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
    return Scaffold(
      extendBody: true,
      body: pages[currentIndex],
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 80,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Black bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 65,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildNavItem(0, Icons.home),
                      _buildNavItem(1, Icons.list_alt),
                      const SizedBox(width: 80), // Space for center button
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
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.black, width: 8),
                    ),
                    child: Icon(Icons.add, color: AppColors.black, size: 24),
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
