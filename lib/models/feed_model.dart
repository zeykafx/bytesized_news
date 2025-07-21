class FeedModel {
  final String text;
  final String title;
  final String description;
  final String xmlUrl;
  final String type;

  FeedModel({
    required this.text,
    required this.title,
    required this.description,
    required this.xmlUrl,
    required this.type,
  });

  factory FeedModel.fromOpmlOutline(dynamic outline) {
    return FeedModel(
      text: outline.text ?? '',
      title: outline.title ?? '',
      description: outline.description ?? '',
      xmlUrl: outline.xmlUrl ?? '',
      type: outline.type ?? '',
    );
  }
}

class FeedCategory {
  final String name;
  final List<FeedModel> feeds;

  FeedCategory({
    required this.name,
    required this.feeds,
  });
}
