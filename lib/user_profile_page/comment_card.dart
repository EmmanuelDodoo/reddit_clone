import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/models/api/request_handler.dart';
import 'package:reddit_clone/models/comment.dart';
import '../models/post.dart';
import '../models/user_provider.dart';
import '../post_page/post_page.dart';

class ProfileCommentCard extends StatefulWidget {
  final Comment comment;
  const ProfileCommentCard({super.key, required this.comment});

  @override
  State<ProfileCommentCard> createState() => _ProfileCommentCardState();
}

class _ProfileCommentCardState extends State<ProfileCommentCard> {
  late final Comment _comment = widget.comment;
  Post? _post;

  void _fetchPost() async {
    var temp = await RequestHandler.getPost(widget.comment.postId)
        .then((value) => Post(jsonMap: value));

    setState(() {
      _post = temp;
    });
  }

  void _goToComment() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Consumer<UserProvider>(
        builder: (context, provider, _) {
          return PostPage(post: _post!);
        },
      ),
    ));
  }

  Widget _makeHeader() {
    return Text(
      _post?.getTitle() ?? "",
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.titleSmall,
    );
  }

  Widget _makeSubNameSection() {
    var text = "${_post?.getSubName() ?? ""} • ${_comment.timeDifference}";
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  Widget _makeContent() {
    return Text(
      _comment.getContents(),
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  @override
  void initState() {
    _fetchPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: _goToComment,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.95,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _makeHeader(),
                _makeSubNameSection(),
                _makeContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
