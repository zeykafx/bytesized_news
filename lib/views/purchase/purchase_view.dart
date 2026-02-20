import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/settings/settings_store.dart' as setting;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PurchaseView extends StatefulWidget {
  const PurchaseView({super.key});

  @override
  State<PurchaseView> createState() => _PurchaseViewState();
}

class _PurchaseViewState extends State<PurchaseView> {
  late AuthStore authStore;
  late setting.SettingsStore settingsStore;

  @override
  void initState() {
    authStore = context.read<AuthStore>();
    settingsStore = context.read<setting.SettingsStore>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upgrade to Premium")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline, size: 60, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                "In-App Purchases Unavailable",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                "This version of Bytesized News uses your own AI provider keys (BYOK). All AI features are available directly through your own API keys — no premium subscription needed.",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Go Back"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
