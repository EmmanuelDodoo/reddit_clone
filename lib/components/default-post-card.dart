import 'package:flutter/material.dart';
import 'package:reddit_clone/models/base-post-card.dart';
import 'package:reddit_clone/components/default-footer.dart';
import 'package:reddit_clone/models/post.dart';

class DefaultPostCard extends BasePostCard {
  final GlobalKey<DefaultFooterState> _footerKey =
      GlobalKey<DefaultFooterState>();
  DefaultFooter? _footer;

  ///The footer is the only stateful section of a post's card which is why
  ///I factored it out
  @override
  void setFooter() {
    _footer = DefaultFooter(
      key: _footerKey,
      post: post,
    );
  }

  DefaultPostCard({Key? key, required Post post}) : super(key: key, post: post);

  @override
  void onDoubleTap() {
    _footerKey.currentState?.updateVote(update: 1);
  }

  @override
  Widget justTextContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Text(
        post.getContents(),
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
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
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            //The margins throughout the card means the with must be less than 50%
            width: MediaQuery.of(context).size.width * 0.43,
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text(
                post.getContents(),
                overflow: TextOverflow.ellipsis,
                maxLines: 6,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.41,
            child: image(context),
          )
        ],
      ),
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
          title(context),
          content(context),
          Container(margin: const EdgeInsets.only(top: 15), child: _footer),
        ],
      ),
    );
  }
}
