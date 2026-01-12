import 'package:flutter/material.dart';

class SleepRecommendationScreen extends StatelessWidget {
  final Map<String, dynamic> data; // Terima data hasil analisa

  const SleepRecommendationScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C2143),
      appBar: AppBar(
        title: const Text("Profil Tidur Kamu"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildResultCard(),
            const SizedBox(height: 24),
            _buildBackButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF262B4B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Status (Contoh: Baik / Insomnia)
          Text("${data['status']}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          Text("${data['message']}", style: const TextStyle(color: Colors.white70)),
          const Divider(color: Colors.white24, height: 32),
          const Text("Saran untuk kamu:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          // List saran menggunakan Column
          ...((data['saran'] as List).map((item) => _buildSaranItem(item)).toList()),
        ],
      ),
    );
  }

  Widget _buildSaranItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_box, color: Colors.teal, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.white70))),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00897B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        onPressed: () => Navigator.pop(context),
        child: const Text("Kembali ke Jurnal Tidur", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}