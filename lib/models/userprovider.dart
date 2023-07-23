import 'package:flutter/foundation.dart';
import 'package:reddit_clone/models/user.dart';

import 'api/http_model.dart';

/// Provides the current user instance throughout the app. Notifies listeners
/// when the user changes
class UserProvider extends ChangeNotifier {
  User? currentUser;

  void setCurrentUser({required User? user}) {
    currentUser = user;
    notifyListeners();
  }

  /// Updates the stored user if any with data from the backend.
  Future<void> refreshUser() async {
    if (currentUser == null) return;
    var refreshed = await RequestHandler.getUser(currentUser!.id)
        .then((value) => User(jsonMap: value));
    currentUser = refreshed;

    notifyListeners();
  }
}
