import 'package:flutter/material.dart';
import 'package:reddit_clone/models/base-post-card.dart';
import 'package:reddit_clone/models/post.dart';

class PostPagePostCard extends BasePostCard {
  PostPagePostCard({
    Key? key,
    required Post post,
  }) : super(key: key, post: post, withCard: false);

  @override
  void openPost(BuildContext context) {}

  @override
  void onDoubleTap() {}

  @override
  void setFooter() {}

  @override
  Widget justTextContent() {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Text(
        post.getContents(),
        style: const TextStyle(
          fontSize: 16,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  @override
  Widget justImageContent(BuildContext context, {double maxHeight = 0.75}) {
    return super.justImageContent(context, maxHeight: maxHeight);
  }

  @override
  Widget image(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
          onTap: () => viewImage(),
          splashColor: Colors.black.withAlpha(100),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.15,
            ),
            child: Image.network(
              post.getImageURL(),
              fit: BoxFit.fitWidth,
            ),
          )),
    );
  }

  @override
  Widget textWithImage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        justTextContent(),
        justImageContent(context),
      ],
    );
  }

  @override
  Widget cardContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          header(context),
          title(),
          content(context),
        ],
      ),
    );
  }
}
