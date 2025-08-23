import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/auth/sub_views/email_verify.dart';
import 'package:bytesized_news/views/feed_view/feed_view.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  late AuthStore authStore;

  @override
  void initState() {
    super.initState();
    authStore = context.read<AuthStore>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Authentication"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          if (authStore.authLoading) ...[
            AnimatedOpacity(
              opacity: authStore.authLoading ? 1 : 0,
              duration: 300.ms,
              child: LinearProgressIndicator(),
            ),
          ],
          Expanded(
            child: SignInScreen(
              showPasswordVisibilityToggle: true,
              showAuthActionSwitch: true,
              providers: [
                EmailAuthProvider(),
                GoogleProvider(clientId: "286405169123-14tsnaatjeclvf6i5k9m7nsitm8qq6h1.apps.googleusercontent.com", iOSPreferPlist: true),
              ],
              actions: [
                AuthStateChangeAction<UserCreated>((context, state) async {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Account created, please verify your email"),
                    ),
                  );
            
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EmailVerify(authStore: authStore),
                    ),
                  );
                }),
                AuthStateChangeAction<SigningUp>((context, SigningUp state) async {
                  if (kDebugMode) {
                    print("Signing up");
                  }
                }),
                AuthStateChangeAction<SignedIn>((context, state) async {
                  authStore.user = authStore.auth.currentUser;
                  bool res = await authStore.init(context);
            
                  if (!res) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Auth(),
                      ),
                    );
                    return;
                  }
            
                  if (!state.user!.emailVerified) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EmailVerify(authStore: authStore),
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const FeedView(),
                      ),
                    );
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
