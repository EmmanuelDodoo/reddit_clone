import 'package:flutter/material.dart';
import 'package:reddit_clone/models/user.dart';

Future<String> readjson(
    {required BuildContext context, required String file}) async {
  AssetBundle bundle = DefaultAssetBundle.of(context);
  return Future(() => bundle.loadString("json/$file"));
}

User makeDummyUser(String json) {
  return User.fromJSON(json: json);
}

Future<User> loadDummyUser(
    {required BuildContext context, required String file}) {
  Future<String> jsonContents = readjson(context: context, file: file);
  return jsonContents.then((value) => User.fromJSON(json: value));
}
