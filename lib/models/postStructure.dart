import 'dart:convert';
import 'dart:ffi';

class CommentsStructure {
  late int id;
  late String username;
  late String timeDifference;
  late String userImageURL;
  late String contents;
  late int votes;
  late List<CommentsStructure> replies;

  /// Create a comment object from a JSON
  ///
  /// Requires: json structure is valid
  CommentsStructure.fromJSON({required String json}) {
    Map<String, dynamic> jsonMap = jsonDecode(json);
    id = jsonMap["id"];
    username = jsonMap["username"];
    timeDifference = gettimeDifference(unixTime: jsonMap["timestamp"]);
    userImageURL = jsonMap["userImage"];
    contents = jsonMap["contents"];
    votes = jsonMap["votes"];
    // Recursively get the replies
    List<dynamic> replyList = jsonMap["replies"];
    replies = List.of(replyList
        .map((e) => CommentsStructure.fromDynamic(commentFragment: e)));
  }

  /// Create a comment object from a dynamic instead of a json.
  ///
  /// Requires: commentFragment is valid, ie , under the hood it should still be
  /// Map<String, dynamic>.
  CommentsStructure.fromDynamic({required dynamic commentFragment}) {
    //commentFragment will still be a map
    id = commentFragment["id"];
    username = commentFragment["username"];
    timeDifference = gettimeDifference(unixTime: commentFragment["timestamp"]);
    userImageURL = commentFragment["userImage"];
    contents = commentFragment["contents"];
    votes = commentFragment["votes"];
    // Recursively get the replies of this comment
    List<dynamic> replyList = commentFragment["replies"];
    replies = List.of(replyList.map(
        (element) => CommentsStructure.fromDynamic(commentFragment: element)));
  }
}

/// Represents the structure of a post after all parsing from
/// JSON has been done
class PostStructure {
  //TODO implement vote Code
  late int id;
  late String sub;
  late String username;
  late String subredditImageURL;
  late String timeDifference;
  late String title;
  late bool imageInPost;
  late String postImageURL;
  late String contents;
  late int votes;
  late List<CommentsStructure> comments;

  Map<String, dynamic> generator({required String json}) {
    Map<String, dynamic> jsonMap = jsonDecode(json);
    id = jsonMap["id"];
    sub = jsonMap["subreddit"];
    username = jsonMap["username"];
    subredditImageURL = jsonMap["subredditImageURL"];
    timeDifference = gettimeDifference(unixTime: jsonMap["timestamp"]);
    title = jsonMap["title"];
    imageInPost = jsonMap["imagePresent"];
    if (imageInPost) {
      postImageURL = jsonMap["imageURL"];
    } else {
      postImageURL = "";
    }
    contents = jsonMap["contents"];
    votes = jsonMap["votes"];

    return jsonMap;
  }

  PostStructure.withComments({required String json}) {
    Map<String, dynamic> map = generator(json: json);
    List<dynamic> commentList = map["comments"];
    comments = List.of(commentList
        .map((e) => CommentsStructure.fromDynamic(commentFragment: e)));
  }

  PostStructure.noComments({required String json}) {
    generator(json: json);
  }
}

/// Return a string of the time difference between when
/// function is called and given unix time (seconds after unix enoch)
String gettimeDifference({required int unixTime}) {
  DateTime now = DateTime.now();
  DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(unixTime * 1000);
  Duration diff = now.difference(timestamp);

  if (diff.inDays > 365) {
    return "${diff.inDays ~/ 365}y";
  } else if (diff.inDays > 30) {
    return "${diff.inDays ~/ 30}mo";
  } else if (diff.inDays > 0) {
    return "${diff.inDays}d";
  } else if (diff.inHours > 0) {
    return "${diff.inHours}h";
  } else if (diff.inMinutes > 0) {
    return "${diff.inMinutes}m";
  } else {
    return "${diff.inSeconds}s";
  }
}
