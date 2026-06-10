import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// IMPORT MODELS
import '../models/watchlist.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  factory DatabaseHelper() => instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'watchlist.db');

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE watchlist (
        id INTEGER PRIMARY KEY,
        user_id INTEGER NOT NULL,
        tmdb_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        release_date TEXT NOT NULL,
        tmdb_rating REAL NOT NULL,
        status TEXT NOT NULL,
        user_rating INTEGER,
        notes TEXT
      )
    ''');
  }

  Future<List<Watchlist>> getWatchlistByUser(int userId) async {
    final db = await database;
    final result = await db.query(
      'watchlist',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return result.map((json) => Watchlist.fromJson(json)).toList();
  }

  Future<int> insertWatchlist(Watchlist item) async {
    final db = await database;

    return await db.insert(
      'watchlist',
      item.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateWatchlist(Watchlist item) async {
    final db = await database;

    return await db.update(
      'watchlist',
      item.toJson(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteWatchlist(int id) async {
    final db = await database;
    return await db.delete('watchlist', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('watchlist');
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
