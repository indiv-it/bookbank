import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

// Local Imports
import 'package:bookbank/Widgets/DashboardWidgets/DailySummaryCard.dart';
import 'package:bookbank/Widgets/DashboardWidgets/MonthlyChart.dart';
import 'package:bookbank/Widgets/DashboardWidgets/YearlyChart.dart';
import 'package:bookbank/Functions/calculations.dart';
import 'package:bookbank/Theme/app_style.dart';

// Database
import 'package:bookbank/Server/database.dart';
import 'package:bookbank/Server/db_helper.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<MyData> _transactions = [];
  DateTime _selectedDate = DateTime.now();
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  // Daily data
  double _dailyIncome = 0;
  double _dailyExpense = 0;
  double _dailyNet = 0;
  Map<String, double> _dailyCategoryExpenses = {};

  // Monthly data
  List<FlSpot> _monthlySpots = [];
  Map<String, double> _monthlyCategoryExpenses = {};
  double _monthlyIncome = 0;
  double _monthlyExpense = 0;
  double _monthlyNet = 0;

  // Yearly data
  List<FlSpot> _yearlySpots = [];
  Map<String, double> _yearlyCategoryExpenses = {};
  double _yearlyIncome = 0;
  double _yearlyExpense = 0;
  double _yearlyNet = 0;

  // Category icons and colors
  final Map<String, IconData> _categoryIcons = {
    'Group1': Icons.work,
    'Group2': Icons.shopping_cart,
    'Group3': Icons.restaurant,
    'Group4': Icons.movie,
  };

  final Map<String, Color> _categoryColors = {
    'Group1': AppColors.blue,
    'Group2': AppColors.orange,
    'Group3': AppColors.purple,
    'Group4': AppColors.pink,
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await DatabaseHelper.instance.getAllData();
    setState(() {
      _transactions = data;
      _calculateData();
    });
  }

  void _calculateData() {
    final calc = FinancialCalculations(_transactions);
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final String dateStr = dateFormat.format(_selectedDate);

    // Calculate daily data
    _dailyIncome = calc.dailyIncome(dateStr);
    _dailyExpense = calc.dailyExpense(dateStr);
    _dailyNet = calc.dailyNet(dateStr);

    // Calculate daily category expenses
    _dailyCategoryExpenses = {
      'Group1': calc.dailyExpenseByCategory(dateStr, 'Group1'),
      'Group2': calc.dailyExpenseByCategory(dateStr, 'Group2'),
      'Group3': calc.dailyExpenseByCategory(dateStr, 'Group3'),
      'Group4': calc.dailyExpenseByCategory(dateStr, 'Group4'),
    };

    // Remove categories with zero expense
    _dailyCategoryExpenses.removeWhere((key, value) => value <= 0);

    // Calculate monthly spots
    _monthlySpots = calc.generateDailySpotsForMonth(
      _selectedYear,
      _selectedMonth,
    );

    // Calculate monthly category expenses
    _monthlyCategoryExpenses = {
      'Group1': calc.monthlyExpenseByCategory(
        _selectedYear,
        _selectedMonth,
        'Group1',
      ),
      'Group2': calc.monthlyExpenseByCategory(
        _selectedYear,
        _selectedMonth,
        'Group2',
      ),
      'Group3': calc.monthlyExpenseByCategory(
        _selectedYear,
        _selectedMonth,
        'Group3',
      ),
      'Group4': calc.monthlyExpenseByCategory(
        _selectedYear,
        _selectedMonth,
        'Group4',
      ),
    };
    _monthlyCategoryExpenses.removeWhere((key, value) => value <= 0);

    // Calculate monthly income/expense/net
    _monthlyIncome = calc.monthlyIncomeForDate(_selectedYear, _selectedMonth);
    _monthlyExpense = calc.monthlyExpenseForDate(_selectedYear, _selectedMonth);
    _monthlyNet = calc.monthlyNetForDate(_selectedYear, _selectedMonth);

    // Calculate yearly spots
    _yearlySpots = calc.generateMonthlySpotsForYear(_selectedYear);

    // Calculate yearly category expenses
    _yearlyCategoryExpenses = {
      'Group1': calc.yearlyExpenseByCategory(_selectedYear, 'Group1'),
      'Group2': calc.yearlyExpenseByCategory(_selectedYear, 'Group2'),
      'Group3': calc.yearlyExpenseByCategory(_selectedYear, 'Group3'),
      'Group4': calc.yearlyExpenseByCategory(_selectedYear, 'Group4'),
    };
    _yearlyCategoryExpenses.removeWhere((key, value) => value <= 0);

    // Calculate yearly income/expense/net
    _yearlyIncome = calc.yearlyIncome(_selectedYear);
    _yearlyExpense = calc.yearlyExpense(_selectedYear);
    _yearlyNet = calc.yearlyNet(_selectedYear);
  }

  void _onDateChanged(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
      _calculateData();
    });
  }

  void _onMonthChanged(int year, int month) {
    setState(() {
      _selectedYear = year;
      _selectedMonth = month;
      _calculateData();
    });
  }

  void _onYearChanged(int newYear) {
    setState(() {
      _selectedYear = newYear;
      _calculateData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.area_chart, size: 24),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dashboard',
                        style: TextStyle(
                          fontSize: AppSize.l.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'View your statistics in detail.',
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: AppSize.s.fontSize,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Container 1 - Daily Summary
              DailySummaryCard(
                selectedDate: _selectedDate,
                dailyIncome: _dailyIncome,
                dailyExpense: _dailyExpense,
                dailyNet: _dailyNet,
                onDateChanged: _onDateChanged,
                categoryExpenses: _dailyCategoryExpenses,
                categoryIcons: _categoryIcons,
                categoryColors: _categoryColors,
              ),
              const SizedBox(height: 24),

              // Container 2 - Monthly Chart
              MonthlyChart(
                selectedYear: _selectedYear,
                selectedMonth: _selectedMonth,
                spots: _monthlySpots,
                onMonthChanged: _onMonthChanged,
                categoryExpenses: _monthlyCategoryExpenses,
                totalExpense: _monthlyCategoryExpenses.values.fold(
                  0.0,
                  (a, b) => a + b,
                ),
                categoryIcons: _categoryIcons,
                categoryColors: _categoryColors,
                monthlyIncome: _monthlyIncome,
                monthlyExpense: _monthlyExpense,
                monthlyNet: _monthlyNet,
              ),
              const SizedBox(height: 24),

              // Container 3 - Yearly Chart
              YearlyChart(
                selectedYear: _selectedYear,
                spots: _yearlySpots,
                onYearChanged: _onYearChanged,
                categoryExpenses: _yearlyCategoryExpenses,
                totalExpense: _yearlyCategoryExpenses.values.fold(
                  0.0,
                  (a, b) => a + b,
                ),
                categoryIcons: _categoryIcons,
                categoryColors: _categoryColors,
                yearlyIncome: _yearlyIncome,
                yearlyExpense: _yearlyExpense,
                yearlyNet: _yearlyNet,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
