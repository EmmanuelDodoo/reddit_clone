import 'package:flutter/material.dart';

class Slides extends StatelessWidget {
  const Slides({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Testing post slides"),
        centerTitle: true,
      ),
      body: Slides(),
    );
  }
}
