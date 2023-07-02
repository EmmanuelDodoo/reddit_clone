import 'package:flutter/material.dart';
import 'package:reddit_clone/dummies.dart';
import 'package:reddit_clone/models/base_provider.dart';
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

  Future<String> readPostJSON(
      {required BuildContext context, required String file}) async {
    AssetBundle bundle = DefaultAssetBundle.of(context);
    return Future(() => bundle.loadString("json/$file"));
  }

  Post makeDummyPost(String json) {
    return Post.fromJSON(json: json, withComments: true);
  }

  List<Widget> getHomePosts(BuildContext context) {
    List<String> postswithextension = List.from(posts.map((p) => "$p.json"));
    List<Widget> postcards = List.from(
      postswithextension.map(
        (e) => FutureBuilder(
          future: readPostJSON(context: context, file: e),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              return DefaultPostCard(post: makeDummyPost(snapshot.data ?? ""));
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );

    return postcards;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _postcards = createAllPosts(context);
    return InheritedData<List<Widget>>(
      data: _postcards,
      child: Scaffold(
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          color: Colors.white,
          backgroundColor: Colors.blue,
          strokeWidth: 1.5,
          onRefresh: () async {
            //Todo Make refresh actually mean something
            return Future<void>.delayed(const Duration(seconds: 3));
          },
          // child: ListView(
          //   children: _postcards,
          // ),
          // child: ListView.builder(
          //   itemCount: _postcards.length,
          //   itemBuilder: (context, index) {
          //     return InkWell(
          //       onTap: () {
          //         print("Hoping");
          //       },
          //       child: _postcards[index],
          //     );
          //   },
          // ),
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
