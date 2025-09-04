import 'package:bytesized_news/models/ai_provider/ai_provider.dart';
import 'package:bytesized_news/views/settings/setting_pages/reader/ai_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
    return OverflowBox(
      // maxHeight: cardHeight,
      // maxWidth: cardWidth,
      fit: OverflowBoxFit.max,
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
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
                    Wrap(
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
                          overflow: TextOverflow.clip,
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
                          overflow: TextOverflow.ellipsis,
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
                        overflow: TextOverflow.ellipsis,
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
