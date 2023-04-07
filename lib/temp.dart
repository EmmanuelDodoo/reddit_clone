import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import "package:reddit_clone/models/post.dart";
import 'package:reddit_clone/models/postStructure.dart';

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final bool _imagepost = true;
  final int _votes = 999;
  final int _comments = 70;
  final bool _upvoted = true;
  final bool _downvoted = false;

  Widget createHeader() {
    return Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(
                          "https://images.pexels.com/photos/2916450/pexels-photo-2916450.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1")),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 2),
                      child: GestureDetector(
                        onTap: () {
                          print("Subreddit tapped");
                        },
                        child: const Text(
                          "r/Programming",
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            print("User tapped");
                          },
                          child: const Text(
                            "u/blueHippo",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Text(
                          "  •12h",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                print("Hamburger icon clicked");
              },
              icon: const Icon(Icons.more_vert_rounded),
            )
          ],
        ));
  }

  Widget createTitle() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: const Text(
        "Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia molestiae quas vel sint commodi repudiandae consequuntur voluptatum laborum numquam blanditiis harum quisquam eius sed odit fugiat iusto fuga praesentium optio, eaque rerum! Provident similique accusantium nemo autem.",
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget createTextContent() {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: const Text(
        "Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia, molestiae quas vel sint commodi repudiandae consequuntur voluptatum laborum numquam blanditiis harum quisquam eius sed odit fugiat iusto fuga praesentium optio, eaque rerum! Provident similique accusantium nemo autem. Veritatis obcaecati tenetur iure eius earum ut molestias architecto voluptate aliquam nihil, eveniet aliquid culpa officia aut! Impedit sit sunt quaerat, odit, tenetur error, harum nesciunt ipsum debitis quas aliquid. Reprehenderit, quia. Quo neque error repudiandae fuga? Ipsa laudantium molestias eos sapiente officiis modi at sunt excepturi expedita sint? Sed quibusdam recusandae alias error harum maxime adipisci amet laborum.",
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 20,
          letterSpacing: 1,
        ),
        // style: ,
      ),
    );
  }

  Widget createImageContent() {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: () {
            print("Image tapped");
          },
          splashColor: Colors.black.withAlpha(100),
          child: Image.network(
            "https://images.pexels.com/photos/450596/pexels-photo-450596.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
            fit: BoxFit.contain,
            width: MediaQuery.of(context).size.width * 0.9,
          ),
        ));
  }

  Widget altText() {
    return const Text(
      "Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia, molestiae quas vel sint commodi repudiandae consequuntur voluptatum laborum numquam blanditiis harum quisquam eius sed odit fugiat iusto fuga praesentium optio, eaque rerum! Provident similique accusantium nemo autem. Veritatis obcaecati tenetur iure eius earum ut molestias architecto voluptate aliquam nihil, eveniet aliquid culpa officia aut! Impedit sit sunt quaerat, odit, tenetur error, harum nesciunt ipsum debitis quas aliquid. Reprehenderit, quia. Quo neque error repudiandae fuga? Ipsa laudantium molestias eos sapiente officiis modi at sunt excepturi expedita sint? Sed quibusdam recusandae alias error harum maxime adipisci amet laborum.",
      maxLines: 6,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 20,
        height: 1.35,
        letterSpacing: 0.7,
      ),
      // style: ,
    );
  }

  Widget altImage() {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          print("Image tapped");
        },
        splashColor: Colors.black.withAlpha(100),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.15,
          child: Image.network(
            "https://images.pexels.com/photos/450596/pexels-photo-450596.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
            fit: BoxFit.fitWidth,
            // width: MediaQuery.of(context).size.width * 0.5,
            // height: MediaQuery.of(context).size.height * 0.5,
          ),
        ),
      ),
    );
  }

  Widget content() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            child: altText(),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.44,
            child: altImage(),
          )
        ],
      ),
    );
  }

  Widget createVotes() {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: InkWell(
            onTap: () {
              print("Upvoted");
            },
            splashColor: Colors.red.withAlpha(30),
            child: SvgPicture.asset(
              _upvoted ? "icons/upvote-solid.svg" : "icons/upvote-light.svg",
              semanticsLabel: "Upvote",
              color: _upvoted ? Colors.red : null,
            ),
          ),
        ),
        Text(
          "$_votes",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black.withAlpha(120),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 8),
          child: InkWell(
            onTap: () {
              print("Downvoted");
            },
            splashColor: Colors.indigo.withAlpha(30),
            child: SvgPicture.asset(
              _downvoted
                  ? "icons/downvote-solid.svg"
                  : "icons/downvote-light.svg",
              semanticsLabel: "Downvote",
              color: _downvoted ? Colors.indigo : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget createComments() {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          child: const Icon(
            Icons.chat_bubble_outline_rounded,
          ),
        ),
        Text(
          "$_comments",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black.withAlpha(150),
          ),
        )
      ],
    );
  }

  Widget createShare() {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          child: const Icon(
            Icons.share_rounded,
          ),
        ),
        Text(
          "Share",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black.withAlpha(150),
          ),
        )
      ],
    );
  }

  Widget createFooter() {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          createVotes(),
          createComments(),
          createShare(),
        ],
      ),
    );
  }

  Widget createCardContent() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          createHeader(),
          createTitle(),
          createTextContent(),
          // content(),
          createFooter()
        ],
      ),
    );
  }

  Widget createCard() {
    return Card(
      elevation: 8,
      color: Colors.amberAccent,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          print('Just tapped');
        },
        onDoubleTap: () {
          print('Just double tapped');
        },
        splashColor: Colors.teal.withAlpha(20),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.95,
          // height: 150,
          child: createCardContent(),
        ),
      ),
    );
  }

  Future<String> readjson(
      {required BuildContext context, required String file}) async {
    AssetBundle bundle = DefaultAssetBundle.of(context);
    return Future(() => bundle.loadString("json/$file"));
  }

  PostCard makeCard(String json) {
    PostStructure ps = PostStructure.withComments(json: json);
    return PostCard(post: ps);
  }

  Future<PostCard> loadCard(
      {required BuildContext context, required String file}) {
    Future<String> jsonContents = readjson(context: context, file: file);
    return jsonContents.then((value) => makeCard(value));
  }

  @override
  Widget build(BuildContext context) {
    String file = "textandimage.json";
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Card creation"),
      ),
      body: Center(
          child: FutureBuilder(
        future: readjson(context: context, file: file),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return makeCard(snapshot.data ?? "");
          } else {
            return const CircularProgressIndicator();
          }
        },
      )),
    );
  }
}
