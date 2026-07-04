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
