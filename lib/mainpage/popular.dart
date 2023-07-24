import '../models/api/http_model.dart';
import '../models/post.dart';
import '../models/post_list.dart';

class Popular extends PostList {
  const Popular({super.key});

  @override
  PostListState<Popular> createState() => _PopularState();
}

class _PopularState extends PostListState<Popular> {
  @override
  Future<List<Post>> fetchPostsData() async {
    return await RequestHandler.getPopularPosts()
        .then((value) => value.map((e) => Post(jsonMap: e)).toList());
  }
}
