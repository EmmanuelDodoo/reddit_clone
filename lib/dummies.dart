import 'package:flutter/material.dart';
import 'package:reddit_clone/models/user.dart';

import 'components/default-post-card.dart';
import 'models/post.dart';

List<String> posts = ["none", "text", "image", "textandimage"];

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
  return Post(jsonMap: json);
}

List<Widget> createAllPosts(BuildContext context) {
  List<String> postswithextension = List.from(posts.map((p) => "$p.json"));
  List<Widget> postcards =
      List.from(postswithextension.map((e) => FutureBuilder(
            future: readPostJSON(context: context, file: e),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                return DefaultPostCard(
                    post: makeDummyPost(snapshot.data ?? ""));
              } else {
                return const CircularProgressIndicator();
              }
            },
          )));

  return postcards;
}
