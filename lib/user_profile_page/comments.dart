import 'package:flutter/material.dart';
import 'package:reddit_clone/models/api/request_handler.dart';
import 'package:reddit_clone/user_profile_page/comment_card.dart';

import '../models/comment.dart';
import '../models/user.dart';

class UserPageComments extends StatefulWidget {
  final User viewedUser;

  const UserPageComments({Key? key, required this.viewedUser})
      : super(key: key);

  @override
  State<UserPageComments> createState() => _UserPageCommentsState();
}

class _UserPageCommentsState extends State<UserPageComments>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<Widget> _commentCards = [];

  Future<List<Comment>> _fetchCommentsData() async {
    return await RequestHandler.getUserComments(widget.viewedUser.id).then(
        (value) => value.map((e) => Comment.simplified(jsonMap: e)).toList());
  }

  List<Widget> _buildCommentCards(List<Comment> comments) {
    var temp = comments.map((e) => ProfileCommentCard(comment: e)).toList();
    _commentCards = temp;
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
          future: _fetchCommentsData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return ListView(
                children: _buildCommentCards(snapshot.data!),
              );
            } else {
              return _commentCards.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView(
                      children: _commentCards,
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
