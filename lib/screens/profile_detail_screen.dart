import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/user_model.dart';

class ProfileDetailScreen extends StatefulWidget {
  final UserModel user;
  const ProfileDetailScreen({super.key, required this.user});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  late TextEditingController nameC;
  late TextEditingController emailC;
  late TextEditingController genderC;
  late TextEditingController dobC;
  late TextEditingController heightC;
  late TextEditingController weightC;

  @override
  void initState() {
    super.initState();
    nameC = TextEditingController(text: widget.user.name);
    emailC = TextEditingController(text: widget.user.email);
    genderC = TextEditingController(text: widget.user.gender);
    dobC = TextEditingController(text: widget.user.dob);
    heightC = TextEditingController(text: widget.user.height.toString());
    weightC = TextEditingController(text: widget.user.weight.toString());
  }

  void _save() {
    Navigator.pop(
      context,
      widget.user.copyWith(
        name: nameC.text,
        email: emailC.text,
        gender: genderC.text,
        dob: dobC.text,
        height: int.parse(heightC.text),
        weight: int.parse(weightC.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C2143),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C2143),
        elevation: 0,
        centerTitle: true,
        title: const Text("Detail Profil"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(radius: 45, backgroundColor: Colors.white24),
            const SizedBox(height: 24),

            _input("Name", nameC),
            _input("Email", emailC),
            _input("Gender", genderC),
            _input("Date of Birth", dobC),
            _input("Height", heightC),
            _input("Weight", weightC),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C2CB),
                ),
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(String label, TextEditingController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.roboto(color: Colors.white, fontSize: 13)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF23284D),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: c,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
