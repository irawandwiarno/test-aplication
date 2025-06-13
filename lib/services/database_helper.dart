import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_gojek_app/models/delivery_model.dart';
import 'package:test_gojek_app/models/user_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'app_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onOpen: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        foto_driver TEXT,
        nama_driver TEXT,
        no_ktp TEXT,
        email TEXT,
        password TEXT
      )
    ''');

    await db.execute('''
     CREATE TABLE delivery (
     id INTEGER PRIMARY KEY AUTOINCREMENT,
     foto_barang TEXT,
     koordinat_awal TEXT,
     koordinat_tujuan TEXT,
     total_jarak REAL,
     total_harga REAL,
     created_at TEXT,
     user_id INTEGER,
     FOREIGN KEY(user_id) REFERENCES user(id) ON DELETE CASCADE
    );
    ''');
  }

  // ========== USER CRUD ==========//

  /// INSERT WITH USER MODEL
  Future<int> insertUser(User user) async {
    final db = await _instance.database;
    return await db.insert('user', user.toMap());
  }

  ///GETUSER BY ID getUser(1)
  Future<User?> getUser(int id) async {
    final db = await _instance.database;
    final maps = await db.query('user', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) return User.fromMap(maps.first);
    return null;
  }

  ///GET BY EMAIL STRING
  Future<User?> getByEmail(String email) async {
    final db = await database;
    email = email.toLowerCase().trim();
    final List<Map<String, dynamic>> maps = await db.query(
      'user',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  ///GET ALL USER
  Future<List<User>> getAllUsers() async {
    final db = await _instance.database;
    final result = await db.query('user');
    return result.map((e) => User.fromMap(e)).toList();
  }

  ///UPDATE USER BY PARSING USER MODEL
  Future<int> updateUser(User user) async {
    final db = await _instance.database;
    return await db
        .update('user', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  ///DELTE USER
  Future<int> deleteUser(int id) async {
    final db = await _instance.database;
    return await db.delete('user', where: 'id = ?', whereArgs: [id]);
  }

  // ========== DELIVERY CRUD ==========//

  /// INSERT DELEVERY WITH DELEVERY MODEL
  Future<int> insertDelivery(Delivery delivery) async {
    final db = await _instance.database;
    return await db.insert('delivery', delivery.toMap());
  }

  /// GET BY ID getDelivery(1)
  Future<Delivery?> getDelivery(int id) async {
    final db = await _instance.database;
    final maps = await db.query('delivery', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) return Delivery.fromMap(maps.first);
    return null;
  }

  ///GET ALL DELIVERY BY DEFAULT (DESC) TERBARU DULU can use ASC
  Future<List<Delivery>> getAllDeliveries({String orderBy = 'DESC'}) async {
    final db = await _instance.database;
    final order = (orderBy.toUpperCase() == 'ASC') ? 'ASC' : 'DESC';
    final result = await db.query(
      'delivery',
      orderBy: 'created_at $order',
    );
    return result.map((e) => Delivery.fromMap(e)).toList();
  }

  /// UPDATE WITH PARSE DELIVERY MODEL
  Future<int> updateDelivery(Delivery delivery) async {
    final db = await _instance.database;
    return await db.update(
      'delivery',
      delivery.toMap(),
      where: 'id = ?',
      whereArgs: [delivery.id],
    );
  }

  /// DELETE DELIVERY
  Future<int> deleteDelivery(int id) async {
    final db = await _instance.database;
    return await db.delete('delivery', where: 'id = ?', whereArgs: [id]);
  }

  ///GET DELIVERY BY USER ID
  Future<List<Delivery>> getDeliveriesByUser(int userId) async {
    final db = await _instance.database;
    final result = await db.query(
      'delivery',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return result.map((e) => Delivery.fromMap(e)).toList();
  }

  //======== Insert User Default =============//
  Future<int?> inserDefaultUser() async {
    final db = await database;
    var res = await db.insert(
      'user',
      User(
        email: 'DRIVER@EMAIL.COM',
        password: '1234',
      ).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return res;
  }
}
