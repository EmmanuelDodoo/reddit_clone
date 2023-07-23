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

  List<Widget> _postCards = [];

  Future<List<Post>> _fetchPostsData() async {
    return await RequestHandler.getUserPosts(widget.viewedUser.id)
        .then((value) => value.map((e) => Post(jsonMap: e)).toList());
  }

  List<Widget> _buildPostCards(List<Post> posts) {
    var temp = posts.map((e) => DefaultPostCard(post: e)).toList();
    _postCards = temp;
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
          future: _fetchPostsData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return ListView(
                children: _buildPostCards(snapshot.data!),
              );
            } else {
              return _postCards.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView(
                      children: _postCards,
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
