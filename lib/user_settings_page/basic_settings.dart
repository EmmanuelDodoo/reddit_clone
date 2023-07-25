import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/models/api/request_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user_provider.dart';

class ImageDialog extends StatefulWidget {
  final void Function(File) callback;
  const ImageDialog({Key? key, required this.callback}) : super(key: key);

  @override
  State<ImageDialog> createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
  File? _selectedImage;

  Future<void> getImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      _selectedImage = File(image.path);
    });
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Pick image',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox(
                child: _selectedImage == null
                    ? InkWell(
                        onTap: () => getImageFromGallery(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.image,
                                ),
                              ),
                              Text(
                                "Choose image",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      )
                    : Image.file(
                        _selectedImage!,
                        width: 85,
                        height: 85,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    if (_selectedImage != null) {
                      Navigator.of(context).pop();
                      widget.callback(_selectedImage!);
                    } else {
                      _showSnackBar(context, "Please select an image", true);
                    }
                  },
                  child: const Text("Update"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class BasicSettings extends StatefulWidget {
  const BasicSettings({Key? key}) : super(key: key);

  @override
  State<BasicSettings> createState() => _BasicSettingsState();
}

class _BasicSettingsState extends State<BasicSettings> {
  User? _currUser;

  final TextEditingController _usernameController = TextEditingController();

  final GlobalKey<FormState> _usernameFormKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();

  void _setUser(BuildContext context, User user) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    userProvider.setCurrentUser(user: user);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("uid", user.id);
  }

  Future<Map<String, dynamic>> _sendUpdateUsernameRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("tokenValue");
    var requestBody = {"username": _usernameController.value.text};

    return await RequestHandler.updateUser(
        requestBody: requestBody, id: _currUser!.id, token: token!);
  }

  Future<Map<String, dynamic>> _sendUpdateEmailRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("tokenValue");
    var requestBody = {"email": _emailController.value.text};

    return await RequestHandler.updateUser(
        requestBody: requestBody, id: _currUser!.id, token: token!);
  }

  Future<Map<String, dynamic>> _sendUpdatePasswordRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("tokenValue");
    var requestBody = {"password": _passwordController.value.text};

    return await RequestHandler.updateUser(
        requestBody: requestBody, id: _currUser!.id, token: token!);
  }

  Future<Map<String, dynamic>> _sendUpdateImageRequest(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("tokenValue");
    var requestBody = {"imageURL": url};

    return await RequestHandler.updateUser(
        requestBody: requestBody, id: _currUser!.id, token: token!);
  }

  Future<String> _uploadImage(File image) async {
    var imageURL = await RequestHandler.uploadImage(image);
    return imageURL["url"];
  }

  void _handleUpdateUsername(BuildContext context) async {
    if (!_usernameFormKey.currentState!.validate()) return;

    // The backend only returns an error when the field type is wrong
    // So no try catch over here
    var response = await _sendUpdateUsernameRequest();

    // ignore: use_build_context_synchronously
    _setUser(context, User(jsonMap: response));

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();

    // ignore: use_build_context_synchronously
    _showSnackBar(context, "Update successful!", false);
  }

  void _handleUpdateEmail(BuildContext context) async {
    if (!_emailFormKey.currentState!.validate()) return;

    // The backend only returns an error when the field type is wrong
    // So no try catch over here
    var response = await _sendUpdateEmailRequest();

    // ignore: use_build_context_synchronously
    _setUser(context, User(jsonMap: response));

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();

    // ignore: use_build_context_synchronously
    _showSnackBar(context, "Update successful!", false);
  }

  void _handleUpdatePassword(BuildContext context) async {
    if (!_passwordFormKey.currentState!.validate()) return;

    // The backend only returns an error when the field type is wrong
    // So no try catch over here
    var response = await _sendUpdatePasswordRequest();

    // ignore: use_build_context_synchronously
    _setUser(context, User(jsonMap: response));

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();

    // ignore: use_build_context_synchronously
    _showSnackBar(context, "Update successful!", false);
  }

  void handleUpdateProfileImage(File image) async {
    var imageURL = await _uploadImage(image);

    var response = await _sendUpdateImageRequest(imageURL);

    //methods within stateful widgets have access to the
    // BuildContext

    // ignore: use_build_context_synchronously
    _setUser(context, User(jsonMap: response));

    // ignore: use_build_context_synchronously
    _showSnackBar(context, "Update successful!", false);
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

  Widget changeUsername(BuildContext context) {
    return InkWell(
      splashColor: Colors.blueGrey,
      onTap: () => showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Update Username',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Form(
                  key: _usernameFormKey,
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'New username',
                    ),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter some text";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => _handleUpdateUsername(context),
                      child: const Text("Update"),
                    ),
                    TextButton(
                      onPressed: () {
                        _usernameController.clear();
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Update username",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          const Icon(
            Icons.arrow_forward_rounded,
            size: 20,
          )
        ],
      ),
    );
  }

  Widget changeUserEmail(BuildContext context) {
    return InkWell(
      splashColor: Colors.blueGrey,
      onTap: () => showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Update email',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Form(
                  key: _emailFormKey,
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'New email',
                    ),
                    validator: (String? value) {
                      RegExp emailPattern = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                      if (value == null ||
                          value.trim().isEmpty ||
                          !emailPattern.hasMatch(value)) {
                        return "Please a valid email";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => _handleUpdateEmail(context),
                      child: const Text("Update"),
                    ),
                    TextButton(
                      onPressed: () {
                        _emailController.clear();
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Update email",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          const Icon(
            Icons.arrow_forward_rounded,
            size: 20,
          )
        ],
      ),
    );
  }

  Widget changeUserPassword(BuildContext context) {
    return InkWell(
      splashColor: Colors.blueGrey,
      onTap: () => showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Update password',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Form(
                  key: _passwordFormKey,
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'New password',
                    ),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please a new password";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => _handleUpdatePassword(context),
                      child: const Text("Update"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _passwordController.clear();
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Update password",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          const Icon(
            Icons.arrow_forward_rounded,
            size: 20,
          )
        ],
      ),
    );
  }

  Widget changeProfileImage(BuildContext context) {
    return InkWell(
      splashColor: Colors.blueGrey,
      onTap: () => showDialog(
        context: context,
        builder: (BuildContext context) => ImageDialog(
          callback: handleUpdateProfileImage,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Update profile image",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          const Icon(
            Icons.arrow_forward_rounded,
            size: 20,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider = Provider.of<UserProvider>(context, listen: false);
    _currUser = provider.currentUser;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: Card(
          elevation: 5,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Center(
                    child: Text(
                      "BASIC SETTINGS",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: changeUsername(context),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: changeUserEmail(context),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: changeUserPassword(context),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: changeProfileImage(context),
                ),
              ],
            ),
          )),
    );
  }
}
