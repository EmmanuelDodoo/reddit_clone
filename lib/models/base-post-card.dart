import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/models/api/http_model.dart';
import 'package:reddit_clone/models/post.dart';
import 'package:reddit_clone/models/subreddit.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/models/userprovider.dart';
import 'package:reddit_clone/postpage/postpage.dart';
import '../components/default-popup-menu.dart';
import '../subredditpage/subredditpage.dart';
import '../userprofilepage/userprofile.dart';

abstract class BasePostCard extends StatelessWidget {
  late final Post post;
  late final bool withCard;
  BasePostCard({Key? key, required this.post, this.withCard = true})
      : super(key: key);

  //TODO Implement event handlers. Maybe mix in a different class to handle them?
  void viewImage() {
    print("View Image");
  }

  Future<Subreddit> _fetchSubreddit() async {
    return await RequestHandler.getSubreddit(post.getSubreddit().id)
        .then((value) => Subreddit.full(jsonMap: value));
  }

  Future<User> _fetchUser() async {
    return await RequestHandler.getUser(post.getUser().id)
        .then((value) => User(jsonMap: value));
  }

  void goToSubreddit(BuildContext context) async {
    var sub = await _fetchSubreddit();
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SubredditPage(
              subreddit: sub,
            )));
  }

  void goToUserProfile(BuildContext context) async {
    var usr = await _fetchUser();
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserProfile(
          viewedUser: usr,
        ),
      ),
    );
  }

  void openPost(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Consumer<UserProvider>(
        builder: (context, provider, _) {
          return PostPage(post: post);
        },
      ),
    ));
  }

  void onDoubleTap(BuildContext context) {
    throw Exception("Unimplemented method");
  }

  void setFooter() {
    throw Exception("Unimplemented method");
  }

  Widget subredditAvatar(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(right: 10),
        child: InkWell(
          borderRadius: BorderRadius.circular(150),
          onTap: () => goToSubreddit(context),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(post.getSubImageURL()),
          ),
        ));
  }

  Widget subredditAndUserId(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 2),
          child: GestureDetector(
            onTap: () => goToSubreddit(context),
            child: Text(
              post.getSubName(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () => goToUserProfile(context),
              child: Text(
                post.getUserName(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            Text(
              "  •${post.timeDifference}",
              style: Theme.of(context).textTheme.bodySmall,
            )
          ],
        )
      ],
    );
  }

  Widget header(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                subredditAvatar(context),
                subredditAndUserId(context),
              ],
            ),
            const DefaultPopUp()
          ],
        ));
  }

  Widget title(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 5),
      child: Text(
        post.getTitle(),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        // style: const TextStyle(
        //   fontSize: 20,
        //   fontWeight: FontWeight.bold,
        // ),
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget justTextContent(BuildContext context) {
    throw Exception("Unimplemented method");
  }

  Widget justImageContent(BuildContext context, {double maxHeight = 0.5}) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height * maxHeight,
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: () => viewImage(),
          splashColor: Colors.blue.withAlpha(100),
          child: Image.network(
            post.getImageURL(),
            fit: BoxFit.fitWidth,
            width: MediaQuery.of(context).size.width * 0.9,
          ),
        ),
      ),
    );
  }

  /// Image section for a textWithImage
  Widget image(BuildContext context) {
    throw Exception("Unimplemented method");
  }

  Widget textWithImage(BuildContext context) {
    throw Exception("Unimplemented method");
  }

  Widget content(BuildContext context) {
    //if just text contents
    if (post.getContents() != "" && !post.isImageInPost()) {
      return justTextContent(context);
    }
    //if just image contents
    else if (post.isImageInPost() && post.getContents() == "") {
      return justImageContent(context);
    }
    //if both text and image
    else if (post.isImageInPost() && post.getContents() != "") {
      return textWithImage(context);
    }
    //if none of the two
    return Container();
  }

  Widget cardContent(BuildContext context) {
    throw Exception("Unimplemented method");
  }

  Widget _prebuild(BuildContext context) {
    return InkWell(
      splashColor: Colors.blueGrey.withAlpha(75),
      onTap: () => openPost(context),
      onDoubleTap: () => onDoubleTap(context),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        child: cardContent(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    setFooter();
    if (withCard) {
      return Card(
        child: _prebuild(context),
      );
    } else {
      return Card(child: _prebuild(context));
    }
  }
}
