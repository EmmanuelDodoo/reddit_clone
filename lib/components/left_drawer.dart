import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/models/user.dart';

import '../models/api/request_handler.dart';
import '../models/subreddit.dart';
import '../models/user_provider.dart';
import '../subreddit_page/subreddit_page.dart';

class LeftDrawer extends StatefulWidget {
  const LeftDrawer({super.key});

  @override
  State<LeftDrawer> createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  User? _currUser;

  Future<Subreddit> _fetchSubreddit(int id) async {
    return await RequestHandler.getSubreddit(id)
        .then((value) => Subreddit.full(jsonMap: value));
  }

  void _visitSubreddit({required int id}) async {
    var sub = await _fetchSubreddit(id);

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();

    // ignore: use_build_context_synchronously
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SubredditPage(
              subreddit: sub,
            )));
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

    var subreddits = _currUser == null ? [] : _currUser!.getSubreddits();

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
          ...subreddits.map((sub) => _leftDrawerListInator(
              name: sub.getSubName(),
              id: sub.id,
              imageURL: sub.getSubImageURL()))
        ],
      ),
    );
  }
}
