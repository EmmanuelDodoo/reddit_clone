import 'package:reddit_clone/models/post_list.dart';
import 'package:reddit_clone/models/user.dart';

import '../models/api/request_handler.dart';
import '../models/post.dart';

class UserPagePosts extends PostList {
  final User viewedUser;
  const UserPagePosts({super.key, required this.viewedUser});

  @override
  PostListState<UserPagePosts> createState() =>
      _UserPagePostsState(viewedUser: viewedUser);
}

class _UserPagePostsState extends PostListState<UserPagePosts> {
  final User viewedUser;

  _UserPagePostsState({required this.viewedUser});

  @override
  Future<List<Post>> fetchPostsData() async {
    return await RequestHandler.getUserPosts(viewedUser.id)
        .then((value) => value.map((e) => Post(jsonMap: e)).toList());
  }
}
