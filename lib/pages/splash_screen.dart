import 'package:flutter/material.dart';
import 'package:tf12c_0032_my_personal_expenses_app/pages/home_screen.dart';
import 'package:tf12c_0032_my_personal_expenses_app/pages/login_screen.dart';
import 'package:tf12c_0032_my_personal_expenses_app/services/authetication_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkAuthenticationStatus();
  }

  Future<void> checkAuthenticationStatus() async {
    final authenticationService = AthenticationService();

    final isLoggedIn = await authenticationService.isLoggedIn();

    if (context.mounted) {
      if (isLoggedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) {
              return const HomeScreen();
            },
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) {
              return const LoginScreen();
            },
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
