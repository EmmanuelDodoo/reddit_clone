/// Mixin to handle voting on a vote-able object like a post or comment
mixin VotingMixin {
  /// The net votes this object has. Should be positive if upvotes >
  /// downvotes and negative if the reverse is true.
  late int votes;

  /// Integer Indicating if this object has been voted on by current user
  /// -1 if downvoted, 0 if not voted, 1 if upvoted
  late int voteCode;

  /// Used for specifying which route any APIs should call.
  /// For example: a post would have segment {"posts/} to call /api/posts/....
  late final String pathSegment;

  int getVotes() => votes;

  int getVoteCode() => voteCode;

  /// Calculate and return the change for both votes and voteCode given
  /// a new voteCode {newCode}. The change is the same for both.
  int _calcChange({required int newCode}) {
    // To take the previous vote state into account, I decided to add the
    // vCode to the previous vote state, then pattern match.
    // temp will contain values in range [-2, 2]
    int temp = voteCode + newCode;

    switch (temp) {
      //When a downvote is tapped again after previously tapping on it.
      // Downvote should then be removed
      case -2:
        return 1;
      // When a post not voted on previously is downvoted.
      case -1:
        return -1;
      // Either a previously downvoted post is upvoted or an
      // upvoted post is downvoted
      case 0:
        // Downvoted previously but now being upvoted
        if (voteCode == -1) {
          return 2;
        }
        // Upvoted previously but now being downvoted
        else if (voteCode == 1) {
          return -2;
        }
        return 0; // This case should never be reached
      //When a post not voted on previously is upvoted
      case 1:
        return 1;
      //When an upvoted is tapped again after previously tapping on it.
      // Upvote should then be removed
      case 2:
        return -1;
    }
    return 0; // should never be reached
  }

  /// Remotely set the values for both votes and voteCode, adding {diff} to both
  ///
  /// Returns true if successful
  bool _remoteSet({required int diff}) {
    try {
      //todo api calls to set a new value for both votes and voteCode
      //apiCall(prev+{diff}
      // maybe instead of two calls, one for voteCode and one for votes, it should
      // be one with the backend handling the details
      return true;
    } catch (exception) {
      return false;
    }
  }

  /// Cast a vote by supplying a new vote code, {newCode}.
  /// Sets both votes and votesCode to new values locally and remotely
  ///
  /// Requires: {newCode} is a valid vote code
  ///
  /// Returns true if successful
  bool setVoteCode({required int newCode}) {
    int change = _calcChange(newCode: newCode);

    if (_remoteSet(diff: change)) {
      voteCode = voteCode + change;
      votes = votes + change;
      return true;
    }

    return false;
  }
}
