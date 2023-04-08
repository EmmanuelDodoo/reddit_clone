// Future<String> readjson(
//     {required BuildContext context, required String file}) async {
//   AssetBundle bundle = DefaultAssetBundle.of(context);
//   return Future(() => bundle.loadString("json/$file"));
// }
//
// PostCard makeCard(String json) {
//   PostStructure ps = PostStructure.withComments(json: json);
//   return PostCard(post: ps);
// }
//
// Future<PostCard> loadCard(
//     {required BuildContext context, required String file}) {
//   Future<String> jsonContents = readjson(context: context, file: file);
//   return jsonContents.then((value) => makeCard(value));
// }
//
// @override
// Widget build(BuildContext context) {
//   String file = "textandimage.json";
//   return Scaffold(
//     appBar: AppBar(
//       centerTitle: true,
//       title: const Text("Card creation"),
//     ),
//     body: Center(
//         child: FutureBuilder(
//       future: readjson(context: context, file: file),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done &&
//             snapshot.data != null) {
//           return makeCard(snapshot.data ?? "");
//         } else {
//           return const CircularProgressIndicator();
//         }
//       },
//     )),
//   );
// }
