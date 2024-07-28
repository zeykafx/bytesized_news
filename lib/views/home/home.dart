import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:bytesized_news/views/home/home_store.dart';
import 'package:bytesized_news/views/settings/settings.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:provider/provider.dart';
import 'package:rss_dart/domain/atom_feed.dart';
import 'package:rss_dart/domain/rss1_feed.dart';
import 'package:rss_dart/domain/rss_feed.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late SettingsStore settingsStore;
  final HomeStore homeStore = HomeStore();

  @override
  void initState() {
    super.initState();
    settingsStore = context.read<SettingsStore>();
    init();
  }

  Future<void> init() async {
    await homeStore.init();
    await homeStore.getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Settings(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.2),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Observer(builder: (context) {
                return Skeletonizer(
                  enabled: homeStore.loading,
                  child: ListView(
                    children: [
                      if (homeStore.loading) ...[
                        const Center(child: LinearProgressIndicator()),
                      ],
                      if (homeStore.feedItems.isEmpty && !homeStore.loading) ...[
                        const Center(child: Text("No feedItems loaded")),
                      ],
                      ...homeStore.feedItems.map(
                        (item) => Card(
                          elevation: 0,
                          color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.4),
                          child: SelectableRegion(
                            focusNode: FocusNode(),
                            selectionControls: MaterialTextSelectionControls(),
                            child: ListTile(
                              title: Text("${item.title} - ${item.feed.value?.name}"),
                              subtitle: Text(item.description.split("\n").first),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
