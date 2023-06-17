import 'package:flutter/material.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:tf12c_0032_my_personal_expenses_app/pages/home_screen.dart';
import 'package:tf12c_0032_my_personal_expenses_app/services/authetication_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: SocialLoginButton(
            buttonType: SocialLoginButtonType.google,
            onPressed: () async {
              try {
                final authenticationService = AthenticationService();
                final user = await authenticationService.signInWithGoogle();

                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) {
                        return const HomeScreen();
                      },
                    ),
                  );
                }
              } catch (e) {
                print(e);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error al autenticar'),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
