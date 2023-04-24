import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reddit_clone/models/comment.dart';

import '../models/classhelpers.dart';

class CommentVoteSection extends StatefulWidget {
  late final Comment comment;
  CommentVoteSection({Key? key, required this.comment}) : super(key: key);

  @override
  State<CommentVoteSection> createState() => _CommentVoteSectionState();
}

class _CommentVoteSectionState extends State<CommentVoteSection> {
  late final Comment _comment;

  @override
  void initState() {
    super.initState();
    _comment = widget.comment;
  }

  /// Updates the vote code on this post with {update} and calculates net votes
  /// accordingly.
  /// Causes re-rendering of Footer.
  ///
  /// Requires: {update} is a valid vote code.
  void updateVote({required int update}) {
    setState(() {
      _comment.setVoteCode(newCode: update);
    });
  }

  /// Returns a Color according to the current voteCode
  Color voteColor() {
    if (_comment.voteCode == -1) {
      return Colors.indigo;
    } else if (_comment.voteCode == 1) {
      return Colors.deepOrange;
    }
    return Colors.black;
  }

  /// Returns the appropriate upvote icon based on voteCode
  Widget upvoteIcon() {
    if (_comment.voteCode == 1) {
      return SvgPicture.asset(
        "icons/upvote-solid.svg",
        semanticsLabel: "Up voted",
        color: voteColor(),
        width: 20,
      );
    }
    return SvgPicture.asset(
      "icons/upvote-light.svg",
      semanticsLabel: "Up vote",
      width: 20,
    );
  }

  /// Returns the appropriate upvote icon based on voteCode
  Widget downvoteIcon() {
    if (_comment.voteCode == -1) {
      return SvgPicture.asset(
        "icons/downvote-solid.svg",
        semanticsLabel: "Down voted",
        color: voteColor(),
        width: 20,
      );
    }
    return SvgPicture.asset(
      "icons/downvote-light.svg",
      semanticsLabel: "Down vote",
      width: 20,
    );
  }

  /// Returns the appropriate color for the text in vote section.
  ///A post which has neither been upvoted nor downvoted is lighter
  ///
  Color voteTextColor() {
    if (_comment.voteCode == 0) {
      return voteColor().withAlpha(120);
    }
    return voteColor();
  }

  Widget voteSection() {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: InkWell(
            splashColor: voteColor().withAlpha(75),
            onTap: () {
              updateVote(update: 1);
            },
            child: upvoteIcon(),
          ),
        ),
        Text(
          ClassHelper.formatNumber(number: _comment.getVotes()),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: voteTextColor(),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 8),
          child: InkWell(
            splashColor: voteColor().withAlpha(75),
            onTap: () {
              updateVote(update: -1);
            },
            child: downvoteIcon(),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return voteSection();
  }
}
