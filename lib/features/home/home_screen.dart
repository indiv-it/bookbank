import 'package:bookbank/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
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

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 45, 24, 24),
        child: Column(
          children: [
            // Header app
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text("BookBank", style: textTheme.titleLarge),
                  ],
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                    color: theme.colorScheme.surface,
                  ),
                  child: Icon(Icons.menu, color: AppColors.black),
                ),
              ],
            ),
            const SizedBox(height: 16),

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
                GroupCard(
                  groupName: 'Group1',
                  groupCount: _group1Count,
                  groupAmount: _group1Amount,
                  groupColor:
                      theme.colorScheme.primary, // Using primary color for blue
                  groupIcon: Icons.add,
                  transactions: _transactions,
                  percentage: _group1Percentage,
                ),
                GroupCard(
                  groupName: 'Group2',
                  groupCount: _group2Count,
                  groupAmount: _group2Amount,
                  groupColor:
                      theme.colorScheme.secondary, // Using secondary for orange
                  groupIcon: Icons.add,
                  transactions: _transactions,
                  percentage: _group2Percentage,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Groups Row2
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GroupCard(
                  groupName: 'Group3',
                  groupCount: _group3Count,
                  groupAmount: _group3Amount,
                  groupColor:
                      Colors.purple, // Replace with proper color from theme
                  groupIcon: Icons.add,
                  transactions: _transactions,
                  percentage: _group3Percentage,
                ),
                GroupCard(
                  groupName: 'Group4',
                  groupCount: _group4Count,
                  groupAmount: _group4Amount,
                  groupColor:
                      Colors.pink, // Replace with proper color from theme
                  groupIcon: Icons.add,
                  transactions: _transactions,
                  percentage: _group4Percentage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
