import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';
import 'db_helper.dart';

class UserService {
  final _db = DBHelper.instance;

  Future<UserModel?> getUserById(int id) async {
    final db = await _db.database;
    final res = await db.query(
      'users',
      where: 'id=?',
      whereArgs: [id],
    );

    if (res.isNotEmpty) {
      return UserModel.fromMap(res.first);
    }
    return null;
  }

  Future<void> updateUser(UserModel user) async {
    if (user.id == null) return;

    final db = await _db.database;

    await db.update(
      'users',
      user.toMap(),
      where: 'id=?',
      whereArgs: [user.id],
    );

    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', user.name);
  }
}
