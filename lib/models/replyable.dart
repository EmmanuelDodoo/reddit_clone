/// Abstract class for objects which can be replied to
abstract class IReplyable {
  /// The unique id of this object
  late final int id;

  /// THe contents of this object
  late final String context;

  Future<void> reply(
      {required int uid,
      required String contents,
      required String token}) async {}
}
