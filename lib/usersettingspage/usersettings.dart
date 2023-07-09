import 'package:flutter/material.dart';
import 'package:reddit_clone/usersettingspage/about.dart';
import 'package:reddit_clone/usersettingspage/appearancesettings.dart';
import 'package:reddit_clone/usersettingspage/basicsettings.dart';
import 'package:reddit_clone/usersettingspage/notificationsettings.dart';

class UserSettings extends StatelessWidget {
  UserSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    Color appBarTextColor = isDark
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.primaryContainer;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Settings",
            style: TextStyle(
              color: appBarTextColor,
            ),
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
