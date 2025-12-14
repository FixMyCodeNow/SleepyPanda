import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Services/auth_service.dart';
import '../Services/user_service.dart';
import '../model/user_model.dart';
import 'profile_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _auth = AuthService();
  final UserService _userService = UserService();

  UserModel? user;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final userId = await _auth.getCurrentUserId();
    if (userId == null) {
      setState(() => loading = false);
      return;
    }

    final result = await _userService.getUserById(userId);

    setState(() {
      user = result;
      loading = false;
    });
  }

  Future<void> _openDetail() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileDetailScreen(user: user!),
      ),
    );

    // 🔥 reload data setelah edit
    _loadUser();
  }

  Future<void> _logout() async {
    await _auth.logout();
    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/welcome',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("User tidak ditemukan"),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1C2143),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C2143),
        elevation: 0,
        centerTitle: true,
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Avatar
            const CircleAvatar(
              radius: 45,
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, color: Colors.white, size: 40),
            ),

            const SizedBox(height: 16),

            Text(
              user!.name.isEmpty ? "Nama belum diisi" : user!.name,
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              user!.email,
              style: GoogleFonts.roboto(color: Colors.white70),
            ),

            const SizedBox(height: 24),

            // Card Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF23284D),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    "Untuk hasil analisa yang lebih akurat, "
                    "lengkapi informasi profil kamu.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _openDetail,
                    child: const Text(
                      "Lihat profil saya",
                      style: TextStyle(color: Color(0xFF00C2CB)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Menu
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF23284D),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _menuTile("Detail profil", _openDetail),
                  _divider(),
                  _menuTile("Terms & Conditions", () {}),
                  _divider(),
                  _menuTile("Feedback", () {}),
                ],
              ),
            ),

            const Spacer(),

            // Logout
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                onPressed: _logout,
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Color(0xFF1C2143)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuTile(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white),
      onTap: onTap,
    );
  }

  Widget _divider() => const Divider(color: Colors.white24, height: 1);
}
