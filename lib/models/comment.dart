import 'dart:convert';
import 'package:reddit_clone/models/classhelpers.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/models/votes.dart';

class Comment with VotingMixin {
  /// The id of this comment instance
  late final int id;

  /// The post this was made on
  late final int postId;

  /// The id of the immediate ancestor of a comment.
  /// If no ancestor exists, then it should be -1.
  late final int immediateAncestorId;

  /// The Simplified User who made this comment
  late User _user;

  /// How long ago this post was made
  late final String timeDifference;

  /// The exact time stamp of this post in unix time
  late final int timestamp;

  /// The contents of this comment
  late String _contents;

  /// All replies made to this comment
  late List<Comment> _replies;

  /// Does this comment have any replies
  bool hasReplies = false;

  /// A generator for Comment constructors.
  ///
  /// Sets the instance fields of a Comment
  void _generator({required dynamic source}) {
    id = source["id"];
    postId = source["postId"];
    immediateAncestorId = source["ancestorId"];
    _user = User.fromSimplified(source: source["user"]);
    timestamp = source["timestamp"];
    timeDifference = ClassHelper.getTimeDifference(unixTime: timestamp);
    _contents = source["contents"];
    votes = source["votes"];
    voteCode = source["voteCode"];
    // Recursively get the replies
    List<dynamic> replyList = source["replies"];
    _replies = List.of(replyList.map((e) => Comment.fromMap(map: e)));

    hasReplies = _replies == [];
  }

  /// Construct a Comment from a valid json
  Comment.fromJson({required String json}) {
    Map<String, dynamic> jsonMap = jsonDecode(json);
    _generator(source: jsonMap);
  }

  /// Construct a Comment Object from a valid map representing json structure.
  ///
  /// Requires: map is valid, ie, under the hood it should still be a
  /// Map<String, dynamic>
  Comment.fromMap({required dynamic map}) {
    _generator(source: map);
  }

  String getContents() => _contents;

  ///Updates the contents of this comment both locally
  /// and on the backend with {newContent}.
  void editContents({required String newContent}) {
    _contents = newContent;
    // todo Make api calls
  }

  List<Comment> getReplies() => List.from(_replies);

  String getUserName() => _user.getUsername();

  String getUserImageURL() => _user.getUserImageURL();
}
