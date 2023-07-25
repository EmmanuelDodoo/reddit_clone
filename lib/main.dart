import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/models/api/request_handler.dart';
import 'package:reddit_clone/models/user_provider.dart';
import 'package:reddit_clone/models/theme/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_page/main_page.dart';
import 'models/user.dart';
import 'skeleton.dart';

void main() async {
  await dotenv.load(fileName: ".env");

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
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<User> _fetchUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int id = prefs.getInt("uid")!;
    var response = await RequestHandler.getUser(id);
    return User(jsonMap: response);
  }

  void _propagateUser(User user) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    userProvider.setCurrentUser(user: user);
  }

  Future<bool> _savedTokenIsExpired() async {
    // Check if the saved saved token, if any, is expired
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var tokenValue = prefs.getString("tokenValue");
    var tokenExpiration = prefs.getInt("tokenExpiration");

    if (tokenValue == null || tokenExpiration == null) return true;

    DateTime tokenTime =
        DateTime.fromMillisecondsSinceEpoch(tokenExpiration * 1000);
    return tokenTime.isBefore(DateTime.now());
  }

  void _loadUser() async {
    if (await _savedTokenIsExpired()) {
    } else {
      var usr = await _fetchUser();
      _propagateUser(usr);
      setState(() {});
    }
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
    _loadUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
          title: "Reddit Clone",
          theme: _theme(context),
          debugShowCheckedModeBanner: false,
          home: SafeArea(
            child: Consumer<UserProvider>(
              child: const MainPage(),
              builder: (context, provider, child) {
                if (child != null) {
                  return Skeleton(
                    currPage: child,
                    selectedIndex: 0,
                  );
                }
                return Container();
              },
            ),
          ),
        );
      },
    );
  }
}
