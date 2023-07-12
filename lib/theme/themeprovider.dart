import 'package:flutter/material.dart';
import 'appcolors.dart';

/// Provides the theme of the app and allows switching between
/// light and dark modes with dark mode as the starting default
class ThemeProvider extends ChangeNotifier {
  Brightness brightness = Brightness.dark;
  bool useMaterial3 = true;
  AppColor _color = AppColor.teal;

  void toggleDarkMode() {
    if (brightness == Brightness.light) {
      brightness = Brightness.dark;
      notifyListeners();
    } else {
      brightness = Brightness.light;
      notifyListeners();
    }
  }

  void toggleMaterial3() {
    useMaterial3 = !useMaterial3;
    notifyListeners();
  }

  Color getAppColor() {
    return _color.color();
  }

  AppColor getCurrentAppColor() {
    return _color;
  }

  void changeAppColor({required AppColor newColor}) {
    _color = newColor;
    notifyListeners();
  }
}
