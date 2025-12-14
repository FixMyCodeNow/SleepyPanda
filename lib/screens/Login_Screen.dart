import 'package:flutter/material.dart';
import 'Register_Screen.dart';
import '../Services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Home_Screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;

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
        SnackBar(content: Text("Email atau password salah")),
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
              // IMAGE PANDA
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      "images/SleepyPanda.png",
                      height: 110,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Masuk menggunakan akun yang\nsudah kamu daftarkan",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 50),

              // EMAIL
              _buildTextField(
                controller: _email,
                label: "Email",
                icon: Icons.email_outlined,
              ),

              SizedBox(height: 20),

              // PASSWORD
              _buildTextField(
                controller: _password,
                label: "Password",
                icon: Icons.lock_outline,
                obscure: true,
                onTrailingTap: () {},
              ),

              SizedBox(height: 35),

              // BUTTON LOGIN
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
                      ? CircularProgressIndicator(color: Colors.white)
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

              SizedBox(height: 25),

              // LINK TO REGISTER
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RegisterScreen()),
                  );
                },
                child: Text.rich(
                  TextSpan(
                    text: "Belum memiliki akun? ",
                    style: GoogleFonts.roboto(color: Colors.white70),
                    children: [
                      TextSpan(
                        text: "Daftar sekarang",
                        style: TextStyle(
                          color: Color(0xFF00C2CB),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    String? trailing,
    VoidCallback? onTrailingTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.roboto(color: Colors.white70, fontSize: 14)),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2A3043),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(icon, color: Colors.white70),
              suffixIcon: trailing != null
                  ? GestureDetector(
                      onTap: onTrailingTap,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            trailing,
                            style: TextStyle(
                                color: Color(0xFF00C2CB), fontSize: 12),
                          ),
                        ),
                      ),
                    )
                  : null,
              contentPadding: EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}
