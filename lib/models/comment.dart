import 'package:reddit_clone/models/api/api_errors.dart';
import 'package:reddit_clone/models/api/request_handler.dart';
import 'package:reddit_clone/models/class_helpers.dart';
import 'package:reddit_clone/models/replyable.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/models/votable.dart';
import 'dart:collection';

class Comment implements IReplyable, Votable {
  /// The id of this comment instance
  @override
  late final int id;

  /// The post this was made on
  late final int postId;

  /// The id of the immediate ancestor of a comment.
  /// If no ancestor exists, then it should be -1.
  late final int ancestorId;

  /// The Simplified User who made this comment
  late User _user;

  /// How long ago this post was made
  late final String timeDifference;

  /// The exact time stamp of this post in unix time
  late final int timestamp;

  /// The contents of this comment
  late String _contents;

  /// The net votes this object has. Should be positive if upvotes >
  /// downvotes and negative if the reverse is true.
  @override
  late int votes;

  @override
  late String context;

  ///The number of replies under this comment
  int _replyNumber = 0;

  /// All replies made to this comment
  List<Comment> _replies = [];

  /// Does this comment have any replies
  bool hasReplies = false;

  /// A generator for Comment constructors.
  ///
  /// Sets the instance fields of a Comment
  void _generator(dynamic source) {
    id = source["id"];
    postId = source["postId"];

    _contents = source["contents"];
    context =
        _contents.length < 25 ? _contents : "${_contents.substring(0, 25)}...";

    timestamp = source["createdAt"];
    timeDifference = ClassHelper.getTimeDifference(unixTime: timestamp);
    votes = source["votes"];

    _user = User(jsonMap: source["user"]);
  }

  /// Construct a Comment from a valid json map. The `replies` field is replaced
  /// with the replyNumber field.
  Comment.simplified({required dynamic jsonMap}) {
    _generator(jsonMap);
    _replyNumber = jsonMap["replyNumber"];
    hasReplies = false;
  }

  /// Construct a full Comment Object from a valid json map. All replies under
  /// this comment are fully constructed as well. No replyNumber field is created.
  Comment.full({required dynamic jsonMap}) {
    _generator(jsonMap);
    List<dynamic> replyList = jsonMap["replies"];
    _replies = List.of(replyList.map((e) => Comment.full(jsonMap: e)));
    hasReplies = _replies == [];
  }

  /// Fetches the user of this comment from the backend.
  ///
  /// Returns a Map<String, dynamic>
  Future<Map<String, dynamic>> _fetchUser(int uid) async {
    try {
      return await RequestHandler.getUser(uid);
    } on ServerError {
      try {
        return await RequestHandler.getUser(uid);
      } catch (e) {
        throw Exception("Failed to fetch user for comment: ${toString()} ");
      }
    } catch (e) {
      throw Exception("Failed to fetch user for comment: ${toString()} ");
    }
  }

  ///Updates the contents of this comment both locally
  /// and on the backend with {newContent}.
  void _editContents({required String newContent}) {
    _contents = newContent;
  }

  /// Returns the number of replies under this comment
  int get replyNumber => _replies == [] ? _replyNumber : _replies.length;

  /// Returns an immutable view of replies under this comment
  List<Comment> getReplies() => UnmodifiableListView(_replies);

  User getUser() => _user;

  String getUserName() => _user.getUsername();

  String getUserImageURL() => _user.getUserImageURL();

  /// Returns the contents of this comment object
  String getContents() => _contents;

  @override
  int getVotes() => votes;

  @override
  Future<void> reply(
      {required int uid,
      required String contents,
      required String token}) async {
    var requestBody = {"userId": uid, "contents": contents, "ancestorId": id};
    var replyMap = await RequestHandler.createComment(
        requestBody: requestBody, pid: postId, token: token);

    var reply = Comment.simplified(jsonMap: replyMap);
    _replies.add(reply);
  }

  @override
  Future<void> upvote({required int uid, required String token}) async {
    await RequestHandler.upvoteComment(uid: uid, cid: id, token: token);
  }

  @override
  Future<void> downvote({required int uid, required String token}) async {
    await RequestHandler.downvoteComment(uid: uid, cid: id, token: token);
  }

  @override
  Future<void> resetVote({required int uid, required String token}) async {
    await RequestHandler.resetCommentVote(uid: uid, cid: id, token: token);
  }

  @override
  String toString() {
    return "<Comment ~id:$id, postId: $postId, contents: ${_contents.substring(0, _contents.length ~/ 2)}... >, ${_replies.length} replies~ >";
  }
}
