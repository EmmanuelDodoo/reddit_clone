import 'dart:convert';
import 'package:reddit_clone/models/classhelpers.dart';
import 'package:reddit_clone/models/replyable.dart';
import 'package:reddit_clone/models/subreddit.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/models/comment.dart';
import 'package:reddit_clone/models/votes.dart';
import 'api/api_errors.dart';
import 'api/http_model.dart';
import 'dart:collection';

/// Representation of a post
class Post with VotingMixin implements IReplyable {
  /// The id of this post instance
  @override
  late final int id;

  /// The simplified Subreddit this post was made on.
  late Subreddit _sub;

  /// The Simplified User who made this post
  late User _user;

  /// The exact time stamp of this post in unix time
  late final int timestamp;

  /// How long ago this post was made
  late String timeDifference;

  /// The title for this post
  late String _title;

  /// Is an Image part of the contents of this post
  late bool _imageInPost;

  /// The URL of the image in the post if there is one. If no image, then
  /// an empty string, ""
  late final String _postImageURL;

  /// The text contents of this post if any. If none, then an empty string ""
  late String _contents;

  /// The total number of comments on this post, including replies.
  late final int commentCount;

  @override
  late final String context;

  /// All comments under this post
  List<Comment> _comments = [];

  // A generator for Post constructors.
  ///
  /// Sets the instance fields of a Post. Does not include comments
  void _generator(dynamic source) {
    id = source["id"];
    timestamp = source["createdAt"];
    timeDifference = ClassHelper.getTimeDifference(unixTime: timestamp);
    _title = source["title"];
    _contents = source["contents"];
    commentCount = source["commentNumber"];
    votes = source["votes"];
    context = _contents.isEmpty || _contents.length < 25
        ? _title
        : "${_contents.substring(0, 25)}...";

    _imageInPost = source["imagePresent"];
    if (_imageInPost) {
      _postImageURL = source["imageURL"];
    } else {
      _postImageURL = "";
    }

    _user = User(jsonMap: source["user"]);

    _sub = Subreddit.simplified(jsonMap: source["subreddit"]);
  }

  /// Construct a post from a valid json map.
  Post({required dynamic jsonMap}) {
    _generator(jsonMap);
  }

  /// Fetches the user of this post from the backend.
  ///
  /// Returns a Map<String, dynamic>
  Future<Map<String, dynamic>> _fetchUser(int uid) async {
    try {
      return await RequestHandler.getUser(uid);
    } on ServerError catch (e) {
      try {
        return await RequestHandler.getUser(uid);
      } catch (e) {
        throw Exception("Failed to fetch user for post: ${toString()} ");
      }
    } catch (e) {
      throw Exception("Failed to fetch user for post: ${toString()} ");
    }
  }

  /// Fetches the subreddit of this post from the backend.
  ///
  /// Returns a Map<String, dynamic>
  Future<Map<String, dynamic>> _fetchSubreddit(int sid) async {
    try {
      return await RequestHandler.getSubreddit(sid);
    } on ServerError catch (e) {
      try {
        return await RequestHandler.getSubreddit(sid);
      } catch (e) {
        throw Exception("Failed to fetch subreddit for post: ${toString()} ");
      }
    } catch (e) {
      throw Exception("Failed to fetch subreddit for post: ${toString()} ");
    }
  }

  /// Fetches the comments under this post from the backend.
  ///
  /// Returns a Map<String, dynamic>
  Future<List<dynamic>> _fetchComments(int pid) async {
    try {
      return await RequestHandler.getAllPostComments(pid);
    } on ServerError catch (e) {
      try {
        return await RequestHandler.getAllPostComments(pid);
      } catch (e) {
        throw Exception("Failed to fetch comments for post: ${toString()} ");
      }
    } catch (e) {
      throw Exception("Failed to fetch comments for post: ${toString()} ");
    }
  }

  String getUserName() => _user.getUsername();

  String getSubName() => _sub.getSubName();

  String getSubImageURL() => _sub.getSubImageURL();

  bool isImageInPost() => _imageInPost;

  String getTitle() => _title;

  String getImageURL() => _postImageURL;

  String getContents() => _contents;

  /// Returns a list of comments under this post.
  Future<List<Comment>> getComments() async {
    // Fetch the comments if they haven't been previously fetched
    if (_comments.isEmpty) {
      await _fetchComments(id).then((value) {
        _comments = List.of(value.map((e) => Comment.full(jsonMap: e)));
      });
    }
    return UnmodifiableListView(_comments);
  }

  @override
  Future<void> reply(
      {required int uid,
      required String contents,
      required String token}) async {
    var requestBody = {"userId": uid, "contents": contents, "ancestorId": -1};
    var commentMap = await RequestHandler.createComment(
        requestBody: requestBody, pid: id, token: token);

    var comment = Comment.simplified(jsonMap: commentMap);
    _comments.add(comment);
  }

  @override
  String toString() {
    return "<Post ~id: $id, title: $_title, creator: ${_user.getUsername()}~ >";
  }
}
