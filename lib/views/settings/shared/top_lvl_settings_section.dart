import 'package:flutter/material.dart';

class TopLvlSettingsSection extends StatelessWidget {
  const TopLvlSettingsSection({super.key, required this.title, required this.settingsPage, required this.subtitle, required this.iconData});

  final String title;
  final String subtitle;
  final IconData iconData;
  final Widget settingsPage;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.normal,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium,
        overflow: TextOverflow.ellipsis,
      ),
      leading: Icon(iconData, color: Theme.of(context).colorScheme.primary, size: 24),

      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => settingsPage,
          ),
        );
      },
    );
  }
}
