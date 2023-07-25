import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/components/default_popup_menu.dart';
import 'package:reddit_clone/models/api/request_handler.dart';
import 'package:reddit_clone/models/post.dart';
import 'package:reddit_clone/components/right_drawer.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/post_page/add_comment_page.dart';
import 'package:reddit_clone/post_page/post_page_comment_card.dart';
import 'package:reddit_clone/post_page/post_page_footer.dart';
import 'package:reddit_clone/post_page/post_page_post_card.dart';

import '../components/authentication/login.dart';
import '../models/comment.dart';
import '../models/user_provider.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key, required Post post})
      : _post = post,
        // _comments = post.getComments(),
        super(key: key);

  final Post _post;

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  User? _currUser;
  late Post _post;
  List<Comment> _comments = [];
  late List<Post> _currUserUpvotedPosts = [];
  late List<Post> _currUserDownvotedPosts = [];
  List<Comment> _currUserUpvotedComments = [];
  List<Comment> _currUserDownvotedComments = [];

  Future<Post> _fetchPost() async {
    return await RequestHandler.getPost(_post.id)
        .then((value) => Post(jsonMap: value));
  }

  Future<void> _loadPostComments() async {
    var temp = await (_comments.isEmpty
        ? widget._post.getComments()
        : _post.getComments());
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
          context: context,
          builder: (BuildContext context) => const LoginModal());
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddCommentPage(replyable: _post)));
  }

  int _getPostVoteCode(Post post) {
    if (_currUser == null) return 0;

    if (_currUserUpvotedPosts.any((element) => post.id == element.id)) return 1;

    if (_currUserDownvotedPosts.any((element) => post.id == element.id)) {
      return -1;
    }

    return 0;
  }

  int _getCommentVoteCode(Comment comment) {
    if (_currUser == null) return 0;

    if (_currUserUpvotedComments.any((element) => comment.id == element.id)) {
      return 1;
    }

    if (_currUserDownvotedComments.any((element) => comment.id == element.id)) {
      return -1;
    }

    return 0;
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
            voteCode: _getCommentVoteCode(_comments[index]),
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
              builder: (BuildContext context) => const LoginModal(),
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
              post: _post,
            ),
          ),
          PostPageFooter(
            post: _post,
            voteCode: _getPostVoteCode(_post),
          ),
          const SliverToBoxAdapter(child: Divider()),
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
    _currUserUpvotedPosts = provider.currUserUpvotedPosts;
    _currUserDownvotedPosts = provider.currUserDownvotedPosts;
    _currUserUpvotedComments = provider.currUserUpvotedComments;
    _currUserDownvotedComments = provider.currUserDownvotedComments;
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
