import 'package:bytesized_news/views/settings/settings_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return const Text("Error loading package info");
        }
        return SettingsSection(
          title: "About",
          children: [
            ListTile(
              leading: const Icon(LucideIcons.sparkles),
              title: const Text("Bytesized News"),
              subtitle: Text("Version: ${snapshot.data?.version}\nBuild: ${snapshot.data?.buildNumber}"),
              trailing: const Text('View Licences'),
              onTap: () {
                showLicensePage(context: context);
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.github),
              title: const Text("Source Code"),
              subtitle: const Wrap(
                children: [
                  Text("You can find the source code of this app and the backend at "),
                  Text("github.com/zeykafx/bytesized_news", style: TextStyle(color: Colors.blue)),
                ],
              ),
              onTap: () {
                // open the paypal link
                launchUrlString("https://github.com/zeykafx/bytesized_news");
              },
              trailing: const Icon(Icons.open_in_new),
            ),
            ListTile(
              leading: const Icon(Icons.laptop),
              title: const Text("Made by Corentin Detry"),
              subtitle: const Wrap(
                children: [
                  Text("If you like this app, you can support me at "),
                  Text("paypal.me/zeykafx", style: TextStyle(color: Colors.blue)),
                ],
              ),
              onTap: () {
                // open the paypal link
                launchUrlString("https://paypal.me/zeykafx");
              },
              trailing: const Icon(Icons.open_in_new),
            ),
          ],
        );
      },
    );
  }
}
