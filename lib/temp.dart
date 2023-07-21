import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reddit_clone/models/api/http_model.dart';
import 'package:reddit_clone/models/comment.dart';

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

  void _tempFunction() {
    var requestBody = {
      "contents": "some test comment",
      "userId": 1,
      "ancestorId": -1
    };
    var token =
        "7b0438908599f45a0e56ba1ee93b0efb0cb741095a3a1ce0fea02664d71dbf21";

    // RequestHandler.getComment(pid: 1, cid: 1).then((value) async {
    //   Comment comment = Comment.simplified(jsonMap: value);
    //   print(comment.getReplies());
    //   await comment.reply(
    //       uid: 3, contents: "Some testing on frontend", token: token);
    //   print(comment.getReplies());
    // });

    RequestHandler.getAllPostComments(1).then((value) {
      var comments = List.of(value.map((e) => Comment.full(jsonMap: e)));
      print(comments);
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
                    _tempFunction();

                    setState(() {
                      _text = "Clicked!";
                    });

                    Timer(
                      const Duration(seconds: 3),
                      () {
                        setState(() {
                          _text = "Button";
                        });
                      },
                    );
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
