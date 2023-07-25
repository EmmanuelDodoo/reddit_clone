import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/models/replyable.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_provider.dart';

class AddCommentPage extends StatefulWidget {
  const AddCommentPage({Key? key, required IReplyable replyable})
      : _replyable = replyable,
        super(key: key);
  final IReplyable _replyable;

  @override
  State<AddCommentPage> createState() => _AddCommentPageState();
}

class _AddCommentPageState extends State<AddCommentPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  User? _currUser;

  final TextEditingController _controller = TextEditingController();

  void _handlePosting(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("tokenValue");

    var contents = _controller.value.text;

    try {
      await widget._replyable
          .reply(uid: _currUser!.id, contents: contents, token: token!);

      // ignore: use_build_context_synchronously
      _showSnackBar(context, "Comment successful", false);

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } catch (e) {
      // ignore: use_build_context_synchronously
      _showSnackBar(context, "Something went wrong. Please try again", true);
    }
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _showSnackBar(
      BuildContext context, String message, bool isError) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isError
                  ? Theme.of(context).colorScheme.errorContainer
                  : Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }

  Widget _floater(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _handlePosting(context),
      child: const Icon(Icons.send),
    );
  }

  Widget _cancelButton(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(
        Icons.close,
        size: 30,
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _cancelButton(context),
          Text(
            "Add a comment",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          TextButton(
            onPressed: () => _handlePosting(context),
            child: Text(
              "Post",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          )
        ],
      ),
    );
  }

  Widget _context(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.symmetric(vertical: 15),
      padding: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      child: Text(
        widget._replyable.context,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }

  Widget _textField(BuildContext context) {
    return Flexible(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _context(context),
            Expanded(
              child: TextFormField(
                controller: _controller,
                style: Theme.of(context).textTheme.bodyMedium,
                expands: true,
                maxLines: null,
                showCursor: true,
                decoration: const InputDecoration(
                  hintText: "Leave a comment",
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter some text";
                  }
                  return null;
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider = Provider.of<UserProvider>(context, listen: false);
    _currUser = provider.currentUser;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        floatingActionButton: _floater(context),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _header(context),
                  ]),
                ),
              )
            ];
          },
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                _textField(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
