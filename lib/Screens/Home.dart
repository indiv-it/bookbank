// Flutter Imports
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// Local Imports
import 'package:bookbank/Widgets/Popups/PopupMain.dart';
import 'package:bookbank/Widgets/Popups/PopupUnallocated.dart';
import 'package:bookbank/Widgets/UnallocatedBar.dart';
import 'package:bookbank/Widgets/UnallocatedNumber.dart';
import 'package:bookbank/Widgets/GroupCard.dart';
import 'package:bookbank/Functions/calculations.dart';
import 'package:bookbank/Theme/app_style.dart';

// Database
import 'package:bookbank/Server/database.dart';
import 'package:bookbank/Server/db_helper.dart';

// Widget Definition
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

// Widget State
class _HomeState extends State<Home> {
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

    // Calculate group amounts and counts
    _group1Amount = calc.sumGroup('Group1').toDouble();
    _group2Amount = calc.sumGroup('Group2').toDouble();
    _group3Amount = calc.sumGroup('Group3').toDouble();
    _group4Amount = calc.sumGroup('Group4').toDouble();

    // Calculate group counts
    _group1Count = calc.groupCount('Group1');
    _group2Count = calc.groupCount('Group2');
    _group3Count = calc.groupCount('Group3');
    _group4Count = calc.groupCount('Group4');

    // Calculate unallocated
    _unallocatedAmount = calc.unallocatedAmount();

    // Calculate percentages
    _group1Percentage = calc.calculateGroupPercentage('Group1');
    _group2Percentage = calc.calculateGroupPercentage('Group2');
    _group3Percentage = calc.calculateGroupPercentage('Group3');
    _group4Percentage = calc.calculateGroupPercentage('Group4');
    _unallocatedPercentage = calc.calculateUnallocatedPercentage();

    // Generate monthly spots for chart
    _spots = calc.generateMonthlySpots();
  }

  @override
  Widget build(BuildContext context) {
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
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "BookBank",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppSize.xl.fontSize,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                      color: AppColors.card,
                    ),
                    child: Icon(Icons.menu),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Container Total Balance / Popup Statistic
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: PopupMain(
                        totalBalance: _totalBalance,
                        bankBalance: _bankBalance,
                        cashBalance: _cashBalance,
                        incomeTotal: _incomeTotal,
                        expenseTotal: _expenseTotal,
                        monthlyIncome: _monthlyIncome,
                        monthlyExpense: _monthlyExpense,
                        spots: _spots,
                      ),
                    );
                  },
                );
              },
              child: Container(
                height: 150,
                padding: EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    // Total Balance
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Total balance", style: AppSize.s),
                            Text(
                              "\$ ${_totalBalance.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: AppSize.m.fontSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        // Line Chart
                        SizedBox(
                          height: 40,
                          width: 160,
                          child: LineChart(
                            LineChartData(
                              lineBarsData: createSegmentsWithArea(_spots),
                              minY: -5000,
                              maxY: 5000,
                              gridData: FlGridData(show: false),
                              titlesData: FlTitlesData(show: false),
                              borderData: FlBorderData(show: false),
                              minX: 1,
                              maxX: 31,
                              lineTouchData: LineTouchData(enabled: false),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Divider
                    SizedBox(
                      width: double.infinity,
                      height: 1,
                      child: Divider(color: AppColors.border),
                    ),

                    // Money Position
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.account_balance_rounded, size: 16),
                                  const SizedBox(width: 8),
                                  Text("Bank", style: AppSize.s),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "\$ ${_bankBalance.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: AppSize.s.fontSize,
                                    ),
                                  ),
                                  Text(
                                    "${_totalBalance > 0 ? (_bankBalance / _totalBalance * 100).toStringAsFixed(1) : 0}%",
                                    style: TextStyle(
                                      fontSize: AppSize.xs.fontSize,
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 1,
                          height: 60,
                          child: Container(color: AppColors.border),
                        ),
                        SizedBox(
                          width: 120,
                          height: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.account_balance_wallet, size: 16),
                                  const SizedBox(width: 8),
                                  Text("Cash", style: AppSize.s),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "\$ ${_cashBalance.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: AppSize.s.fontSize,
                                    ),
                                  ),
                                  Text(
                                    "${_totalBalance > 0 ? (_cashBalance / _totalBalance * 100).toStringAsFixed(1) : 0}%",
                                    style: TextStyle(
                                      fontSize: AppSize.xs.fontSize,
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Unallocated
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: PopupUnallocated(
                        totalIncome: _incomeTotal,
                        group1Amount: _group1Amount,
                        group2Amount: _group2Amount,
                        group3Amount: _group3Amount,
                        group4Amount: _group4Amount,
                        unallocatedAmount: _unallocatedAmount,
                      ),
                    );
                  },
                );
              },
              child: Container(
                width: double.infinity,
                height: 80,
                margin: const EdgeInsets.symmetric(vertical: 11),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Unallocated ",
                          style: TextStyle(
                            color: AppColors.grey,
                            fontSize: AppSize.s.fontSize,
                          ),
                        ),
                        Text(
                          '฿ ${_unallocatedAmount.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: AppSize.s.fontSize),
                        ),
                        Text(
                          ' from ',
                          style: TextStyle(
                            color: AppColors.grey,
                            fontSize: AppSize.s.fontSize,
                          ),
                        ),
                        Text(
                          '฿ ${_totalBalance.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: AppSize.s.fontSize),
                        ),
                      ],
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          height: 6,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.border,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              MoneyBar(
                                width: calculateBarWidth(
                                  _group1Amount,
                                  _totalBalance,
                                  constraints.maxWidth,
                                ).toDouble(),
                                color: AppColors.blue,
                              ),
                              MoneyBar(
                                width: calculateBarWidth(
                                  _group2Amount,
                                  _totalBalance,
                                  constraints.maxWidth,
                                ).toDouble(),
                                color: AppColors.orange,
                              ),
                              MoneyBar(
                                width: calculateBarWidth(
                                  _group3Amount,
                                  _totalBalance,
                                  constraints.maxWidth,
                                ).toDouble(),
                                color: AppColors.purple,
                              ),
                              MoneyBar(
                                width: calculateBarWidth(
                                  _group4Amount,
                                  _totalBalance,
                                  constraints.maxWidth,
                                ).toDouble(),
                                color: AppColors.pink,
                              ),
                              MoneyBar(
                                width: calculateBarWidth(
                                  _unallocatedAmount,
                                  _totalBalance,
                                  constraints.maxWidth,
                                ).toDouble(),
                                color: AppColors.border,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MoneyNumber(
                          amount: _group1Amount,
                          color: AppColors.blue,
                          percentage: _group1Percentage,
                        ),
                        MoneyNumber(
                          amount: _group2Amount,
                          color: AppColors.orange,
                          percentage: _group2Percentage,
                        ),
                        MoneyNumber(
                          amount: _group3Amount,
                          color: AppColors.purple,
                          percentage: _group3Percentage,
                        ),
                        MoneyNumber(
                          amount: _group4Amount,
                          color: AppColors.pink,
                          percentage: _group4Percentage,
                        ),
                        MoneyNumber(
                          amount:
                              _unallocatedAmount -
                              _group1Amount -
                              _group2Amount -
                              _group3Amount -
                              _group4Amount,
                          color: AppColors.border,
                          percentage: _unallocatedPercentage,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Groups Row1
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GroupCard(
                  groupName: 'Group1',
                  groupCount: _group1Count,
                  groupAmount: _group1Amount,
                  groupColor: AppColors.blue,
                  groupIcon: Icons.add,
                  transactions: _transactions,
                  percentage: _group1Percentage,
                ),
                GroupCard(
                  groupName: 'Group2',
                  groupCount: _group2Count,
                  groupAmount: _group2Amount,
                  groupColor: AppColors.orange,
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
                  groupColor: AppColors.purple,
                  groupIcon: Icons.add,
                  transactions: _transactions,
                  percentage: _group3Percentage,
                ),
                GroupCard(
                  groupName: 'Group4',
                  groupCount: _group4Count,
                  groupAmount: _group4Amount,
                  groupColor: AppColors.pink,
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
