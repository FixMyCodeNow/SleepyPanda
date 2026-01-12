import 'package:flutter/material.dart';
import 'Register_Screen.dart';
import '../Services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Home_Screen.dart';
import 'ForgotPasswordModal.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;

  // 🔥 tambahan
  bool _obscurePassword = true;

  void _login() async {
    setState(() => isLoading = true);

    bool success = await _authService.login(
      _email.text.trim(),
      _password.text.trim(),
    );

    setState(() => isLoading = false);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email atau password salah")),
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
                "Masuk menggunakan akun yang\nsudah kamu daftarkan",
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
                  onPressed: isLoading ? null : _login,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Masuk",
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RegisterScreen()),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.roboto(fontSize: 13),
                    children: const [
                      TextSpan(
                        text: "Belum memiliki akun? ",
                        style: TextStyle(color: Colors.white70),
                      ),
                      TextSpan(
                        text: "Daftar sekarang",
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
