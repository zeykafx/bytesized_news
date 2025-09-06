import 'package:bytesized_news/models/ai_provider/ai_provider.dart';
import 'package:bytesized_news/views/settings/setting_pages/reader/ai_store.dart';
import 'package:bytesized_news/views/settings/setting_pages/reader/widgets/provider_card.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

class CustomProviderSettings extends StatefulWidget {
  const CustomProviderSettings({
    super.key,
  });

  @override
  State<CustomProviderSettings> createState() => _CustomProviderSettingsState();
}

class _CustomProviderSettingsState extends State<CustomProviderSettings> {
  final double cardHeight = 120;
  final double cardWidth = 210;

  late final SettingsStore settingsStore;
  late final AiStore store;

  late PageController carouselController;
  late CarouselController carousel;

  late ReactionDisposer reactionDisposer;
  @override
  void initState() {
    super.initState();
    carouselController = PageController();
    carousel = CarouselController();

    settingsStore = context.read<SettingsStore>();

    store = AiStore();

    store.init(settingsStore).then((_) async {
      await Future.delayed(Duration(milliseconds: 500));
      carousel.animateToItem(store.providerIndex);
    });

    reactionDisposer = autorun((_) {
      carousel.animateToItem(store.providerIndex);
    });
  }

  @override
  void dispose() {
    reactionDisposer();
    carouselController.dispose();
    carousel.dispose();
    for (TextEditingController controller in store.apiKeysControllers.values) {
      controller.dispose();
    }
    for (TextEditingController controller in store.apiUrlsControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        if (store.initialized == false) {
          return LinearProgressIndicator(
            year2023: false,
          ).animate().fade(duration: 300.ms);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Stack(
            children: [
              if (store.loading) ...[
                LinearProgressIndicator(
                  year2023: false,
                ).animate().fade(duration: 300.ms),
              ],

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),

                  Text(
                    "Select AI Provider",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  SizedBox(
                    height: cardHeight,
                    child: CarouselView.weighted(
                      // itemExtent: cardWidth,
                      flexWeights: [1, 2, 1],
                      scrollDirection: Axis.horizontal,
                      itemSnapping: true,
                      enableSplash: false,
                      controller: carousel,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                      children: [
                        for (AiProvider provider in store.allProviders) ...[
                          ProviderCard(
                            cardHeight: cardHeight,
                            cardWidth: cardWidth,
                            provider: provider,
                            colorScheme: colorScheme,
                            store: store,
                            carousel: carousel,
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  Card.filled(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Configure ${store.providerInUse.name}",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),

                          if (store.providerInUse.needsApiKey)
                            TextFormField(
                              controller: store.apiKeysControllers[store.providerIndex],
                              decoration: InputDecoration(
                                labelText: "API Key",
                                hintText: "Enter your ${store.allProviders[store.providerIndex].name} API key",
                                prefixIcon: const Icon(Icons.key_outlined),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.visibility_outlined),
                                  onPressed: () {
                                    store.obscure = !store.obscure;
                                  },
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.0),
                                  ),
                                ),
                              ),
                              obscureText: store.obscure,
                            ),

                          const SizedBox(height: 16),

                          TextFormField(
                            controller: store.apiUrlsControllers[store.providerIndex],
                            decoration: InputDecoration(
                              labelText: "API Base URL",
                              hintText: "Custom API endpoint (optional)",
                              prefixIcon: const Icon(Icons.link_outlined),
                              helperText: store.allProviders[store.providerIndex].openAiCompatible ? "OpenAI compatible endpoint" : "Custom API endpoint",
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  initialValue: store.providerInUse.models[store.providerInUse.modelToUseIndex],
                                  decoration: InputDecoration(
                                    labelText: "Model",
                                    prefixIcon: const Icon(Icons.psychology_outlined),
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12.0),
                                      ),
                                    ),
                                  ),
                                  isExpanded: true,
                                  items: store.providerInUse.models.map((model) {
                                    return DropdownMenuItem<String>(
                                      value: model,
                                      child: Text(
                                        model,
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    store.handleProviderModelUpdate(store.providerInUse, store.providerInUse.models.indexOf(value!));
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(icon: const Icon(Icons.edit_note_outlined), onPressed: () => showManageModelsDialog(context, store)),
                            ],
                          ),

                          // const SizedBox(height: 16),
                          ExpansionTile(
                            enableFeedback: true,
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: const EdgeInsets.only(top: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            initiallyExpanded: !store.providerUseSameModelForSuggestions,
                            showTrailingIcon: false,
                            title: SwitchListTile(
                              contentPadding: const EdgeInsets.all(2),
                              title: const Text("Use other model for suggestion"),
                              subtitle: Text("Enable to choose another model for suggestions", style: Theme.of(context).textTheme.bodySmall),
                              value: !store.providerInUse.useSameModelForSuggestions,
                              onChanged: (value) async {
                                await store.handleProviderUseSameModelUpdate(store.providerInUse, !value);

                                if (value) {
                                  store.expansibleController.expand();
                                } else {
                                  store.expansibleController.collapse();
                                }
                                setState(() {}); // hack
                              },
                            ),
                            controller: store.expansibleController,
                            children: [
                              DropdownButtonFormField<String>(
                                initialValue: store.providerInUse.models[store.providerInUse.modelToUseIndexForSuggestions],

                                decoration: InputDecoration(
                                  labelText: "Suggestions model",
                                  prefixIcon: const Icon(Icons.psychology_outlined),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12.0),
                                    ),
                                  ),
                                ),
                                isExpanded: true,
                                items: store.providerInUse.models.map((model) {
                                  return DropdownMenuItem<String>(
                                    value: model,
                                    child: Text(
                                      model,
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) async {
                                  await store.handleProviderModelUpdate(store.providerInUse, store.providerInUse.models.indexOf(value!), isSuggestion: true);
                                },
                              ),
                            ],
                          ),

                          ListTile(
                            title: Text("Temperature${!store.providerInUse.useSameModelForSuggestions ? " for both models" : ""}"),
                            subtitle: SizedBox(
                              width: 150,
                              child: Row(
                                children: [
                                  SizedBox(width: 35, child: Text(store.providerInUse.temperature.toStringAsFixed(1))),
                                  Expanded(
                                    child: Slider(
                                      year2023: false,
                                      label: store.providerInUse.temperature.toStringAsFixed(2),
                                      value: store.providerInUse.temperature,
                                      min: 0.0,
                                      max: 1.0,
                                      divisions: 10,
                                      onChanged: (newVal) {
                                        // store.providerInUse.temperature = newVal;
                                        store.handleProviderTemperatureUpdate(store.providerInUse, newVal);
                                        setState(() {}); // hack
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    store.testProviderToUse(context);
                                  },
                                  icon: const Icon(Icons.wifi_find_outlined),
                                  label: const Text("Test"),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed: () async {
                                    try {
                                      await store.handleProviderUpdate(
                                        store.providerInUse,
                                        store.apiKeysControllers[store.providerIndex]!.text,
                                        store.apiUrlsControllers[store.providerIndex]!.text,
                                      );
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("Saved succesfully"), duration: 1.seconds));
                                      }
                                    } catch (e) {
                                      if (kDebugMode) {
                                        print(e);
                                      }

                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
                                      }
                                    }
                                  },
                                  icon: const Icon(Icons.save_outlined),
                                  label: const Text("Save"),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          AnimatedSize(
                            duration: 200.ms,
                            curve: Curves.easeInOutQuad,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: colorScheme.primary.withValues(alpha: 0.3),
                                ),
                              ),
                              child: SelectableRegion(
                                selectionControls: MaterialTextSelectionControls(),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      size: 20,
                                      color: colorScheme.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        defaultProviders[store.providerIndex].providerInfo,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void showManageModelsDialog(BuildContext context, AiStore store) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController newModelController = TextEditingController();
        final ScrollController listViewController = ScrollController();
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Manage Models"),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Observer(
                      builder: (_) => Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: store.providerInUse.models.length,
                          controller: listViewController,
                          itemBuilder: (context, index) {
                            final model = store.providerInUse.models[index];
                            return ListTile(
                              title: Text(model),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () {
                                  store.deleteModel(model);
                                  setState(() {});
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: newModelController,
                      decoration: const InputDecoration(
                        labelText: "New model name",
                        hintText: "Enter the new model name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                        ),
                      ),
                      onFieldSubmitted: (value) {
                        if (value.isNotEmpty) {
                          store.addModel(value);
                          newModelController.clear();
                          listViewController.animateTo(listViewController.position.maxScrollExtent, duration: 200.ms, curve: Curves.easeInOutCubic);
                          setState(() {});
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Close"),
                ),
                FilledButton(
                  onPressed: () {
                    if (newModelController.text.isNotEmpty) {
                      store.addModel(newModelController.text);
                      newModelController.clear();
                      listViewController.animateTo(listViewController.position.maxScrollExtent, duration: 200.ms, curve: Curves.easeInOutCubic);

                      setState(() {});
                    }
                  },
                  child: const Text("Add Model"),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      setState(() {});
    });
  }
}
