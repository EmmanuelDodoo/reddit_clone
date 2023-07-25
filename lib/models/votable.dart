abstract class Votable {
  late final int id;

  late int votes;

  int getVotes() => votes;

  Future<void> upvote({required int uid, required String token}) async {
    throw Exception("Unimplemented method");
  }

  Future<void> downvote({required int uid, required String token}) async {
    throw Exception("Unimplemented method");
  }

  Future<void> resetVote({required int uid, required String token}) async {
    throw Exception("Unimplemented method");
  }
}
