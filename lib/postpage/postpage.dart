import 'package:flutter/material.dart';
import 'package:reddit_clone/models/default-popup-menu.dart';
import 'package:reddit_clone/models/post.dart';
import 'package:reddit_clone/models/rightdrawer.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/postpage/post-page-comment-card.dart';
import 'package:reddit_clone/postpage/post-page-footer.dart';
import 'package:reddit_clone/postpage/post-page-post-card.dart';

import '../models/comment.dart';

class PostPage extends StatelessWidget {
  PostPage({Key? key, required User currUser, required Post post})
      : _currUser = currUser,
        _post = post,
        _comments = post.getComments(),
        super(key: key);

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late final Post _post;
  late final User _currUser;
  late final List<Comment> _comments;

  void _goBack() {
    print("Go back pressed");
  }

  Future<void> _refresh() async {
    return Future<void>.delayed(const Duration(seconds: 3));
  }

  void _commentOnPost() {
    print("Comment on post tapped");
  }

  Widget _emptyComments() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 100),
        height: 300,
        // width: 300,
        // color: Colors.purple,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.mood_outlined,
              size: 50,
            ),
            Text(
              "Be the first to comment!",
              style: TextStyle(fontSize: 25),
            ),
          ],
        ),
      ),
    );
  }

  SliverChildDelegate _commentSection() {
    if (_comments.isEmpty) {
      return SliverChildBuilderDelegate((_, index) => _emptyComments(),
          childCount: 1);
    } else {
      return SliverChildBuilderDelegate((BuildContext context, int index) {
        return Container(
          margin: const EdgeInsets.only(top: 10),
          child: CommentCard(
            comment: _comments[index],
          ),
        );
      }, childCount: _comments.length);
    }
  }

  Widget _textField(BuildContext context) {
    return InkWell(
      onTap: _commentOnPost,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        padding: const EdgeInsets.only(left: 15),
        alignment: Alignment.centerLeft,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.grey[350],
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: const Text(
          "Add a comment",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _userAvatar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: InkWell(
        onTap: () => Scaffold.of(context).openEndDrawer(),
        child: CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(_currUser.getUserImageURL()),
        ),
      ),
    );
  }

  Widget _body() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      color: Colors.white,
      backgroundColor: Colors.red,
      onRefresh: _refresh,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PostPagePostCard(
              post: _post,
            ),
          ),
          PostPageFooter(
            post: _post,
          ),
          SliverList(
            delegate: _commentSection(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: RightDrawer(
        currUser: _currUser,
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBack,
        ),
        actions: [
          const DefaultPopUp(),
          Builder(
            builder: (BuildContext context) {
              return _userAvatar(context);
            },
          ),
        ],
      ),
      body: _body(),
      bottomNavigationBar: BottomAppBar(
        height: 50.0,
        child: _textField(context),
      ),
    );
  }
}
