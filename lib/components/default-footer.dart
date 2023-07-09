import 'package:flutter/material.dart';
import 'package:reddit_clone/models/post.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/classhelpers.dart';

///Stateful widget for the footer of a post since that's the
/// only section which will change with user interaction
class DefaultFooter extends StatefulWidget {
  DefaultFooter({Key? key, required this.post}) : super(key: key);
  late final Post post;

  @override
  State<DefaultFooter> createState() => DefaultFooterState();
}

class DefaultFooterState extends State<DefaultFooter> {
  late final Post _post;
  late int _votesNumber;
  late int _commentNumber;
  late int _voteCode;

  @override
  void initState() {
    //Set the initial values to what was passed to Footer
    // Can't pass it down otherwise
    _post = widget.post;
    _voteCode = widget.post.getVoteCode();
    _commentNumber = widget.post.commentNumber;
    _votesNumber = widget.post.getVotes();

    super.initState();
  }

  /// Updates the vote code on this post with {update} and calculates net votes
  /// accordingly.
  /// Causes re-rendering of Footer.
  ///
  /// Requires: {update} is a valid vote code.
  void updateVote({required int update}) {
    setState(() {
      _post.setVoteCode(newCode: update);
      _votesNumber = _post.votes;
      _voteCode = _post.voteCode;
    });
  }

  void shareButton() {
    print("Share button tapped");
  }

  /// Returns a Color according to the current voteCode
  Color voteColor(BuildContext context) {
    if (_voteCode == -1) {
      return const Color(0xFFDB2D54);
    } else if (_voteCode == 1) {
      return Theme.of(context).colorScheme.primary;
    }
    return Colors.black;
  }

  /// Returns the appropriate upvote icon based on voteCode
  Widget upvoteIcon(BuildContext context) {
    if (_voteCode == 1) {
      return SvgPicture.asset(
        "icons/upvote-solid.svg",
        semanticsLabel: "Up voted",
        color: voteColor(context),
        width: 20,
      );
    }
    return SvgPicture.asset(
      "icons/upvote-light.svg",
      semanticsLabel: "Up vote",
      color: voteColor(context),
      width: 20,
    );
  }

  /// Returns the appropriate upvote icon based on voteCode
  Widget downvoteIcon(BuildContext context) {
    if (_voteCode == -1) {
      return SvgPicture.asset(
        "icons/downvote-solid.svg",
        semanticsLabel: "Down voted",
        color: voteColor(context),
        width: 20,
      );
    }
    return SvgPicture.asset(
      "icons/downvote-light.svg",
      semanticsLabel: "Down vote",
      color: voteColor(context),
      width: 20,
    );
  }

  /// Returns the appropriate color for the text in vote section.
  ///A post which has neither been upvoted nor downvoted is lighter
  ///
  Color? voteTextColor(BuildContext context) {
    if (_voteCode == 0) {
      return Theme.of(context).textTheme.bodyMedium?.color?.withAlpha(120);
    }
    return voteColor(context);
  }

  Widget voteSection(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(60),
            onTap: () {
              updateVote(update: 1);
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: upvoteIcon(context),
            ),
          ),
        ),
        Text(
          ClassHelper.formatNumber(number: _votesNumber),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: voteTextColor(context),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(60),
            onTap: () {
              updateVote(update: -1);
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: downvoteIcon(context),
            ),
          ),
        )
      ],
    );
  }

  Widget commentSection(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          child: Icon(
            Icons.chat_bubble_outline_rounded,
            size: 20,
            color:
                Theme.of(context).textTheme.bodyMedium?.color?.withAlpha(180),
          ),
        ),
        Text(
          ClassHelper.formatNumber(number: _commentNumber),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color:
                Theme.of(context).textTheme.bodyMedium?.color?.withAlpha(180),
          ),
        )
      ],
    );
  }

  Widget shareSection(BuildContext context) {
    return InkWell(
      onTap: () => shareButton(),
      splashColor: Colors.black.withAlpha(100),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Icon(
              Icons.share_rounded,
              size: 20,
              color:
                  Theme.of(context).textTheme.bodyMedium?.color?.withAlpha(180),
            ),
          ),
          Text(
            "Share",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color:
                  Theme.of(context).textTheme.bodyMedium?.color?.withAlpha(180),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          voteSection(context),
          commentSection(context),
          shareSection(context),
        ],
      ),
    );
  }
}
