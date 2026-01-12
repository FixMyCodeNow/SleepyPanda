import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; 

import '../model/user_model.dart';
import '../Services/user_service.dart';

class ProfileDetailScreen extends StatefulWidget {
  final UserModel user;
  const ProfileDetailScreen({super.key, required this.user});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  final _userService = UserService();

  late TextEditingController nameC;
  late TextEditingController genderC;
  late TextEditingController dobC;
  late TextEditingController heightC;
  late TextEditingController weightC;

  @override
  void initState() {
    super.initState();
    nameC = TextEditingController(text: widget.user.name);
    genderC = TextEditingController(text: widget.user.gender);
    dobC = TextEditingController(text: widget.user.dob);
    heightC = TextEditingController(text: widget.user.height.toString());
    weightC = TextEditingController(text: widget.user.weight.toString());
  }

  // Fungsi untuk memunculkan Kalender
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dobC.text = DateFormat('dd MMMM yyyy').format(picked);
      });
    }
  }

  Future<void> _save() async {
    final updated = widget.user.copyWith(
      name: nameC.text,
      gender: genderC.text,
      dob: dobC.text,
      height: int.tryParse(heightC.text) ?? 0,
      weight: int.tryParse(weightC.text) ?? 0,
    );

    // ================= KODE LAMA (JANGAN DIUBAH) =================
    await _userService.updateUser(updated);

    // ================= TAMBAHAN AUTO SYNC =================
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', updated.name);
    // =======================================================

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C2143),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C2143),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          children: [
            // Avatar
            const CircleAvatar(
              radius: 45,
              backgroundColor: Colors.white10,
              child: Icon(Icons.person, size: 50, color: Colors.white54),
            ),
            const SizedBox(height: 30),

            _input("Nama", nameC, icon: Icons.person_outline, showEditIcon: true),
            _input("Email", TextEditingController(text: widget.user.email), 
                icon: Icons.email_outlined, readOnly: true, showEditIcon: true),
            _input("Gender", genderC, icon: Icons.transgender),
            _input("Date of birth", dobC, 
                icon: Icons.calendar_month_outlined, 
                readOnly: true, 
                onTap: _selectDate), 
            _input("Height", heightC, 
                isNumber: true, 
                suffix: "Cm", 
                icon: Icons.square_outlined), 
            _input("Weight", weightC, 
                isNumber: true, 
                suffix: "Kg", 
                icon: Icons.square_outlined),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 1, 147, 155), // Sesuaikan warna button jika perlu
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================== COMPONENT INPUT YANG DIPERBAIKI ==================
  Widget _input(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
    bool readOnly = false,
    String? suffix,
    IconData? icon,
    VoidCallback? onTap,
    bool showEditIcon = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onTap,
            child: TextField(
              controller: controller,
              enabled: onTap == null, // disable manual ketik jika ada fungsi onTap (seperti kalender)
              readOnly: readOnly,
              keyboardType: isNumber ? TextInputType.number : TextInputType.text,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF262B4B),
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(icon, color: Colors.white70, size: 22),
                ),
                suffixIcon: showEditIcon 
                  ? const Icon(Icons.edit_note_outlined, color: Colors.white70)
                  : (suffix != null 
                      ? Padding(
                          padding: const EdgeInsets.only(top: 15, right: 15),
                          child: Text(suffix, style: const TextStyle(color: Colors.white70)),
                        )
                      : null),
              ),
            ),
          ),
        ],
      ),
    );
  }
}