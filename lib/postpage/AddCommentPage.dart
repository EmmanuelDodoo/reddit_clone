import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/models/replyable.dart';
import 'package:reddit_clone/models/user.dart';

import '../models/inherited-data.dart';
import '../models/userprovider.dart';

class AddCommentPage extends StatelessWidget {
  AddCommentPage({Key? key, required IReplyable replyable})
      : _replyable = replyable,
        super(key: key);
  late final IReplyable _replyable;
  User? _currUser;

  final TextEditingController _controller = TextEditingController();

  void _getText() {
    print(_controller.text);
  }

  void _handlePosting() {
    print("Posting");
  }

  Widget _floater() {
    return FloatingActionButton(
      onPressed: _handlePosting,
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _cancelButton(context),
          const Text(
            "Add a comment",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          TextButton(
            onPressed: _getText,
            child: const Text(
              "Post",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _context() {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      padding: const EdgeInsets.only(bottom: 5),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.purple))),
      child: Text(
        _replyable.context,
        style: const TextStyle(
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _textField(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: MediaQuery.of(context).size.height * 0.7,
      child: TextField(
        expands: true,
        maxLines: null,
        showCursor: true,
        controller: _controller,
        onSubmitted: (String text) => _getText(),
        decoration: const InputDecoration(
          hintText: "Leave a comment",
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
        floatingActionButton: _floater(),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _header(context),
            _context(),
            Expanded(
              child: _textField(context),
            ),
          ],
        ),
      ),
    );
  }
}
