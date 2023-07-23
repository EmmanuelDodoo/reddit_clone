import 'package:flutter/material.dart';
import 'package:reddit_clone/dummies.dart';
import 'package:reddit_clone/models/inherited-data.dart';

import '../components/default-post-card.dart';
import '../models/api/http_model.dart';
import '../models/post.dart';
import '../models/user.dart';

class UserPagePosts extends StatefulWidget {
  final User viewedUser;
  const UserPagePosts({Key? key, required this.viewedUser}) : super(key: key);

  @override
  State<UserPagePosts> createState() => _UserPagePostsState();
}

class _UserPagePostsState extends State<UserPagePosts>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<Post> _posts = [];

  Future<List<Post>> _fetchPostsData() async {
    return await RequestHandler.getUserPosts(widget.viewedUser.id)
        .then((value) => value.map((e) => Post(jsonMap: e)).toList());
  }

  List<Widget> _buildPostCards(List<Post> posts) {
    return posts.map((e) => DefaultPostCard(post: e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          var temp = await _fetchPostsData();
          setState(() {
            _posts = temp;
          });
        },
        child: FutureBuilder(
          future: _fetchPostsData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return ListView(
                children: _posts.isEmpty
                    ? _buildPostCards(snapshot.data!)
                    : _buildPostCards(_posts),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  //Prevents the view from defaulting to the beginning
  @override
  bool get wantKeepAlive => true;
}
