import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:myapp/views/settings/settings.dart';
import 'package:myapp/views/settings/settings_store.dart';
import 'package:provider/provider.dart';
import 'package:rss_dart/domain/atom_feed.dart';
import 'package:rss_dart/domain/rss1_feed.dart';
import 'package:rss_dart/domain/rss_feed.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late SettingsStore settingsStore;

  @override
  void initState() {
    super.initState();
    parseRss();
    settingsStore = context.read<SettingsStore>();
  }

  Future<void> parseRss() async {
    String url = "https://www.theverge.com/rss/frontpage";
    Dio dio = Dio();
    Response res = await dio.get(url);
    AtomFeed channel = AtomFeed.parse(res.data);
    // print(channel.items[0].title);
    // print(channel.items[0].content);
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
      body: Center(
        child: ElevatedButton(
          child: Text("change"),
          onPressed: () {
            settingsStore.setDarkMode(DarkMode.system);
          },
        ),
      ),
    );
  }
}
