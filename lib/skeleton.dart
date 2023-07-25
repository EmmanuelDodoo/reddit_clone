import 'package:flutter/material.dart';
import 'package:reddit_clone/components/left_drawer.dart';
import 'package:reddit_clone/components/right_drawer.dart';
import 'package:reddit_clone/components/authentication/login.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/models/user_provider.dart';
import 'package:reddit_clone/components/skeleton_bottom_app_nav.dart';

// ignore: must_be_immutable
class Skeleton extends StatelessWidget {
  Skeleton({Key? key, required this.currPage, required this.selectedIndex})
      : super(key: key);
  late final Widget currPage;
  int selectedIndex;
  User? _currUser;

  Widget _userAvatar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: () {
          if (_currUser != null) {
            Scaffold.of(context).openEndDrawer();
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) => const LoginModal(),
            );
          }
        },
        child: _currUser == null
            ? Center(
                child: Text(
                  "Login",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              )
            : CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(_currUser!.getUserImageURL()),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider = Provider.of<UserProvider>(context, listen: false);
    _currUser = provider.currentUser;
    // _userSubreddits = _currUser == null ? [] : _currUser!.getSubreddits();
    return Scaffold(
      // drawer: _leftDrawer(),
      drawer: const LeftDrawer(),
      endDrawer: RightDrawer(),
      appBar: AppBar(
        backgroundColor: AppBarTheme.of(context).backgroundColor,
        elevation: 0,
        actions: [
          Builder(
            builder: (BuildContext context) {
              return _userAvatar(context);
            },
          ),
        ],
      ),
      body: currPage,
      // bottomNavigationBar: _bottomNavBar(context),
      bottomNavigationBar: SkeletonBottomNav(selectedIndex: selectedIndex),
    );
  }
}
