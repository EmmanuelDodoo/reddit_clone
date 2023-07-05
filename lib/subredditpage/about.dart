import 'package:flutter/material.dart';
import 'package:reddit_clone/models/inherited-data.dart';
import 'package:reddit_clone/models/subreddit.dart';
import 'package:collection/collection.dart';

class SubredditAboutSection extends StatelessWidget {
  SubredditAboutSection({Key? key}) : super(key: key);

  late Subreddit _subreddit;

  Widget _descriptionSection() {
    return Card(
      elevation: 8,
      color: Colors.tealAccent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: const Text(
                "Description",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Text(
              _subreddit.getSubDescription(),
              style: const TextStyle(
                fontSize: 15,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rulesSection() {
    return Card(
      elevation: 8,
      color: Colors.tealAccent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: const Text(
                "Rules",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            ..._subreddit.getSubRules().mapIndexed((index, rule) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  "${index + 1}. $rule",
                  style: const TextStyle(
                    fontSize: 15,
                    letterSpacing: 1.0,
                  ),
                ),
              );
            }).toList()
          ],
        ),
        // child: ,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _subreddit = InheritedData.of<Subreddit>(context).data;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListView(
        children: [
          _descriptionSection(),
          _rulesSection(),
        ],
      ),
    );
  }
}
