import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/models/user.dart';
import '../components/default-post-card.dart';
import '../models/post.dart';
import '../models/userprovider.dart';

abstract class PostList extends StatefulWidget {
  const PostList({super.key});

  @override
  State<PostList> createState() => PostListState();
}

class PostListState<T extends PostList> extends State<PostList>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<Widget> _postCards = [];
  late User? _currUser;
  late List<Post> _currUserUpvotedPosts = [];
  late List<Post> _currUserDownvotedPosts = [];
  late UserProvider provider = Provider.of(context, listen: false);

  Future<List<Post>> fetchPostsData() async {
    throw Exception("Unimplemented method");
  }

  int _getVoteCode(Post post) {
    if (_currUser == null) return 0;

    if (_currUserUpvotedPosts.any((element) => post.id == element.id)) return 1;

    if (_currUserDownvotedPosts.any((element) => post.id == element.id))
      return -1;

    return 0;
  }

  List<Widget> _buildPostCards(List<Post> posts) {
    var temp = posts
        .map((e) => DefaultPostCard(
              post: e,
              voteCode: _getVoteCode(e),
            ))
        .toList();
    _postCards = temp;
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    _currUser = provider.currentUser;
    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          // This basically forces the page to be rebuilt and hence the post to
          // be re fetched
          setState(() {});
        },
        child: FutureBuilder(
          future: fetchPostsData(),
          builder: (context, snapshot) {
            _currUserUpvotedPosts = provider.currUserUpvotedPosts;
            _currUserDownvotedPosts = provider.currUserDownvotedPosts;
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
