import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUpModal extends StatefulWidget {
  ///Optional function to call after a successfull signup
  final void Function()? onCloseSuccessfully;

  const SignUpModal({Key? key, this.onCloseSuccessfully}) : super(key: key);

  @override
  State<SignUpModal> createState() => _SignUpModalState();
}

class _SignUpModalState extends State<SignUpModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  File? _selectedImage;
  bool _obscurePassword = true;

  Future<void> _getImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      _selectedImage = File(image.path);
    });
  }

  void _handlePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _handleSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // TODO form submission

      Navigator.of(context).pop();

      /// Call the on close successfully function from widget
      /// if any
      if (widget.onCloseSuccessfully != null) {
        widget.onCloseSuccessfully!();
      }
    }
  }

  Widget _header(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 15),
      child: Text(
        "Sign up",
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _textArea(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            style: Theme.of(context).textTheme.bodyMedium,
            controller: _emailController,
            decoration: const InputDecoration(
              prefixText: "    ",
              hintText: 'Email',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an email';
              }
              return null;
            },
          ),
          TextFormField(
            style: Theme.of(context).textTheme.bodyMedium,
            controller: _usernameController,
            decoration: const InputDecoration(
              prefixText: "u/",
              hintText: 'Username',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an username';
              }
              return null;
            },
          ),
          TextFormField(
            style: Theme.of(context).textTheme.bodyMedium,
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              prefixText: "    ",
              suffixIcon: IconButton(
                onPressed: _handlePasswordVisibility,
                iconSize: 18,
                icon: _obscurePassword
                    ? const Icon(
                        Icons.visibility_rounded,
                      )
                    : const Icon(
                        Icons.visibility_off_rounded,
                      ),
              ),
              hintText: 'Password',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _imageSection(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          Image.file(
            _selectedImage!,
            width: 45,
            height: 45,
            fit: BoxFit.cover,
          ),
          IconButton(
            onPressed: () => setState(() {
              _selectedImage = null;
            }),
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }

  Widget _imageSelection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _selectedImage != null
              ? _imageSection(context)
              : TextButton(
                  onPressed: _getImageFromGallery,
                  child: const Text("Choose profile picture"),
                ),
        ],
      ),
    );
  }

  Widget _buttons(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _handleSubmit(context),
            child: const Text('Sign up'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            _header(context),
            _textArea(context),
            _imageSelection(context),
            _buttons(context),
          ],
        ),
      ),
    );
  }
}
