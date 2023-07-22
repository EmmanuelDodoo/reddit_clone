import 'package:flutter/material.dart';
import 'package:reddit_clone/dummies.dart';
import 'package:reddit_clone/models/api/http_model.dart';
import 'package:reddit_clone/models/inherited-data.dart';
import '../components/default-post-card.dart';
import '../models/post.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late List<Widget> _postcards;
  // late final DataProvider<Widget> _dataProvider;

  Future<void> _loadHomePosts() async {
    var tempPosts = await RequestHandler.getHomePosts()
        .then((value) => value.map((map) => Post(jsonMap: map)));

    var cards = tempPosts.map((post) => DefaultPostCard(post: post)).toList();

    setState(() {
      _postcards = cards;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadHomePosts();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedData<List<Widget>>(
      data: _postcards,
      child: Scaffold(
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _loadHomePosts,
          child: ListView(
            children: _postcards,
          ),
        ),
      ),
    );
  }

  //Prevents the view from defaulting to the beginning
  @override
  bool get wantKeepAlive => true;
}
