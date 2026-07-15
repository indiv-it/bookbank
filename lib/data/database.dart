class MyData {
  MyData({
    this.id,
    required this.amount,
    required this.moneyList,
    required this.moneyType,
    required this.moneyGroup,
    this.date,
    this.title,
  });

  int? id;
  num amount;
  String moneyList;
  String moneyType;
  String moneyGroup;
  String? date;
  String? title;

  /// แปลงข้อมูลในคลาสเป็นแผนที่สำหรับเขียนลง SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'moneyList': moneyList,
      'moneyType': moneyType,
      'moneyGroup': moneyGroup,
      'date': date,
      'title': title,
    };
  }

  /// สร้างวัตถุจากผลลัพธ์ที่อ่านจาก SQLite
  factory MyData.fromMap(Map<String, dynamic> map) {
    return MyData(
      id: map['id'] as int?,
      amount: (map['amount'] as num?) ?? 0,
      moneyList: (map['moneyList'] as String?) ?? '',
      moneyType: (map['moneyType'] as String?) ?? '',
      moneyGroup: (map['moneyGroup'] as String?) ?? '',
      date: map['date'] as String?,
      title: map['title'] as String?,
    );
  }
}

class GroupSettings {
  GroupSettings({
    this.id,
    required this.groupId,
    required this.groupName,
    required this.iconCodePoint,
    required this.colorValue,
    required this.savingsGoalEnabled,
    this.savingsGoalAmount = 0,
  });

  int? id;
  String groupId;
  String groupName;
  int iconCodePoint;
  int colorValue;
  bool savingsGoalEnabled;
  double savingsGoalAmount;

  /// แปลงข้อมูลในคลาสเป็นแผนที่สำหรับเขียนลง SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'groupId': groupId,
      'groupName': groupName,
      'iconCodePoint': iconCodePoint,
      'colorValue': colorValue,
      'savingsGoalEnabled': savingsGoalEnabled ? 1 : 0,
      'savingsGoalAmount': savingsGoalAmount,
    };
  }

  /// สร้างวัตถุจากผลลัพธ์ที่อ่านจาก SQLite
  factory GroupSettings.fromMap(Map<String, dynamic> map) {
    return GroupSettings(
      id: map['id'] as int?,
      groupId: (map['groupId'] as String?) ?? '',
      groupName: (map['groupName'] as String?) ?? '',
      iconCodePoint: (map['iconCodePoint'] as int?) ?? 0,
      colorValue: (map['colorValue'] as int?) ?? 0,
      savingsGoalEnabled: (map['savingsGoalEnabled'] as int?) == 1,
      savingsGoalAmount: (map['savingsGoalAmount'] as num?)?.toDouble() ?? 0,
    );
  }
}
