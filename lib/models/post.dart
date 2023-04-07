import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reddit_clone/models/postStructure.dart';

///Stateful widget for the footer of a post since that's the
/// only section which will change with time
///
class Footer extends StatefulWidget {
  /*
  * The vote code indicates whether the user has voted on a post
  * -1 : downvoted post
  * 0 : has not voted
  * 1: upvoted post
  * */
  Footer(
      {Key? key,
      required this.votesNumber,
      required this.commentNumber,
      required this.voteCode})
      : super(key: key);

  int votesNumber;
  int commentNumber;
  int voteCode;

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  late int votesNumber;
  late int commentNumber;
  late int voteCode;

  @override
  void initState() {
    //Set the initial values to what was passed to Footer
    // Can't pass it down otherwise
    voteCode = widget.voteCode;
    commentNumber = widget.commentNumber;
    votesNumber = widget.votesNumber;

    super.initState();
  }

  /// Sends an Http request to change the votes of a post
  /// while also updating the votes number of this post.
  ///
  /// update: int in range [-2, 2]
  ///
  /// After operation, votesNumber = votesNumber+update
  /// voteCode = voteCode + update
  ///
  void updateVote({required int update}) {
    //TODO: Send http request

    setState(() {
      votesNumber = votesNumber + update;
      voteCode = voteCode + update;
    });
  }

  /// Return a string version of number with the suffices, 'k', 'm' added as
  /// needed
  String formatNumber({required int number}) {
    if (number > 999999) {
      double temp = number / 1000000;
      return "${temp.toStringAsFixed(1)}m";
    } else if (number > 999) {
      double temp = number / 1000;
      return "${temp.toStringAsFixed(1)}k";
    }
    return "$number";
  }

  /// Handle voting on a post.
  /// vCode: the code of the vote being cast, 1 if upvoted, -1 if downvoted
  void castVote({required int vCode}) {
    // To take the previous vote state into account, I decided to add the
    // vCode to the previous vote state, then pattern match.
    // temp will contain values in range [-2, 2]
    int temp = voteCode + vCode;

    switch (temp) {
      //When a downvote is tapped again after previously tapping on it.
      // Downvote should then be removed
      case -2:
        updateVote(update: 1);
        break;
      // When a post not voted on previously is downvoted.
      case -1:
        updateVote(update: -1);
        break;
      // Either a previously downvoted post is upvoted or an
      // upvoted post is downvoted
      case 0:
        // Downvoted previously but now being upvoted
        if (voteCode == -1) {
          updateVote(update: 2);
        }
        // Upvoted previously but now being downvoted
        else if (voteCode == 1) {
          updateVote(update: -2);
        }
        break;
      //When a post not voted on previously is upvoted
      case 1:
        updateVote(update: 1);
        break;
      //When an upvoted is tapped again after previously tapping on it.
      // Upvote should then be removed
      case 2:
        updateVote(update: -1);
        break;
    }
  }

  void shareButton() {
    print("Share button tapped");
  }

  /// Returns a Color according to the current voteCode
  Color voteColor() {
    if (voteCode == -1) {
      return Colors.indigo;
    } else if (voteCode == 1) {
      return Colors.deepOrange;
    }
    return Colors.black;
  }

  /// Returns the appropriate upvote icon based on voteCode
  Widget upvoteIcon() {
    if (voteCode == 1) {
      return SvgPicture.asset(
        "icons/upvote-solid.svg",
        semanticsLabel: "Up voted",
        color: voteColor(),
        width: 20,
      );
    }
    return SvgPicture.asset(
      "icons/upvote-light.svg",
      semanticsLabel: "Up vote",
      width: 20,
    );
  }

  /// Returns the appropriate upvote icon based on voteCode
  Widget downvoteIcon() {
    if (voteCode == -1) {
      return SvgPicture.asset(
        "icons/downvote-solid.svg",
        semanticsLabel: "Down voted",
        color: voteColor(),
        width: 20,
      );
    }
    return SvgPicture.asset(
      "icons/downvote-light.svg",
      semanticsLabel: "Down vote",
      width: 20,
    );
  }

  /// Returns the appropriate color for the text in vote section.
  ///A post which has neither been upvoted nor downvoted is lighter
  ///
  Color voteTextColor() {
    if (voteCode == 0) {
      return voteColor().withAlpha(120);
    }
    return voteColor();
  }

  Widget voteSection() {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: InkWell(
            splashColor: voteColor().withAlpha(75),
            onTap: () {
              castVote(vCode: 1);
            },
            child: upvoteIcon(),
          ),
        ),
        Text(
          formatNumber(number: votesNumber),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: voteTextColor(),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 8),
          child: InkWell(
            splashColor: voteColor().withAlpha(75),
            onTap: () {
              castVote(vCode: -1);
            },
            child: downvoteIcon(),
          ),
        )
      ],
    );
  }

  Widget commentSection() {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          child: const Icon(
            Icons.chat_bubble_outline_rounded,
            size: 20,
          ),
        ),
        Text(
          formatNumber(number: commentNumber),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black.withAlpha(150),
          ),
        )
      ],
    );
  }

  Widget shareSection() {
    return InkWell(
      onTap: () => shareButton(),
      splashColor: Colors.black.withAlpha(100),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: const Icon(
              Icons.share_rounded,
              size: 20,
            ),
          ),
          Text(
            "Share",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black.withAlpha(150),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          voteSection(),
          commentSection(),
          shareSection(),
        ],
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final GlobalKey<_FooterState> _footerKey = GlobalKey<_FooterState>();
  late PostStructure post;
  late Footer _footer;

  ///The footer is the only stateful section of a post's card which is why
  ///I factored it out
  void setFooter() {
    _footer = Footer(
        key: _footerKey,
        votesNumber: post.votes,
        commentNumber: post.comments.length,
        voteCode: 0);
  }

  PostCard({Key? key, required this.post}) : super(key: key);

  //TODO Implement event handlers. Maybe mix in a different class to handle them?
  void viewImage() {
    print("View Image");
  }

  void _goToSubreddit() {
    print("Go to subreddit");
  }

  void _goToUserProfile() {
    print('Go to user profile');
  }

  void _openPost() {
    print('Open post');
  }

  void _openHamburger() {
    print('Open hamburger');
  }

  void _castVote() {
    switch (_footer.voteCode) {
      // If a downvoted post is double tapped, it should be upvoted
      case -1:
        _footer.voteCode = 1;
        _footerKey.currentState?.castVote(vCode: 1);
        break;
      // If a neutral post is double tapped, it should be upvoted
      case 0:
        _footer.voteCode = 1;
        _footerKey.currentState?.castVote(vCode: 1);
        break;
      // If an upvoted post is double tapped, nothing should change
    }
  }

  Widget _subredditAvatar() {
    return Container(
        margin: const EdgeInsets.only(right: 10),
        child: InkWell(
          onTap: _goToSubreddit,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(post.subredditImageURL),
          ),
        ));
  }

  Widget _subredditAndUserId() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 2),
          child: GestureDetector(
            onTap: _goToSubreddit,
            child: Text(
              post.sub,
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
              onTap: _goToUserProfile,
              child: Text(
                post.username,
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

  Widget _hamburgerIcon() {
    return IconButton(
      onPressed: _openHamburger,
      icon: const Icon(Icons.more_vert_rounded),
    );
  }

  Widget _header() {
    return Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _subredditAvatar(),
                _subredditAndUserId(),
              ],
            ),
            _hamburgerIcon(),
          ],
        ));
  }

  Widget _title() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 5),
      child: Text(
        post.title,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _justTextContent() {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Text(
        post.contents,
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 16,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget _justImageContent(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.width),
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
            post.postImageURL,
            fit: BoxFit.fitWidth,
            width: MediaQuery.of(context).size.width * 0.9,
          ),
        ),
      ),
    );
  }

  Widget _image(BuildContext context) {
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
              post.postImageURL,
              fit: BoxFit.fitWidth,
            ),
          )),
    );
  }

  Widget _textWithImage(BuildContext context) {
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
                  post.contents,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 6,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.2,
                    letterSpacing: 0.6,
                  ),
                ),
              )),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.41,
            child: _image(context),
          )
        ],
      ),
    );
  }

  Widget _content(BuildContext context) {
    //if just text contents
    if (post.contents != "" && !post.imageInPost) {
      return _justTextContent();
    }
    //if just image contents
    else if (post.imageInPost && post.contents == "") {
      return _justImageContent(context);
    }
    //if both text and image
    else if (post.imageInPost && post.contents != "") {
      return _textWithImage(context);
    }
    //if none of the two
    return Container();
  }

  Widget _cardContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _header(),
          _title(),
          _content(context),
          _footer,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    setFooter();
    return Card(
      elevation: 8,
      color: Colors.amberAccent,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.blueGrey.withAlpha(75),
        onTap: _openPost,
        onDoubleTap: _castVote,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.95,
          child: _cardContent(context),
        ),
      ),
    );
  }
}
