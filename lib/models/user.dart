import 'dart:convert';

import 'package:reddit_clone/models/api/http_model.dart';
import 'package:reddit_clone/models/classhelpers.dart';
import 'package:reddit_clone/models/post.dart';
import 'package:reddit_clone/models/subreddit.dart';
import 'package:reddit_clone/models/comment.dart';
import 'dart:collection';

import 'api/api_errors.dart';

/// A representation of a user on the platform
class User {
  /// The unique id of this user
  late final int id;

  /// The name of this user
  late String _username;

  /// The url pointing to the user's profile image
  late String _userImageURL;

  /// The unix time for when this user account was created
  int _joinDate = 0;

  /// The string representing how long ago this user joined
  String _userAgeString = "";

  /// The amount of karma this user has
  int _karma = 0;

  List<Subreddit> _subscribedSubreddits = [];

  List<Post> _ownedPosts = [];

  List<Post> _upvotedPosts = [];

  List<Post> _downvotedPosts = [];

  List<Comment> _ownedComments = [];

  List<Comment> _upvotedComments = [];

  List<Comment> _downvotedComments = [];

  /// Create a simplified view of a user
  ///
  /// Simplified users have no posts, comments, or subreddits
  ///
  /// Requires: source is a valid json of a simplified user
  User({required dynamic jsonMap}) {
    id = jsonMap["id"];
    _username = jsonMap["username"];
    _userImageURL = jsonMap["imageURL"];
    _karma = jsonMap["karma"];
    _joinDate = jsonMap["joined"];
    _userAgeString = ClassHelper.getTimeDifference(unixTime: _joinDate);

    //TODO Testing to see if this means not using async await for elsewhere
    _loadSubreddits();
  }

  /// Fetches the owned posts of this user from the backend.
  ///
  /// Returns a Map<String, dynamic>
  Future<List<dynamic>> _fetchOwnedPosts(int uid) async {
    try {
      return await RequestHandler.getUserPosts(uid);
    } on ServerError {
      try {
        return await RequestHandler.getUserPosts(uid);
      } catch (e) {
        throw Exception("Failed to fetch owned posts for user: ${toString()} ");
      }
    } catch (e) {
      throw Exception("Failed to fetch owned posts for user: ${toString()} ");
    }
  }

  Future<List<dynamic>> _fetchUpvotedPosts(int uid) async {
    try {
      return await RequestHandler.getUserUpvotedPosts(uid);
    } on ServerError {
      try {
        return await RequestHandler.getUserUpvotedPosts(uid);
      } catch (e) {
        throw Exception(
            "Failed to fetch upvoted posts for user: ${toString()} ");
      }
    } catch (e) {
      throw Exception("Failed to fetch upvoted posts for user: ${toString()} ");
    }
  }

  Future<List<dynamic>> _fetchDownvotedPosts(int uid) async {
    try {
      return await RequestHandler.getUserDownvotedPosts(uid);
    } on ServerError {
      try {
        return await RequestHandler.getUserDownvotedPosts(uid);
      } catch (e) {
        throw Exception(
            "Failed to fetch downvoted posts for user: ${toString()} ");
      }
    } catch (e) {
      throw Exception(
          "Failed to fetch downvoted posts for user: ${toString()} ");
    }
  }

  Future<List<dynamic>> _fetchOwnedComments(int uid) async {
    try {
      return await RequestHandler.getUserComments(uid);
    } on ServerError {
      try {
        return await RequestHandler.getUserComments(uid);
      } catch (e) {
        throw Exception(
            "Failed to fetch owned comments for user: ${toString()} ");
      }
    } catch (e) {
      throw Exception(
          "Failed to fetch owned comments for user: ${toString()} ");
    }
  }

  Future<List<dynamic>> _fetchUpvotedComments(int uid) async {
    try {
      return await RequestHandler.getUserUpvotedComments(uid);
    } on ServerError {
      try {
        return await RequestHandler.getUserUpvotedComments(uid);
      } catch (e) {
        throw Exception(
            "Failed to fetch upvoted comments for user: ${toString()} ");
      }
    } catch (e) {
      throw Exception(
          "Failed to fetch upvoted comments for user: ${toString()} ");
    }
  }

  Future<List<dynamic>> _fetchDownvotedComments(int uid) async {
    try {
      return await RequestHandler.getUserDownvotedComments(uid);
    } on ServerError {
      try {
        return await RequestHandler.getUserDownvotedComments(uid);
      } catch (e) {
        throw Exception(
            "Failed to fetch downvoted comments for user: ${toString()} ");
      }
    } catch (e) {
      throw Exception(
          "Failed to fetch downvoted comments for user: ${toString()} ");
    }
  }

  Future<List<dynamic>> _fetchSubscribedSubreddits(int uid) async {
    try {
      return await RequestHandler.getUserSubreddits(uid);
    } on ServerError {
      try {
        return await RequestHandler.getUserSubreddits(uid);
      } catch (e) {
        throw Exception(
            "Failed to fetch subscribed subreddits for user: ${toString()} ");
      }
    } catch (e) {
      throw Exception(
          "Failed to fetch subscribed subreddits for user: ${toString()} ");
    }
  }

  String getUsername() => "u/$_username";

  /// Modifies this users name and returns the new user name.
  String setUsername({required String newName, required String token}) {
    _username = newName;

    var requestBody = {"username": newName};
    RequestHandler.updateUser(requestBody: requestBody, id: id, token: token);

    return _username;
  }

  String getUserImageURL() => _userImageURL;

  /// Modifies this users image url and returns the new user image url.
  String setUserImageURL(
      {required String newUserImageURL, required String token}) {
    _userImageURL = newUserImageURL;

    var requestBody = {"imageURL": newUserImageURL};
    RequestHandler.updateUser(requestBody: requestBody, id: id, token: token);

    return _userImageURL;
  }

  int getKarma() => _karma;

  int setKarma({required int change, required String token}) {
    _karma = _karma + change;

    var requestBody = {"karma": change};
    RequestHandler.updateUser(requestBody: requestBody, id: id, token: token);

    return _karma;
  }

  void setPassword({required String newPassword, required String token}) {
    var requestBody = {"password": newPassword};
    RequestHandler.updateUser(requestBody: requestBody, id: id, token: token);
  }

  void setEmail({required String newEmail, required String token}) {
    var requestBody = {"email": newEmail};
    RequestHandler.updateUser(requestBody: requestBody, id: id, token: token);
  }

  List<Subreddit> getSubreddits() =>
      UnmodifiableListView(_subscribedSubreddits);

  Future<List<Subreddit>> _loadSubreddits() async {
    // Fetch the subreddits if they haven't previously been fetched
    if (_subscribedSubreddits.isEmpty) {
      await _fetchSubscribedSubreddits(id).then((value) {
        _subscribedSubreddits =
            List.of(value.map((e) => Subreddit.simplified(jsonMap: e)));
      });
    }
    return _subscribedSubreddits;
  }

  Future<List<Post>> getOwnedPosts() async {
    // Fetch the posts if they haven't been previously fetched
    if (_ownedPosts.isEmpty) {
      await _fetchOwnedPosts(id).then((value) {
        _ownedPosts = List.of(value.map((e) => Post(jsonMap: e)));
      });
    }

    return UnmodifiableListView(_ownedPosts);
  }

  Future<List<Post>> getUpvotedPosts() async {
    // Fetch the posts if they haven't been previously fetched
    if (_upvotedPosts.isEmpty) {
      await _fetchUpvotedPosts(id).then((value) {
        _upvotedPosts = List.of(value.map((e) => Post(jsonMap: e)));
      });
    }

    return UnmodifiableListView(_upvotedPosts);
  }

  Future<List<Post>> getDownvotedPosts() async {
    // Fetch the posts if they haven't been previously fetched
    if (_downvotedPosts.isEmpty) {
      await _fetchDownvotedPosts(id).then((value) {
        _downvotedPosts = List.of(value.map((e) => Post(jsonMap: e)));
      });
    }

    return UnmodifiableListView(_downvotedPosts);
  }

  Future<List<Comment>> getOwnedComments() async {
    // Fetch comments if they haven't previously been fetched
    if (_ownedComments.isEmpty) {
      await _fetchOwnedComments(id).then((value) {
        _ownedComments =
            List.of(value.map((e) => Comment.simplified(jsonMap: e)));
      });
    }

    return _ownedComments;
  }

  Future<List<Comment>> getUpvotedComments() async {
    // Fetch comments if they haven't previously been fetched
    if (_upvotedComments.isEmpty) {
      await _fetchUpvotedComments(id).then((value) {
        _upvotedComments =
            List.of(value.map((e) => Comment.simplified(jsonMap: e)));
      });
    }

    return _upvotedComments;
  }

  Future<List<Comment>> getDownvotedComments() async {
    // Fetch comments if they haven't previously been fetched
    if (_downvotedComments.isEmpty) {
      await _fetchDownvotedComments(id).then((value) {
        _downvotedComments =
            List.of(value.map((e) => Comment.simplified(jsonMap: e)));
      });
    }

    return _downvotedComments;
  }

  void subscribeToSubreddit({required int sid, required String token}) async {
    await RequestHandler.subscribeToSubreddit(uid: id, sid: sid, token: token);
  }

  void unsubscribeFromSubreddit(
      {required int sid, required String token}) async {
    await RequestHandler.unsubscribeToSubreddit(
        uid: id, sid: sid, token: token);
  }

  String getUserAgeString() => _userAgeString.substring(0);

  int getUserJoinDate() => _joinDate;

  @override
  String toString() {
    return "<User ~id: $id, username: $_username~ >";
  }
}
