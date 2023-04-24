import 'package:flutter/material.dart';
import 'mainpage/mainpage.dart';
import 'models/user.dart';
import 'temp.dart';
// import 'rem.dart';
import 'skeleton.dart';
import 'dummies.dart';
import "package:reddit_clone/postpage/postpage.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String userfile = "user.json";
    String postfile = "image.json";
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: readUserJSON(context: context, file: userfile),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            User user = makeDummyUser(snapshot.data ?? "");
            // return Skeleton(
            //     currPage: const MainPage(),
            //     currUser: makeDummyUser(snapshot.data ?? ""));
            // return PostPage(currUser: makeDummyUser(snapshot.data ?? ""),);
            return FutureBuilder(
              future: readPostJSON(context: context, file: postfile),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null) {
                  return PostPage(
                      currUser: user, post: makeDummyPost(snapshot.data ?? ""));
                } else {
                  return const CircularProgressIndicator();
                }
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      // home: const MyStatelessWidget(),
    );
  }
}
