import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();

  final TextEditingController _nameController =
      TextEditingController(text: "Ariana");
  final TextEditingController _emailController =
      TextEditingController(text: "ariana@mail.com");
  final TextEditingController _dobController =
      TextEditingController(text: "30 May 1994");
  final TextEditingController _heightController =
      TextEditingController(text: "166 Cm");
  final TextEditingController _weightController =
      TextEditingController(text: "58 Kg");

  String gender = "Female";

  Future<void> _logout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C2143),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C2143),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Profile",
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),

            // Avatar default (tanpa gambar/icon)
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),

            const SizedBox(height: 20),

            // Name field
            _buildProfileField(
              label: "Nama",
              controller: _nameController,
              icon: Icons.person_outline,
            ),

            // Email
            _buildProfileField(
              label: "Email",
              controller: _emailController,
              icon: Icons.email_outlined,
            ),

            // Gender
            _buildGenderField(),

            // Date of Birth
            _buildProfileField(
              label: "Date of birth",
              controller: _dobController,
              icon: Icons.calendar_today,
            ),

            // Height
            _buildProfileField(
              label: "Height",
              controller: _heightController,
              icon: Icons.height,
            ),

            // Weight
            _buildProfileField(
              label: "Weight",
              controller: _weightController,
              icon: Icons.monitor_weight_outlined,
            ),

            const SizedBox(height: 10),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C2CB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Profil berhasil disimpan!"),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Text(
                  "Save",
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Other options section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF23284D),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    "Untuk hasil analisa yang lebih baik, daftarkan informasi profil mu.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Lihat profil saya",
                      style: GoogleFonts.roboto(
                        color: const Color(0xFF00C2CB),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Divider(color: Colors.white24, height: 20),
                  _buildOptionItem("Detail Profil"),
                  _buildOptionItem("Terms & Conditions"),
                  _buildOptionItem("Feedback"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _logout,
                child: Text(
                  "Logout",
                  style: GoogleFonts.roboto(
                    color: const Color(0xFF1C2143),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---
  Widget _buildProfileField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          label,
          style: GoogleFonts.roboto(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.white70),
            suffixIcon: const Icon(Icons.edit_outlined, color: Colors.white70),
            filled: true,
            fillColor: const Color(0xFF23284D),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF00C2CB)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          "Gender",
          style: GoogleFonts.roboto(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF23284D),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            dropdownColor: const Color(0xFF23284D),
            value: gender,
            iconEnabledColor: Colors.white,
            decoration: const InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.female, color: Colors.white70),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            items: ["Female", "Male"]
                .map((g) => DropdownMenuItem(
                      value: g,
                      child: Text(
                        g,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                gender = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOptionItem(String text) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        text,
        style: GoogleFonts.roboto(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 18),
      onTap: () {},
    );
  }
}
