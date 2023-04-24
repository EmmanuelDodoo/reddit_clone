import 'package:flutter/material.dart';
import 'package:reddit_clone/models/base-popup-menu.dart';

class CommentPopUp extends BasePopUp {
  CommentPopUp({Key? key, required void Function() this.collapse})
      : super(key: key);
  late final Function() collapse;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          onTap: share,
          child: Row(
            children: [
              const Icon(
                Icons.share_outlined,
                // color: Colors.black,
              ),
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: const Text(
                  "Share",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        ),
        PopupMenuItem(
            onTap: save,
            child: Row(
              children: [
                const Icon(
                  Icons.bookmark_outline,
                  // color: Colors.black,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            )),
        PopupMenuItem(
            onTap: subscribe,
            child: Row(
              children: [
                const Icon(
                  Icons.notifications_outlined,
                  color: Colors.black,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: const Text(
                    "Get reply notifications",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            )),
        PopupMenuItem(
            onTap: collapse,
            child: Row(
              children: [
                const Icon(
                  Icons.close_fullscreen_outlined,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: const Text(
                    "Collapse thread",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ))
      ],
    );
  }
}
