import 'package:flutter/material.dart';
import 'package:reddit_clone/models/post.dart';
import 'package:reddit_clone/postpage/postpage.dart';
import 'default-popup-menu.dart';

abstract class BasePostCard extends StatelessWidget {
  late final Post post;
  late final bool withCard;
  BasePostCard({Key? key, required this.post, this.withCard = true})
      : super(key: key);

  //TODO Implement event handlers. Maybe mix in a different class to handle them?
  void viewImage() {
    print("View Image");
  }

  void goToSubreddit() {
    print("Go to subreddit");
  }

  void goToUserProfile() {
    print('Go to user profile');
  }

  void openPost(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => PostPage(post: post)));
  }

  void onDoubleTap() {
    throw Exception("Unimplemented method");
  }

  void setFooter() {
    throw Exception("Unimplemented method");
  }

  Widget subredditAvatar() {
    return Container(
        margin: const EdgeInsets.only(right: 10),
        child: InkWell(
          onTap: goToSubreddit,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(post.getSubImageURL()),
          ),
        ));
  }

  Widget subredditAndUserId() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 2),
          child: GestureDetector(
            onTap: goToSubreddit,
            child: Text(
              post.getSubName(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: goToUserProfile,
              child: Text(
                post.getUserName(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              "  •${post.timeDifference}",
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        )
      ],
    );
  }

  Widget header() {
    return Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                subredditAvatar(),
                subredditAndUserId(),
              ],
            ),
            const DefaultPopUp()
          ],
        ));
  }

  Widget title() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 5),
      child: Text(
        post.getTitle(),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget justTextContent() {
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
      return justTextContent();
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
    return Container(
      color: Colors.amberAccent,
      child: InkWell(
        splashColor: Colors.blueGrey.withAlpha(75),
        onTap: () => openPost(context),
        onDoubleTap: onDoubleTap,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.95,
          child: cardContent(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    setFooter();
    if (withCard) {
      return Card(
        elevation: 8,
        color: Colors.amberAccent,
        clipBehavior: Clip.hardEdge,
        child: _prebuild(context),
      );
    } else {
      return _prebuild(context);
    }
  }
}
