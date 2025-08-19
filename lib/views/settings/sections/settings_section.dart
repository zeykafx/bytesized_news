import 'package:flutter/material.dart';

// code from https://github.com/ReVanced/revanced-manager/blob/main/lib/ui/widgets/settingsView/settings_section.dart#L3
class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      // color: Theme.of(context).colorScheme.surfaceContainerLow.withValues(alpha: 0.7),
      color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.2),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0, left: 20.0),
            child: Text(title, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
        ],
      ),
    );
  }
}
