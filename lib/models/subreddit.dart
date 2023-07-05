import 'dart:convert';

/// Representation of a subreddit
class Subreddit {
  /// The unique id of this subreddit instance
  late final int id;

  /// The name of this subreddit
  late String _name;

  /// The URL of this subreddit's image
  late String _subImageURL;

  /// The URL of this subreddit's thumbnail
  String _thumbnailURL = "";

  String _about = "";

  List<String> _rules = [];

  Subreddit.fromSimplified({required dynamic source}) {
    id = source["id"];
    _name = source["name"];
    _subImageURL = source["imageURL"];
  }

  Subreddit.fromJSON({required String json}) {
    Map<String, dynamic> jsonMap = jsonDecode(json);
    id = jsonMap["id"];
    _name = jsonMap["name"];
    _subImageURL = jsonMap["imageURL"];
    _about = jsonMap["about"];
    _thumbnailURL = jsonMap["thumbnail"];
    List<dynamic> rulesMap = jsonMap["rules"];
    _rules = List.from(rulesMap.map((rs) => rs.toString()));
  }

  String getSubName() => "r/$_name";

  String getSubImageURL() => _subImageURL;

  /// Returns a copy of the description of this sub
  String getSubDescription() => _about.substring(0);

  String getSubThumbnail() => _thumbnailURL.substring(0);

  /// Returns a copy of the rules of this sub
  List<String> getSubRules() => _rules.map((e) => e).toList();
}
