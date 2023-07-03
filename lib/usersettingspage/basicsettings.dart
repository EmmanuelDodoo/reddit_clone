import 'dart:io';

import 'package:flutter/material.dart';
import '../models/inherited-data.dart';
import '../models/user.dart';
import 'package:image_picker/image_picker.dart';

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
            const Text('Pick image'),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox(
                child: _selectedImage == null
                    ? InkWell(
                        onTap: () => getImageFromGallery(),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.image,
                                ),
                              ),
                              Text(
                                "Choose image",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
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
                  child: const Text('Close'),
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

  late User _currUser;

  void handleUpdateUsername(String newName) {}

  void handleUpdateProfileImage(File image) {}

  Widget changeUsername(BuildContext context) {
    TextEditingController _controller = TextEditingController();
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
                const Text('Update Username'),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (String value) {
                      Navigator.of(context).pop();
                      handleUpdateUsername(value);
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'New username',
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
                        handleUpdateUsername(_controller.text);
                      },
                      child: const Text("Update"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Update username",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Icon(Icons.arrow_forward_rounded)
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
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Update profile image",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Icon(Icons.arrow_forward_rounded)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _currUser = InheritedData.of<User>(context).data;

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
                  child: const Center(
                    child: Text(
                      "BASIC SETTINGS",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
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
