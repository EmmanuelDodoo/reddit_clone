import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import '../models/inherited-data.dart';
import '../models/user.dart';

class CreateSubredditPage extends StatefulWidget {
  const CreateSubredditPage({Key? key}) : super(key: key);

  @override
  State<CreateSubredditPage> createState() => _CreateSubredditPageState();
}

class _CreateSubredditPageState extends State<CreateSubredditPage> {
  User? _currUser;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _formController = TextEditingController();

  void handleCreateSub() {
    if (_formKey.currentState!.validate()) {}
  }

  /// Returns true if no other sub has the same name
  bool noDuplicateSubnames({required String name}) {
    return false;
  }

  Widget _subNameSection(BuildContext context) {
    return Container(
      // color: Colors.amberAccent,
      child: Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            "Subreddit name",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextFormField(
            controller: _formController,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              } else if (!noDuplicateSubnames(name: value)) {
                return "This name is already taken";
              }
              return null;
            },
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _currUser = InheritedData.of<User?>(context).data;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create a Subreddit"),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _subNameSection(context),
              Center(
                child: TextButton(
                  onPressed: handleCreateSub,
                  child: const Text("Create Subreddit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
