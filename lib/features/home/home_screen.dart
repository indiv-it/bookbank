import 'package:bookbank/Widgets/hearder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

// Local Imports
import 'package:bookbank/features/home/widgets/dashboard_summary.dart';
import 'package:bookbank/features/home/widgets/unallocated_summary.dart';
import 'package:bookbank/features/home/widgets/group_card.dart';
import 'package:bookbank/utils/calculations.dart';

// Database
import 'package:bookbank/data/database.dart';
import 'package:bookbank/data/db_helper.dart';
import 'package:bookbank/features/menu/editGroup/providers/group_settings_provider.dart';

class GroupData {
  final String groupId;
  final String groupName;
  final int groupCount;
  final double groupAmount;
  final Color groupColor;
  final IconData groupIcon;
  final double percentage;
  final bool savingsGoalEnabled;
  final double savingsGoalAmount;

  GroupData({
    required this.groupId,
    required this.groupName,
    required this.groupCount,
    required this.groupAmount,
    required this.groupColor,
    required this.groupIcon,
    required this.percentage,
    this.savingsGoalEnabled = false,
    this.savingsGoalAmount = 0,
  });
}

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

  GroupData _getGroupData(
    String groupId,
    Color defaultColor,
    List<GroupSettings> groupSettings,
  ) {
    final settings = groupSettings.firstWhere(
      (s) => s.groupId == groupId,
      orElse: () => GroupSettings(
        groupId: groupId,
        groupName: groupId,
        iconCodePoint: Icons.add.codePoint,
        colorValue: defaultColor.toARGB32(),
        savingsGoalEnabled: false,
        savingsGoalAmount: 0,
      ),
    );

    final amount = groupId == 'Group1'
        ? _group1Amount
        : groupId == 'Group2'
        ? _group2Amount
        : groupId == 'Group3'
        ? _group3Amount
        : _group4Amount;

    final count = groupId == 'Group1'
        ? _group1Count
        : groupId == 'Group2'
        ? _group2Count
        : groupId == 'Group3'
        ? _group3Count
        : _group4Count;

    final percentage = groupId == 'Group1'
        ? _group1Percentage
        : groupId == 'Group2'
        ? _group2Percentage
        : groupId == 'Group3'
        ? _group3Percentage
        : _group4Percentage;

    return GroupData(
      groupId: groupId,
      groupName: settings.groupName,
      groupCount: count,
      groupAmount: amount,
      groupColor: Color(settings.colorValue),
      groupIcon: _getIconFromCodePoint(settings.iconCodePoint),
      percentage: percentage,
      savingsGoalEnabled: settings.savingsGoalEnabled,
      savingsGoalAmount: settings.savingsGoalAmount,
    );
  }

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
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    return Consumer<GroupSettingsProvider>(
      builder: (context, groupProvider, child) {
        final groupSettings = groupProvider.groupSettings;

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
                    Header(),
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
                      group1Color: _getGroupData(
                        'Group1',
                        theme.colorScheme.primary,
                        groupSettings,
                      ).groupColor,
                      group2Color: _getGroupData(
                        'Group2',
                        theme.colorScheme.secondary,
                        groupSettings,
                      ).groupColor,
                      group3Color: _getGroupData(
                        'Group3',
                        theme.colorScheme.tertiary,
                        groupSettings,
                      ).groupColor,
                      group4Color: _getGroupData(
                        'Group4',
                        theme.colorScheme.error,
                        groupSettings,
                      ).groupColor,
                    ),

                    // Groups Row1
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GroupCard(
                            groupName: _getGroupData(
                              'Group1',
                              theme.colorScheme.primary,
                              groupSettings,
                            ).groupName,
                            groupId: 'Group1',
                            groupCount: _getGroupData(
                              'Group1',
                              theme.colorScheme.primary,
                              groupSettings,
                            ).groupCount,
                            groupAmount: _getGroupData(
                              'Group1',
                              theme.colorScheme.primary,
                              groupSettings,
                            ).groupAmount,
                            groupColor: _getGroupData(
                              'Group1',
                              theme.colorScheme.primary,
                              groupSettings,
                            ).groupColor,
                            groupIcon: _getGroupData(
                              'Group1',
                              theme.colorScheme.primary,
                              groupSettings,
                            ).groupIcon,
                            transactions: _transactions,
                            percentage: _getGroupData(
                              'Group1',
                              theme.colorScheme.primary,
                              groupSettings,
                            ).percentage,
                            savingsGoalEnabled: _getGroupData(
                              'Group1',
                              theme.colorScheme.primary,
                              groupSettings,
                            ).savingsGoalEnabled,
                            savingsGoalAmount: _getGroupData(
                              'Group1',
                              theme.colorScheme.primary,
                              groupSettings,
                            ).savingsGoalAmount,
                          ),
                        ),
                        SizedBox(width: isTablet ? 16.w : 12.w),
                        Expanded(
                          child: GroupCard(
                            groupName: _getGroupData(
                              'Group2',
                              theme.colorScheme.secondary,
                              groupSettings,
                            ).groupName,
                            groupId: 'Group2',
                            groupCount: _getGroupData(
                              'Group2',
                              theme.colorScheme.secondary,
                              groupSettings,
                            ).groupCount,
                            groupAmount: _getGroupData(
                              'Group2',
                              theme.colorScheme.secondary,
                              groupSettings,
                            ).groupAmount,
                            groupColor: _getGroupData(
                              'Group2',
                              theme.colorScheme.secondary,
                              groupSettings,
                            ).groupColor,
                            groupIcon: _getGroupData(
                              'Group2',
                              theme.colorScheme.secondary,
                              groupSettings,
                            ).groupIcon,
                            transactions: _transactions,
                            percentage: _getGroupData(
                              'Group2',
                              theme.colorScheme.secondary,
                              groupSettings,
                            ).percentage,
                            savingsGoalEnabled: _getGroupData(
                              'Group2',
                              theme.colorScheme.secondary,
                              groupSettings,
                            ).savingsGoalEnabled,
                            savingsGoalAmount: _getGroupData(
                              'Group2',
                              theme.colorScheme.secondary,
                              groupSettings,
                            ).savingsGoalAmount,
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
                            groupName: _getGroupData(
                              'Group3',
                              Colors.purple,
                              groupSettings,
                            ).groupName,
                            groupId: 'Group3',
                            groupCount: _getGroupData(
                              'Group3',
                              Colors.purple,
                              groupSettings,
                            ).groupCount,
                            groupAmount: _getGroupData(
                              'Group3',
                              Colors.purple,
                              groupSettings,
                            ).groupAmount,
                            groupColor: _getGroupData(
                              'Group3',
                              Colors.purple,
                              groupSettings,
                            ).groupColor,
                            groupIcon: _getGroupData(
                              'Group3',
                              Colors.purple,
                              groupSettings,
                            ).groupIcon,
                            transactions: _transactions,
                            percentage: _getGroupData(
                              'Group3',
                              Colors.purple,
                              groupSettings,
                            ).percentage,
                            savingsGoalEnabled: _getGroupData(
                              'Group3',
                              Colors.purple,
                              groupSettings,
                            ).savingsGoalEnabled,
                            savingsGoalAmount: _getGroupData(
                              'Group3',
                              Colors.purple,
                              groupSettings,
                            ).savingsGoalAmount,
                          ),
                        ),
                        SizedBox(width: isTablet ? 16.w : 12.w),
                        Expanded(
                          child: GroupCard(
                            groupName: _getGroupData(
                              'Group4',
                              Colors.pink,
                              groupSettings,
                            ).groupName,
                            groupId: 'Group4',
                            groupCount: _getGroupData(
                              'Group4',
                              Colors.pink,
                              groupSettings,
                            ).groupCount,
                            groupAmount: _getGroupData(
                              'Group4',
                              Colors.pink,
                              groupSettings,
                            ).groupAmount,
                            groupColor: _getGroupData(
                              'Group4',
                              Colors.pink,
                              groupSettings,
                            ).groupColor,
                            groupIcon: _getGroupData(
                              'Group4',
                              Colors.pink,
                              groupSettings,
                            ).groupIcon,
                            transactions: _transactions,
                            percentage: _getGroupData(
                              'Group4',
                              Colors.pink,
                              groupSettings,
                            ).percentage,
                            savingsGoalEnabled: _getGroupData(
                              'Group4',
                              Colors.pink,
                              groupSettings,
                            ).savingsGoalEnabled,
                            savingsGoalAmount: _getGroupData(
                              'Group4',
                              Colors.pink,
                              groupSettings,
                            ).savingsGoalAmount,
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
      },
    );
  }
}
