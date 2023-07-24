import 'dart:convert';
import 'dart:collection';

import 'package:reddit_clone/models/post.dart';

import 'api/api_errors.dart';
import 'api/http_model.dart';

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

  int _subscriberCount = 0;

  List<String> _rules = [];

  List<Post> _post = [];

  void _generator(dynamic jsonMap) {
    id = jsonMap["id"];
    _name = jsonMap["name"];
    _subImageURL = jsonMap["imageURL"];
  }

  /// Create s simplified Subreddit object.
  /// The thumbnailURL, about, rules and subscriberCount field
  /// are left empty
  Subreddit.simplified({required dynamic jsonMap}) {
    _generator(jsonMap);
  }

  ///Creates a complete subreddit object.
  Subreddit.full({required dynamic jsonMap}) {
    _generator(jsonMap);
    _thumbnailURL = jsonMap["thumbnailURL"];
    _subscriberCount = jsonMap["subscriberNumber"];
    _about = jsonMap["about"];

    List<dynamic> rulesMap = jsonMap["rules"];
    _rules = List.of(rulesMap.map((e) => e as String));
  }

  Future<List<dynamic>> _fetchPosts(int sid) async {
    try {
      return await RequestHandler.getSubredditPosts(sid);
    } on ServerError catch (e) {
      try {
        return await RequestHandler.getAllPostComments(sid);
      } catch (e) {
        throw Exception("Failed to fetch posts for subreddit: ${toString()} ");
      }
    } catch (e) {
      throw Exception("Failed to fetch posts for subreddit: ${toString()} ");
    }
  }

  String getSubName() => "r/$_name";

  String getSubImageURL() => _subImageURL;

  /// Returns a copy of the description of this sub
  String getSubDescription() => _about.substring(0);

  String getSubThumbnail() => _thumbnailURL.substring(0);

  int get subscriberCount => _subscriberCount;

  /// Returns a copy of the rules of this sub
  List<String> getSubRules() => UnmodifiableListView(_rules);

  Future<List<Post>> getPosts() async {
    // Fetch the posts if they haven't been previously fetched.
    if (_post.isEmpty) {
      await _fetchPosts(id)
          .then((value) => _post = List.of(value.map((e) => Post(jsonMap: e))));
    }

    return UnmodifiableListView(_post);
  }

  @override
  String toString() {
    return "<Subreddit ~id: $id, name: $_name, about: ${_about.substring(0, _about.length ~/ 2)}...~ >";
  }
}
