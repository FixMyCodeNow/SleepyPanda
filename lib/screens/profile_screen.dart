import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Services/auth_service.dart';
import '../Services/user_service.dart';
import '../model/user_model.dart';
import 'profile_detail_screen.dart';

class SleepRecommendationScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  const SleepRecommendationScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C2143),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF262B4B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['status'],
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    data['message'],
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14, height: 1.4),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(color: Colors.white24),
                  ),
                  const Text(
                    "Saran untuk kamu:",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...(data['saran'] as List).map((saran) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_box, color: Color(0xFF009696), size: 18),
                        const SizedBox(width: 10),
                        Expanded(child: Text(saran, style: const TextStyle(color: Colors.white70, fontSize: 13))),
                      ],
                    ),
                  )).toList(),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF009696),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Kembali ke Jurnal Tidur", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


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
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Scaffold(backgroundColor: Color(0xFF1C2143), body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: const Color(0xFF1C2143),
      appBar: AppBar(backgroundColor: const Color(0xFF1C2143), elevation: 0, toolbarHeight: 10),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  child: const Icon(Icons.person, size: 65, color: Colors.white),
                ),
              ),

              const SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF262B4B),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Untuk hasil analisa yang lebih baik, akurat, dan bermanfaat. Profil tidur hanya bisa diakses setelah kamu melakukan pelacakan tidur paling tidak 30 hari.",
                      style: GoogleFonts.roboto(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        // ACTION PADA TOMBOL LIHAT PROFIL TIDUR
                        onPressed: () {
                          // MOCK DATA UNTUK P2 BAGIAN C
                          final mockData = {
                            "status": "🚀 Baik",
                            "message": "Selamat, kamu memiliki profil tidur yang baik! Durasi tidur kamu memadai dan berkualitas.",
                            "saran": [
                              "Tetap jaga rutinitas tidur yang konsisten.",
                              "Pastikan lingkungan tidur nyaman (gelap, sejuk, tenang).",
                              "Hindari penggunaan smartphone sebelum tidur.",
                              "Lakukan aktivitas fisik secara teratur."
                            ]
                          };

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SleepRecommendationScreen(data: mockData),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF009696),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          elevation: 0,
                        ),
                        child: const Text("Lihat profil tidur", style: TextStyle(fontSize: 12, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF262B4B),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _menuTile("Detil profil", Icons.person_outline, _openDetail),
                    _divider(),
                    _menuTile("Terms & Conditions", Icons.description_outlined, () {}),
                    _divider(),
                    _menuTile("Feedback", Icons.edit_outlined, () {}),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    await _auth.logout();
                    if (!mounted) return;
                    Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
                  },
                  child: const Text(
                    "Logout",
                    style: TextStyle(color: Color(0xFF009696), fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 24),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white, size: 20),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
    );
  }

  Widget _divider() => Divider(color: Colors.white.withOpacity(0.1), height: 1, indent: 20, endIndent: 20);
}