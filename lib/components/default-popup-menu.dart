import 'package:flutter/material.dart';
import 'package:reddit_clone/models/base-popup-menu.dart';

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
                  color: Colors.black,
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
                color: Colors.black,
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
                color: Colors.black,
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
        )),
        // PopupMenuItem(
        //   child: InkWell(
        //     onTap: _award,
        //     child: Row(
        //       children: [
        //         const Icon(
        //           Icons.military_tech,
        //           color: Colors.black,
        //         ),
        //         Container(
        //           margin: const EdgeInsets.only(left: 8),
        //           child: const Text(
        //             "Award",
        //             style: TextStyle(
        //               fontSize: 15,
        //               fontWeight: FontWeight.w500,
        //             ),
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
