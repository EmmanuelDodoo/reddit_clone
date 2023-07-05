import 'package:flutter/material.dart';
import 'package:reddit_clone/usersettingspage/about.dart';
import 'package:reddit_clone/usersettingspage/appearancesettings.dart';
import 'package:reddit_clone/usersettingspage/basicsettings.dart';
import 'package:reddit_clone/usersettingspage/notificationsettings.dart';

import '../models/user.dart';

class UserSettings extends StatelessWidget {
  UserSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Settings",
            style: TextStyle(fontSize: 20),
          ),
        ),
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              child: BasicSettings(),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              child: NotificationSettings(),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              child: AppearanceSettings(),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              child: About(),
            ),
            // const Text("Support/ About"),
          ],
        ),
      ),
    );
  }
}
