import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/models/userprovider.dart';
import 'mainpage/mainpage.dart';
import 'models/user.dart';
import 'models/inherited-data.dart';
// import 'rem.dart';
import 'skeleton.dart';
import 'temp.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? _user;
  final ThemeData _theme = ThemeData(primarySwatch: Colors.purple);

  void loadUser() async {
    String file = "json/user.json";
    User usr = await rootBundle
        .loadString(file)
        .then((value) => User.fromJSON(json: value));
    setState(() {
      _user = usr;
    });
  }

  @override
  void initState() {
    // loadUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Reddit Clone",
      theme: _theme,
      home: SafeArea(
        child: Consumer<UserProvider>(
          child: MainPage(),
          builder: (context, provider, child) {
            if (child != null) {
              return Skeleton(currPage: child);
            }
            return Container();
          },
        ),
      ),
    );
  }
}
