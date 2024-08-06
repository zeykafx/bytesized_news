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
                              // some trickery to get the index of each element as well as the item
                              // this is used to animate each card fading in with a delay.
                              ...homeStore.feedItems
                                  .asMap()
                                  .map(
                                    (idx, item) => MapEntry(
                                      idx,
                                      Card(
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                                        elevation: 0,
                                        color: !item.bookmarked
                                            ? Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.4)
                                            : Theme.of(context).colorScheme.secondaryContainer,
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
                                            textColor: item.read ? Theme.of(context).dividerColor : Theme.of(context).textTheme.bodyMedium?.color,
                                            onTap: () {
                                              homeStore.toggleItemRead(idx);
                                              // force update the state to change the list tile's color to gray
                                              setState(() {});
                                              Navigator.of(context)
                                                  .push(
                                                MaterialPageRoute(
                                                  builder: (context) => Story(
                                                    feedItem: item,
                                                  ),
                                                ),
                                              )
                                                  .then((_) {
                                                // update the state of the list items after the story view is popped
                                                // this is done because if the item was bookmarked while in the story view, we want to show that in the list
                                                setState(() {});
                                              });
                                            },
                                            dense: true,
                                            trailing: PopupMenuButton(
                                              elevation: 20,
                                              icon: const Icon(Icons.more_vert),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                side: BorderSide(color: Theme.of(context).colorScheme.secondaryContainer, width: 0.3),
                                              ),
                                              onSelected: (int index) {
                                                switch (index) {
                                                  case 0:
                                                    {
                                                      homeStore.toggleItemRead(idx, toggle: true);
                                                      // have to use setState because mobx doesn't detect changes in complex objects (at least the way I set things up)
                                                      setState(() {});
                                                      break;
                                                    }
                                                  case 1:
                                                    {
                                                      homeStore.toggleItemBookmarked(idx, toggle: true);
                                                      setState(() {});
                                                      break;
                                                    }
                                                }
                                              },
                                              itemBuilder: (BuildContext context) {
                                                return [
                                                  // MARK AS READ/UNREAD
                                                  PopupMenuItem(
                                                    value: 0,
                                                    child: Wrap(
                                                      children: [
                                                        const Padding(
                                                          padding: EdgeInsets.only(left: 10),
                                                          child: Icon(
                                                            Icons.check,
                                                            size: 19,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 20),
                                                          child: Text(item.read ? "Mark as Unread" : "Mark as Read"),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // BOOKMARK
                                                  PopupMenuItem(
                                                    value: 1,
                                                    child: Wrap(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 10),
                                                          child: Icon(
                                                            item.bookmarked ? Icons.bookmark_added : Icons.bookmark_add,
                                                            size: 19,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 20),
                                                          child: Text(item.bookmarked ? "Remove from bookmarks" : "Add to bookmarks"),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ];
                                              },
                                            ),
                                          ),
                                        ),
                                      ).animate(delay: Duration(milliseconds: idx * 100)).fadeIn(),
                                    ),
                                  )
                                  .values,
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
