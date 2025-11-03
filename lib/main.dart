import 'package:flutter/material.dart';
import 'package:testt/Services/auth_service.dart';
import 'package:testt/screens/user_info_screen.dart';
import 'screens/Splash_Screen.dart';
import 'screens/Welcome_Screen.dart';
import 'screens/Login_Screen.dart';
import 'screens/Register_Screen.dart';
import 'screens/Forgot_Password_Screen.dart';
import 'screens/Home_Screen.dart';

void main() {
  runApp(const SleepyPandaApp());
}

class SleepyPandaApp extends StatelessWidget {
  const SleepyPandaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleepy Panda',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1E2230),
        fontFamily: 'Roboto',
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/userinfo': (context) => const UserInfoScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }

  void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final auth = AuthService();
  final loggedIn = await auth.isLoggedIn();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: loggedIn ? '/home' : '/',
    routes: {
      '/': (context) => SplashScreen(),
      '/login': (context) => LoginScreen(),
      '/register': (context) => RegisterScreen(),
      '/home': (context) => HomeScreen(),
    },
  ));
}

}
