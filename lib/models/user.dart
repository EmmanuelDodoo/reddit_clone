import 'dart:convert';

import 'package:reddit_clone/models/post.dart';
import 'package:reddit_clone/models/subreddit.dart';
import 'package:reddit_clone/models/comment.dart';

/// A representation of a user on the platform
class User {
  /// The unique id of this user
  late final int _id;

  /// The name of this user
  late final String _username;

  /// All subreddits this user has joined
  late Subreddit _subreddits;

  /// The url pointing to the user's profile image
  late String _userImageURL;

  /// All the post made by this user
  late Post _posts;

  /// All the comments left by this user
  late Comment _comments;

  /// Construct a user from a valid json
  User.fromJSON({required String json}) {
    Map<String, dynamic> jsonMap = jsonDecode(json);
    _id = jsonMap["id"];
    _username = jsonMap["username"];
  }

  /// Create a simplified view of a user
  ///
  /// Simplified users have no user images, posts, comments, or subreddits
  ///
  /// Requires: source is a valid json of a simplified user
  User.fromSimplified({required dynamic source}) {
    // todo add the `r/` and `u/` over here
    _id = source["id"];
    _username = source["name"];
  }

  String getUsername() => _username;

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
}
