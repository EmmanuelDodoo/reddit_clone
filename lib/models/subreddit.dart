/// Representation of a subreddit
class Subreddit {
  /// The unique id of this subreddit instance
  late final int id;

  /// The name of this subreddit
  late String _name;

  /// The URL of this subreddits image
  late String _subImageURL;

  Subreddit.fromSimplified({required dynamic source}) {
    id = source["id"];
    _name = source["name"];
    _subImageURL = source["imageURL"];
  }

  String getSubName() => "r/$_name";

  String getSubImageURL() => _subImageURL;

  List<String> getSubRules() => [
        "All messages must be written in reverse order. The more confusing, the better!",
        "Every member must speak in rhymes. Failure to do so will result in temporary banishment to the land of limericks.",
        "Use only emojis to express your deepest thoughts and emotions. Words are so last century.",
        "Every Tuesday, all messages must be translated into Pig Latin. Odayn't ayday eakspay inway Englishway!",
        "In honor of our intergalactic friends, all messages should be written in an alien language of your choice. Bonus points for incorporating extraterrestrial slang!",
        "Each member is encouraged to communicate exclusively through puns. Failure to comply may result in a \"pun-ishment\" of listening to an hour-long pun stand-up routine.",
        "Only emacs allowed",
        "Only vi allowed",
      ];
}
