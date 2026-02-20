import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/feed_view/feed_view.dart';
import 'package:flutter/material.dart';

class EmailVerify extends StatelessWidget {
  final AuthStore authStore;
  const EmailVerify({super.key, required this.authStore});

  @override
  Widget build(BuildContext context) {
    // No email verification in BYOK mode - redirect directly to feed view
    return const FeedView();
  }
}
