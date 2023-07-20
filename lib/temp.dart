import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reddit_clone/models/api/http_model.dart';

class Temp extends StatefulWidget {
  const Temp({super.key});

  @override
  State<Temp> createState() => _TempState();
}

class _TempState extends State<Temp> {
  String _text = "Button";
  File? _testImage;

  Future<void> getImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      _testImage = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Playground",
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white24,
          appBar: AppBar(
            title: const Text("Playground"),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    var requestBody = {
                      "contents": "some test comment",
                      "userId": 1,
                      "ancestorId": -1
                    };
                    var token =
                        "dce4bf21ff940b50f2d801a337c1fb3a2f9faa218605b4e3ca52dbfd880b9dc6";
                    RequestHandler.getSubredditPosts(1)
                        .then((value) => print(value));

                    setState(() {
                      _text = "Clicked!";
                    });

                    Timer(const Duration(seconds: 3), () {
                      setState(() {
                        _text = "Button";
                      });
                    });
                  },
                  child: Text(_text),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
