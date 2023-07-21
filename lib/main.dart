import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/models/userprovider.dart';
import 'package:reddit_clone/theme/themeprovider.dart';
import 'mainpage/mainpage.dart';
import 'models/user.dart';
import 'models/inherited-data.dart';
import 'skeleton.dart';
import 'temp.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? _user;

  void loadUser() async {
    String file = "json/user.json";
    User usr = await rootBundle
        .loadString(file)
        .then((value) => User.fromJSON(json: value));
    setState(() {
      _user = usr;
    });
  }

  ThemeData _theme(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

    bool isDark = themeProvider.getBrightness() == Brightness.dark;

    return ThemeData(
      useMaterial3: themeProvider.useMaterial3,
      // useMaterial3: false,
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? Colors.black87 : null,
        elevation: 0,
        shape: const RoundedRectangleBorder(),
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        color: isDark ? Colors.black87 : null,
        height: MediaQuery.of(context).size.height * 0.05,
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? Colors.black87 : null,
        elevation: 0,
      ),
      cardTheme: const CardTheme(
        elevation: 3,
        clipBehavior: Clip.hardEdge,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      ),
      colorScheme: ColorScheme.fromSeed(
        // brightness: Brightness.dark,
        brightness: themeProvider.getBrightness(),
        seedColor: themeProvider.getAppColor(),
      ),
      dialogTheme: const DialogTheme(
        shape: RoundedRectangleBorder(),
      ),
      tabBarTheme: const TabBarTheme(
        labelPadding: EdgeInsets.only(bottom: 5),
      ),
      popupMenuTheme: const PopupMenuThemeData(
        elevation: 20,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  void initState() {
    // loadUser();
    super.initState();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Consumer<ThemeProvider>(
  //     builder: (context, provider, child) {
  //       return MaterialApp(
  //         title: "Reddit Clone",
  //         theme: _theme(context),
  //         home: SafeArea(
  //           child: Consumer<UserProvider>(
  //             child: MainPage(),
  //             builder: (context, provider, child) {
  //               if (child != null) {
  //                 return Skeleton(
  //                   currPage: child,
  //                   selectedIndex: 0,
  //                 );
  //               }
  //               return Container();
  //             },
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Temp();
  }
}
