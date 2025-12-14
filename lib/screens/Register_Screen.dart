import 'package:flutter/material.dart';
import '../Services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = AuthService();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool loading = false;

  Future<void> _register() async {
    setState(() => loading = true);

    final success =
        await _auth.register(_email.text.trim(), _password.text.trim());

    setState(() => loading = false);

    if (!mounted) return;

    if (success) {
      // 🔥 CUMA INI YANG DIUBAH
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/userinfo',
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email sudah terdaftar!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2230),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
          child: Column(
            children: [
              // 🔥 LOGO TETAP ADA
              Image.asset(
                "images/SleepyPanda.png",
                height: 110,
              ),

              const SizedBox(height: 12),

              Text(
                "Daftar menggunakan email yang\nvalid",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 40),

              // EMAIL
              _buildField(
                controller: _email,
                label: "Email",
                icon: Icons.email_outlined,
              ),

              const SizedBox(height: 20),

              // PASSWORD
              _buildField(
                controller: _password,
                label: "Password",
                icon: Icons.lock_outline,
                obscure: true,
              ),

              const SizedBox(height: 35),

              // BUTTON DAFTAR
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
                  onPressed: loading ? null : _register,
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Daftar",
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2A3043),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(icon, color: Colors.white70),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}
