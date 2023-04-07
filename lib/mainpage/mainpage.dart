import 'package:flutter/material.dart';
import 'home.dart';
import 'popular.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _pages = [const Home(), const Popular()];

  late Widget _activepage;

  @override
  void initState() {
    _activepage = _pages[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.delete),
          bottom: const TabBar(
            labelPadding: EdgeInsets.only(bottom: 10),
            indicatorWeight: 2.5,
            tabs: [
              Text(
                "Home",
                style: TextStyle(fontSize: 25),
              ),
              Text(
                "Popular",
                style: TextStyle(fontSize: 25),
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