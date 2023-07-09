import 'package:flutter/material.dart';

abstract class BasePopUp extends StatelessWidget {
  const BasePopUp({Key? key}) : super(key: key);

  void save() {
    print("Saved tapped");
  }

  void share() {
    print("Share");
  }

  void subscribe() {
    print("Subscribe tapped");
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
