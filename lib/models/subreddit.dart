/// Representation of a subreddit
class Subreddit {
  /// The unique id of this subreddit instance
  late final int id;

  /// The name of this subreddit
  late String _name;

  /// The URL of this subreddits image
  late String _subImageURL;

  Subreddit.fromSimplified({required dynamic source}) {
    _name = source["name"];
    _subImageURL = source["imageURL"];
  }

  String getSubName() => _name;

  String getSubImageURL() => _subImageURL;
}
