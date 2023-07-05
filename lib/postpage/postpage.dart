import 'package:flutter/material.dart';
import 'package:reddit_clone/components/default-popup-menu.dart';
import 'package:reddit_clone/models/post.dart';
import 'package:reddit_clone/components/rightdrawer.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/postpage/AddCommentPage.dart';
import 'package:reddit_clone/postpage/post-page-comment-card.dart';
import 'package:reddit_clone/postpage/post-page-footer.dart';
import 'package:reddit_clone/postpage/post-page-post-card.dart';
import 'package:reddit_clone/models/inherited-data.dart';

import '../login/login.dart';
import '../models/comment.dart';

class PostPage extends StatelessWidget {
  PostPage({Key? key, required Post post})
      : _post = post,
        _comments = post.getComments(),
        super(key: key);

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late final Post _post;
  User? _currUser;
  late final List<Comment> _comments;

  Future<void> _refresh() async {
    return Future<void>.delayed(const Duration(seconds: 3));
  }

  void _commentOnPost(BuildContext context) {
    if (_currUser == null) {
      showDialog(
          context: context, builder: (BuildContext context) => LoginModal());
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddCommentPage(replyable: _post)));
  }

  Widget _emptyComments() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 100),
        height: 300,
        // width: 300,
        // color: Colors.purple,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
      onTap: () => _commentOnPost(context),
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
        onTap: () {
          if (_currUser != null) {
            Scaffold.of(context).openEndDrawer();
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) => LoginModal(),
            );
          }
        },
        child: _currUser == null
            ? const Center(
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(_currUser!.getUserImageURL()),
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
    _currUser = InheritedData.of<User?>(context).data;
    return SafeArea(
      child: Scaffold(
        endDrawer: RightDrawer(),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
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
      ),
    );
  }
}
