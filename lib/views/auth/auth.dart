import 'package:bytesized_news/views/feed_view/feed_view.dart';
import 'package:flutter/material.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    // No Firebase auth in BYOK mode - redirect directly to the feed view
    return const FeedView();
  }
}
