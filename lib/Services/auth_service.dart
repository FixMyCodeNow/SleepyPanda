import 'package:shared_preferences/shared_preferences.dart';
import 'db_helper.dart';

class AuthService {
  final DBHelper _dbHelper = DBHelper.instance;

  // ================= REGISTER =================
  Future<bool> register(String email, String password) async {
    final db = await _dbHelper.database;

    final existingUser = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (existingUser.isNotEmpty) {
      return false;
    }

    final userId = await db.insert(
      'users',
      {
        'email': email,
        'password': password,
        'name': '',
        'gender': '',
        'dob': '',
        'height': 0,
        'weight': 0,
      },
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userId);

    return true;
  }

  // ================= LOGIN =================
  Future<bool> login(String email, String password) async {
    final db = await _dbHelper.database;

    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', result.first['id'] as int);
      return true;
    }
    return false;
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
  }

  // ================= CURRENT USER =================
  Future<int?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  // ================= RESET PASSWORD =================

  Future<bool> resetPassword(String email, String newPassword) async {
    final db = await _dbHelper.database;

    final user = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (user.isEmpty) {
      return false;
    }

    await db.update(
      'users',
      {'password': newPassword},
      where: 'email = ?',
      whereArgs: [email],
    );

    return true;
  }
}
