/// Abstract class for objects which can be replied to
abstract class IReplyable {
  /// The unique id of this object
  late final int id;

  ///The route used to reply to this object
  late final String replyRoute;

  /// THe contents of this object
  late final String context;

  ///Todo create function to perform replies
  void reply() {}
}
