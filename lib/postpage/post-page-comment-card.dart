import 'package:flutter/material.dart';
import 'package:reddit_clone/components/comment-popup-menu.dart';
import 'package:reddit_clone/models/comment.dart';
import 'package:reddit_clone/postpage/AddCommentPage.dart';
import 'package:reddit_clone/postpage/comment-vote-section.dart';

class CommentCard extends StatefulWidget {
  CommentCard({Key? key, required this.comment, this.isChild = false})
      : super(key: key);
  late final Comment comment;
  late final bool isChild;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  late final Comment _comment;
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _comment = widget.comment;
  }

  void _doubleTap() {
    print("double tapped");
  }

  void _viewUser() {
    print("View use tapped");
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
    return Container(
      child: Row(
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
            ),
          )
        ],
      ),
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
