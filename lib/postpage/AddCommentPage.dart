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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  User? _currUser;

  final TextEditingController _controller = TextEditingController();

  void _handlePosting() {
    if (_formKey.currentState!.validate()) {
      print("Successful validation");
    }
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _cancelButton(context),
          Text(
            "Add a comment",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          TextButton(
            onPressed: _handlePosting,
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
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      padding: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      child: Text(
        _replyable.context,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }

  Widget _textField(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Form(
        key: _formKey,
        child: TextFormField(
          style: Theme.of(context).textTheme.bodyMedium,
          expands: true,
          maxLines: null,
          showCursor: true,
          controller: _controller,
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return "Please enter some text";
            }
            return null;
          },
          decoration: const InputDecoration(
            hintText: "Leave a comment",
          ),
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
          body: Column(
            children: [
              _context(context),
              Expanded(
                child: _textField(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
