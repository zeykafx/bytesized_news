import 'package:bytesized_news/views/auth/auth.dart';
import 'package:bytesized_news/views/feed_view/feed_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EmailVerify extends StatefulWidget {
  const EmailVerify({super.key});

  @override
  State<EmailVerify> createState() => _EmailVerifyState();
}

class _EmailVerifyState extends State<EmailVerify> {
  // check every 5 second if the user has verified their email
  Future<void> checkEmailVerified() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      if (user.emailVerified) {
        if (kDebugMode) {
          print("Email verified");
        }
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const FeedView(),
          ),
          (route) => false, // remove all routes
        );
      } else {
        if (kDebugMode) {
          print("Sleeping for 2 seconds");
        }
        await Future<void>.delayed(const Duration(seconds: 3));
        await checkEmailVerified();
      }
    } else {
      if (kDebugMode) {
        print("User is null, sleeping for 10 seconds");
      }
      await Future<void>.delayed(const Duration(seconds: 10));
    }
  }

  @override
  void initState() {
    super.initState();
    checkEmailVerified();
  }

  @override
  Widget build(BuildContext context) {
    return EmailVerificationScreen(
      auth: FirebaseAuth.instance,
      actions: [
        EmailVerifiedAction(() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const FeedView(),
            ),
          );
        }),
        AuthCancelledAction((context) {
          FirebaseUIAuth.signOut(context: context);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const Auth(),
            ),
            (route) => false, // remove all routes
          );
        }),
      ],
    );
  }
}
