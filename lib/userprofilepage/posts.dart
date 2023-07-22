import 'package:flutter/material.dart';
import 'package:reddit_clone/dummies.dart';
import 'package:reddit_clone/models/inherited-data.dart';

import '../components/default-post-card.dart';
import '../models/api/http_model.dart';
import '../models/post.dart';

class UserPagePosts extends StatefulWidget {
  final int userId;
  const UserPagePosts({Key? key, required this.userId}) : super(key: key);

  @override
  State<UserPagePosts> createState() => _UserPagePostsState();
}

class _UserPagePostsState extends State<UserPagePosts>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late List<Widget> _postcards;

  Future<void> _loadHomePosts() async {
    var tempPosts = await RequestHandler.getUserPosts(widget.userId)
        .then((value) => value.map((map) => Post(jsonMap: map)));

    var cards = tempPosts.map((post) => DefaultPostCard(post: post)).toList();

    setState(() {
      _postcards = cards;
    });
  }

  @override
  Widget build(BuildContext context) {
    // _postcards = createAllPosts(context);

    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          //Todo Make refresh actually mean something
          return Future<void>.delayed(const Duration(seconds: 3));
        },
        child: ListView(
          children: _postcards,
        ),
      ),
    );
  }

  //Prevents the view from defaulting to the beginning
  @override
  bool get wantKeepAlive => true;
}
