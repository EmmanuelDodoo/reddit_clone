import 'package:flutter/material.dart';
import 'appcolors.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provides basic settings for the theme of the app
///
/// The defaults are dark mode, teal theme and using material 3
class ThemeProvider extends ChangeNotifier {
  Brightness? _brightness = Brightness.dark;
  bool useMaterial3 = true;
  AppColor? _color;

  ThemeProvider() {
    setMaterial3FromPreferences();
    setDarkModeFromPreferences();
    setAppColorFromPreferences();
  }

  void toggleDarkMode() async {
    if (_brightness == Brightness.light) {
      _brightness = Brightness.dark;
    } else {
      _brightness = Brightness.light;
    }

    // Save the change
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDarkMode", _brightness == Brightness.dark);

    notifyListeners();
  }

  void setDarkModeFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? temp = prefs.getBool("isDarkMode");

    if (temp == null || temp) {
      _brightness = Brightness.dark;
    } else {
      _brightness = Brightness.light;
    }

    notifyListeners();
  }

  Brightness getBrightness() {
    if (_brightness == null) {
      return Brightness.dark;
    }
    return _brightness!;
  }

  void toggleMaterial3() async {
    useMaterial3 = useMaterial3 == null ? false : !useMaterial3!;

    // Save the change
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("useMaterial3", useMaterial3!);

    notifyListeners();
  }

  void setMaterial3FromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? temp = prefs.getBool("useMaterial3");

    if (temp == null) {
      useMaterial3 = true;
    } else {
      useMaterial3 = temp;
    }
    notifyListeners();
  }

  Color getAppColor() {
    return _color == null ? AppColor.teal.color() : _color!.color();
  }

  AppColor getCurrentAppColor() {
    return _color ?? AppColor.teal;
  }

  void changeAppColor({required AppColor newColor}) async {
    _color = newColor;

    //Save the Change
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("color", _color!.name);

    notifyListeners();
  }

  void setAppColorFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? temp = prefs.getString("color");

    switch (temp) {
      case "rose":
        _color = AppColor.rose;
        break;
      case "cyan":
        _color = AppColor.cyan;
        break;
      case "orange":
        _color = AppColor.orange;
        break;
      case "emerald":
        _color = AppColor.emerald;
        break;
      case "purple":
        _color = AppColor.purple;
        break;
      case "slate":
        _color = AppColor.slate;
        break;
      default:
        _color = AppColor.teal;
        break;
    }

    notifyListeners();
  }
}
