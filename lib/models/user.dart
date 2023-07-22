import 'dart:convert';

import 'package:reddit_clone/models/classhelpers.dart';
import 'package:reddit_clone/models/post.dart';
import 'package:reddit_clone/models/subreddit.dart';
import 'package:reddit_clone/models/comment.dart';

/// A representation of a user on the platform
class User {
  /// The unique id of this user
  late final int id;

  /// The name of this user
  late String _username;

  /// All subreddits this user has joined
  List<Subreddit> _subreddits = [];

  /// The url pointing to the user's profile image
  late String _userImageURL;

  /// All the post made by this user
  List<Post> _posts = [];

  /// All the comments left by this user
  List<Comment> _comments = [];

  /// The unix time for when this user account was created
  int _joindate = 0;

  /// The string representing how long ago this user joined
  String _userAgeString = "";

  /// The amount of karma this user has
  int _karma = 0;

  /// Construct a user from a valid json
  User.fromJSON({required String json}) {
    Map<String, dynamic> jsonMap = jsonDecode(json);
    id = jsonMap["id"];
    _username = jsonMap["username"];
    _userImageURL = jsonMap["userImageURL"];
    _joindate = jsonMap["joindate"];
    _userAgeString = ClassHelper.getTimeDifference(unixTime: _joindate);
    _karma = jsonMap["karma"];
    List<dynamic> subredditsMap = jsonMap["subreddits"];
    _subreddits = List.from(
        subredditsMap.map((e) => Subreddit.fromSimplified(source: e)));
    List<dynamic> postsMap = jsonMap["posts"];
    _posts = List.from(postsMap.map((e) => Post.fromMap(map: e)));
    List<dynamic> commentsMap = jsonMap["comments"];
    _comments =
        List.from(commentsMap.map((e) => Comment.simplified(jsonMap: e)));
    //Todo user image, karma, join date, subreddits,subreddit images, posts,
  }

  /// Create a simplified view of a user
  ///
  /// Simplified users have no posts, comments, or subreddits
  ///
  /// Requires: source is a valid json of a simplified user
  User.fromSimplified({required dynamic source}) {
    id = source["id"];
    _username = source["name"];
    _userImageURL = source["userImageURL"];
  }

  /// Create a simplified view of a user
  ///
  /// Simplified users have no posts, comments, or subreddits
  ///
  /// Requires: source is a valid json of a simplified user
  User.simplified({required dynamic jsonMap}) {
    id = jsonMap["id"];
    _username = jsonMap["username"];
    _userImageURL = jsonMap["imageURL"];
    _karma = jsonMap["karma"];
    _joindate = jsonMap["joined"];
  }

  String getUsername() => "u/$_username";

  /// Modifies this users name and returns the new user name.
  String setUsername({required String newName}) {
    _username = newName;
    return _username;
  }

  String getUserImageURL() => _userImageURL;

  /// Modifies this users image url and returns the new user image url.
  String setUserImageURL({required String newUserImageURL}) {
    _userImageURL = newUserImageURL;
    return _userImageURL;
  }

  int getKarma() => _karma;

  int setKarma({required int change}) {
    _karma = _karma + change;
    //todo api call to update user
    return _karma;
  }

  List<Subreddit> getSubreddits() => List.of(_subreddits);

  List<Post> getPosts() => List.of(_posts);

  List<Comment> getComments() => List.of(_comments);

  String getUserAgeString() => _userAgeString.substring(0);

  int getUserJoinDate() => _joindate;
}
