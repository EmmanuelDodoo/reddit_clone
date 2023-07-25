import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/components/comment_popup_menu.dart';
import 'package:reddit_clone/models/comment.dart';
import 'package:reddit_clone/post_page/add_comment_page.dart';
import 'package:reddit_clone/post_page/comment_vote_section.dart';

import '../models/user.dart';
import '../models/user_provider.dart';
import '../user_profile_page/user_profile.dart';

class CommentCard extends StatefulWidget {
  const CommentCard(
      {Key? key,
      required this.comment,
      this.isChild = false,
      required this.voteCode})
      : super(key: key);
  final Comment comment;
  final int voteCode;
  final bool isChild;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  late final Comment _comment;
  bool _isCollapsed = false;

  User? _currUser;
  List<Comment> _currUserUpvotedComments = [];
  List<Comment> _currUserDownvotedComments = [];

  @override
  void initState() {
    super.initState();
    _comment = widget.comment;
  }

  void _doubleTap() {}

  void _viewUser() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserProfile(
          viewedUser: _comment.getUser(),
        ),
      ),
    );
  }

  void _reply() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddCommentPage(replyable: _comment)));
  }

  void _collapse() {
    setState(() {
      _isCollapsed = true;
    });
  }

  int _getVoteCode(Comment comment) {
    if (_currUser == null) return 0;

    if (_currUserUpvotedComments.any((element) => comment.id == element.id)) {
      return 1;
    }

    if (_currUserDownvotedComments.any((element) => comment.id == element.id)) {
      return -1;
    }

    return 0;
  }

  Widget _userAvatar() {
    return Container(
        margin: const EdgeInsets.only(right: 10, left: 5, top: 5),
        child: CircleAvatar(
          radius: 15,
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(_comment.getUserImageURL()),
        ));
  }

  Widget _footer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CommentPopUp(
          collapse: _collapse,
        ),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: IconButton(
            onPressed: _reply,
            icon: const Icon(Icons.turn_left),
            color:
                Theme.of(context).textTheme.bodyMedium?.color?.withAlpha(180),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 10),
          child: CommentVoteSection(
            comment: _comment,
            voteCode: widget.voteCode,
          ),
        )
      ],
    );
  }

  Widget _collapsedVersion(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isCollapsed = false;
        });
      },
      child: SizedBox(
        height: 30,
        width: double.maxFinite,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: _viewUser,
              child: Row(
                children: [
                  _userAvatar(),
                  Text(
                    _comment.getUserName(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    " • ${_comment.timeDifference}  ",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Text(
                _comment.getContents(),
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _children() {
    List<Comment> replies = _comment.getReplies();
    return Column(
      children: [
        ...(replies.map((rep) => Container(
              margin: const EdgeInsets.only(left: 10),
              child: CommentCard(
                comment: rep,
                isChild: true,
                voteCode: _getVoteCode(rep),
              ),
            )))
      ],
    );
  }

  Widget _expandedVersion(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isCollapsed = true;
        });
      },
      onDoubleTap: _doubleTap,
      child: Container(
        decoration: BoxDecoration(
          border: widget.isChild
              ? const Border(
                  left: BorderSide(color: Colors.purple),
                )
              : null,
        ),
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: _viewUser,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _userAvatar(),
                    Text(
                      _comment.getUserName(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      " • ${_comment.timeDifference}  ",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 5),
              child: Text(
                _comment.getContents(),
              ),
            ),
            _footer(),
            _comment.hasReplies ? Container() : _children(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider = Provider.of<UserProvider>(context, listen: false);
    _currUser = provider.currentUser;
    _currUserUpvotedComments = provider.currUserUpvotedComments;
    _currUserDownvotedComments = provider.currUserDownvotedComments;

    if (widget.isChild) {
      return AnimatedContainer(
        duration: const Duration(seconds: 3),
        curve: Curves.easeIn,
        child: _isCollapsed
            ? _collapsedVersion(context)
            : _expandedVersion(context),
      );
    }

    return Card(
      child: AnimatedContainer(
        duration: const Duration(seconds: 3),
        curve: Curves.easeIn,
        child: _isCollapsed
            ? _collapsedVersion(context)
            : _expandedVersion(context),
      ),
    );
  }
}