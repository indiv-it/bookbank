import 'package:bookbank/data/database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class FinancialCalculations {
  final List<MyData> transactions;

  FinancialCalculations(this.transactions);

  // รายรับเงินในบัญชี
  int filterBankIncome() {
    int sum = 0;
    for (var element in transactions) {
      if (element.moneyList == 'bank' && element.moneyType == 'income') {
        sum += element.amount.toInt();
      }
    }
    return sum;
  }

  // รายจ่ายเงินในบัญชี (รวม transfer ที่ออกจาก bank)
  int filterBankExpense() {
    int sum = 0;
    for (var element in transactions) {
      if (element.moneyList == 'bank' &&
          (element.moneyType == 'expense' || element.moneyType == 'transfer')) {
        sum += element.amount.toInt();
      }
    }
    return sum;
  }

  // รายรับเงินสด
  int filterCashIncome() {
    int sum = 0;
    for (var element in transactions) {
      if (element.moneyList == 'cash' &&
          (element.moneyType == 'income' || element.moneyType == 'transfer')) {
        sum += element.amount.toInt();
      }
    }
    return sum;
  }

  // รายจ่ายเงินสด
  int filterCashExpense() {
    int sum = 0;
    for (var element in transactions) {
      if (element.moneyList == 'cash' && element.moneyType == 'expense') {
        sum += element.amount.toInt();
      }
    }
    return sum;
  }

  // รายรับตามกลุ่ม
  int groupIncome(String group) {
    return transactions
        .where((e) => e.moneyGroup == group && e.moneyType == 'income')
        .fold(
          0,
          (previousValue, element) => previousValue + element.amount.toInt(),
        );
  }

  // รายจ่ายตามกลุ่ม
  int groupExpense(String group) {
    return transactions
        .where((e) => e.moneyGroup == group && e.moneyType == 'expense')
        .fold(
          0,
          (previousValue, element) => previousValue + element.amount.toInt(),
        );
  }

  // รวมรายรับตามกลุ่มทั้งหมด
  int incomeGroupTotal() {
    return transactions
        .where((e) => e.moneyType == 'income' && e.moneyGroup.isNotEmpty)
        .fold(0, (sum, e) => sum + e.amount.toInt());
  }

  // รวมรายจ่ายตามกลุ่มทั้งหมด
  int expenseGroupTotal() {
    return transactions
        .where((e) => e.moneyType == 'expense' && e.moneyGroup.isNotEmpty)
        .fold(0, (sum, e) => sum + e.amount.toInt());
  }

  // รวมเงินในบัญชี
  int sumBank() {
    return filterBankIncome() - filterBankExpense();
  }

  // รวมเงินสด
  int sumCash() {
    return filterCashIncome() - filterCashExpense();
  }

  // รวมรายรับทั้งหมด (ไม่รวม transfer)
  int income() {
    int sum = 0;
    for (var element in transactions) {
      if (element.moneyType == 'income') {
        sum += element.amount.toInt();
      }
    }
    return sum;
  }

  // รวมรายจ่ายทั้งหมด
  int expense() {
    return filterBankExpense() + filterCashExpense();
  }

  // รวมเงินคงเหลือทั้งหมด
  int sumAll() {
    return income() - expense();
  }

  // รวมเงินคงเหลือตามกลุ่ม
  int sumGroup(String group) {
    return groupIncome(group) - groupExpense(group);
  }

  // รวมเงินคงเหลือตามกลุ่มทั้งหมด
  int sumGroupAll() {
    return incomeGroupTotal() - expenseGroupTotal();
  }

  // ส่วนต่าง
  int gap() {
    return sumAll() - sumGroupAll();
  }

  // คำนวณเปอร์เซ็นต์ของหมวดหมู่เทียบกับผลรวมหมวดหมู่ทั้งหมด
  double calculateGroupPercentage(String group) {
    double groupTotal = sumGroupAll().toDouble();
    if (groupTotal <= 0) return 0.0;
    double groupAmount = sumGroup(group).toDouble();
    return (groupAmount / groupTotal) * 100.0;
  }

  // คำนวณเปอร์เซ็นต์ของ Unallocated เทียบกับผลรวมหมวดหมู่ทั้งหมด
  double calculateUnallocatedPercentage() {
    double groupTotal = sumGroupAll().toDouble();
    if (groupTotal <= 0) return 0.0;
    double unallocated = gap().toDouble();
    return (unallocated / groupTotal) * 100.0;
  }

  // นับจำนวนรายการตามกลุ่ม
  int groupCount(String group) {
    return transactions.where((e) => e.moneyGroup == group).length;
  }

  // นับจำนวนรายการที่ไม่ได้จัดกลุ่ม (รายรับ)
  int unallocatedCount() {
    return transactions
        .where((e) => e.moneyGroup.isEmpty && e.moneyType == 'income')
        .length;
  }

  // รวมยอดเงินที่ไม่ได้จัดกลุ่ม (รายรับ)
  double unallocatedAmount() {
    return transactions
        .where((e) => e.moneyGroup.isEmpty && e.moneyType == 'income')
        .fold(0.0, (sum, e) => sum + e.amount.toDouble());
  }

  // สร้างข้อมูล FlSpot สำหรับกราฟ 30 วัน
  List<FlSpot> generateMonthlySpots() {
    List<FlSpot> spots = [];
    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    // สร้างข้อมูล 30 วันย้อนหลัง
    for (int i = 29; i >= 0; i--) {
      DateTime date = now.subtract(Duration(days: i));
      String dateStr = dateFormat.format(date);

      // คำนวณรายรับของวันนั้น
      double dailyIncome = transactions
          .where((e) => e.moneyType == 'income' && e.date == dateStr)
          .fold(0.0, (sum, e) => sum + e.amount.toDouble());

      // คำนวณรายจ่ายของวันนั้น
      double dailyExpense = transactions
          .where((e) => e.moneyType == 'expense' && e.date == dateStr)
          .fold(0.0, (sum, e) => sum + e.amount.toDouble());

      // คำนวณยอดสุทธิ (รายรับ - รายจ่าย)
      double netAmount = dailyIncome - dailyExpense;

      // x = วันที่ (1-30), y = ยอดสุทธิ
      spots.add(FlSpot((30 - i).toDouble(), netAmount));
    }

    return spots;
  }

  // สร้างข้อมูล FlSpot สำหรับกราฟ 30 วันตามหมวดหมู่
  List<FlSpot> generateMonthlySpotsForGroup(String group) {
    List<FlSpot> spots = [];
    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    // กรองเฉพาะ transaction ของ group นี้
    final groupTransactions = transactions
        .where((e) => e.moneyGroup == group)
        .toList();

    // สร้างข้อมูล 30 วันย้อนหลัง
    for (int i = 29; i >= 0; i--) {
      DateTime date = now.subtract(Duration(days: i));
      String dateStr = dateFormat.format(date);

      // คำนวณรายรับของวันนั้นในหมวดหมู่
      double dailyIncome = groupTransactions
          .where((e) => e.moneyType == 'income' && e.date == dateStr)
          .fold(0.0, (sum, e) => sum + e.amount.toDouble());

      // คำนวณรายจ่ายของวันนั้นในหมวดหมู่
      double dailyExpense = groupTransactions
          .where((e) => e.moneyType == 'expense' && e.date == dateStr)
          .fold(0.0, (sum, e) => sum + e.amount.toDouble());

      // คำนวณยอดสุทธิ (รายรับ - รายจ่าย)
      double netAmount = dailyIncome - dailyExpense;

      // x = วันที่ (1-30), y = ยอดสุทธิ
      spots.add(FlSpot((30 - i).toDouble(), netAmount));
    }

    return spots;
  }

  // รายรับเฉพาะเดือนปัจจุบัน
  double monthlyIncome() {
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;

    return transactions
        .where(
          (e) =>
              e.moneyType == 'income' &&
              e.date != null &&
              e.date!.isNotEmpty &&
              _isCurrentMonth(e.date!, currentMonth, currentYear),
        )
        .fold(0.0, (sum, e) => sum + e.amount.toDouble());
  }

  // รายจ่ายเฉพาะเดือนปัจจุบัน
  double monthlyExpense() {
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;

    return transactions
        .where(
          (e) =>
              e.moneyType == 'expense' &&
              e.date != null &&
              e.date!.isNotEmpty &&
              _isCurrentMonth(e.date!, currentMonth, currentYear),
        )
        .fold(0.0, (sum, e) => sum + e.amount.toDouble());
  }

  // รายรับเฉพาะเดือนปัจจุบันตามหมวดหมู่
  double monthlyGroupIncome(String group) {
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;

    return transactions
        .where(
          (e) =>
              e.moneyGroup == group &&
              e.moneyType == 'income' &&
              e.date != null &&
              e.date!.isNotEmpty &&
              _isCurrentMonth(e.date!, currentMonth, currentYear),
        )
        .fold(0.0, (sum, e) => sum + e.amount.toDouble());
  }

  // รายจ่ายเฉพาะเดือนปัจจุบันตามหมวดหมู่
  double monthlyGroupExpense(String group) {
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;

    return transactions
        .where(
          (e) =>
              e.moneyGroup == group &&
              e.moneyType == 'expense' &&
              e.date != null &&
              e.date!.isNotEmpty &&
              _isCurrentMonth(e.date!, currentMonth, currentYear),
        )
        .fold(0.0, (sum, e) => sum + e.amount.toDouble());
  }

  // ตรวจสอบว่าวันที่อยู่ในเดือนปัจจุบันหรือไม่
  bool _isCurrentMonth(String dateStr, int currentMonth, int currentYear) {
    try {
      List<String> parts = dateStr.split('-');
      if (parts.length != 3) return false;
      int year = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      return year == currentYear && month == currentMonth;
    } catch (e) {
      return false;
    }
  }

  // ========== Daily Calculations ==========

  // รายรับในวันที่ระบุ
  double dailyIncome(String dateStr) {
    return transactions
        .where((e) => e.moneyType == 'income' && e.date == dateStr)
        .fold(0.0, (sum, e) => sum + e.amount.toDouble());
  }

  // รายจ่ายในวันที่ระบุ
  double dailyExpense(String dateStr) {
    return transactions
        .where((e) => e.moneyType == 'expense' && e.date == dateStr)
        .fold(0.0, (sum, e) => sum + e.amount.toDouble());
  }

  // ยอดสุทธิในวันที่ระบุ
  double dailyNet(String dateStr) {
    return dailyIncome(dateStr) - dailyExpense(dateStr);
  }

  // รายจ่ายตามหมวดหมู่ในวันที่ระบุ
  double dailyExpenseByCategory(String dateStr, String group) {
    return transactions
        .where(
          (e) =>
              e.moneyType == 'expense' &&
              e.moneyGroup == group &&
              e.date == dateStr,
        )
        .fold(0.0, (sum, e) => sum + e.amount.toDouble());
  }

  // คำนวณเปอร์เซ็นต์ของหมวดหมู่เทียบกับรายจ่ายทั้งหมดในวันนั้น
  double dailyCategoryPercentage(String dateStr, String group) {
    double totalExpense = dailyExpense(dateStr);
    if (totalExpense <= 0) return 0.0;
    return (dailyExpenseByCategory(dateStr, group) / totalExpense) * 100.0;
  }

  // ========== Monthly Calculations ==========

  // รายรับในเดือนที่ระบุ
  double monthlyIncomeForDate(int year, int month) {
    return transactions
        .where(
          (e) =>
              e.moneyType == 'income' &&
              e.date != null &&
              e.date!.isNotEmpty &&
              _isMonthYear(e.date!, year, month),
        )
        .fold(0.0, (sum, e) => sum + e.amount.toDouble());
  }

  // รายจ่ายในเดือนที่ระบุ
  double monthlyExpenseForDate(int year, int month) {
    return transactions
        .where(
          (e) =>
              e.moneyType == 'expense' &&
              e.date != null &&
              e.date!.isNotEmpty &&
              _isMonthYear(e.date!, year, month),
        )
        .fold(0.0, (sum, e) => sum + e.amount.toDouble());
  }

  // ยอดสุทธิในเดือนที่ระบุ
  double monthlyNetForDate(int year, int month) {
    return monthlyIncomeForDate(year, month) -
        monthlyExpenseForDate(year, month);
  }

  // รายจ่ายตามหมวดหมู่ในเดือนที่ระบุ
  double monthlyExpenseByCategory(int year, int month, String group) {
    return transactions
        .where(
          (e) =>
              e.moneyType == 'expense' &&
              e.moneyGroup == group &&
              e.date != null &&
              e.date!.isNotEmpty &&
              _isMonthYear(e.date!, year, month),
        )
        .fold(0.0, (sum, e) => sum + e.amount.toDouble());
  }

  // คำนวณเปอร์เซ็นต์ของหมวดหมู่เทียบกับรายจ่ายทั้งหมดในเดือนนั้น
  double monthlyCategoryPercentage(int year, int month, String group) {
    double totalExpense = monthlyExpenseForDate(year, month);
    if (totalExpense <= 0) return 0.0;
    return (monthlyExpenseByCategory(year, month, group) / totalExpense) *
        100.0;
  }

  // สร้างข้อมูล FlSpot สำหรับกราฟรายวันในเดือนที่ระบุ
  List<FlSpot> generateDailySpotsForMonth(int year, int month) {
    List<FlSpot> spots = [];
    int daysInMonth = DateTime(year, month + 1, 0).day;

    for (int day = 1; day <= daysInMonth; day++) {
      String dateStr =
          '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
      double netAmount = dailyNet(dateStr);
      spots.add(FlSpot(day.toDouble(), netAmount));
    }

    return spots;
  }

  // ========== Yearly Calculations ==========

  // รายรับในปีที่ระบุ
  double yearlyIncome(int year) {
    return transactions
        .where(
          (e) =>
              e.moneyType == 'income' &&
              e.date != null &&
              e.date!.isNotEmpty &&
              _isYear(e.date!, year),
        )
        .fold(0.0, (sum, e) => sum + e.amount.toDouble());
  }

  // รายจ่ายในปีที่ระบุ
  double yearlyExpense(int year) {
    return transactions
        .where(
          (e) =>
              e.moneyType == 'expense' &&
              e.date != null &&
              e.date!.isNotEmpty &&
              _isYear(e.date!, year),
        )
        .fold(0.0, (sum, e) => sum + e.amount.toDouble());
  }

  // ยอดสุทธิในปีที่ระบุ
  double yearlyNet(int year) {
    return yearlyIncome(year) - yearlyExpense(year);
  }

  // รายจ่ายตามหมวดหมู่ในปีที่ระบุ
  double yearlyExpenseByCategory(int year, String group) {
    return transactions
        .where(
          (e) =>
              e.moneyType == 'expense' &&
              e.moneyGroup == group &&
              e.date != null &&
              e.date!.isNotEmpty &&
              _isYear(e.date!, year),
        )
        .fold(0.0, (sum, e) => sum + e.amount.toDouble());
  }

  // คำนวณเปอร์เซ็นต์ของหมวดหมู่เทียบกับรายจ่ายทั้งหมดในปีนั้น
  double yearlyCategoryPercentage(int year, String group) {
    double totalExpense = yearlyExpense(year);
    if (totalExpense <= 0) return 0.0;
    return (yearlyExpenseByCategory(year, group) / totalExpense) * 100.0;
  }

  // สร้างข้อมูล FlSpot สำหรับกราฟรายเดือนในปีที่ระบุ
  List<FlSpot> generateMonthlySpotsForYear(int year) {
    List<FlSpot> spots = [];

    for (int month = 1; month <= 12; month++) {
      double netAmount = monthlyNetForDate(year, month);
      spots.add(FlSpot(month.toDouble(), netAmount));
    }

    return spots;
  }

  // ========== Helper Functions ==========

  // ตรวจสอบว่าวันที่อยู่ในเดือนและปีที่ระบุหรือไม่
  bool _isMonthYear(String dateStr, int year, int month) {
    try {
      List<String> parts = dateStr.split('-');
      if (parts.length != 3) return false;
      int dateYear = int.parse(parts[0]);
      int dateMonth = int.parse(parts[1]);
      return dateYear == year && dateMonth == month;
    } catch (e) {
      return false;
    }
  }

  // ตรวจสอบว่าวันที่อยู่ในปีที่ระบุหรือไม่
  bool _isYear(String dateStr, int year) {
    try {
      List<String> parts = dateStr.split('-');
      if (parts.length != 3) return false;
      int dateYear = int.parse(parts[0]);
      return dateYear == year;
    } catch (e) {
      return false;
    }
  }
}

// คำนวณเปอร์เซ็นต์ของจำนวนเงินที่มีเทียบกับยอดรวม
double calculatePercentage(double amount, double total) {
  if (total <= 0) return 0.0;
  return (amount / total) * 100.0;
}

// คำนวณความยาวของแถบจากเปอร์เซ็นต์
double calculateBarWidth(double amount, double total, double maxWidth) {
  if (total <= 0) return 0.0;
  return (amount * maxWidth) / total;
}
