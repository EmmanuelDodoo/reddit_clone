import 'package:flutter/material.dart';

enum AppColor { teal, rose, cyan, orange, emerald, purple, slate }

extension Codes on AppColor {
  /// Returns the Color widget of this App Color
  Color color() {
    switch (this) {
      case AppColor.teal:
        return const Color(0xFF33554F);
      case AppColor.rose:
        return const Color(0xFFE11D48);
      case AppColor.cyan:
        return const Color(0xFF0891B2);
      case AppColor.orange:
        return const Color(0xFFEA580C);
      case AppColor.emerald:
        return const Color(0xFF059669);
      case AppColor.purple:
        return const Color(0xFF8A2BE2);
      case AppColor.slate:
        return const Color(0xFF475569);
    }
  }
}
