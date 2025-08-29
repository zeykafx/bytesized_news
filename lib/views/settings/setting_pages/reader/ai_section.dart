import 'package:bytesized_news/models/ai_provider/ai_provider.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/settings/setting_pages/reader/ai_store.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:bytesized_news/views/settings/shared/settings_section.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

class AiSection extends StatefulWidget {
  const AiSection({super.key});

  @override
  State<AiSection> createState() => _AiSectionState();
}

class _AiSectionState extends State<AiSection> {
  late final SettingsStore settingsStore;
  late final AuthStore authStore;
  final BorderRadius borderRadius = BorderRadius.circular(12);
  ExpansibleController expansibleController = ExpansibleController();

  @override
  void initState() {
    super.initState();
    settingsStore = context.read<SettingsStore>();
    authStore = context.read<AuthStore>();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        bool aiEnabled = (authStore.userTier == Tier.premium) || settingsStore.enableCustomAiProvider;
        return SettingsSection(
          title: "Artificial Intelligence",
          onlySection: false,
          children: [
            // suggest articles
            SwitchListTile(
              title: const Text("Suggest articles"),
              subtitle: Text("Suggest unread articles from the past day based on your preferences"),
              value: aiEnabled ? settingsStore.suggestionEnabled : false,
              onChanged: aiEnabled
                  ? (value) {
                      settingsStore.suggestionEnabled = value;
                    }
                  : null,
            ),

            // SHOW AI SUMMARY ON STORY PAGE LOAD
            SwitchListTile(
              title: const Text("Show Summary on page load"),
              subtitle: !aiEnabled ? Text("Available with premium") : null,
              value: aiEnabled ? settingsStore.showAiSummaryOnLoad : false,
              onChanged: aiEnabled
                  ? (value) {
                      settingsStore.setShowAiSummaryOnLoad(value);
                    }
                  : null,
            ),

            // FETCH AI SUMMARY ON STORY PAGE LOAD
            SwitchListTile(
              title: const Text("Generate Summary on page load"),
              subtitle: !aiEnabled ? Text("Available with premium") : null,
              value: aiEnabled ? settingsStore.fetchAiSummaryOnLoad : false,
              onChanged: aiEnabled
                  ? (value) {
                      settingsStore.setFetchAiSummaryOnLoad(value);
                    }
                  : null,
            ),

            ListTile(
              title: const Text("Summary length (in paragraphs)"),
              subtitle: SizedBox(
                width: 150,
                child: Row(
                  children: [
                    SizedBox(width: 35, child: Text(settingsStore.summaryLength.toStringAsFixed(0))),
                    Expanded(
                      child: Slider(
                        year2023: false,
                        label: settingsStore.summaryLength.toStringAsFixed(0),
                        value: settingsStore.summaryLength.toDouble(),
                        min: 1.0,
                        max: 4.0,
                        divisions: 3,
                        onChanged: (newVal) {
                          settingsStore.summaryLength = newVal.toInt();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // BYOK settings
            ExpansionTile(
              enableFeedback: true,
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsets.only(bottom: 12, top: 0),
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius,
              ),
              initiallyExpanded: settingsStore.enableCustomAiProvider,
              showTrailingIcon: false,
              title: SwitchListTile(
                title: const Text("Use a custom AI Provider"),
                subtitle: Text("Bring your own API key"),
                value: settingsStore.enableCustomAiProvider,
                onChanged: (value) {
                  settingsStore.enableCustomAiProvider = value;
                  if (value) {
                    expansibleController.expand();
                  } else {
                    expansibleController.collapse();
                  }
                },
              ),
              controller: expansibleController,
              children: [
                CustomProviderSettings(),
              ],
            ),
          ],
        );
      },
    );
  }
}

class CustomProviderSettings extends StatefulWidget {
  const CustomProviderSettings({
    super.key,
  });

  @override
  State<CustomProviderSettings> createState() => _CustomProviderSettingsState();
}

class _CustomProviderSettingsState extends State<CustomProviderSettings> {
  final double cardHeight = 120;
  final double cardWidth = 180;

  late final SettingsStore settingsStore;
  late final AiStore store;

  late PageController carouselController;
  late CarouselController carousel;

  ExpansibleController expansibleController = ExpansibleController();

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select AI Provider",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (store.loading) ...[
                const SizedBox(height: 8),

                LinearProgressIndicator(
                  year2023: false,
                ).animate().fade(duration: 300.ms),
              ],

              const SizedBox(height: 8),

              SizedBox(
                height: cardHeight,
                child: CarouselView.weighted(
                  flexWeights: [
                    1,
                    2,
                    1,
                  ],
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

                      DropdownButtonFormField<String>(
                        initialValue: store.selectedModels[store.providerIndex],
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
                        items: store.allProviders[store.providerIndex].models.map((model) {
                          return DropdownMenuItem<String>(
                            value: model,
                            child: Text(
                              model,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            store.selectedModels[store.providerIndex] = value;
                          });

                          store.handleProviderModelUpdate(store.providerInUse, store.providerInUse.models.indexOf(value!));
                        },
                      ),

                      ExpansionTile(
                        enableFeedback: true,
                        tilePadding: EdgeInsets.zero,
                        childrenPadding: const EdgeInsets.only(top: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        initiallyExpanded: !store.providerInUse.useSameModelForSuggestions,
                        showTrailingIcon: false,
                        title: SwitchListTile(
                          contentPadding: EdgeInsets.all(2),
                          title: const Text("Different model for suggestions"),
                          subtitle: Text("A better model might provider better suggestions", style: Theme.of(context).textTheme.bodySmall),
                          value: !store.providerInUse.useSameModelForSuggestions,
                          onChanged: (value) async {
                            await store.handleProviderUseSameModelUpdate(store.providerInUse, !value);

                            if (value) {
                              expansibleController.expand();
                            } else {
                              expansibleController.collapse();
                            }
                            setState(() {}); // hack
                          },
                        ),
                        controller: expansibleController,
                        children: [
                          DropdownButtonFormField<String>(
                            initialValue: store.selectedSuggestionModels[store.providerIndex],
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
                            items: store.allProviders[store.providerIndex].models.map((model) {
                              return DropdownMenuItem<String>(
                                value: model,
                                child: Text(
                                  model,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) async {
                              setState(() {
                                store.selectedSuggestionModels[store.providerIndex] = value;
                              });

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
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Saved succesfully"), duration: 1.seconds));
                                } catch (e) {
                                  if (kDebugMode) {
                                    print(e);
                                  }

                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
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
        );
      },
    );
  }
}

class ProviderCard extends StatelessWidget {
  const ProviderCard({
    super.key,
    required this.cardHeight,
    required this.cardWidth,
    required this.provider,
    required this.colorScheme,
    required this.store,
    required this.carousel,
  });

  final double cardHeight;
  final double cardWidth;
  final AiProvider provider;
  final ColorScheme colorScheme;
  final AiStore store;
  final CarouselController carousel;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: OverflowBox(
        maxHeight: cardHeight,
        maxWidth: cardWidth,
        child: Card.filled(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Material(
            color: provider.inUse ? colorScheme.primaryContainer.withValues(alpha: 0.3) : colorScheme.primaryContainer.withValues(alpha: 0.1),
            child: InkWell(
              onTap: () async {
                await store.handleProviderOnTap(provider);
                // carousel.animateToItem(store.allProviders.indexOf(provider));
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            provider.iconFileName,
                            height: 20,
                            width: 20,
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.center,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          provider.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: provider.inUse ? FontWeight.w600 : FontWeight.w500,
                            color: provider.inUse ? colorScheme.primary : colorScheme.onSurface,
                          ),
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                        ),
                      ],
                    ),
                    if (provider.inUse) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "Active",
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                        ),
                      ),
                    ],

                    Flexible(
                      child: Text(
                        "${provider.models.length} models available",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
