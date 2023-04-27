import 'package:flutter/material.dart';
import 'package:reddit_clone/models/replyable.dart';

class AddCommentPage extends StatelessWidget {
  AddCommentPage({Key? key, required IReplyable replyable})
      : _replyable = replyable,
        super(key: key);
  late final IReplyable _replyable;

  final TextEditingController _controller = TextEditingController();

  void _getText() {
    print(_controller.text);
  }

  void _post() {
    print("Posting");
  }

  void _goBack() {
    print("Go back tapped");
  }

  Widget _floater() {
    return FloatingActionButton(
      onPressed: _post,
      child: const Icon(Icons.send),
    );
  }

  Widget _cancelButton() {
    return IconButton(
      onPressed: _goBack,
      icon: const Icon(
        Icons.close,
        size: 30,
      ),
    );
  }

  Widget _header() {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _cancelButton(),
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: _floater(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          _context(),
          Expanded(
            child: _textField(context),
          ),
        ],
      ),
    );
  }
}
