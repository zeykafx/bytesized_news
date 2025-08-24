import 'package:bytesized_news/models/curatedFeed/curated_feed.dart';
import 'package:bytesized_news/models/curatedFeed/curated_feed_category.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/curated_feeds/curated_feeds_store.dart';
import 'package:bytesized_news/views/feed_view/widgets/add_feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class CuratedFeedsView extends StatefulWidget {
  final BuildContext context;
  final Function getFeeds;
  final Function getItems;
  const CuratedFeedsView({super.key, required this.context, required this.getFeeds, required this.getItems});

  @override
  State<CuratedFeedsView> createState() => _CuratedFeedsViewState();
}

class _CuratedFeedsViewState extends State<CuratedFeedsView> {
  CuratedFeedsStore curatedFeedsStore = CuratedFeedsStore();

  late AuthStore authStore;

  @override
  void initState() {
    authStore = context.read<AuthStore>();
    curatedFeedsStore.readCuratedFeeds(widget.context, authStore);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Observer(
      builder: (context) {
        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("News Sources"),
                if (curatedFeedsStore.selectedFeeds.isNotEmpty)
                  Text(
                    "${curatedFeedsStore.selectedFeeds.length} selected",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
            backgroundColor: colorScheme.surface,
            elevation: 0,
            scrolledUnderElevation: 1,
            actions: [
              if (curatedFeedsStore.selectedFeeds.isNotEmpty || curatedFeedsStore.selectedCategories.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Badge(
                    label: Text('${curatedFeedsStore.selectedFeeds.length}'),
                    child: IconButton.filled(
                      onPressed: () {
                        _showFollowConfirmation(context);
                      },
                      icon: const Icon(Icons.add),
                      style: IconButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 8),
            ],
          ),
          body: _buildBody(context, theme, colorScheme),
          floatingActionButton: _buildFloatingActionButton(context, colorScheme),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    if (curatedFeedsStore.loading) {
      return _buildLoadingState();
    }

    if (curatedFeedsStore.curatedCategories.isEmpty) {
      return _buildEmptyState(colorScheme);
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discover curated news sources',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Choose feeds and/or categories to follow',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: _buildAddFeedCard(colorScheme, theme),
        ),

        // LIST OF CARDS
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final category = curatedFeedsStore.curatedCategories[index];
              return _buildCategoryCard(context, category, theme, colorScheme);
            },
            childCount: curatedFeedsStore.curatedCategories.length,
          ),
        ),
        // bottom padding
        const SliverToBoxAdapter(
          child: SizedBox(height: 40),
        ),
      ],
    );
  }

  Widget _buildAddFeedCard(ColorScheme colorScheme, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: InkWell(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add RSS/ATOM feeds",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Manually add any RSS/ATOM feed with its link",
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          initiallyExpanded: false,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AddFeed(
              getFeeds: widget.getFeeds,
              getItems: widget.getItems,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading curated feeds...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.rss_feed_outlined,
            size: 64,
            color: colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No curated feeds available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, CuratedFeedCategory category, ThemeData theme, ColorScheme colorScheme) {
    final isSelected = curatedFeedsStore.isCategorySelected(category);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? colorScheme.primary.withValues(alpha: 0.5) : colorScheme.outline.withValues(alpha: 0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (value) => curatedFeedsStore.isCategoryAlreadyFollowed(category) ? null : curatedFeedsStore.toggleCategorySelection(category),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${category.curatedFeeds.length} feeds',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                if (curatedFeedsStore.selectedFeeds.where((feed) => category.curatedFeeds.contains(feed)).isNotEmpty)
                  Badge(
                    label: Text(
                      '${curatedFeedsStore.selectedFeeds.where((feed) => category.curatedFeeds.contains(feed)).length}',
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    backgroundColor: colorScheme.primary,
                  ),
              ],
            ),
          ),
          initiallyExpanded: false,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                children: category.curatedFeeds.map((feed) => _buildFeedTile(feed, category.name, theme, colorScheme)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedTile(CuratedFeed feed, String categoryName, ThemeData theme, ColorScheme colorScheme) {
    final isSelected = curatedFeedsStore.isFeedSelected(feed);
    final category = curatedFeedsStore.curatedCategories.firstWhere((cat) => cat.name == categoryName);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => curatedFeedsStore.isFeedAlreadyFollowed(feed) ? null : curatedFeedsStore.toggleFeedSelection(feed, category),
        enableFeedback: true,
        borderRadius: BorderRadius.circular(8),
        child: Opacity(
          opacity: curatedFeedsStore.isFeedAlreadyFollowed(feed) ? 0.4 : 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (value) => curatedFeedsStore.isFeedAlreadyFollowed(feed) ? null : curatedFeedsStore.toggleFeedSelection(feed, category),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.rss_feed_rounded,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feed.title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      if (curatedFeedsStore.isFeedAlreadyFollowed(feed)) ...[
                        const SizedBox(height: 2),
                        Text(
                          "Already followed",
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                      const SizedBox(height: 2),
                      Tooltip(
                        message: feed.link,
                        child: Text(
                          feed.link,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildFloatingActionButton(BuildContext context, ColorScheme colorScheme) {
    final totalSelected = curatedFeedsStore.selectedFeeds.length;

    if (totalSelected == 0) return null;

    return FloatingActionButton.extended(
      onPressed: () {
        _showFollowConfirmation(context);
      },
      icon: const Icon(Icons.add),
      label: Text('Follow ($totalSelected)'),
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
    );
  }

  void _showFollowConfirmation(BuildContext context) {
    final selectedFeedsCount = curatedFeedsStore.selectedFeeds.length;
    final selectedCategoriesCount = curatedFeedsStore.selectedCategories.length;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext modalSheetContext) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.rss_feed,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Follow Feeds',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'You\'re about to follow:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 12),
              if (selectedCategoriesCount > 0)
                Row(
                  children: [
                    Icon(
                      Icons.category,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text('$selectedCategoriesCount categories'),
                  ],
                ),
              if (selectedFeedsCount > 0)
                Row(
                  children: [
                    Icon(
                      Icons.article,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text('$selectedFeedsCount individual feeds'),
                  ],
                ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(modalSheetContext),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        curatedFeedsStore.followSelectedFeeds(context);
                        Navigator.pop(modalSheetContext);
                      },
                      child: const Text('Follow'),
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
}
