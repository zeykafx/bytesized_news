import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.title, required this.sections, required this.isMainView});
  final String title;
  final bool isMainView;
  final List<Widget> sections;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SettingsStore settingsStore;

  @override
  void initState() {
    super.initState();
    settingsStore = context.read<SettingsStore>();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: settingsStore.maxWidth),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 110.0,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(widget.title),
                    centerTitle: false,
                    titlePadding: EdgeInsets.only(
                      left: 55,
                      bottom: 14,
                    ),
                    expandedTitleScale: widget.isMainView ? 1.5 : 1.1,
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate.fixed(
                    <Widget>[
                      ListView(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: widget.sections,
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
