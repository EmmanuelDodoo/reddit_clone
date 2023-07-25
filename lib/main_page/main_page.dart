import 'package:flutter/material.dart';
import 'home.dart';
import 'popular.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: const TabBar(
            tabs: [
              Text(
                "Home",
                style: TextStyle(fontSize: 19),
              ),
              Text(
                "Popular",
                style: TextStyle(fontSize: 19),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Home(),
            Popular(),
          ],
        ),
      ),
    );
  }
}
