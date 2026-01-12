import 'package:flutter/material.dart';
import 'screens/Splash_Screen.dart';
import 'screens/Welcome_Screen.dart';
import 'screens/Login_Screen.dart';
import 'screens/Register_Screen.dart';
import 'screens/Home_Screen.dart';
import 'screens/user_info_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SleepyPandaApp(startRoute: '',));
}

class SleepyPandaApp extends StatelessWidget {
  const SleepyPandaApp({super.key, required String startRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleepy Panda',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1E2230),
        fontFamily: 'Roboto',
      ),

      // 🚨 SELALU START DARI SPLASH
      initialRoute: '/splash',

      routes: {
        '/splash': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/userinfo': (context) => const UserInfoScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
