import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'drink.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'drinks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE drinks(
            id INTEGER PRIMARY KEY,
            name TEXT,
            description TEXT,
            ingredients TEXT,
            imageUrl TEXT
          )
        ''');
      },
    );
  }

  static Future<void> cacheDrinks(List<Drink> drinks) async {
    final database = await db;
    final batch = database.batch();
    for (final d in drinks) {
      batch.insert('drinks', d.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  static Future<List<Drink>> getCachedDrinks() async {
    final database = await db;
    final maps = await database.query('drinks');
    return maps.map((e) => Drink.fromMap(e)).toList();
  }
}
