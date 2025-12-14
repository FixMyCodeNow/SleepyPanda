import 'db_helper.dart';
import '../model/user_model.dart';

class UserService {
  // ========================
  // GET USER BY ID
  // ========================
  Future<UserModel?> getUserById(int id) async {
    final db = await DBHelper.instance.database;

    final res = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (res.isEmpty) return null;

    final m = res.first;

    return UserModel(
      id: m['id'] as int,
      name: m['name'] as String? ?? '',
      email: m['email'] as String? ?? '',
      gender: m['gender'] as String? ?? '',
      dob: m['dob'] as String? ?? '',
      height: m['height'] as int? ?? 0,
      weight: m['weight'] as int? ?? 0,
    );
  }

  // ========================
  // UPDATE USER
  // ========================
  Future<int> updateUser(UserModel user) async {
    final db = await DBHelper.instance.database;

    return await db.update(
      'users',
      {
        'name': user.name,
        'email': user.email,
        'gender': user.gender,
        'dob': user.dob,
        'height': user.height,
        'weight': user.weight,
      },
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // ========================
  // GET USER BY EMAIL
  // ========================
  Future<UserModel?> getByEmail(String email) async {
    final db = await DBHelper.instance.database;

    final res = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (res.isEmpty) return null;

    final m = res.first;

    return UserModel(
      id: m['id'] as int,
      name: m['name'] as String? ?? '',
      email: m['email'] as String? ?? '',
      gender: m['gender'] as String? ?? '',
      dob: m['dob'] as String? ?? '',
      height: m['height'] as int? ?? 0,
      weight: m['weight'] as int? ?? 0,
    );
  }
}
