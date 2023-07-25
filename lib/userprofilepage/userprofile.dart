import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/usersettingspage/usersettings.dart';

import '../models/inherited-data.dart';
import '../models/userprovider.dart';
import './posts.dart';
import './comments.dart';

class UserProfile extends StatefulWidget {
  final User viewedUser;
  const UserProfile({Key? key, required this.viewedUser}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late User _viewedUser = widget.viewedUser;

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
        .then((value) => User(jsonMap: jsonDecode(value)));
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
            Container(
              margin: const EdgeInsets.only(left: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _viewedUser.getUsername(),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white),
                  ),
                  (_currUser != null && _currUser!.id == _viewedUser.id
                      ? IconButton(
                          onPressed: () => handleEditProfile(context),
                          iconSize: 20,
                          icon: const Icon(
                            Icons.edit_rounded,
                            color: Colors.white,
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.only(top: 30, right: 15),
                          width: 20,
                          height: 20,
                        ))
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "${_viewedUser.getKarma()} • ",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white),
                ),
                Text(
                  _viewedUser.getUserAgeString(),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white),
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
    bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    Color appBarTextColor = isDark
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.primaryContainer;
    UserProvider provider = Provider.of<UserProvider>(context, listen: false);
    _currUser = provider.currentUser;

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
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: appBarTextColor),
                    ), // This is the title in the app bar.
                    pinned: true,
                    expandedHeight: 350.0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: _userHeader(context),
                    ),
                    forceElevated: innerBoxIsScrolled,

                    bottom: const TabBar(
                      tabs: [
                        Text(
                          "Posts",
                        ),
                        Text(
                          "Comments",
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: Container(
              margin: const EdgeInsets.only(top: 105),
              child: TabBarView(
                children: [
                  UserPagePosts(
                    viewedUser: widget.viewedUser,
                  ),
                  UserPageComments(
                    viewedUser: widget.viewedUser,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
