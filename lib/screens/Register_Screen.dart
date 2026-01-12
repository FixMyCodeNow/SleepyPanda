import 'package:flutter/material.dart';
import '../Services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ForgotPasswordModal.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = AuthService();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool loading = false;

  // 🔥 tambahan
  bool _obscurePassword = true;

  Future<void> _register() async {
    setState(() => loading = true);

    final success =
        await _auth.register(_email.text.trim(), _password.text.trim());

    setState(() => loading = false);

    if (!mounted) return;

    if (success) {
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
              Image.asset("assets/images/SleepyPanda.png", height: 110),
              const SizedBox(height: 16),

              Text(
                "Daftar menggunakan email yang\nvalid",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 40),

              _buildField(
                controller: _email,
                hint: "Email",
                icon: Icons.email_outlined,
              ),

              const SizedBox(height: 20),

              _buildField(
                controller: _password,
                hint: "Password",
                icon: Icons.lock_outline,
                obscure: _obscurePassword,
                isPassword: true, // 🔥 tambahan
              ),

              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const ForgotPasswordModal(),
                    );
                  },
                  child: Text(
                    "Lupa password?",
                    style: GoogleFonts.roboto(
                      color: const Color(0xFF00C2CB),
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

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

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.roboto(fontSize: 13),
                    children: const [
                      TextSpan(
                        text: "Sudah memiliki akun? ",
                        style: TextStyle(color: Colors.white70),
                      ),
                      TextSpan(
                        text: "Masuk sekarang",
                        style: TextStyle(
                          color: Color(0xFF00C2CB),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
    required String hint,
    required IconData icon,
    bool obscure = false,
    bool isPassword = false, // 🔥 tambahan
  }) {
    return Container(
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
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: Icon(icon, color: Colors.white70),

          // 🔥 icon mata
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                )
              : null,

          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }
}
