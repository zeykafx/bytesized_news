import 'package:bytesized_news/views/story/story.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:bytesized_news/views/home/home_store.dart';
import 'package:bytesized_news/views/settings/settings.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:time_formatter/time_formatter.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
      body: Observer(builder: (context) {
        return RefreshIndicator(
          onRefresh: () async {
            homeStore.fetchItems();
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 0,
              color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.2),
              child: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text('Articles: ${homeStore.feedItems.length} loaded'),
                      Skeletonizer(
                        enabled: homeStore.loading,
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (homeStore.loading) ...[
                                const Center(child: LinearProgressIndicator()),
                              ],
                              if (homeStore.feedItems.isEmpty && !homeStore.loading) ...[
                                const Center(child: Text("No feedItems loaded")),
                              ],
                              ...homeStore.feedItems.map(
                                (item) => Card(
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                                  elevation: 0,
                                  color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.4),
                                  child: SelectableRegion(
                                    focusNode: FocusNode(),
                                    selectionControls: MaterialTextSelectionControls(),
                                    child: ListTile(
                                      title: Text("${item.title} - ${item.feed?.name}"),
                                      subtitle: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(item.description.split("\n").first),
                                          Text(
                                            formatTime(item.publishedDate.millisecondsSinceEpoch),
                                            style: TextStyle(color: Theme.of(context).dividerColor),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => Story(
                                              feedItem: item,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ).animate(delay: Duration(milliseconds: item.id * 100)).fadeIn(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
