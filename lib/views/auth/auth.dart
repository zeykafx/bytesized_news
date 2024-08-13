import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/auth/sub_views/email_verify.dart';
import 'package:bytesized_news/views/auth/sub_views/profile.dart';
import 'package:firebase_auth/firebase_auth.dart' hide GoogleAuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final AuthStore authStore = AuthStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Authentication"),
      ),
      body: Observer(builder: (_) {
        return SignInScreen(
          showPasswordVisibilityToggle: true,
          actions: [
            AuthStateChangeAction<UserCreated>((context, state) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Account created, please verify your email"),
                ),
              );
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const EmailVerify(),
                ),
              );
            }),
            AuthStateChangeAction<SigningUp>((context, SigningUp state) {
              print("Signing up");
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(
              //     content: Text("Signing up..."),
              //   ),
              // );
            }),
            AuthStateChangeAction<SignedIn>((context, state) {
              if (!state.user!.emailVerified) {
                // Navigator.pushNamed(context, '/verify-email');
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const EmailVerify(),
                  ),
                );
              } else {
                // Navigator.pushReplacementNamed(context, '/profile');
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Profile(),
                  ),
                );
              }
            }),
          ],
        );
      }),
    );
  }
}
