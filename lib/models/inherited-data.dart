import 'package:flutter/material.dart';
import 'user.dart';

///Propagate data throughout out this widget's subtree
class InheritedData<T> extends InheritedWidget {
  final T data;

  const InheritedData({super.key, required super.child, required this.data});

  static InheritedData<T> of<T>(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedData<T>>()!;

  @override
  bool updateShouldNotify(covariant InheritedData oldWidget) {
    return data != oldWidget.data;
  }
}
