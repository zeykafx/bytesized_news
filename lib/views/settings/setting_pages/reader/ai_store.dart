import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/models/ai_provider/ai_provider.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:isar_community/isar.dart';
import 'package:mobx/mobx.dart';
import 'package:llm_dart/llm_dart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'ai_store.g.dart';

class AiStore = _AiStore with _$AiStore;

abstract class _AiStore with Store {
  late SettingsStore settingsStore;
  late DbUtils dbUtils;

  @observable
  FlutterSecureStorage storage = FlutterSecureStorage();

  @observable
  bool initialized = false;

  @observable
  bool loading = false;

  @observable
  late AiProvider providerInUse;

  @computed
  int get providerIndex => allProviders.indexOf(providerInUse);

  @computed
  bool get providerUseSameModelForSuggestions => providerInUse.useSameModelForSuggestions;

  @observable
  ObservableList<AiProvider> allProviders = <AiProvider>[].asObservable();

  @observable
  bool obscure = true;

  @observable
  Map<int, TextEditingController> apiKeysControllers = {};

  @observable
  Map<int, TextEditingController> apiUrlsControllers = {};

  @observable
  bool showCustomModelField = false;

  @observable
  late TextEditingController customModelController;

  @observable
  bool showCustomSuggestionModelField = false;

  @observable
  ExpansibleController expansibleController = ExpansibleController();

  @observable
  late TextEditingController customSuggestionModelController;

  @computed
  int get modelsLength => providerInUse.models.length;

  @computed
  ObservableList get models => providerInUse.models.asObservable();

  Future<void> init(SettingsStore settingsStore) async {
    this.settingsStore = settingsStore;
    dbUtils = DbUtils(isar: Isar.getInstance()!);

    providerInUse = await dbUtils.getActiveAiProvider() ?? allProviders.first;
    if (providerInUse.useSameModelForSuggestions) {
      expansibleController.collapse();
    } else {
      expansibleController.expand();
    }
    allProviders = (await dbUtils.getAiProviders()).asObservable();

    for (int i = 0; i < allProviders.length; i++) {
      apiKeysControllers[i] = TextEditingController(text: allProviders[i].apiKey);
      apiUrlsControllers[i] = TextEditingController(text: allProviders[i].apiLink);
      // selectedModels[i] = allProviders[i].models[allProviders[i].modelToUseIndex];
      // if (!allProviders[i].useSameModelForSuggestions) {
      //   selectedSuggestionModels[i] = allProviders[i].models[allProviders[i].modelToUseIndexForSuggestions];
      // }
    }
    customModelController = TextEditingController();
    customSuggestionModelController = TextEditingController();

    initialized = true;
  }

  @action
  Future<void> handleProviderOnTap(AiProvider provider) async {
    providerInUse = await dbUtils.setActiveAiProvider(provider, allProviders);
    if (providerInUse.useSameModelForSuggestions) {
      expansibleController.collapse();
    } else {
      expansibleController.expand();
    }
    await refreshProviders();
  }

  @action
  Future<void> refreshProviders() async {
    allProviders = allProviders;
  }

  @action
  Future<void> handleProviderApiKeyUpdate(AiProvider provider, String apiKey, {bool saveToDB = true}) async {
    provider.apiKey = apiKey;
    if (saveToDB) {
      await dbUtils.updateAiProvider(provider);
    }
    providerInUse = provider;
    allProviders[providerIndex] = provider;
  }

  @action
  Future<void> handleProviderBaseUrlUpdate(AiProvider provider, String baseUrl, {bool saveToDB = true}) async {
    provider.apiLink = baseUrl;
    if (saveToDB) {
      await dbUtils.updateAiProvider(provider);
    }
    providerInUse = provider;
    allProviders[providerIndex] = provider;
  }

  @action
  Future<void> handleProviderTemperatureUpdate(AiProvider provider, double newTemp, {bool saveToDB = true}) async {
    provider.temperature = newTemp;
    if (saveToDB) {
      await dbUtils.updateAiProvider(provider);
    }
    providerInUse = provider;
    allProviders[providerIndex] = provider;
  }

  @action
  Future<void> handleProviderUseSameModelUpdate(AiProvider provider, bool value, {bool saveToDB = true}) async {
    provider.useSameModelForSuggestions = value;

    if (saveToDB) {
      await dbUtils.updateAiProvider(provider);
    }
    providerInUse = provider;
    allProviders[providerIndex] = provider;
  }

  @action
  Future<void> handleProviderModelUpdate(AiProvider provider, int modelToUse, {bool saveToDB = true, bool isSuggestion = false}) async {
    if (!isSuggestion) {
      provider.modelToUseIndex = modelToUse;
    } else {
      provider.modelToUseIndexForSuggestions = modelToUse;
    }

    if (saveToDB) {
      await dbUtils.updateAiProvider(provider);
    }
    providerInUse = provider;
    allProviders[providerIndex] = provider;
  }

  @action
  Future<void> handleProviderUpdate(AiProvider provider, String apiKey, String baseUrl) async {
    loading = true;
    provider.apiKey = apiKey;
    provider.apiLink = baseUrl;

    await dbUtils.updateAiProvider(provider);
    providerInUse = provider;
    allProviders[providerIndex] = provider;
    loading = false;
  }

  @action
  Future<void> addModel(String model) async {
    if (model.isEmpty || providerInUse.models.contains(model)) return;

    providerInUse.models = [...providerInUse.models, model];

    await dbUtils.updateAiProvider(providerInUse);

    allProviders[providerIndex] = providerInUse;
    await refreshProviders();
  }

  @action
  Future<void> deleteModel(String model) async {
    if (providerInUse.models.length <= 1) return;
    List<String> models = List.from(providerInUse.models);
    models.remove(model);
    providerInUse.models = models.toList();

    if (providerInUse.modelToUseIndex >= providerInUse.models.length) {
      providerInUse.modelToUseIndex = providerInUse.models.length - 1;
    }
    if (providerInUse.modelToUseIndexForSuggestions >= providerInUse.models.length) {
      providerInUse.modelToUseIndexForSuggestions = providerInUse.models.length - 1;
    }
    await dbUtils.updateAiProvider(providerInUse);

    allProviders[providerIndex] = providerInUse;
    await refreshProviders();
  }

  @action
  Future<void> testProviderToUse(BuildContext context) async {
    AiProvider aiProvider = providerInUse;
    if (aiProvider.apiKey.isEmpty && aiProvider.needsApiKey) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please provide an API key")));
      return;
    }
    loading = true;

    try {
      ChatCapability prov;
      if (aiProvider.devName == "openrouter") {
        prov = await ai()
            .openRouter()
            .baseUrl(aiProvider.apiLink)
            .apiKey(aiProvider.apiKey)
            .model(aiProvider.models[aiProvider.modelToUseIndex])
            .temperature(aiProvider.temperature)
            .reasoning(false)
            .maxTokens(200)
            .build();
      } else {
        prov = await createProvider(
          providerId: aiProvider.devName,
          apiKey: aiProvider.apiKey,
          model: aiProvider.models[aiProvider.modelToUseIndex],
          baseUrl: aiProvider.apiLink,
          temperature: aiProvider.temperature,
          extensions: {"reasoning": false},
        );
      }
      final messages = [ChatMessage.user('Hello, world!, respond in one sentence')];
      final response = await prov.chat(messages);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Reponse: ${response.text}"),
          behavior: SnackBarBehavior.floating,
          duration: 10.seconds,
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }

    loading = false;
  }
}
