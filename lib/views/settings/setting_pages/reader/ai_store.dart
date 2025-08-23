import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'ai_store.g.dart';

class AiStore = _AiStore with _$AiStore;

abstract class _AiStore with Store {
  late SettingsStore settingsStore;

  @observable
  FlutterSecureStorage storage = FlutterSecureStorage();
  @observable
  String apiKey = "";

  @observable
  bool hasApiKey = false;

  Future<void> init(SettingsStore settingsStore) async {
    this.settingsStore = settingsStore;

    hasApiKey = (await storage.read(key: "hasApiKey") ?? "false") == "true" ? true : false;
    apiKey = await storage.read(key: "apiKey") ?? "";
  }

  Future<void> setApiKey(String apiKey) async {
    this.apiKey = apiKey;
    hasApiKey = true;
    await storage.write(key: "hasApiKey", value: "true");
    await storage.write(key: "apiKey", value: apiKey);
  }
}
