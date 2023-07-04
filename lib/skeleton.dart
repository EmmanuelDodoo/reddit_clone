import 'package:flutter/material.dart';
import 'package:reddit_clone/components/rightdrawer.dart';
import 'package:reddit_clone/createpage/createpage.dart';
import 'package:reddit_clone/mainpage/mainpage.dart';
import 'package:reddit_clone/models/subreddit.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/models/inherited-data.dart';

class Skeleton extends StatelessWidget {
  Skeleton({Key? key, required this.currPage}) : super(key: key);
  late final Widget currPage;
  late User _currUser;
  late List<Subreddit> _userSubreddits;

  void _visitSubreddit({required int id}) {
    print("Visiting subreddit with id $id");
  }

  void _goToHome(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const MainPage()));
  }

  void _goToCreate(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CreatePage()));
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
        onTap: () => Scaffold.of(context).openEndDrawer(),
        child: CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(_currUser.getUserImageURL()),
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

  /// Return the appropriate icon for the identifier, taking
  /// note of the current page
  Icon bottomIcons({required String identifier}) {
    String currPageString = currPage.toString();

    if (identifier == "MainPage") {
      if (currPageString == identifier) {
        return const Icon(Icons.home);
      }
      return const Icon(Icons.home_outlined);
    } else if (identifier == "ChatsPage") {
      if (currPageString == identifier) {
        return const Icon(Icons.chat);
      }
      return const Icon(Icons.chat_outlined);
    } else if (identifier == "NotificationsPage") {
      if (identifier == currPageString) {
        return const Icon(Icons.notifications);
      }
      return const Icon(Icons.notifications_outlined);
    }
    return const Icon(Icons.add);
  }

  @override
  Widget build(BuildContext context) {
    _currUser = InheritedData.of<User>(context).data;
    _userSubreddits = _currUser.getSubreddits();
    return Scaffold(
      drawer: _leftDrawer(),
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
      bottomNavigationBar: BottomAppBar(
        color: BottomAppBarTheme.of(context).color,
        height: MediaQuery.of(context).size.height * 0.06,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              onPressed: () => _goToHome(context),
              icon: bottomIcons(identifier: "MainPage"),
            ),
            IconButton(
              onPressed: () => _goToCreate(context),
              icon: bottomIcons(identifier: "CreatePage"),
            ),
            IconButton(
              onPressed: () => _goToChat(context),
              icon: bottomIcons(identifier: "ChatsPage"),
            ),
            IconButton(
              onPressed: () => _goToNotifications(context),
              icon: bottomIcons(identifier: "NotificationsPage"),
            )
          ],
        ),
      ),
    );
  }
}
