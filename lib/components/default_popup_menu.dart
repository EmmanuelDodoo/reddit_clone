import 'package:flutter/material.dart';
import 'package:reddit_clone/models/base_popup_menu.dart';

class DefaultPopUp extends BasePopUp {
  const DefaultPopUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          child: InkWell(
            onTap: share,
            child: Row(
              children: [
                const Icon(
                  Icons.share,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: const Text(
                    "Share",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        PopupMenuItem(
            child: InkWell(
          onTap: save,
          child: Row(
            children: [
              const Icon(
                Icons.bookmarks_rounded,
              ),
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: const Text(
                  "Save",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        )),
        PopupMenuItem(
          child: InkWell(
            onTap: subscribe,
            child: Row(
              children: [
                const Icon(
                  Icons.notifications,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: const Text(
                    "Subscribe",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
