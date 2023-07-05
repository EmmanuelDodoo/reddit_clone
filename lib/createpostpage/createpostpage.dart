import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/models/subreddit.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:collection/collection.dart';
import '../models/inherited-data.dart';

class CreatePostPage extends StatefulWidget {
  CreatePostPage({Key? key}) : super(key: key);

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  User? _currUser;
  File? _selectedImage;
  Subreddit? _selectedSubreddit;

  void _handlePosting() {
    if (_formKey.currentState!.validate()) {
      print("Successful validation");
    }
  }

  Future<void> getImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      _selectedImage = File(image.path);
    });
  }

  Widget _header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.close,
            size: 30,
          ),
        ),
        TextButton(
          onPressed: _handlePosting,
          child: const Text(
            "POST",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }

  Widget _subredditDropdown(BuildContext context) {
    List<Subreddit> options = _currUser!.getSubreddits();
    return DropdownButton<Subreddit>(
      hint: const Text(
        "Select Subreddit",
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      value: _selectedSubreddit,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (Subreddit? value) {
        // This is called when the user selects an item.
        setState(() {
          _selectedSubreddit = value!;
        });
      },
      items: options.map<DropdownMenuItem<Subreddit>>((Subreddit value) {
        return DropdownMenuItem<Subreddit>(
          value: value,
          child: Text(
            value.getSubName(),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        );
      }).toList(),
    );
  }

  void _rulesDialog(BuildContext context) {
    List<String> rules =
        _selectedSubreddit == null ? [] : _selectedSubreddit!.getSubRules();
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: const Text(
                  "SUBREDDIT RULES:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView(
                shrinkWrap: true,
                children: rules.mapIndexed((index, rule) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text("${index + 1}. $rule"),
                  );
                }).toList(),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('I understand'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rules(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (_selectedSubreddit == null) return;
        _rulesDialog(context);
      },
      child: const Text("RULES"),
    );
  }

  Widget _subreddit(BuildContext context) {
    return Container(
      child: _currUser!.getSubreddits().isEmpty
          ? const Text("You need to subscribe to a subreddit first")
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _subredditDropdown(context),
                _rules(context),
              ],
            ),
    );
  }

  Widget _imageSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
          child: Stack(
        children: [
          Image.file(
            _selectedImage!,
            fit: BoxFit.cover,
          ),
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: IconButton(
              onPressed: () => setState(() {
                _selectedImage = null;
              }),
              icon: const Icon(
                Icons.close,
                size: 30,
              ),
              color: Colors.red,
            ),
          ),
        ],
      )),
    );
  }

  Widget _textField(BuildContext context) {
    return Flexible(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            Expanded(
              child: TextFormField(
                controller: _contentController,
                expands: true,
                maxLines: null,
                showCursor: true,
                decoration: const InputDecoration(
                  hintText: 'Content',
                ),
                validator: (String? value) {
                  if ((value == null || value.isEmpty) &&
                      _selectedImage == null) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _floatingButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: _handlePosting,
      child: const Text('Post'),
    );
  }

  @override
  Widget build(BuildContext context) {
    _currUser = InheritedData.of<User?>(context).data;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: _floatingButton(context),
        resizeToAvoidBottomInset: true,
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 10,
              ),
              _header(context),
              const SizedBox(
                height: 10,
              ),
              _subreddit(context),
              const SizedBox(
                height: 10,
              ),
              (_selectedImage == null ? Container() : _imageSection(context)),
              const SizedBox(
                height: 10,
              ),
              _textField(context),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            height: 50,
            child: IconButton(
              onPressed: () => getImageFromGallery(),
              icon: const Icon(
                Icons.image,
              ),
            )),
      ),
    );
  }
}
