import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/cart_item.dart';

class DBHelper {
  DBHelper._internal();
  static final DBHelper instance = DBHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  
  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'kapetayo.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE cart (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            coffeeId TEXT,
            name TEXT,
            image TEXT,
            basePrice REAL,
            quantity INTEGER,
            size TEXT,
            temperature TEXT,
            addOns TEXT
          )
        ''');
      },
    );
  }

  
  Future<int> insertItem(CartItem item) async {
    final db = await database;

    return await db.insert(
      'cart',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  
  Future<List<CartItem>> getItems() async {
    final db = await database;

    final result = await db.query('cart');

    return result.map((map) => CartItem.fromMap(map)).toList();
  }

  
  Future<int> updateItem(CartItem item) async {
    final db = await database;

    return await db.update(
      'cart',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  
  Future<int> deleteItem(int id) async {
    final db = await database;

    return await db.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  
  Future<int> clearCart() async {
    final db = await database;
    return await db.delete('cart');
  }

  
  Future<CartItem?> getItemById(int id) async {
    final db = await database;

    final result = await db.query(
      'cart',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return CartItem.fromMap(result.first);
  }

  
  Future<void> close() async {
    final db = await database;
    await db.close();
    _db = null;
  }
}