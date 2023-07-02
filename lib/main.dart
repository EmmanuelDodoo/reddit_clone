import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'mainpage/mainpage.dart';
import 'models/user.dart';
import 'models/inherited-data.dart';
// import 'rem.dart';
import 'skeleton.dart';
import 'temp.dart';

void main() {
  runApp(MyApp());
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

  Widget _app() {
    if (_user == null) {
      return MaterialApp(
        title: "Testing user propagation",
        theme: _theme,
        home: const Scaffold(
          //Todo A logo could be displayed instead of the progress bar
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return InheritedData<User>(
      data: _user!,
      child: MaterialApp(
        title: "Testing User propagation",
        theme: _theme,
        home: SafeArea(
          child: Skeleton(
            currPage: MainPage(),
          ),
          // child: Test(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return _app();
  }
}
