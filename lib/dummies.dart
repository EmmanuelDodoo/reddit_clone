import 'package:flutter/material.dart';
import 'package:reddit_clone/models/user.dart';

import 'models/default-post-card.dart';
import 'models/post.dart';

Future<String> readUserJSON(
    {required BuildContext context, required String file}) async {
  AssetBundle bundle = DefaultAssetBundle.of(context);
  return Future(() => bundle.loadString("json/$file"));
}

User makeDummyUser(String json) {
  return User.fromJSON(json: json);
}

Future<User> loadDummyUser(
    {required BuildContext context, required String file}) {
  Future<String> jsonContents = readUserJSON(context: context, file: file);
  return jsonContents.then((value) => User.fromJSON(json: value));
}

Future<String> readPostJSON(
    {required BuildContext context, required String file}) async {
  AssetBundle bundle = DefaultAssetBundle.of(context);
  return Future(() => bundle.loadString("json/$file"));
}

Post makeDummyPost(String json) {
  return Post.fromJSON(json: json, withComments: true);
}
