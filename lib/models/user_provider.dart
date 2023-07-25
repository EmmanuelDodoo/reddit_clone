import 'package:flutter/foundation.dart';
import 'package:reddit_clone/models/comment.dart';
import 'package:reddit_clone/models/post.dart';
import 'package:reddit_clone/models/user.dart';

import 'api/request_handler.dart';

/// Provides the current user instance throughout the app. Notifies listeners
/// when the user changes
class UserProvider extends ChangeNotifier {
  User? currentUser;
  List<Post> currUserUpvotedPosts = [];
  List<Post> currUserDownvotedPosts = [];
  List<Comment> currUserUpvotedComments = [];
  List<Comment> currUserDownvotedComments = [];

  void setCurrentUser({required User? user}) async {
    currentUser = user;
    if (currentUser != null) {
      currUserUpvotedPosts = await currentUser!.getUpvotedPosts();
      currUserDownvotedPosts = await currentUser!.getDownvotedPosts();
      currUserUpvotedComments = await currentUser!.getUpvotedComments();
      currUserDownvotedComments = await currentUser!.getDownvotedComments();
    }
    notifyListeners();
  }

  /// Updates the stored user if any with data from the backend.
  Future<void> refreshUser() async {
    if (currentUser == null) return;
    var refreshed = await RequestHandler.getUser(currentUser!.id)
        .then((value) => User(jsonMap: value));

    setCurrentUser(user: refreshed);
  }
}
