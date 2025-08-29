// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AiStore on _AiStore, Store {
  Computed<int>? _$providerIndexComputed;

  @override
  int get providerIndex => (_$providerIndexComputed ??= Computed<int>(
    () => super.providerIndex,
    name: '_AiStore.providerIndex',
  )).value;

  late final _$storageAtom = Atom(name: '_AiStore.storage', context: context);

  @override
  FlutterSecureStorage get storage {
    _$storageAtom.reportRead();
    return super.storage;
  }

  @override
  set storage(FlutterSecureStorage value) {
    _$storageAtom.reportWrite(value, super.storage, () {
      super.storage = value;
    });
  }

  late final _$initializedAtom = Atom(
    name: '_AiStore.initialized',
    context: context,
  );

  @override
  bool get initialized {
    _$initializedAtom.reportRead();
    return super.initialized;
  }

  @override
  set initialized(bool value) {
    _$initializedAtom.reportWrite(value, super.initialized, () {
      super.initialized = value;
    });
  }

  late final _$loadingAtom = Atom(name: '_AiStore.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$providerInUseAtom = Atom(
    name: '_AiStore.providerInUse',
    context: context,
  );

  @override
  AiProvider get providerInUse {
    _$providerInUseAtom.reportRead();
    return super.providerInUse;
  }

  bool _providerInUseIsInitialized = false;

  @override
  set providerInUse(AiProvider value) {
    _$providerInUseAtom.reportWrite(
      value,
      _providerInUseIsInitialized ? super.providerInUse : null,
      () {
        super.providerInUse = value;
        _providerInUseIsInitialized = true;
      },
    );
  }

  late final _$allProvidersAtom = Atom(
    name: '_AiStore.allProviders',
    context: context,
  );

  @override
  ObservableList<AiProvider> get allProviders {
    _$allProvidersAtom.reportRead();
    return super.allProviders;
  }

  @override
  set allProviders(ObservableList<AiProvider> value) {
    _$allProvidersAtom.reportWrite(value, super.allProviders, () {
      super.allProviders = value;
    });
  }

  late final _$obscureAtom = Atom(name: '_AiStore.obscure', context: context);

  @override
  bool get obscure {
    _$obscureAtom.reportRead();
    return super.obscure;
  }

  @override
  set obscure(bool value) {
    _$obscureAtom.reportWrite(value, super.obscure, () {
      super.obscure = value;
    });
  }

  late final _$apiKeysControllersAtom = Atom(
    name: '_AiStore.apiKeysControllers',
    context: context,
  );

  @override
  Map<int, TextEditingController> get apiKeysControllers {
    _$apiKeysControllersAtom.reportRead();
    return super.apiKeysControllers;
  }

  @override
  set apiKeysControllers(Map<int, TextEditingController> value) {
    _$apiKeysControllersAtom.reportWrite(value, super.apiKeysControllers, () {
      super.apiKeysControllers = value;
    });
  }

  late final _$apiUrlsControllersAtom = Atom(
    name: '_AiStore.apiUrlsControllers',
    context: context,
  );

  @override
  Map<int, TextEditingController> get apiUrlsControllers {
    _$apiUrlsControllersAtom.reportRead();
    return super.apiUrlsControllers;
  }

  @override
  set apiUrlsControllers(Map<int, TextEditingController> value) {
    _$apiUrlsControllersAtom.reportWrite(value, super.apiUrlsControllers, () {
      super.apiUrlsControllers = value;
    });
  }

  late final _$selectedModelsAtom = Atom(
    name: '_AiStore.selectedModels',
    context: context,
  );

  @override
  Map<int, String?> get selectedModels {
    _$selectedModelsAtom.reportRead();
    return super.selectedModels;
  }

  @override
  set selectedModels(Map<int, String?> value) {
    _$selectedModelsAtom.reportWrite(value, super.selectedModels, () {
      super.selectedModels = value;
    });
  }

  late final _$handleProviderOnTapAsyncAction = AsyncAction(
    '_AiStore.handleProviderOnTap',
    context: context,
  );

  @override
  Future<void> handleProviderOnTap(AiProvider provider) {
    return _$handleProviderOnTapAsyncAction.run(
      () => super.handleProviderOnTap(provider),
    );
  }

  late final _$refreshProvidersAsyncAction = AsyncAction(
    '_AiStore.refreshProviders',
    context: context,
  );

  @override
  Future<void> refreshProviders() {
    return _$refreshProvidersAsyncAction.run(() => super.refreshProviders());
  }

  late final _$handleProviderApiKeyUpdateAsyncAction = AsyncAction(
    '_AiStore.handleProviderApiKeyUpdate',
    context: context,
  );

  @override
  Future<void> handleProviderApiKeyUpdate(
    AiProvider provider,
    String apiKey, {
    bool saveToDB = true,
  }) {
    return _$handleProviderApiKeyUpdateAsyncAction.run(
      () => super.handleProviderApiKeyUpdate(
        provider,
        apiKey,
        saveToDB: saveToDB,
      ),
    );
  }

  late final _$handleProviderBaseUrlUpdateAsyncAction = AsyncAction(
    '_AiStore.handleProviderBaseUrlUpdate',
    context: context,
  );

  @override
  Future<void> handleProviderBaseUrlUpdate(
    AiProvider provider,
    String baseUrl, {
    bool saveToDB = true,
  }) {
    return _$handleProviderBaseUrlUpdateAsyncAction.run(
      () => super.handleProviderBaseUrlUpdate(
        provider,
        baseUrl,
        saveToDB: saveToDB,
      ),
    );
  }

  late final _$handleProviderTemperatureUpdateAsyncAction = AsyncAction(
    '_AiStore.handleProviderTemperatureUpdate',
    context: context,
  );

  @override
  Future<void> handleProviderTemperatureUpdate(
    AiProvider provider,
    double newTemp, {
    bool saveToDB = true,
  }) {
    return _$handleProviderTemperatureUpdateAsyncAction.run(
      () => super.handleProviderTemperatureUpdate(
        provider,
        newTemp,
        saveToDB: saveToDB,
      ),
    );
  }

  late final _$handleProviderUseSameModelUpdateAsyncAction = AsyncAction(
    '_AiStore.handleProviderUseSameModelUpdate',
    context: context,
  );

  @override
  Future<void> handleProviderUseSameModelUpdate(
    AiProvider provider,
    bool value, {
    bool saveToDB = true,
  }) {
    return _$handleProviderUseSameModelUpdateAsyncAction.run(
      () => super.handleProviderUseSameModelUpdate(
        provider,
        value,
        saveToDB: saveToDB,
      ),
    );
  }

  late final _$handleProviderModelUpdateAsyncAction = AsyncAction(
    '_AiStore.handleProviderModelUpdate',
    context: context,
  );

  @override
  Future<void> handleProviderModelUpdate(
    AiProvider provider,
    int modelToUse, {
    bool saveToDB = true,
    bool isSuggestion = false,
  }) {
    return _$handleProviderModelUpdateAsyncAction.run(
      () => super.handleProviderModelUpdate(
        provider,
        modelToUse,
        saveToDB: saveToDB,
        isSuggestion: isSuggestion,
      ),
    );
  }

  late final _$handleProviderUpdateAsyncAction = AsyncAction(
    '_AiStore.handleProviderUpdate',
    context: context,
  );

  @override
  Future<void> handleProviderUpdate(
    AiProvider provider,
    String apiKey,
    String baseUrl,
  ) {
    return _$handleProviderUpdateAsyncAction.run(
      () => super.handleProviderUpdate(provider, apiKey, baseUrl),
    );
  }

  late final _$testProviderToUseAsyncAction = AsyncAction(
    '_AiStore.testProviderToUse',
    context: context,
  );

  @override
  Future<void> testProviderToUse(BuildContext context) {
    return _$testProviderToUseAsyncAction.run(
      () => super.testProviderToUse(context),
    );
  }

  @override
  String toString() {
    return '''
storage: ${storage},
initialized: ${initialized},
loading: ${loading},
providerInUse: ${providerInUse},
allProviders: ${allProviders},
obscure: ${obscure},
apiKeysControllers: ${apiKeysControllers},
apiUrlsControllers: ${apiUrlsControllers},
selectedModels: ${selectedModels},
providerIndex: ${providerIndex}
    ''';
  }
}
