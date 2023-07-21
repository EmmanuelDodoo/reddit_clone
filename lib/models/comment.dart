import 'dart:convert';
import 'package:reddit_clone/models/api/api_errors.dart';
import 'package:reddit_clone/models/api/http_model.dart';
import 'package:reddit_clone/models/classhelpers.dart';
import 'package:reddit_clone/models/replyable.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/models/votes.dart';
import 'dart:collection';

class Comment with VotingMixin implements IReplyable {
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
        _contents.length < 25 ? _contents : "${_contents.substring(0, 15)}...";

    timestamp = source["createdAt"];
    timeDifference = ClassHelper.getTimeDifference(unixTime: timestamp);
    votes = source["votes"];

    // fetch and convert user json to a User.
    int userId = source["userId"];
    // _user = User.simplified(source: _fetchUser(userId));
    _fetchUser(userId).then((value) {
      _user = User.simplified(source: value);
    });

    // vote stuff
    // TODO take a close look
    voteRoute = "comments/$id/";
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
  Future<Map<String, dynamic>> _fetchUser(int id) async {
    try {
      return await RequestHandler.getUser(id);
    } on ServerError catch (e) {
      try {
        return await RequestHandler.getUser(id);
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
    // todo Make api calls
  }

  /// Returns the number of replies under this comment
  int get replyNumber => _replies == [] ? _replyNumber : _replies.length;

  /// Returns an immutable view of replies under this comment
  List<Comment> getReplies() => UnmodifiableListView(_replies);

  String getUserName() => _user.getUsername();

  String getUserImageURL() => _user.getUserImageURL();

  /// Returns the contents of this comment object
  String getContents() => _contents;

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
  String toString() {
    return "<Comment~ id:$id, postId: $postId, contents: ${_contents.substring(0, 5)}... >, ${_replies.length}} replies";
  }
}
