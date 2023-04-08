import 'dart:convert';

/// An extraction of functions shared by model classes.
/// Do not instantiate
class ClassHelper {
  /// Returns as a string, the time difference between when this function is
  /// called and the given unix time (seconds after the unix epoch).
  ///
  ///Suffices for seconds, minutes, days, months, years are attached appropriately.
  static String getTimeDifference({required int unixTime}) {
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

  /// Return a string version of number with the suffices, 'k', 'm' added as
  /// needed
  static String formatNumber({required int number}) {
    if (number > 999999) {
      double temp = number / 1000000;
      return "${temp.toStringAsFixed(1)}m";
    } else if (number > 999) {
      double temp = number / 1000;
      return "${temp.toStringAsFixed(1)}k";
    }
    return "$number";
  }
}
