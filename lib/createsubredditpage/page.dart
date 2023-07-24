import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/api/http_model.dart';
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
  final TextEditingController _nameFieldController = TextEditingController();
  final TextEditingController _aboutFieldController = TextEditingController();
  final TextEditingController _rulesFieldController = TextEditingController();

  File? _selectedSubImage;
  File? _selectedThumbnailImage;

  Future<String> _uploadImage(File image) async {
    var imageURL = await RequestHandler.uploadImage(image);
    return imageURL["url"];
  }

  Future<void> getSubImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      _selectedSubImage = File(image.path);
    });
  }

  Future<void> getSubThumbnailFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      _selectedThumbnailImage = File(image.path);
    });
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _showSnackBar(
      BuildContext context, String message, bool isError) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                // ?.copyWith(color: isError ? Colors.red : Colors.green[400]),
                ?.copyWith(
                    color: isError
                        ? Theme.of(context).colorScheme.errorContainer
                        : Theme.of(context).colorScheme.primary)),
      ),
    );
  }

  List<String> _processRules() {
    return _rulesFieldController.text.split("\n");
  }

  void handleCreateSub(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedSubImage == null) {
      _showSnackBar(context, "Please choose an image for the subreddit", true);
      return;
    }

    if (_selectedThumbnailImage == null) {
      _showSnackBar(
          context, "Please choose a thumbnail for the subreddit", true);
      return;
    }

    var token = await SharedPreferences.getInstance()
        .then((value) => value.getString("tokenValue"));

    var imageURL = await _uploadImage(_selectedSubImage!);
    var thumbnailURL = await _uploadImage(_selectedThumbnailImage!);

    var requestBody = {
      "userId": _currUser!.id,
      "name": _nameFieldController.value.text.trim(),
      "about": _aboutFieldController.value.text.trim(),
      "rules": _processRules(),
      "imageURL": imageURL,
      "thumbnailURL": thumbnailURL,
    };

    try {
      await RequestHandler.createSubreddit(
          requestBody: requestBody, token: token!);

      // ignore: use_build_context_synchronously
      _showSnackBar(context, "Successfully created subreddit", false);

      // ignore: use_build_context_synchronously
      UserProvider provider = Provider.of<UserProvider>(context, listen: false);
      provider.refreshUser();

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } catch (e) {
      // ignore: use_build_context_synchronously
      _showSnackBar(
          context, "Something went wrong. Please try again later", true);
    }
  }

  Widget _subImageSection(BuildContext context) {
    Widget noImageSelected = SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: () => getSubImageFromGallery(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.image,
                ),
              ),
              Text(
                "Choose Subreddit Image",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );

    return _selectedSubImage == null
        ? noImageSelected
        : Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 43.0),
                child: Text(
                  "Subreddit Image: ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              Image.file(
                _selectedSubImage!,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * 0.1,
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              IconButton(
                onPressed: getSubImageFromGallery,
                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 20,
                ),
              ),
            ],
          );
  }

  Widget _subThumbnailSection(BuildContext context) {
    Widget noImageSelected = SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: () => getSubThumbnailFromGallery(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.image,
                ),
              ),
              Text(
                "Choose Subreddit Thumbnail Image",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );

    return _selectedThumbnailImage == null
        ? noImageSelected
        : Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(
                  "Subreddit Thumbnail: ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              Image.file(
                _selectedThumbnailImage!,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * 0.1,
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              IconButton(
                onPressed: getSubThumbnailFromGallery,
                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 20,
                ),
              ),
            ],
          );
  }

  Widget _textField(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _nameFieldController,
            decoration: const InputDecoration(
              hintText: 'Subreddit name',
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _aboutFieldController,
            decoration: const InputDecoration(
              hintText: 'Subreddit Description',
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return "Please enter a description";
              }
              return null;
            },
          ),
          TextFormField(
            controller: _rulesFieldController,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: 'Subreddit Rules',
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return "Please enter some rules";
              }
              return null;
            },
          ),
        ],
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
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 5,
              ),
              _subImageSection(context),
              const SizedBox(
                height: 10,
              ),
              _subThumbnailSection(context),
              const SizedBox(
                height: 10,
              ),
              _textField(context),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: TextButton(
                  onPressed: () => handleCreateSub(context),
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
