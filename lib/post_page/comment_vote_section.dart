import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/models/comment.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/authentication/login.dart';
import '../models/class_helpers.dart';
import '../models/user.dart';
import '../models/user_provider.dart';

class CommentVoteSection extends StatefulWidget {
  final Comment comment;
  final int voteCode;
  const CommentVoteSection(
      {Key? key, required this.comment, required this.voteCode})
      : super(key: key);

  @override
  State<CommentVoteSection> createState() => _CommentVoteSectionState();
}

class _CommentVoteSectionState extends State<CommentVoteSection> {
  late final Comment _comment;
  User? _currUser;
  late int _voteCode;
  String? token;
  late int _votesNumber;

  @override
  void initState() {
    super.initState();
    _comment = widget.comment;
    _votesNumber = _comment.getVotes();
    _voteCode = widget.voteCode;
  }

  Future<void> handleUpvote(BuildContext context) async {
    if (_currUser == null) {
      showDialog(context: context, builder: (context) => const LoginModal());
      return;
    }
    UserProvider provider = Provider.of(context, listen: false);

    // Already upvoted so reset vote
    if (_voteCode == 1) {
      setState(() {
        _votesNumber -= 1;
        _voteCode = 0;
      });
      await _comment.resetVote(uid: _currUser!.id, token: token!);
    } else {
      setState(() {
        if (_voteCode == 0) {
          _votesNumber += 1;
        } else {
          _votesNumber += 2;
        }
        _voteCode = 1;
      });
      await _comment.upvote(uid: _currUser!.id, token: token!);
    }
    await provider.refreshUser();
  }

  Future<void> handleDownvote(BuildContext context) async {
    if (_currUser == null) {
      showDialog(context: context, builder: (context) => const LoginModal());
      return;
    }
    UserProvider provider = Provider.of(context, listen: false);

    //Already downvoted so reset
    if (_voteCode == -1) {
      setState(() {
        _votesNumber += 1;
        _voteCode = 0;
      });
      await _comment.resetVote(uid: _currUser!.id, token: token!);
    } else {
      setState(() {
        if (_voteCode == 0) {
          _votesNumber -= 1;
        } else {
          _votesNumber += -2;
        }
        _voteCode = -1;
      });
      await _comment.downvote(uid: _currUser!.id, token: token!);
    }

    await provider.refreshUser();
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
            splashColor: voteColor(context).withAlpha(75),
            onTap: () => handleUpvote(context),
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
            splashColor: voteColor(context).withAlpha(75),
            onTap: () => handleDownvote(context),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: downvoteIcon(context),
            ),
          ),
        )
      ],
    );
  }

  Future<void> _setToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        token = prefs.getString("tokenValue");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider = Provider.of<UserProvider>(context, listen: false);
    _currUser = provider.currentUser;
    _setToken();
    return voteSection(context);
  }
}
