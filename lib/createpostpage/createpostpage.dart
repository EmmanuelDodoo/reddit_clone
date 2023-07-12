import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/models/subreddit.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:collection/collection.dart';
import '../models/userprovider.dart';

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

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _showSnackBar(
      BuildContext context, String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: Colors.red),
        ),
      ),
    );
  }

  void _handlePosting(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (_selectedSubreddit != null) {
        print("Successful validation");
      } else {
        _showSnackBar(context, "Please choose a subreddit");
      }
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
          onPressed: () => _handlePosting(context),
          child: Text(
            "POST",
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        )
      ],
    );
  }

  Widget _subredditDropdown(BuildContext context) {
    List<Subreddit> options = _currUser!.getSubreddits();
    return DropdownButton<Subreddit>(
      hint: Text(
        "Select Subreddit",
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      value: _selectedSubreddit,
      elevation: 16,
      underline: Container(
        height: 2,
        color: Theme.of(context).colorScheme.primary,
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
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
                child: Text(
                  "SUBREDDIT RULES:",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: rules.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Text(
                        "${index + 1}. ${rules[index]}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(letterSpacing: 0.5),
                      ),
                    );
                  },
                ),
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
      child: const Text("Rules"),
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
      child: Stack(
        children: [
          Image.file(
            _selectedImage!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.25,
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
      ),
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
                style: Theme.of(context).textTheme.bodyMedium,
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
      onPressed: () => _handlePosting(context),
      child: const Text('Post'),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider = Provider.of<UserProvider>(context, listen: false);
    _currUser = provider.currentUser;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: _floatingButton(context),
        resizeToAvoidBottomInset: true,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          _header(context),
                          const SizedBox(
                            height: 10,
                          ),
                          _subreddit(context),
                          const SizedBox(
                            height: 10,
                          ),
                          (_selectedImage == null
                              ? Container()
                              : _imageSection(context)),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )
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
