import 'package:reddit_clone/models/post_list.dart';
import 'package:flutter/material.dart';
import '../models/api/request_handler.dart';
import '../models/post.dart';

class Home extends PostList {
  const Home({super.key});

  @override
  PostListState<Home> createState() => _HomeState();
}

class _HomeState extends PostListState<Home> {
  @override
  Future<List<Post>> fetchPostsData() async {
    return await RequestHandler.getHomePosts()
        .then((value) => value.map((e) => Post(jsonMap: e)).toList());
  }
}

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
