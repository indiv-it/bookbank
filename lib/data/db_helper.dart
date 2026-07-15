import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:bookbank/data/database.dart';

/// ตัวช่วยเชื่อมต่อ SQLite และจัดการคำสั่ง CRUD
class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  /// เปิดฐานข้อมูล และเก็บ instance ไว้ใช้งานครั้งต่อไป
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// สร้างไฟล์ฐานข้อมูล และเตรียมตารางเริ่มต้น
  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'Mydatabase.db');

    return await openDatabase(
      path,
      version: 4,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// สร้างตาราง transactions ในฐานข้อมูล
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        moneyList TEXT NOT NULL,
        moneyType TEXT NOT NULL,
        moneyGroup TEXT NOT NULL,
        date TEXT,
        title TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE group_settings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        groupId TEXT NOT NULL UNIQUE,
        groupName TEXT NOT NULL,
        iconCodePoint INTEGER NOT NULL,
        colorValue INTEGER NOT NULL,
        savingsGoalEnabled INTEGER NOT NULL DEFAULT 0,
        savingsGoalAmount REAL NOT NULL DEFAULT 0
      )
    ''');
    // Insert default group settings
    await _insertDefaultGroupSettings(db);
  }

  /// อัปเกรดฐานข้อมูลเมื่อเปลี่ยนเวอร์ชัน
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE transactions ADD COLUMN date TEXT');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE transactions ADD COLUMN title TEXT');
    }
    if (oldVersion < 4) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS group_settings(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          groupId TEXT NOT NULL UNIQUE,
          groupName TEXT NOT NULL,
          iconCodePoint INTEGER NOT NULL,
          colorValue INTEGER NOT NULL,
          savingsGoalEnabled INTEGER NOT NULL DEFAULT 0,
          savingsGoalAmount REAL NOT NULL DEFAULT 0
        )
      ''');
      await _insertDefaultGroupSettings(db);
    }
  }

  /// แทรกข้อมูลเริ่มต้นสำหรับ group settings
  Future<void> _insertDefaultGroupSettings(Database db) async {
    final defaultGroups = [
      {
        'groupId': 'Group1',
        'groupName': 'Group1',
        'iconCodePoint': 0xe145,
        'colorValue': 0xFF2196F3,
      }, // Icons.add
      {
        'groupId': 'Group2',
        'groupName': 'Group2',
        'iconCodePoint': 0xe145,
        'colorValue': 0xFF4CAF50,
      }, // Icons.add
      {
        'groupId': 'Group3',
        'groupName': 'Group3',
        'iconCodePoint': 0xe145,
        'colorValue': 0xFF9C27B0,
      }, // Icons.add
      {
        'groupId': 'Group4',
        'groupName': 'Group4',
        'iconCodePoint': 0xe145,
        'colorValue': 0xFFE91E63,
      }, // Icons.add
    ];

    for (var group in defaultGroups) {
      await db.insert('group_settings', {
        'groupId': group['groupId'],
        'groupName': group['groupName'],
        'iconCodePoint': group['iconCodePoint'],
        'colorValue': group['colorValue'],
        'savingsGoalEnabled': 0,
        'savingsGoalAmount': 0,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
  }

  /// เพิ่มข้อมูลใหม่ลงในตาราง transactions
  Future<int> insertData(MyData item) async {
    final db = await database;
    return await db.insert(
      'transactions',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// อ่านข้อมูลทั้งหมดจากตาราง transactions
  Future<List<MyData>> getAllData() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      orderBy: 'id DESC',
    );
    return maps.map((map) => MyData.fromMap(map)).toList();
  }

  /// อัปเดตข้อมูลในตาราง transactions โดยใช้ id
  Future<int> updateData(MyData item) async {
    final db = await database;
    if (item.id == null) return 0;
    return await db.update(
      'transactions',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  /// ลบข้อมูลตาม id จากตาราง transactions
  Future<int> deleteData(int id) async {
    final db = await database;
    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  /// อ่านข้อมูล group settings ทั้งหมด
  Future<List<GroupSettings>> getAllGroupSettings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('group_settings');
    return maps.map((map) => GroupSettings.fromMap(map)).toList();
  }

  /// อ่านข้อมูล group settings ตาม groupId
  Future<GroupSettings?> getGroupSettings(String groupId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'group_settings',
      where: 'groupId = ?',
      whereArgs: [groupId],
    );
    if (maps.isEmpty) return null;
    return GroupSettings.fromMap(maps.first);
  }

  /// อัปเดตหรือแทรกข้อมูล group settings
  Future<int> upsertGroupSettings(GroupSettings settings) async {
    final db = await database;
    return await db.insert(
      'group_settings',
      settings.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// อัปเดตข้อมูล group settings ตาม id
  Future<int> updateGroupSettings(GroupSettings settings) async {
    final db = await database;
    if (settings.id == null) return 0;
    return await db.update(
      'group_settings',
      settings.toMap(),
      where: 'id = ?',
      whereArgs: [settings.id],
    );
  }
}
