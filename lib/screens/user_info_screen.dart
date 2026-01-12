import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../Services/auth_service.dart';
import '../Services/user_service.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  int _currentStep = 0;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  String? _gender;
  DateTime? _birthDate;

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
    _heightController.addListener(() => setState(() {}));
    _weightController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _saveUserInfo() async {
    final userId = await _authService.getCurrentUserId();
    if (userId == null) return;

    final user = await _userService.getUserById(userId);
    if (user == null) return;

    final updatedUser = user.copyWith(
      name: _nameController.text,
      gender: _gender ?? '',
      dob: _birthDate != null
          ? "${_birthDate!.year}-${_birthDate!.month.toString().padLeft(2, '0')}-${_birthDate!.day.toString().padLeft(2, '0')}"
          : '',
      height: int.tryParse(_heightController.text) ?? 0,
      weight: int.tryParse(_weightController.text) ?? 0,
    );

    await _userService.updateUser(updatedUser);
  }

  void _nextStep() async {
    if (_currentStep < 4) {
      setState(() => _currentStep++);
    } else {
      await _saveUserInfo();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2241),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: _buildStep(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_currentStep) {
      case 0:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Selamat datang di Sleepy Panda!\nSebelumnya, siapa ya di depan kami ini?",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Nama",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF2A2E4B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            _nextButton(
                enabled: _nameController.text.isNotEmpty,
                onTap: _nextStep),
          ],
        );

      case 1:
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Hai! Sekarang pilih yuk, supaya kami bisa kenal kamu lebih baik.",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 30),

        // Wanita
        GestureDetector(
          onTap: () => setState(() => _gender = "Wanita"),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2E4B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _gender == "Wanita"
                    ? const Color(0xFF1EC8C8)
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: const [
                Text(
                  "👩",
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(width: 12),
                Text(
                  "Wanita",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 15),

        // Pria
        GestureDetector(
          onTap: () => setState(() => _gender = "Pria"),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2E4B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _gender == "Pria"
                    ? const Color(0xFF1EC8C8)
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: const [
                Text(
                  "👨",
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(width: 12),
                Text(
                  "Pria",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 30),
        _nextButton(enabled: _gender != null, onTap: _nextStep),
      ],
  );


      case 2:
        int selectedDay = _birthDate?.day ?? 1;
        int selectedMonth = _birthDate?.month ?? 1;
        int selectedYear = _birthDate?.year ?? 2000;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Terima kasih! Sekarang kapan tanggal lahir mu?",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 40),
            Center(
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: const Color(0xFF1E2241),
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (_) {
                      return SizedBox(
                        height: 300,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            const Text(
                              "Pilih Tanggal Lahir",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CupertinoPicker(
                                      itemExtent: 40,
                                      scrollController:
                                          FixedExtentScrollController(
                                              initialItem: selectedDay - 1),
                                      onSelectedItemChanged: (value) {
                                        selectedDay = value + 1;
                                      },
                                      children: List.generate(
                                        31,
                                        (i) => Center(
                                          child: Text("${i + 1}",
                                              style: const TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: CupertinoPicker(
                                      itemExtent: 40,
                                      scrollController:
                                          FixedExtentScrollController(
                                              initialItem: selectedMonth - 1),
                                      onSelectedItemChanged: (value) {
                                        selectedMonth = value + 1;
                                      },
                                      children: List.generate(
                                        12,
                                        (i) => Center(
                                          child: Text("${i + 1}",
                                              style: const TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: CupertinoPicker(
                                      itemExtent: 40,
                                      scrollController:
                                          FixedExtentScrollController(
                                              initialItem:
                                                  selectedYear - 1900),
                                      onSelectedItemChanged: (value) {
                                        selectedYear = 1900 + value;
                                      },
                                      children: List.generate(
                                        DateTime.now().year - 1899,
                                        (i) => Center(
                                          child: Text("${1900 + i}",
                                              style: const TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _birthDate = DateTime(
                                      selectedYear,
                                      selectedMonth,
                                      selectedDay);
                                });
                                Navigator.pop(context);
                              },
                              child: const Text("Simpan"),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 40),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2E4B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _birthDate == null
                        ? "Pilih Tanggal"
                        : "${_birthDate!.day.toString().padLeft(2, '0')} / "
                            "${_birthDate!.month.toString().padLeft(2, '0')} / "
                            "${_birthDate!.year}",
                    style:
                        const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            _nextButton(enabled: _birthDate != null, onTap: _nextStep),
          ],
        );

      case 3:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Selanjutnya, berapa tinggi badan mu?",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF2A2E4B),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text("Cm", style: TextStyle(color: Colors.white)),
              ],
            ),
            const SizedBox(height: 30),
            _nextButton(
                enabled: _heightController.text.isNotEmpty,
                onTap: _nextStep),
          ],
        );

      case 4:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Terakhir, berapa berat badan mu?",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF2A2E4B),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text("Kg", style: TextStyle(color: Colors.white)),
              ],
            ),
            const SizedBox(height: 30),
            _nextButton(
                enabled: _weightController.text.isNotEmpty,
                onTap: _nextStep),
          ],
        );

      default:
        return const SizedBox();
    }
  }

  Widget _nextButton({required bool enabled, required VoidCallback onTap}) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? const Color(0xFF1EC8C8) : Colors.grey,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          minimumSize: const Size(150, 45),
        ),
        onPressed: enabled ? onTap : null,
        child: Text(
          _currentStep < 4 ? "Lanjut" : "Selesai",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
