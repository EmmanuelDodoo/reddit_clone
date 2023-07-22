import 'package:flutter/material.dart';
import 'package:reddit_clone/components/leftDrawer.dart';
import 'package:reddit_clone/components/rightdrawer.dart';
import 'package:reddit_clone/createpostpage/createpostpage.dart';
import 'package:reddit_clone/components/authentication/login.dart';
import 'package:reddit_clone/mainpage/mainpage.dart';
import 'package:reddit_clone/models/subreddit.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/models/inherited-data.dart';
import 'package:reddit_clone/models/userprovider.dart';
import 'package:reddit_clone/components/skeletonBottomAppNav.dart';

class Skeleton extends StatelessWidget {
  Skeleton({Key? key, required this.currPage, required this.selectedIndex})
      : super(key: key);
  late final Widget currPage;
  int selectedIndex;
  User? _currUser;
  List<Subreddit> _userSubreddits = [];

  void _visitSubreddit({required int id}) {
    print("Visiting subreddit with id $id");
  }

  void _goToHome(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const MainPage()));
  }

  void _goToCreate(BuildContext context) {
    if (_currUser == null) {
      showDialog(
          context: context, builder: (BuildContext context) => LoginModal());
      return;
    }

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CreatePostPage()));
  }

  void _goToChat(BuildContext context) {
    print("Go to chat tapped");
  }

  void _goToNotifications(BuildContext context) {
    print("Go to notifications tapped");
  }

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
              builder: (BuildContext context) => LoginModal(),
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

  Widget _leftDrawerListInator(
      {required String name, String imageURL = "", required int id}) {
    if (imageURL == "") {
      imageURL =
          "https://images.pexels.com/photos/4016597/pexels-photo-4016597.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1";
    }
    return InkWell(
      onTap: () => _visitSubreddit(id: id),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Row(
          children: [
            CircleAvatar(
              radius: 13,
              backgroundImage: NetworkImage(imageURL),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Drawer _leftDrawer() {
    return Drawer(
      child: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 25, bottom: 20),
            child: const Center(
              child: Text(
                "Your communities: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          ..._userSubreddits.map((sub) => _leftDrawerListInator(
              name: sub.getSubName(),
              id: sub.id,
              imageURL: sub.getSubImageURL()))
        ],
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
      drawer: LeftDrawer(),
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
