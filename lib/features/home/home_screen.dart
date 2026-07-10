import 'package:bookbank/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:fl_chart/fl_chart.dart';

// Local Imports
import 'package:bookbank/features/home/widgets/dashboard_summary.dart';
import 'package:bookbank/features/home/widgets/unallocated_summary.dart';
import 'package:bookbank/Widgets/group_card.dart';
import 'package:bookbank/utils/calculations.dart';

// Database
import 'package:bookbank/data/database.dart';
import 'package:bookbank/data/db_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MyData> _transactions = [];
  double _totalBalance = 0;
  double _bankBalance = 0;
  double _cashBalance = 0;

  int _group1Count = 0;
  int _group2Count = 0;
  int _group3Count = 0;
  int _group4Count = 0;

  double _group1Amount = 0;
  double _group2Amount = 0;
  double _group3Amount = 0;
  double _group4Amount = 0;
  double _unallocatedAmount = 0;

  double _incomeTotal = 0;
  double _expenseTotal = 0;
  double _monthlyIncome = 0;
  double _monthlyExpense = 0;
  List<FlSpot> _spots = [];

  double _group1Percentage = 0;
  double _group2Percentage = 0;
  double _group3Percentage = 0;
  double _group4Percentage = 0;
  double _unallocatedPercentage = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await DatabaseHelper.instance.getAllData();
    if (!mounted) return;
    setState(() {
      _transactions = data;
      _calculateTotals();
    });
  }

  void _calculateTotals() {
    final calc = FinancialCalculations(_transactions);

    _totalBalance = calc.sumAll().toDouble();
    _bankBalance = calc.sumBank().toDouble();
    _cashBalance = calc.sumCash().toDouble();
    _incomeTotal = calc.income().toDouble();
    _expenseTotal = calc.expense().toDouble();
    _monthlyIncome = calc.monthlyIncome();
    _monthlyExpense = calc.monthlyExpense();

    _group1Amount = calc.sumGroup('Group1').toDouble();
    _group2Amount = calc.sumGroup('Group2').toDouble();
    _group3Amount = calc.sumGroup('Group3').toDouble();
    _group4Amount = calc.sumGroup('Group4').toDouble();

    _group1Count = calc.groupCount('Group1');
    _group2Count = calc.groupCount('Group2');
    _group3Count = calc.groupCount('Group3');
    _group4Count = calc.groupCount('Group4');

    _unallocatedAmount = calc.unallocatedAmount();

    _group1Percentage = calc.calculateGroupPercentage('Group1');
    _group2Percentage = calc.calculateGroupPercentage('Group2');
    _group3Percentage = calc.calculateGroupPercentage('Group3');
    _group4Percentage = calc.calculateGroupPercentage('Group4');
    _unallocatedPercentage = calc.calculateUnallocatedPercentage();

    _spots = calc.generateMonthlySpots();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
              isTablet ? 32.w : 24.w,
              isTablet ? 60.h : 45.h,
              isTablet ? 32.w : 24.w,
              isTablet ? 32.h : 24.h,
            ),
            child: Column(
              children: [
                // Header app
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: isTablet ? 48.w : 40.w,
                          height: isTablet ? 48.h : 40.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              isTablet ? 24.r : 20.r,
                            ),
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(width: isTablet ? 12.w : 8.w),
                        Text(
                          "BookBank",
                          style: textTheme.titleLarge?.copyWith(
                            fontSize: isTablet ? 24.sp : 20.sp,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: isTablet ? 48.w : 40.w,
                          height: isTablet ? 48.h : 40.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              isTablet ? 24.r : 20.r,
                            ),
                            border: Border.all(color: AppColors.border),
                            color: theme.colorScheme.surface,
                          ),
                          child: Icon(
                            Icons.notifications_none,
                            color: AppColors.black,
                            size: isTablet ? 24.sp : 20.sp,
                          ),
                        ),
                        const SizedBox(width: 8),
                        PopupMenuButton<String>(
                          icon: Icon(
                            Icons.menu,
                            size: isTablet ? 24.sp : 20.sp,
                          ),
                          offset: Offset(70.w, 50.h),
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              AppColors.card,
                            ),
                            side: WidgetStatePropertyAll(
                              BorderSide(color: AppColors.border),
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          onSelected: (String value) {
                            // Handle menu selection
                          },
                          itemBuilder: (BuildContext context) => [
                            ...[
                              {'name': 'Edit Group', 'icon': Icons.edit},
                              {
                                'name': 'Dark Theme',
                                'icon': Icons.nightlight_round_rounded,
                                'switch': true,
                              },
                              {
                                'name': 'Change language',
                                'icon': Icons.language,
                              },
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
                                        Icon(
                                          item['icon'] as IconData,
                                          size: 16.sp,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          item['name'] as String,
                                          style: TextStyle(
                                            fontSize: AppSize.m,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        if (item['switch'] == true) ...[
                                          const Spacer(),
                                          Transform.scale(
                                            scale: 0.6,
                                            child: Switch(
                                              value: true,
                                              onChanged: (value) {},
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
                SizedBox(height: isTablet ? 24.h : 16.h),

                DashboardSummary(
                  totalBalance: _totalBalance,
                  bankBalance: _bankBalance,
                  cashBalance: _cashBalance,
                  incomeTotal: _incomeTotal,
                  expenseTotal: _expenseTotal,
                  monthlyIncome: _monthlyIncome,
                  monthlyExpense: _monthlyExpense,
                  spots: _spots,
                ),

                UnallocatedSummary(
                  incomeTotal: _incomeTotal,
                  totalBalance: _totalBalance,
                  unallocatedAmount: _unallocatedAmount,
                  group1Amount: _group1Amount,
                  group2Amount: _group2Amount,
                  group3Amount: _group3Amount,
                  group4Amount: _group4Amount,
                  group1Percentage: _group1Percentage,
                  group2Percentage: _group2Percentage,
                  group3Percentage: _group3Percentage,
                  group4Percentage: _group4Percentage,
                  unallocatedPercentage: _unallocatedPercentage,
                ),

                // Groups Row1
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GroupCard(
                        groupName: 'Group1',
                        groupCount: _group1Count,
                        groupAmount: _group1Amount,
                        groupColor: theme.colorScheme.primary,
                        groupIcon: Icons.add,
                        transactions: _transactions,
                        percentage: _group1Percentage,
                      ),
                    ),
                    SizedBox(width: isTablet ? 16.w : 12.w),
                    Expanded(
                      child: GroupCard(
                        groupName: 'Group2',
                        groupCount: _group2Count,
                        groupAmount: _group2Amount,
                        groupColor: theme.colorScheme.secondary,
                        groupIcon: Icons.add,
                        transactions: _transactions,
                        percentage: _group2Percentage,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isTablet ? 16.h : 12.h),

                // Groups Row2
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GroupCard(
                        groupName: 'Group3',
                        groupCount: _group3Count,
                        groupAmount: _group3Amount,
                        groupColor: Colors.purple,
                        groupIcon: Icons.add,
                        transactions: _transactions,
                        percentage: _group3Percentage,
                      ),
                    ),
                    SizedBox(width: isTablet ? 16.w : 12.w),
                    Expanded(
                      child: GroupCard(
                        groupName: 'Group4',
                        groupCount: _group4Count,
                        groupAmount: _group4Amount,
                        groupColor: Colors.pink,
                        groupIcon: Icons.add,
                        transactions: _transactions,
                        percentage: _group4Percentage,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
