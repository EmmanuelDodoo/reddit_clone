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

  List<Widget> _postCards = [];

  Future<List<Post>> _fetchPostsData() async {
    return await RequestHandler.getHomePosts()
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
          // This basically forces the page to be rebuilt and hence the post to
          // be re fetched
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
