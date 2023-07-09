import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/components/authentication/login.dart';
import 'package:reddit_clone/createsubredditpage/page.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/usersettingspage/usersettings.dart';
import '../models/userprovider.dart';
import '../userprofilepage/userprofile.dart';

class RightDrawer extends StatelessWidget {
  RightDrawer({Key? key}) : super(key: key);
  User? _currUser;

  void _handleVisitProfile(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => UserProfile(
              userId: _currUser!.id,
            )));

    print("Going to user profile");
  }

  void _handleSignOut(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    _currUser = null;
    userProvider.setCurrentUser(user: null);
    Navigator.of(context).pop();
  }

  void _handleSignIn(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => LoginModal(),
    );
  }

  void _createSubreddit(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CreateSubredditPage()));
  }

  void _openSaved() {
    print("Open saved tapped");
  }

  void _openSettings(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => UserSettings()));
  }

  Widget _rightDrawerHeader(BuildContext context) {
    return DrawerHeader(
      padding: const EdgeInsets.all(0.0),
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(_currUser!.getUserImageURL()),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding:
              const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            _currUser!.getUsername(),
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Theme.of(context).colorScheme.inversePrimary),
          ),
        ),
      ),
    );
  }

  Widget _karmaSection(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 5),
                child: Icon(
                  Icons.filter_vintage_outlined,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${_currUser!.getKarma()}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    "Karma",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              )
            ],
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 5),
                child: Icon(
                  Icons.cake_rounded,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currUser!.getUserAgeString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    "Reddit age",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _rightDrawerList(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () => _handleVisitProfile(context),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: const Icon(
                      Icons.account_circle_outlined,
                      size: 20,
                    ),
                  ),
                  Text(
                    "My Profile",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => _createSubreddit(context),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: const Icon(
                      Icons.create_outlined,
                      size: 20,
                    ),
                  ),
                  Text(
                    "Create a community",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          letterSpacing: 0.8,
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
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: const Icon(
                      Icons.bookmarks_outlined,
                      size: 20,
                    ),
                  ),
                  Text(
                    "Saved",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => _openSettings(context),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: const Icon(
                      Icons.settings_outlined,
                      size: 20,
                    ),
                  ),
                  Text(
                    "Settings",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => _handleSignOut(context),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: const Icon(
                      Icons.logout_rounded,
                      size: 20,
                    ),
                  ),
                  Text(
                    "Sign out",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          letterSpacing: 0.8,
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

  Widget _signedInDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: 275,
            child: _rightDrawerHeader(context),
          ),
          _karmaSection(context),
          const Divider(),
          _rightDrawerList(context),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider = Provider.of<UserProvider>(context, listen: false);
    _currUser = provider.currentUser;
    if (_currUser == null) {
      return Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _handleSignIn(context),
              child: const Text(
                "Sign in",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      );
    }

    return _signedInDrawer(context);
  }
}
