import 'package:flutter/material.dart';
import 'package:reddit_clone/dummies.dart';
import 'package:reddit_clone/models/inherited-data.dart';

class UserPagePosts extends StatefulWidget {
  const UserPagePosts({Key? key}) : super(key: key);

  @override
  State<UserPagePosts> createState() => _UserPagePostsState();
}

class _UserPagePostsState extends State<UserPagePosts>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late List<Widget> _postcards;

  @override
  Widget build(BuildContext context) {
    _postcards = createAllPosts(context);

    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        color: Colors.white,
        backgroundColor: Colors.blue,
        strokeWidth: 1.5,
        onRefresh: () async {
          //Todo Make refresh actually mean something
          return Future<void>.delayed(const Duration(seconds: 3));
        },
        // child: ListView.builder(
        //   itemCount: 40,
        //   itemBuilder: (context, index) {
        //     return ListTile(
        //       title: Text("Post $index"),
        //     );
        //   },
        // ),
        child: ListView(
          children: _postcards,
        ),
      ),
    );
  }

  //Prevents the view from defaulting to the beginning
  @override
  bool get wantKeepAlive => true;
}
