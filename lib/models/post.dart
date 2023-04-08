import 'dart:convert';
import 'package:reddit_clone/models/classhelpers.dart';
import 'package:reddit_clone/models/subreddit.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/models/comment.dart';
import 'package:reddit_clone/models/votes.dart';

/// Representation of a post
class Post with VotesMixin {
  /// The id of this post instance
  late final int id;

  /// The simplified Subreddit this post was made on
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
  late String _postImageURL;

  /// The text contents of this post if any. If none, then an empty string ""
  late String _contents;

  /// All comments under this post
  late List<Comment> _comments;

  /// The number of comments on this post. Only considers direct comments.
  late int commentNumber;

  // A generator for Post constructors.
  ///
  /// Sets the instance fields of a Post. Does not include comments
  void _generator({required dynamic source}) {
    id = source["id"];
    _user = User.fromSimplified(source: source["user"]);
    _sub = Subreddit.fromSimplified(source: source["subreddit"]);
    timestamp = source["timestamp"];
    timeDifference = ClassHelper.getTimeDifference(unixTime: timestamp);
    _title = source["title"];
    _contents = source["contents"];
    _imageInPost = source["imagePresent"];
    votes = source["votes"];
    voteCode = source["voteCode"];
    // No need to construct all those comments just to get the length of the list
    commentNumber = source["comments"].length;
    if (_imageInPost) {
      _postImageURL = source["imageURL"];
    } else {
      _postImageURL = "";
    }

    pathSegment = "posts/";
  }

  /// Create a Post object with the given valid json.
  /// If withComments is true, All comments are parsed into Comment objects.
  Post.fromJSON({required String json, bool withComments = false}) {
    dynamic map = jsonDecode(json);
    _generator(source: map);

    if (withComments) {
      List<Map<String, dynamic>> commentsMap = map["comments"];
      _comments = List.from(commentsMap.map((e) => Comment.fromMap(map: map)));
    }
  }

  /// Construct a Post object from a valid map representing json structure.
  /// If withComments is true, All comments are parsed into Comment objects.
  ///
  /// Requires: map is valid, ie, under the hood it should still be a
  /// Map<String, dynamic>
  Post.fromMap({required dynamic map, withComments = false}) {
    _generator(source: map);

    if (withComments) {
      List<Map<String, dynamic>> commentsMap = map["comments"];
      _comments = List.from(commentsMap.map((e) => Comment.fromMap(map: map)));
    }
  }

  String getUserName() => _user.getUsername();

  String getSubName() => _sub.getSubName();

  String getSubImageURL() => _sub.getSubImageURL();

  bool isImageInPost() => _imageInPost;

  String getTitle() => _title;

  String getImageURL() => _postImageURL;

  String getContents() => _contents;

  List<Comment> getComments() => List.of(_comments);
}
