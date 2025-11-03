import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Register akun baru
  Future<bool> register(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    // Simpan akun ke SharedPreferences
    await prefs.setString('user_email', email);
    await prefs.setString('user_password', password);
    await prefs.setBool('is_logged_in', true);

    return true;
  }

  // Login akun yang sudah ada
  Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    final savedEmail = prefs.getString('user_email');
    final savedPassword = prefs.getString('user_password');

    if (email == savedEmail && password == savedPassword) {
      await prefs.setBool('is_logged_in', true);
      return true;
    } else {
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
  }

  // Cek apakah user sudah login sebelumnya
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  Future<bool> resetPassword(String email, String newPassword) async {
  final prefs = await SharedPreferences.getInstance();

  final savedEmail = prefs.getString('user_email');
  if (savedEmail == email) {
    await prefs.setString('user_password', newPassword);
    return true;
  } else {
    return false;
  }
}

}
