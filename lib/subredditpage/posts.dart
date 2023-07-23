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

  List<Widget> _postCards = [];
  late final Subreddit _subreddit;

  Future<List<Post>> _fetchPostsData() async {
    var temp = await RequestHandler.getSubredditPosts(_subreddit.id)
        .then((value) => value.map((e) => Post(jsonMap: e)).toList());
    return temp;
  }

  List<Widget> _buildPostCards(List<Post> posts) {
    var temp = posts.map((e) => DefaultPostCard(post: e)).toList();
    _postCards = temp;
    return temp;
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
    );
  }

  //Prevents the view from defaulting to the beginning
  @override
  bool get wantKeepAlive => true;
}
