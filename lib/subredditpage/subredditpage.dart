import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/components/authentication/login.dart';
import 'package:reddit_clone/mainpage/home.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/models/subreddit.dart';
import 'package:reddit_clone/subredditpage/about.dart';

import '../components/default-popup-menu.dart';
import '../models/inherited-data.dart';
import '../models/userprovider.dart';

class SubredditPage extends StatefulWidget {
  SubredditPage({Key? key}) : super(key: key);

  @override
  State<SubredditPage> createState() => _SubredditPageState();
}

class _SubredditPageState extends State<SubredditPage> {
  User? _currUser;

  late Subreddit _subreddit;
  List<Subreddit> _currUserSubreddits = [];

  void _loadCurrUserSubreddits() async {
    var temp = await _currUser!.getSubreddits();

    setState(() {
      _currUserSubreddits = temp;
    });
  }

  void handleSubscribe() {
    if (_currUser == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) => LoginModal(),
      );
    }
  }

  Widget _subscribeButton() {
    bool hasSubscribed = _currUser != null &&
        _currUser!.getSubreddits().any((sub) => sub.id == _subreddit.id);
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
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Theme.of(context).colorScheme.inversePrimary.withAlpha(100),
          ],
        ),
      ),
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
                child: Text(_subreddit.getSubName(),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white)),
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
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white),
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    Color appBarTextColor = isDark
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.primaryContainer;
    UserProvider provider = Provider.of<UserProvider>(context, listen: false);
    _currUser = provider.currentUser;
    _loadCurrUserSubreddits();

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
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: appBarTextColor),
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
                        tabs: [
                          Text(
                            "Posts",
                          ),
                          Text(
                            "About",
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
