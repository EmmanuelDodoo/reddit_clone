import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reddit_clone/models/api/http_model.dart';
import 'package:reddit_clone/models/comment.dart';
import 'package:reddit_clone/models/subreddit.dart';

import 'models/post.dart';

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
        "3e4d32ce79f05d4003e53efba8f61c9eebe41b85106289e7ef457038d70d2b3d";

    var token2 =
        "23e35afd2b136124b08df34b1bb3cd6181e2053cda4442276f49eb6516697dd0";

    // RequestHandler.getComment(pid: 1, cid: 1).then((value) async {
    //   Comment comment = Comment.simplified(jsonMap: value);
    //   print(comment.getReplies());
    //   await comment.reply(
    //       uid: 3, contents: "Some testing on frontend", token: token);
    //   print(comment.getReplies());
    // });

    RequestHandler.getSubreddit(1).then((value) async {
      Subreddit subreddit = Subreddit.full(jsonMap: value);
      print(subreddit);
      print(await subreddit.getPosts());
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
