import 'package:flutter/material.dart';
import 'package:reddit_clone/models/inherited-data.dart';

class UserPageComments extends StatefulWidget {
  const UserPageComments({Key? key}) : super(key: key);

  @override
  State<UserPageComments> createState() => _UserPageCommentsState();
}

class _UserPageCommentsState extends State<UserPageComments>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
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
        child: ListView.builder(
          itemCount: 40,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("Comment $index"),
            );
          },
        ),
      ),
    );
  }

  //Prevents the view from defaulting to the beginning
  @override
  bool get wantKeepAlive => true;
}
