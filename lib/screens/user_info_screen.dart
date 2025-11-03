import 'package:flutter/material.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  int _currentStep = 0;
  final TextEditingController _nameController = TextEditingController();
  String? _gender;
  DateTime? _birthDate;
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {})); // ✅ tambahkan ini
    _heightController.addListener(() => setState(() {}));
    _weightController.addListener(() => setState(() {}));
  }

  void _nextStep() {
    setState(() {
      if (_currentStep < 4) {
        _currentStep++;
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2241),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: _buildStep(),
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_currentStep) {
      // STEP 1: Nama
      case 0:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Selamat datang di Sleepy Panda!\nSebelumnya, siapa ya di depan kami ini?",
              style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Roboto'),
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
            _nextButton(enabled: _nameController.text.isNotEmpty, onTap: _nextStep),
          ],
        );

      // STEP 2: Gender
      case 1:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hai! Sekarang pilih yuk, supaya kami bisa kenal kamu lebih baik.",
              style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Roboto'),
            ),
            const SizedBox(height: 40),
            RadioListTile(
              title: const Text("Pria", style: TextStyle(color: Colors.white)),
              value: "Pria",
              groupValue: _gender,
              onChanged: (value) => setState(() => _gender = value),
            ),
            RadioListTile(
              title: const Text("Wanita", style: TextStyle(color: Colors.white)),
              value: "Wanita",
              groupValue: _gender,
              onChanged: (value) => setState(() => _gender = value),
            ),
            const SizedBox(height: 30),
            _nextButton(enabled: _gender != null, onTap: _nextStep),
          ],
        );

      // STEP 3: Tanggal Lahir
      case 2:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Terima kasih! Sekarang kapan tanggal lahir mu?",
              style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Roboto'),
            ),
            const SizedBox(height: 40),
            Center(
              child: GestureDetector(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) setState(() => _birthDate = date);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2E4B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _birthDate == null
                        ? "Pilih Tanggal"
                        : "${_birthDate!.day.toString().padLeft(2, '0')} / ${_birthDate!.month.toString().padLeft(2, '0')} / ${_birthDate!.year}",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            _nextButton(enabled: _birthDate != null, onTap: _nextStep),
          ],
        );

      // STEP 4: Tinggi
      case 3:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Selanjutnya, berapa tinggi badan mu?",
              style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Roboto'),
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
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 10),
                const Text("Cm", style: TextStyle(color: Colors.white)),
              ],
            ),
            const SizedBox(height: 30),
            _nextButton(enabled: _heightController.text.isNotEmpty, onTap: _nextStep),
          ],
        );

      // STEP 5: Berat
      case 4:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Terakhir, berapa berat badan mu?",
              style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Roboto'),
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
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 10),
                const Text("Kg", style: TextStyle(color: Colors.white)),
              ],
            ),
            const SizedBox(height: 30),
            _nextButton(enabled: _weightController.text.isNotEmpty, onTap: _nextStep),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
