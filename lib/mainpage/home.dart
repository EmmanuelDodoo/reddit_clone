import 'package:flutter/material.dart';
import 'package:reddit_clone/models/api/http_model.dart';
import '../components/default-post-card.dart';
import '../models/post.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<Post> _posts = [];

  Future<List<Post>> _fetchPostsData() async {
    return await RequestHandler.getHomePosts()
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
