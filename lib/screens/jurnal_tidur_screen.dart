import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SleepRecommendationScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  const SleepRecommendationScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF191D30),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Hasil Analisa", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF222844),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['status'],
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    data['message'],
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14, height: 1.4),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(color: Colors.white24),
                  ),
                  const Text(
                    "Saran untuk kamu:",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...(data['saran'] as List).map((saran) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_box, color: Color(0xFF008E97), size: 18),
                        const SizedBox(width: 10),
                        Expanded(child: Text(saran, style: const TextStyle(color: Colors.white70, fontSize: 13))),
                      ],
                    ),
                  )).toList(),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008E97),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Kembali ke Jurnal Tidur", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- JURNAL TIDUR SCREEN ---
class JurnalTidurScreen extends StatefulWidget {
  const JurnalTidurScreen({super.key});

  @override
  State<JurnalTidurScreen> createState() => _JurnalTidurScreenState();
}

class _JurnalTidurScreenState extends State<JurnalTidurScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Color bgColor = const Color(0xFF191D30); 
  final Color cardColor = const Color(0xFF222844);
  final Color accentColor = const Color(0xFF008E97); 

  DateTime? sleepStart;
  DateTime? sleepEnd;
  int? sleepDurationMinutes;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadSleepData();
  }

  Future<void> _loadSleepData() async {
    final prefs = await SharedPreferences.getInstance();
    final start = prefs.getString('sleep_start');
    final end = prefs.getString('sleep_end');
    final duration = prefs.getInt('sleep_duration_minutes');

    if (!mounted) return;

    setState(() {
      sleepStart = start != null ? DateTime.tryParse(start) : null;
      sleepEnd = end != null ? DateTime.tryParse(end) : null;
      sleepDurationMinutes = duration;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getFormattedWeekRange() {
    DateTime now = DateTime.now();
    DateTime firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime lastDayOfWeek = firstDayOfWeek.add(const Duration(days: 6));
    String start = DateFormat('d MMM').format(firstDayOfWeek);
    String end = DateFormat('d MMM').format(lastDayOfWeek);
    return '$start - $end';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
           
            _header(),
            
           
            _tabMenu(),
            
            const SizedBox(height: 10), // Memberi sedikit jarak agar rapi
            
           
            _infoCard(),
            
            
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _dailyView(),
                  _weekView(),
                  _monthView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        'Jurnal Tidur',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _infoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Untuk hasil analisa yang lebih baik, akurat, dan\nbermanfaat. Profil tidur hanya bisa diakses\nsetelah kamu melakukan pelacakan tidur paling\ntidak 30 hari.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell( // Menggunakan InkWell agar bisa di-tap
             // Cari bagian InkWell di dalam widget _infoCard() pada JurnalTidurScreen
// Lalu ganti isi onTap-nya dengan ini:

                  onTap: () {
                    // MOCK DATA YANG DISESUAIKAN: STATUS SEHAT
                    final mockResult = {
                      "status": "🚀 Sehat", // Disamakan dengan status "Sehat"
                      "message": "Berdasarkan analisa mesin pembelajaran XGBoost, profil tidur kamu tergolong Sehat. Kamu memiliki konsistensi yang baik antara waktu mulai tidur dan bangun tidur.",
                      "saran": [
                        "Pertahankan rutinitas tidur di jam yang sama setiap hari.",
                        "Pastikan durasi tidur tetap berada di rentang 7-8 jam.",
                        "Lakukan relaksasi ringan sebelum tidur untuk menjaga kualitas.",
                        "Batasi konsumsi kafein di sore hari agar ritme sirkadian terjaga."
                      ]
                    };

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SleepRecommendationScreen(data: mockResult),
                      ),
                    );
                  },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Lihat profil tidur',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabMenu() {
    return TabBar(
      controller: _tabController,
      indicatorColor: Colors.white,
      indicatorSize: TabBarIndicatorSize.label,
      dividerColor: Colors.transparent,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white54,
      tabs: const [
        Tab(text: 'Daily'),
        Tab(text: 'Week'),
        Tab(text: 'Month'),
      ],
    );
  }

  Widget _dailyView() {
    final dateText = sleepStart != null
        ? DateFormat('dd MMMM yyyy').format(sleepStart!)
        : DateFormat('dd MMMM yyyy').format(DateTime.now());

    final durationText = sleepDurationMinutes != null
        ? '${sleepDurationMinutes! ~/ 60} jam ${sleepDurationMinutes! % 60} menit'
        : '0 jam 0 menit';

    final sleepRangeText = (sleepStart != null && sleepEnd != null)
        ? '${DateFormat('HH:mm').format(sleepStart!)} - ${DateFormat('HH:mm').format(sleepEnd!)}'
        : '--:-- - --:--';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dateText, style: const TextStyle(color: Colors.white, fontSize: 15)),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildSimpleInfo("⏰", 'Durasi tidur', durationText),
                const SizedBox(width: 25),
                _buildSimpleInfo("🌟", 'Waktu tidur', sleepRangeText),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleInfo(String emoji, String label, String value) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }

  Widget _weekView() {
    DateTime now = DateTime.now();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  DateFormat('yyyy').format(now),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.chevron_left, color: Colors.white54, size: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        _getFormattedWeekRange(),
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.white54, size: 20),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              _infoGridCard("⏰", 'Average', 'Durasi tidur', '0 jam 0 menit'),
              _infoGridCard("🌟", 'Total', 'Durasi tidur', '0 jam 0 menit'),
              _infoGridCard("🛌", 'Average', 'Mulai tidur', '--:--'),
              _infoGridCard("😊", 'Average', 'Bangun tidur', '--:--'),
            ],
          ),
          const SizedBox(height: 30),
          const Text('Durasi Tidur', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          _emptyBoxLarge(),
        ],
      ),
    );
  }

  Widget _infoGridCard(String emoji, String topLabel, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(topLabel, style: const TextStyle(color: Colors.white54, fontSize: 10)),
                Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _monthView() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: _emptyBoxLarge(),
    );
  }

  Widget _emptyBoxLarge() {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Center(
        child: Text(
          'Belum ada data, mulai lacak tidur\nkamu untuk melihat data',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12, height: 1.5),
        ),
      ),
    );
  }
}