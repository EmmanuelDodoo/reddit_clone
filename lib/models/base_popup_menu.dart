import 'package:flutter/material.dart';

abstract class BasePopUp extends StatelessWidget {
  const BasePopUp({Key? key}) : super(key: key);

  void save() {}

  void share() {}

  void subscribe() {}

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
