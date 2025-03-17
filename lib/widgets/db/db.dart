import 'package:get/get.dart';
import 'package:newthijar/model/sale_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Repository {
  static final Repository _instance = Repository._internal();
  factory Repository() => _instance;

  static Database? _database;

  Repository._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'sale_list.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE sale(id INTEGER PRIMARY KEY, billName TEXT, billNum TEXT, billDate TEXT)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < newVersion) {
          db.execute(
            'CREATE TABLE sale(id INTEGER PRIMARY KEY, billName TEXT, billNum TEXT, billDate TEXT)',
          );
        }
      },
    );
  }

  Future<void> insertSale(SaleModel saleModel) async {
    try {
      final db = await database;
      await db.insert('sale', saleModel.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      printInfo(info: "errro ===$e");
    }
  }

  Future<List<SaleModel>> getAllSale() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sale');
    return List.generate(maps.length, (i) {
      return SaleModel.fromJson(maps[i]);
    });
  }

  Future<void> deleteSale(int id) async {
    final db = await database;
    await db.delete('sale', where: 'id = ?', whereArgs: [id]);
  }
}
