import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/models/api/http_model.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/inherited-data.dart';
import '../models/userprovider.dart';

class About extends StatelessWidget {
  About({Key? key}) : super(key: key);
  final String aboutText =
      """Emmanuel Dodoo here. I'm, as of the last update, a passionate college student from Ghana. I began this Reddit clone to immerse myself in the world of mobile development and maybe find a calling in the field. The journey was long but I embraced the challenges and victories, crafting a feature-rich app that I'm proud of. Although satisfied with its current state, I think there's ample room for improvement, and I look forward to returning to implement more exciting features in the future. This project tested my perseverance and sanity in a way I never though possible. Was it worth it? For me, yes. Yes it was. To catch up on what I've been working on, Click the Resume option below. """;

  final String resumeURL =
      "https://emmanueldodoo.com/Emmanuel-Dodoo-Resume.pdf";

  User? _currUser;

  void _handleResume(BuildContext context) async {
    var url = Uri.parse(resumeURL);
    if (await launchUrl(url, mode: LaunchMode.externalApplication)) {}
  }

  void _aboutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        "Well Hello There",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          aboutText,
                          textAlign: TextAlign.justify,
                          softWrap: true,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(letterSpacing: 0.4),
                        ),
                      ),
                    ),
                    Text(
                      "Thanks!!",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(letterSpacing: 0.5),
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
            ));
  }

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
    UserProvider provider = Provider.of<UserProvider>(context, listen: false);
    _currUser = provider.currentUser;
    List<String> notificationOptions = [
      "Help Center",
      "Report Issue",
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
                    "SUPPORT & ABOUT SETTINGS",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ...notificationOptions
                  .map((opt) => optionBuilder(opt, context))
                  .toList(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: InkWell(
                  onTap: () => _aboutDialog(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "About",
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: InkWell(
                  onTap: () => _handleResume(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Resume",
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
