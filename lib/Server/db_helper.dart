import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:bookbank/Server/database.dart';

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
      version: 3,
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
  }

  /// อัปเกรดฐานข้อมูลเมื่อเปลี่ยนเวอร์ชัน
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE transactions ADD COLUMN date TEXT');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE transactions ADD COLUMN title TEXT');
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
}
