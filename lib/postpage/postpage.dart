import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/components/default-popup-menu.dart';
import 'package:reddit_clone/models/api/http_model.dart';
import 'package:reddit_clone/models/post.dart';
import 'package:reddit_clone/components/rightdrawer.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/postpage/AddCommentPage.dart';
import 'package:reddit_clone/postpage/post-page-comment-card.dart';
import 'package:reddit_clone/postpage/post-page-footer.dart';
import 'package:reddit_clone/postpage/post-page-post-card.dart';
import 'package:reddit_clone/models/inherited-data.dart';

import '../components/authentication/login.dart';
import '../models/comment.dart';
import '../models/userprovider.dart';

class PostPage extends StatefulWidget {
  PostPage({Key? key, required Post post})
      : _post = post,
        // _comments = post.getComments(),
        super(key: key);

  late final Post _post;

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  User? _currUser;
  late Post _post;
  List<Comment> _comments = [];

  Future<Post> _fetchPost() async {
    return await RequestHandler.getPost(_post.id)
        .then((value) => Post(jsonMap: value));
  }

  Future<void> _loadPostComments() async {
    var temp = await widget._post.getComments();
    setState(() {
      _comments = temp;
    });
  }

  Future<void> _refresh() async {
    var post = await _fetchPost();
    setState(() {
      _post = post;
    });

    await _loadPostComments();
  }

  void _commentOnPost(BuildContext context) {
    if (_currUser == null) {
      showDialog(
          context: context, builder: (BuildContext context) => LoginModal());
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddCommentPage(replyable: widget._post)));
  }

  Widget _emptyComments(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 100),
        height: 300,
        // width: 300,
        // color: Colors.purple,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.mood_outlined,
              size: 35,
              color: Theme.of(context).colorScheme.secondary,
            ),
            Text(
              "Be the first to comment!",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }

  SliverChildDelegate _commentSection(BuildContext context) {
    if (_comments.isEmpty) {
      return SliverChildBuilderDelegate((_, index) => _emptyComments(context),
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
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
      onTap: () => _commentOnPost(context),
      child: Container(
        padding: const EdgeInsets.only(left: 15),
        // alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Text(
          "Add a comment",
          style: Theme.of(context).textTheme.bodyLarge,
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
            ? Center(
                child: Text(
                  "Login",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              )
            : CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(_currUser!.getUserImageURL()),
              ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PostPagePostCard(
              post: widget._post,
            ),
          ),
          PostPageFooter(
            post: widget._post,
          ),
          SliverToBoxAdapter(child: Divider()),
          SliverList(
            delegate: _commentSection(context),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    _loadPostComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider = Provider.of<UserProvider>(context, listen: false);
    _currUser = provider.currentUser;
    _post = widget._post;
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
        body: _body(context),
        bottomNavigationBar: BottomAppBar(
          height: MediaQuery.of(context).size.height * 0.06,
          child: _textField(context),
        ),
      ),
    );
  }
}
