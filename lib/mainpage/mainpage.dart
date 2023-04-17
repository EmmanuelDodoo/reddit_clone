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
          backgroundColor: AppBarTheme.of(context).backgroundColor,
          toolbarHeight: 2,
          bottom: const TabBar(
            labelPadding: EdgeInsets.only(bottom: 10),
            indicatorWeight: 2.0,
            tabs: [
              Text(
                "Home",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "Popular",
                style: TextStyle(fontSize: 18),
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
