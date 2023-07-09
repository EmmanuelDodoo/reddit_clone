import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/inherited-data.dart';
import '../models/user.dart';
import 'package:image_picker/image_picker.dart';

import '../models/userprovider.dart';

class ImageDialog extends StatefulWidget {
  void Function(File) callback;
  ImageDialog({Key? key, required this.callback}) : super(key: key);

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
                    Navigator.of(context).pop();
                    if (_selectedImage != null) {
                      widget.callback(_selectedImage!);
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

class BasicSettings extends StatelessWidget {
  BasicSettings({Key? key}) : super(key: key);

  User? _currUser;
  TextEditingController _usernameController = TextEditingController();
  final GlobalKey<FormState> _usernameFormKey = GlobalKey<FormState>();

  void _handleUpdateUsername(BuildContext context) {
    if (_usernameFormKey.currentState!.validate()) {
      // _currUser!.setUsername(newName: _usernameController.text);
      Navigator.of(context).pop();
    }
  }

  void handleUpdateProfileImage(File image) {}

  Widget changeUsername(BuildContext context) {
    return InkWell(
      splashColor: Colors.blueGrey,
      onTap: () => showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                      if (value == null || value.isEmpty) {
                        return "Please enter some text";
                      }
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
                  child: changeProfileImage(context),
                ),
              ],
            ),
          )),
    );
  }
}
