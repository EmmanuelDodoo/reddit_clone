import 'package:flutter/material.dart';
import 'package:reddit_clone/components/default-footer.dart';
import '../models/post.dart';

class PostPageFooter extends StatelessWidget {
  final Post post;
  final int voteCode;

  const PostPageFooter({
    Key? key,
    required this.post,
    required this.voteCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: _PostPageFooterHeaderDelegate(post: post, voteCode: voteCode),
      pinned: true,
    );
  }
}

class _PostPageFooterHeaderDelegate extends SliverPersistentHeaderDelegate {
  late final Post post;
  final int voteCode;
  _PostPageFooterHeaderDelegate({required this.post, required this.voteCode});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 50,
      child: DefaultFooter(
        post: post,
        voteCode: voteCode,
      ),
    );
  }

  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 30;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
