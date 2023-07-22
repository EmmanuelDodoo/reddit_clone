import 'package:flutter/material.dart';

import '../components/default-post-card.dart';
import '../models/api/http_model.dart';
import '../models/post.dart';

class Popular extends StatefulWidget {
  const Popular({Key? key}) : super(key: key);

  @override
  State<Popular> createState() => _PopularState();
}

class _PopularState extends State<Popular> with AutomaticKeepAliveClientMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late List<Widget> _postcards;

  Future<void> _loadPopularPosts() async {
    var tempPosts = await RequestHandler.getPopularPosts()
        .then((value) => value.map((map) => Post(jsonMap: map)));

    var cards = tempPosts.map((post) => DefaultPostCard(post: post)).toList();

    setState(() {
      _postcards = cards;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPopularPosts();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _loadPopularPosts,
        child: ListView(
          children: _postcards,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
