import 'package:flutter/material.dart';
import '../models/api/http_model.dart';
import '../models/post.dart';
import '../models/subreddit.dart';
import '../components/default-post-card.dart';

class SubredditPosts extends StatefulWidget {
  const SubredditPosts({super.key, required this.subreddit});

  final Subreddit subreddit;

  @override
  State<SubredditPosts> createState() => _SubredditPostsState();
}

class _SubredditPostsState extends State<SubredditPosts>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<Post> _posts = [];
  late final Subreddit _subreddit;

  Future<List<Post>> _fetchPostsData() async {
    var temp = await RequestHandler.getSubredditPosts(_subreddit.id)
        .then((value) => value.map((e) => Post(jsonMap: e)).toList());
    return temp;
  }

  List<Widget> _buildPostCards(List<Post> posts) {
    return posts.map((e) => DefaultPostCard(post: e)).toList();
  }

  @override
  void initState() {
    super.initState();
    _subreddit = widget.subreddit;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
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
    );
  }

  //Prevents the view from defaulting to the beginning
  @override
  bool get wantKeepAlive => true;
}
