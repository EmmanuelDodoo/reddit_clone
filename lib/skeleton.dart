import 'package:flutter/material.dart';

class Skeleton extends StatelessWidget {
  Skeleton({Key? key, required this.currPage}) : super(key: key);
  late final Widget currPage;
  final List<String> comm = ["Perry,", "The List", "Builder?!"];

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

  void _visitSubreddit({required int id}) {
    print("Visiting subreddit with id $id");
  }

  void _goToHome() {
    print("Go home tapped");
  }

  void _goToCreate() {
    print("go create tapped");
  }

  void _goToChat() {
    print("Go to chat tapped");
  }

  void _goToNotifications() {
    print("Go to notifications tapped");
  }

  Widget _userAvatar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: () => Scaffold.of(context).openEndDrawer(),
        child: const CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(
              "https://images.pexels.com/photos/5022847/pexels-photo-5022847.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
        ),
      ),
    );
  }

  Widget _rightDrawerHeader() {
    return DrawerHeader(
      padding: const EdgeInsets.all(0.0),
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              "https://images.pexels.com/photos/15828302/pexels-photo-15828302.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: InkWell(
            onTap: _signOutSnackBar,
            child: const Text(
              "Todo User name",
              style: TextStyle(fontSize: 30, color: Colors.amberAccent),
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
                children: const [
                  Text(
                    "578",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
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
                children: const [
                  Text(
                    "2y 7m",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
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
    return Container(
      height: 225,
      margin: const EdgeInsets.only(left: 15, top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: _visitUser,
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
          InkWell(
            onTap: _createSubreddit,
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
          InkWell(
            onTap: _openSaved,
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
          InkWell(
            onTap: _openSettings,
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
          )
        ],
      ),
    );
  }

  Drawer _rightDrawer() {
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

  Widget _leftDrawerListInator(
      {required String name, String imageURL = "", required int id}) {
    if (imageURL == "") {
      imageURL =
          "https://images.pexels.com/photos/4016597/pexels-photo-4016597.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1";
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 25, left: 20),
      child: InkWell(
        onTap: () => _visitSubreddit(id: id),
        child: Row(
          children: [
            CircleAvatar(
              radius: 13,
              backgroundImage: NetworkImage(imageURL),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: Text(
                "r/$name",
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
          ...comm.map((e) => _leftDrawerListInator(name: e, id: 1))
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
    return Scaffold(
      drawer: _leftDrawer(),
      endDrawer: _rightDrawer(),
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
              onPressed: _goToHome,
              icon: bottomIcons(identifier: "MainPage"),
            ),
            IconButton(
              onPressed: _goToCreate,
              icon: bottomIcons(identifier: "CreatePage"),
            ),
            IconButton(
              onPressed: _goToChat,
              icon: bottomIcons(identifier: "ChatsPage"),
            ),
            IconButton(
              onPressed: _goToNotifications,
              icon: bottomIcons(identifier: "NotificationsPage"),
            )
          ],
        ),
      ),
    );
  }
}
