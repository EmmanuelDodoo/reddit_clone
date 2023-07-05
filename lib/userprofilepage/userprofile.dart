import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/usersettingspage/usersettings.dart';

import '../models/inherited-data.dart';
import './posts.dart';
import './comments.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key? key, required int userId}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late User _viewedUser;

  User? _currUser;

  void handleEditProfile(BuildContext context) {
    if (_currUser != null && _currUser!.id == _viewedUser.id) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => UserSettings()));
      return;
    }
  }

  void getViewedUser() async {
    //TODO temp solution
    String file = "json/user.json";
    User usr = await rootBundle
        .loadString(file)
        .then((value) => User.fromJSON(json: value));
    setState(() {
      _viewedUser = usr;
    });
  }

  Widget _usernameSection(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 60),
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  _viewedUser.getUsername(),
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                (_currUser != null && _currUser!.id == _viewedUser.id
                    ? IconButton(
                        onPressed: () => handleEditProfile(context),
                        icon: const Icon(
                          Icons.edit_rounded,
                          color: Colors.white,
                        ),
                      )
                    : Container())
              ],
            ),
            Row(
              children: [
                Text(
                  "${_viewedUser.getKarma()} • ",
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _viewedUser.getUserAgeString(),
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
          image: NetworkImage(_viewedUser.getUserImageURL()),
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
    _currUser = InheritedData.of<User?>(context).data;

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
                      _viewedUser.getUsername(),
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

  @override
  void initState() {
    getViewedUser();
    super.initState();
  }
}
