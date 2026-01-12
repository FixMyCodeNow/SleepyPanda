import 'dart:async';
import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  bool _isSleeping = false;
  int _hour = 7;
  int _minute = 30;
  String _userName = "Serena";
  Timer? _alarmTimer;
  Timer? _clockTimer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _alarmPlayed = false;
  DateTime? _sleepStart;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _audioPlayer.setAudioContext(
      AudioContext(
        android: AudioContextAndroid(
          usageType: AndroidUsageType.alarm,
          contentType: AndroidContentType.sonification,
          audioFocus: AndroidAudioFocus.gainTransient,
        ),
      ),
    );
    _loadUserName();
    _startClock();

    // Munculkan pop-up set alarm saat pertama kali masuk
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showAlarmPicker();
    });
  }

  void _startClock() {
    _clockTimer?.cancel();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
    });
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name');
    setState(() {
      _userName = (name != null && name.isNotEmpty) ? name : "Serena";
    });
  }

  void _startAlarmListenerRealTime() {
    _alarmTimer?.cancel();
    _alarmTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (!_isSleeping || _alarmPlayed) return;
      final now = DateTime.now();
      if (now.hour == _hour && now.minute == _minute) {
        _alarmPlayed = true;
        await _playAlarm();
        await _saveSleepData();
      }
    });
  }

  Future<void> _playAlarm() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource('audio/alarm.mp3'));
    } catch (e) {
      debugPrint("ALARM ERROR: $e");
    }
  }

  Future<void> _stopAlarm() async {
    await _audioPlayer.stop();
  }

  Future<void> _saveSleepData() async {
    if (_sleepStart == null) return;
    final sleepEnd = DateTime.now();
    final duration = sleepEnd.difference(_sleepStart!).inMinutes;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sleep_start', _sleepStart!.toIso8601String());
    await prefs.setString('sleep_end', sleepEnd.toIso8601String());
    await prefs.setInt('sleep_duration_minutes', duration);
  }

  @override
  void dispose() {
    _alarmTimer?.cancel();
    _clockTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  // ================= POP UP: SET ALARM (UI KIRI) =================
  void _showAlarmPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Agar rounded corner terlihat
      builder: (context) {
        return StatefulBuilder( // Agar picker bisa di scroll di dalam modal
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Color(0xFF1C2143),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
                  const SizedBox(height: 50),
                  const Text("Pilih waktu bangun tidur mu", style: TextStyle(color: Colors.white, fontSize: 18)),
                  const Spacer(),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 75, height: 75, decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(15))),
                          const SizedBox(width: 40),
                          Container(width: 75, height: 75, decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(15))),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _timeColumn(
                            values: List.generate(24, (i) => i),
                            selected: _hour,
                            onChanged: (v) {
                              setModalState(() => _hour = v);
                              setState(() => _hour = v);
                            },
                          ),
                          const Text(" : ", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                          _timeColumn(
                            values: List.generate(60, (i) => i),
                            selected: _minute,
                            onChanged: (v) {
                              setModalState(() => _minute = v);
                              setState(() => _minute = v);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                      children: [
                        TextSpan(text: "Waktu tidur ideal yang cukup adalah\nselama "),
                        TextSpan(text: "8 jam", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _isSleeping = true;
                          _alarmPlayed = false;
                          _sleepStart = DateTime.now();
                        });
                        _startAlarmListenerRealTime();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF008E97),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text("Tidur sekarang", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("Nanti saja", style: TextStyle(color: Colors.white38))),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151934),
      body: SafeArea(
        child: _isSleeping ? _sleepingView() : const Center(child: Text("Silahkan atur alarm", style: TextStyle(color: Colors.white24))),
      ),
    );
  }

  // ================= UI: ALARM MODE (UI KANAN) =================
  Widget _sleepingView() {
    return Stack(
      children: [
        Positioned(
          top: 40,
          left: 30,
          child: Text("Selamat tidur, $_userName", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_formatTime(_now), style: const TextStyle(fontSize: 68, color: Colors.white, fontWeight: FontWeight.w300)),
              Text("Waktu bangun - ${_hour.toString().padLeft(2, '0')}:${_minute.toString().padLeft(2, '0')}", style: const TextStyle(color: Colors.white54, fontSize: 14)),
            ],
          ),
        ),
        Positioned(
          bottom: 160,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 40,
            child: Stack(
              children: [
                CustomPaint(size: Size(MediaQuery.of(context).size.width, 40), painter: _WavePainter(opacity: 0.3, phase: 0)),
                CustomPaint(size: Size(MediaQuery.of(context).size.width, 40), painter: _WavePainter(opacity: 0.5, phase: 180)),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: GestureDetector(
            onVerticalDragUpdate: (details) async {
              if (details.primaryDelta! < -15) { // Geser ke atas
                await _stopAlarm();
                setState(() => _isSleeping = false);
                _showAlarmPicker(); // Munculkan pop-up lagi setelah bangun
              }
            },
            child: Column(
              children: const [
                Icon(Icons.keyboard_double_arrow_up, color: Colors.white38, size: 28),
                SizedBox(height: 5),
                Text("Geser ke atas untuk bangun", style: TextStyle(color: Colors.white38, fontSize: 13)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _timeColumn({required List<int> values, required int selected, required ValueChanged<int> onChanged}) {
    return SizedBox(
      height: 180,
      width: 75,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 60,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: (i) => onChanged(values[i]),
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: values.length,
          builder: (_, i) {
            final isSelected = values[i] == selected;
            return Center(
              child: Text(
                values[i].toString().padLeft(2, '0'),
                style: TextStyle(
                  fontSize: isSelected ? 34 : 28,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w300,
                  color: isSelected ? Colors.white : Colors.white24,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatTime(DateTime t) => "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";
}

class _WavePainter extends CustomPainter {
  final double opacity;
  final double phase;
  _WavePainter({required this.opacity, required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(opacity)..style = PaintingStyle.stroke..strokeWidth = 1.5;
    final path = Path()..moveTo(0, size.height / 2);
    for (double x = 0; x <= size.width; x++) {
      path.lineTo(x, size.height / 2 + 6 * Math.sin((x + phase) / 35));
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}