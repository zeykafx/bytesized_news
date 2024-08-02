
import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:mobx/mobx.dart';

import '../../models/feedItem/feedItem.dart';

part 'story_store.g.dart';

class StoryStore = _StoryStore with _$StoryStore;

abstract class _StoryStore with Store {

  @observable
  FeedItem? feedItem;

  @observable
  int progress = 0;

  @observable
  bool loading = false;

  @observable
  bool isLocked = true;

  @observable
  bool isCollapsed = true;

  @observable
  bool isExpanded = false;

  @observable
  BottomSheetBarController bsbController = BottomSheetBarController();

}