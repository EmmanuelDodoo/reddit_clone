import 'package:reddit_clone/models/post_list.dart';

import '../models/api/http_model.dart';
import '../models/post.dart';
import '../models/subreddit.dart';

class SubredditPosts extends PostList {
  final Subreddit subreddit;
  const SubredditPosts({super.key, required this.subreddit});

  @override
  PostListState<SubredditPosts> createState() =>
      _SubredditPostsState(subreddit: subreddit);
}

class _SubredditPostsState extends PostListState<SubredditPosts> {
  final Subreddit subreddit;

  _SubredditPostsState({required this.subreddit});
  @override
  Future<List<Post>> fetchPostsData() async {
    var temp = await RequestHandler.getSubredditPosts(subreddit.id)
        .then((value) => value.map((e) => Post(jsonMap: e)).toList());
    return temp;
  }
}
