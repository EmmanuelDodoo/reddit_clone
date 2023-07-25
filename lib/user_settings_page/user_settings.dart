import 'package:flutter/material.dart';
import 'package:reddit_clone/user_settings_page/about.dart';
import 'package:reddit_clone/user_settings_page/appearance_settings.dart';
import 'package:reddit_clone/user_settings_page/basic_settings.dart';
import 'package:reddit_clone/user_settings_page/notification_settings.dart';

class UserSettings extends StatelessWidget {
  const UserSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    Color appBarTextColor = isDark
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.primary;
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
              child: const BasicSettings(),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              child: const NotificationSettings(),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              child: const AppearanceSettings(),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              child: const About(),
            ),
            // const Text("Support/ About"),
          ],
        ),
      ),
    );
  }
}
