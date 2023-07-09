import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../models/userprovider.dart';

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
      child: Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Subreddit name",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          TextFormField(
            controller: _formController,
            style: Theme.of(context).textTheme.bodyMedium,
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
    UserProvider provider = Provider.of<UserProvider>(context, listen: false);
    _currUser = provider.currentUser;

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
