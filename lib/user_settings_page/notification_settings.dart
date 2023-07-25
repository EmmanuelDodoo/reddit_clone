import 'package:flutter/material.dart';

class NotificationSettings extends StatelessWidget {
  const NotificationSettings({Key? key}) : super(key: key);

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
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
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
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
            const Icon(
              Icons.arrow_forward_rounded,
              size: 20,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> notificationOptions = [
      "Mentions",
      "Chat messages",
      "Upvotes",
      "New follows"
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
                child: Center(
                  child: Text(
                    "NOTIFICATION SETTINGS",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
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
