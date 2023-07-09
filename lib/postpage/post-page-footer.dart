import 'package:flutter/material.dart';
import 'package:reddit_clone/components/default-footer.dart';
import '../models/post.dart';

class PostPageFooter extends StatelessWidget {
  late final Post post;

  PostPageFooter({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: _PostPageFooterHeaderDelegate(post: post),
      pinned: true,
    );
  }
}

class _PostPageFooterHeaderDelegate extends SliverPersistentHeaderDelegate {
  late final Post post;
  _PostPageFooterHeaderDelegate({required this.post});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 50,
      child: DefaultFooter(
        post: post,
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
