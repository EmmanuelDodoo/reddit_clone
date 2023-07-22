import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/models/user.dart';

import '../models/subreddit.dart';
import '../models/userprovider.dart';

class LeftDrawer extends StatefulWidget {
  const LeftDrawer({super.key});

  @override
  State<LeftDrawer> createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  User? _currUser;
  List<Subreddit> _currUserSubreddits = [];

  void _loadCurrUserSubreddits() async {
    var temp = await _currUser!.getSubreddits();

    setState(() {
      _currUserSubreddits = temp;
    });
  }

  void _visitSubreddit({required int id}) {
    print("Visiting subreddit with id $id");
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

  @override
  Widget build(BuildContext context) {
    UserProvider provider = Provider.of<UserProvider>(context, listen: false);
    _currUser = provider.currentUser;

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
          ..._currUserSubreddits.map((sub) => _leftDrawerListInator(
              name: sub.getSubName(),
              id: sub.id,
              imageURL: sub.getSubImageURL()))
        ],
      ),
    );
  }
}
