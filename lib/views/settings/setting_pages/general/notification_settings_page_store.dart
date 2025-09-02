import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/feed_sync/feed_sync.dart';
import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:isar_community/isar.dart';
import 'package:mobx/mobx.dart';

part 'notification_settings_page_store.g.dart';

class NotificationsPageStore = _NotificationsPageStore with _$NotificationsPageStore;

abstract class _NotificationsPageStore with Store {
  @observable
  bool loading = false;

  @observable
  ObservableList<Feed> feeds = <Feed>[].asObservable();

  @observable
  late DbUtils dbUtils;

  @observable
  late AuthStore authStore;

  @observable
  late FeedSync feedSync;

  @action
  void init(AuthStore aStore) {
    authStore = aStore;
    Isar isar = Isar.getInstance()!;
    dbUtils = DbUtils(isar: isar);
    feedSync = FeedSync(isar: isar, authStore: authStore);
  }

  @action
  Future<void> loadFeeds() async {
    loading = true;
    feeds = (await dbUtils.getFeeds()).asObservable();
    loading = false;
  }

  Future<void> handleItemChange(Feed feed, bool value) async {
    feed.notifyAfterBgSync = value;
    await dbUtils.addFeed(feed);
    feeds = (await dbUtils.getFeeds()).asObservable();
    feedSync.updateSingleFeedInFirestore(feed);
  }
}
