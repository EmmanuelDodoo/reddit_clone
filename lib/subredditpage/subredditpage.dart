import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reddit_clone/mainpage/home.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/models/subreddit.dart';
import 'package:reddit_clone/subredditpage/about.dart';

import '../components/default-popup-menu.dart';
import '../models/inherited-data.dart';

class SubredditPage extends StatefulWidget {
  SubredditPage({Key? key}) : super(key: key);

  @override
  State<SubredditPage> createState() => _SubredditPageState();
}

class _SubredditPageState extends State<SubredditPage> {
  late User _currUser;

  late Subreddit _subreddit;

  void loadSubreddit() async {
    String file = "json/subreddit.json";
    Subreddit sub = await rootBundle.loadString(file).then(
          (value) => Subreddit.fromJSON(json: value),
        );
    setState(() {
      _subreddit = sub;
    });
  }

  void handleSubscribe() {}

  Widget _subscribeButton() {
    bool hasSubscribed = _currUser
        .getSubreddits()
        .any((sub) => sub.getSubName() == _subreddit.getSubName());
    return IconButton(
      onPressed: handleSubscribe,
      icon: Icon(
        (hasSubscribed ? Icons.check_circle_outline_rounded : Icons.add),
        size: 30,
        color: Colors.white,
      ),
    );
  }

  Widget _subnameSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 60),
      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black45,
            ],
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(_subreddit.getSubImageURL()),
              ),
              Container(
                // margin: const EdgeInsets.only(left: 10),
                child: Text(
                  _subreddit.getSubName(),
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              _subscribeButton(),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            constraints: const BoxConstraints(
              maxWidth: 300,
            ),
            child: Text(
              _subreddit.getSubDescription(),
              softWrap: true,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _subHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(_subreddit.getSubThumbnail()),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _subnameSection(context),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    loadSubreddit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _currUser = InheritedData.of<User>(context).data;

    return InheritedData<Subreddit>(
      data: _subreddit,
      child: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                // These are the slivers that show up in the "outer" scroll view.
                return <Widget>[
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    sliver: SliverAppBar(
                      title: Text(
                        _subreddit.getSubName(),
                        style: const TextStyle(fontSize: 18),
                      ), // This is the title in the app bar.
                      pinned: true,
                      expandedHeight: 350.0,
                      flexibleSpace: FlexibleSpaceBar(
                        background: _subHeader(context),
                      ),
                      forceElevated: innerBoxIsScrolled,
                      actions: [
                        const DefaultPopUp(),
                      ],

                      bottom: const TabBar(
                        indicatorWeight: 3,
                        labelPadding: EdgeInsets.symmetric(vertical: 10),
                        tabs: [
                          Text(
                            "Posts",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            "About",
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
                child: TabBarView(
                  children: [
                    Home(),
                    SubredditAboutSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
