import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/components/authentication/login.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/models/subreddit.dart';
import 'package:reddit_clone/subreddit_page/about.dart';
import 'package:reddit_clone/subreddit_page/posts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/default_popup_menu.dart';
import '../models/api/request_handler.dart';
import '../models/inherited_data.dart';
import '../models/user_provider.dart';

class SubredditPage extends StatefulWidget {
  const SubredditPage({Key? key, required this.subreddit}) : super(key: key);
  final Subreddit subreddit;

  @override
  State<SubredditPage> createState() => _SubredditPageState();
}

class _SubredditPageState extends State<SubredditPage> {
  User? _currUser;
  late Subreddit _subreddit;
  late bool hasSubscribed = _currUser != null &&
      _currUser!.getSubreddits().any((sub) => sub.id == _subreddit.id);

  void handleSubscribe() async {
    if (_currUser == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) => const LoginModal(),
      );
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("tokenValue");
    try {
      await RequestHandler.subscribeToSubreddit(
          uid: _currUser!.id, sid: _subreddit.id, token: token!);

      setState(() {
        hasSubscribed = true;
      });
      // ignore: use_build_context_synchronously
      UserProvider provider = Provider.of<UserProvider>(context, listen: false);
      await provider.refreshUser();

      // ignore: use_build_context_synchronously
      _showSnackBar(context, "Successfully Subscribed!", false);
    } catch (e) {
      // ignore: use_build_context_synchronously
      _showSnackBar(
          context, "Sorry something went wrong. Please try again", true);
    }
  }

  void handleUnSubscribe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("tokenValue");
    try {
      await RequestHandler.unsubscribeToSubreddit(
          uid: _currUser!.id, sid: _subreddit.id, token: token!);

      setState(() {
        hasSubscribed = false;
      });

      // ignore: use_build_context_synchronously
      UserProvider provider = Provider.of<UserProvider>(context, listen: false);
      await provider.refreshUser();

      // ignore: use_build_context_synchronously
      _showSnackBar(context, "Successfully Unsubscribed!", false);
    } catch (e) {
      // ignore: use_build_context_synchronously
      _showSnackBar(
          context, "Sorry something went wrong. Please try again", true);
    }
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _showSnackBar(
      BuildContext context, String message, bool isError) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                // ?.copyWith(color: isError ? Colors.red : Colors.green[400]),
                ?.copyWith(
                    color: isError
                        ? Theme.of(context).colorScheme.errorContainer
                        : Theme.of(context).colorScheme.primary)),
      ),
    );
  }

  Widget _subscribeButton() {
    return IconButton(
      onPressed: () {
        if (hasSubscribed) {
          handleUnSubscribe();
          return;
        }
        handleSubscribe();
      },
      icon: Icon(
        (hasSubscribed ? Icons.check_circle_outline_rounded : Icons.add),
        size: 30,
        color: Colors.white,
      ),
    );
  }

  Widget _subNameSection(BuildContext context) {
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
              Text(_subreddit.getSubName(),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.white)),
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
              _subNameSection(context),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _subreddit = widget.subreddit;
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    Color appBarTextColor = isDark
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.primaryContainer;
    UserProvider provider = Provider.of<UserProvider>(context, listen: false);
    _currUser = provider.currentUser;

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
                      actions: const [
                        DefaultPopUp(),
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
                    // _subPosts(context),
                    SubredditPosts(subreddit: _subreddit),
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
