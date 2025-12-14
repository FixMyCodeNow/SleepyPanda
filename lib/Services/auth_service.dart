import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AuthService {
  static Database? _database;

  // INIT DATABASE
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'users.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');
      },
    );
  }

  // REGISTER USER
  Future<bool> register(String email, String password) async {
    final db = await database;

    try {
      // INSERT user & dapatkan ID
      int id = await db.insert('users', {
        'email': email,
        'password': password
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('current_user_id', id);
      await prefs.setString('current_user_email', email);
      await prefs.setBool('loggedIn', true);        // ➕ diperbaiki

      return true;
    } catch (e) {
      // jika email sudah ada, return false
      return false;
    }
  }

  // LOGIN USER
  Future<bool> login(String email, String password) async {
    final db = await database;

    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('loggedIn', true);
      await prefs.setString('current_user_email', email);
      await prefs.setInt('current_user_id', result.first['id'] as int);

      return true;
    }

    return false;
  }

  // CHECK LOGIN STATUS
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loggedIn') ?? false;
  }

  // RESET PASSWORD
  Future<bool> resetPassword(String email, String newPassword) async {
    final db = await database;

    final updateCount = await db.update(
      'users',
      {'password': newPassword},
      where: 'email = ?',
      whereArgs: [email],
    );

    return updateCount > 0;
  }

  // GET CURRENT EMAIL
  Future<String?> getCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('current_user_email');
  }

  // GET CURRENT USER ID
  Future<int?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('current_user_id');
  }

  // LOGOUT
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();          // ➕ lebih bersih
  }



  
}
