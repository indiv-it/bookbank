import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Local Imports
import 'package:bookbank/features/charts/dashboard_widgets/daily_summary_card.dart';
import 'package:bookbank/features/charts/dashboard_widgets/monthly_chart.dart';
import 'package:bookbank/features/charts/dashboard_widgets/yearly_chart.dart';
import 'package:bookbank/utils/calculations.dart';
import 'package:bookbank/core/theme/app_theme.dart';

// Database
import 'package:bookbank/data/database.dart';
import 'package:bookbank/data/db_helper.dart';
import 'package:bookbank/features/menu/editGroup/providers/group_settings_provider.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
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
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await DatabaseHelper.instance.getAllData();
    if (!mounted) return;
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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Consumer<GroupSettingsProvider>(
      builder: (context, groupProvider, child) {
        final groupSettings = groupProvider.groupSettings;

        final Map<String, IconData> categoryIcons = {
          'Group1': _getIconFromCodePoint(
            groupSettings
                .firstWhere(
                  (s) => s.groupId == 'Group1',
                  orElse: () => GroupSettings(
                    groupId: 'Group1',
                    groupName: 'Group1',
                    iconCodePoint: Icons.work.codePoint,
                    colorValue: AppColors.blue.toARGB32(),
                    savingsGoalEnabled: false,
                    savingsGoalAmount: 0,
                  ),
                )
                .iconCodePoint,
          ),
          'Group2': _getIconFromCodePoint(
            groupSettings
                .firstWhere(
                  (s) => s.groupId == 'Group2',
                  orElse: () => GroupSettings(
                    groupId: 'Group2',
                    groupName: 'Group2',
                    iconCodePoint: Icons.shopping_cart.codePoint,
                    colorValue: AppColors.orange.toARGB32(),
                    savingsGoalEnabled: false,
                    savingsGoalAmount: 0,
                  ),
                )
                .iconCodePoint,
          ),
          'Group3': _getIconFromCodePoint(
            groupSettings
                .firstWhere(
                  (s) => s.groupId == 'Group3',
                  orElse: () => GroupSettings(
                    groupId: 'Group3',
                    groupName: 'Group3',
                    iconCodePoint: Icons.restaurant.codePoint,
                    colorValue: AppColors.purple.toARGB32(),
                    savingsGoalEnabled: false,
                    savingsGoalAmount: 0,
                  ),
                )
                .iconCodePoint,
          ),
          'Group4': _getIconFromCodePoint(
            groupSettings
                .firstWhere(
                  (s) => s.groupId == 'Group4',
                  orElse: () => GroupSettings(
                    groupId: 'Group4',
                    groupName: 'Group4',
                    iconCodePoint: Icons.movie.codePoint,
                    colorValue: AppColors.pink.toARGB32(),
                    savingsGoalEnabled: false,
                    savingsGoalAmount: 0,
                  ),
                )
                .iconCodePoint,
          ),
        };

        final Map<String, Color> categoryColors = {
          'Group1': Color(
            groupSettings
                .firstWhere(
                  (s) => s.groupId == 'Group1',
                  orElse: () => GroupSettings(
                    groupId: 'Group1',
                    groupName: 'Group1',
                    iconCodePoint: Icons.work.codePoint,
                    colorValue: AppColors.blue.toARGB32(),
                    savingsGoalEnabled: false,
                    savingsGoalAmount: 0,
                  ),
                )
                .colorValue,
          ),
          'Group2': Color(
            groupSettings
                .firstWhere(
                  (s) => s.groupId == 'Group2',
                  orElse: () => GroupSettings(
                    groupId: 'Group2',
                    groupName: 'Group2',
                    iconCodePoint: Icons.shopping_cart.codePoint,
                    colorValue: AppColors.orange.toARGB32(),
                    savingsGoalEnabled: false,
                    savingsGoalAmount: 0,
                  ),
                )
                .colorValue,
          ),
          'Group3': Color(
            groupSettings
                .firstWhere(
                  (s) => s.groupId == 'Group3',
                  orElse: () => GroupSettings(
                    groupId: 'Group3',
                    groupName: 'Group3',
                    iconCodePoint: Icons.restaurant.codePoint,
                    colorValue: AppColors.purple.toARGB32(),
                    savingsGoalEnabled: false,
                    savingsGoalAmount: 0,
                  ),
                )
                .colorValue,
          ),
          'Group4': Color(
            groupSettings
                .firstWhere(
                  (s) => s.groupId == 'Group4',
                  orElse: () => GroupSettings(
                    groupId: 'Group4',
                    groupName: 'Group4',
                    iconCodePoint: Icons.movie.codePoint,
                    colorValue: AppColors.pink.toARGB32(),
                    savingsGoalEnabled: false,
                    savingsGoalAmount: 0,
                  ),
                )
                .colorValue,
          ),
        };

        final Map<String, String> categoryNames = {
          'Group1': groupSettings
              .firstWhere(
                (s) => s.groupId == 'Group1',
                orElse: () => GroupSettings(
                  groupId: 'Group1',
                  groupName: 'Group1',
                  iconCodePoint: Icons.work.codePoint,
                  colorValue: AppColors.blue.toARGB32(),
                  savingsGoalEnabled: false,
                  savingsGoalAmount: 0,
                ),
              )
              .groupName,
          'Group2': groupSettings
              .firstWhere(
                (s) => s.groupId == 'Group2',
                orElse: () => GroupSettings(
                  groupId: 'Group2',
                  groupName: 'Group2',
                  iconCodePoint: Icons.shopping_cart.codePoint,
                  colorValue: AppColors.orange.toARGB32(),
                  savingsGoalEnabled: false,
                  savingsGoalAmount: 0,
                ),
              )
              .groupName,
          'Group3': groupSettings
              .firstWhere(
                (s) => s.groupId == 'Group3',
                orElse: () => GroupSettings(
                  groupId: 'Group3',
                  groupName: 'Group3',
                  iconCodePoint: Icons.restaurant.codePoint,
                  colorValue: AppColors.purple.toARGB32(),
                  savingsGoalEnabled: false,
                  savingsGoalAmount: 0,
                ),
              )
              .groupName,
          'Group4': groupSettings
              .firstWhere(
                (s) => s.groupId == 'Group4',
                orElse: () => GroupSettings(
                  groupId: 'Group4',
                  groupName: 'Group4',
                  iconCodePoint: Icons.movie.codePoint,
                  colorValue: AppColors.pink.toARGB32(),
                  savingsGoalEnabled: false,
                  savingsGoalAmount: 0,
                ),
              )
              .groupName,
        };

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Icon(
                        Icons.area_chart,
                        size: 24,
                        color: theme.iconTheme.color,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dashboard',
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'View your statistics in detail.',
                            style: textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
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
                    categoryIcons: categoryIcons,
                    categoryColors: categoryColors,
                    categoryNames: categoryNames,
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
                    categoryIcons: categoryIcons,
                    categoryColors: categoryColors,
                    categoryNames: categoryNames,
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
                    categoryIcons: categoryIcons,
                    categoryColors: categoryColors,
                    categoryNames: categoryNames,
                    yearlyIncome: _yearlyIncome,
                    yearlyExpense: _yearlyExpense,
                    yearlyNet: _yearlyNet,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
