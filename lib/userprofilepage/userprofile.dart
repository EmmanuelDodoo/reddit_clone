import 'package:flutter/material.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/usersettingspage/usersettings.dart';

import '../models/inherited-data.dart';
import './posts.dart';
import './comments.dart';

class UserProfile extends StatelessWidget {
  UserProfile({Key? key}) : super(key: key);
  late User _currUser;

  void handleEditProfile(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => UserSettings()));
  }

  Widget _usernameSection(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 60),
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  _currUser.getUsername(),
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () => handleEditProfile(context),
                  icon: const Icon(
                    Icons.edit_rounded,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  "${_currUser.getKarma()} • ",
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _currUser.userAgeString,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                )
              ],
            )
          ],
        ));
  }

  Widget _userHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(_currUser.getUserImageURL()),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _usernameSection(context),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _currUser = InheritedData.of<User>(context).data;

    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              // These are the slivers that show up in the "outer" scroll view.
              return <Widget>[
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    title: Text(
                      _currUser.getUsername(),
                      style: const TextStyle(fontSize: 18),
                    ), // This is the title in the app bar.
                    pinned: true,
                    expandedHeight: 350.0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: _userHeader(context),
                    ),
                    forceElevated: innerBoxIsScrolled,

                    bottom: const TabBar(
                      indicatorWeight: 3,
                      labelPadding: EdgeInsets.symmetric(vertical: 10),
                      tabs: [
                        Text(
                          "Posts",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Comments",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: Container(
              margin: const EdgeInsets.only(top: 105),
              child: const TabBarView(
                children: [
                  UserPagePosts(),
                  UserPageComments(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
