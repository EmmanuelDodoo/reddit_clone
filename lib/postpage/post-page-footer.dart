import 'package:flutter/material.dart';
import 'package:reddit_clone/models/default-footer.dart';
import '../models/post.dart';

class PostPageFooter extends StatelessWidget {
  late final Post post;
  late final Color color;

  PostPageFooter(
      {Key? key, required this.post, this.color = Colors.amberAccent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: _PostPageFooterHeaderDelegate(post: post, color: color),
      pinned: true,
    );
  }
}

class _PostPageFooterHeaderDelegate extends SliverPersistentHeaderDelegate {
  late final Post post;
  late final Color color;
  _PostPageFooterHeaderDelegate({required this.post, required this.color});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 50,
      color: color,
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
