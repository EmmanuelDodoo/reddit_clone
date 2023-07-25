import 'package:flutter/material.dart';
import 'package:reddit_clone/models/inherited_data.dart';
import 'package:reddit_clone/models/subreddit.dart';
import 'package:collection/collection.dart';

class SubredditAboutSection extends StatelessWidget {
  SubredditAboutSection({Key? key}) : super(key: key);

  late Subreddit _subreddit;

  Widget _descriptionSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Text(
                "Description",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Text(
              _subreddit.getSubDescription(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _rulesSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Text(
                "Rules",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ..._subreddit.getSubRules().mapIndexed((index, rule) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  "${index + 1}. $rule",
                  style: Theme.of(context).textTheme.bodyMedium,
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
          _descriptionSection(context),
          _rulesSection(context),
        ],
      ),
    );
  }
}
