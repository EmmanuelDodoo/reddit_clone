import 'package:flutter/material.dart';
import 'package:reddit_clone/models/user.dart';

class RightDrawer extends StatelessWidget {
  RightDrawer({Key? key, required User currUser})
      : _currUser = currUser,
        super(key: key);
  late final User _currUser;

  void _visitUser() {
    print("Going to user profile");
  }

  void _signOutSnackBar() {
    print("Where is my sign out snack bar");
  }

  void _createSubreddit() {
    print("Create subreddit tapped");
  }

  void _openSaved() {
    print("Open saved tapped");
  }

  void _openSettings() {
    print("Open settings");
  }

  Widget _rightDrawerHeader() {
    return DrawerHeader(
      padding: const EdgeInsets.all(0.0),
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(_currUser.getUserImageURL()),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: InkWell(
            onTap: _signOutSnackBar,
            child: Text(
              _currUser.getUsername(),
              style: const TextStyle(fontSize: 30, color: Colors.amberAccent),
            )),
      ),
    );
  }

  Widget _karmaSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 5),
                child: const Icon(
                  Icons.filter_vintage_outlined,
                  color: Colors.blue,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${_currUser.getKarma()}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Karma",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                ],
              )
            ],
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 5),
                child: const Icon(
                  Icons.cake_rounded,
                  color: Colors.blue,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currUser.userAgeString,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Reddit age",
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _rightDrawerList() {
    return SizedBox(
      height: 225,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: _visitUser,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: const Icon(Icons.account_circle_outlined),
                  ),
                  const Text(
                    "My Profile",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: _createSubreddit,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: const Icon(Icons.create_outlined),
                  ),
                  const Text(
                    "Create a community",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: _openSaved,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: const Icon(Icons.bookmarks_outlined),
                  ),
                  const Text(
                    "Saved",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: _openSettings,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: const Icon(Icons.settings_outlined),
                  ),
                  const Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: 350,
            child: _rightDrawerHeader(),
          ),
          _karmaSection(),
          Container(
            margin: const EdgeInsets.only(top: 15),
            height: .6,
            color: Colors.blueGrey,
          ),
          _rightDrawerList(),
        ],
      ),
    );
  }
}
