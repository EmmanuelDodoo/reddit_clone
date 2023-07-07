import 'package:flutter/foundation.dart';
import 'package:reddit_clone/models/user.dart';

/// Provides the current user instance throughout the app. Notifies listeners
/// when the user changes
class UserProvider extends ChangeNotifier {
  User? currentUser;

  void setCurrentUser({required User? user}) {
    currentUser = user;
    notifyListeners();
  }
}
