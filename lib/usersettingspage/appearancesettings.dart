import 'package:flutter/material.dart';
import 'package:reddit_clone/models/user.dart';

import '../models/inherited-data.dart';

class AppearanceSettings extends StatelessWidget {
  AppearanceSettings({Key? key}) : super(key: key);

  User? _currUser;

  Widget optionBuilder(String name, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: InkWell(
        splashColor: Colors.blueGrey,
        onTap: () => showDialog(
          context: context,
          builder: (BuildContext context) => Dialog(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$name has not been implemented yet!",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(Icons.arrow_forward_rounded)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _currUser = InheritedData.of<User?>(context).data;

    List<String> notificationOptions = [
      "Auto Dark mode",
      "Light Theme",
      "Dark Theme",
      "Font Size"
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: const Center(
                  child: Text(
                    "APPEARANCE SETTINGS",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ...notificationOptions
                  .map((opt) => optionBuilder(opt, context))
                  .toList()
            ],
          ),
        ),
      ),
    );
  }
}
