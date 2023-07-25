import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/notifications_page/notifications_page.dart';
import 'package:reddit_clone/skeleton.dart';

import '../create_post_page/create_post_page.dart';
import '../main_page/main_page.dart';
import '../models/user.dart';
import '../models/user_provider.dart';
import 'authentication/login.dart';

class SkeletonBottomNav extends StatefulWidget {
  final int selectedIndex;
  const SkeletonBottomNav({super.key, required this.selectedIndex});

  @override
  State<SkeletonBottomNav> createState() => _SkeletonBottomNavState();
}

class _SkeletonBottomNavState extends State<SkeletonBottomNav> {
  int _selectedIndex = 0;
  User? _currUser;

  void _goToHome(BuildContext context) {
    // Check if the where this was built is the same as
    // where the user wants to go
    if (widget.selectedIndex == _selectedIndex) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Skeleton(
          currPage: const MainPage(),
          selectedIndex: 0,
        ),
      ),
    );
  }

  void _goToCreate(BuildContext context) {
    if (_currUser == null) {
      showDialog(
          context: context,
          builder: (BuildContext context) => LoginModal(
                onCloseSuccessfully: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CreatePostPage())),
              ));
      return;
    }

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CreatePostPage()));
  }

  void _goToNotifications(BuildContext context) {
    // Check if the where this was built is the same as
    // where the user wants to go
    if (widget.selectedIndex == _selectedIndex) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Skeleton(
          currPage: const NotificationsPage(),
          selectedIndex: 2,
        ),
      ),
    );
  }

  void _goToProfile(BuildContext context) {
    // Check if the where this was built is the same as
    // where the user wants to go
    if (widget.selectedIndex == _selectedIndex) return;
  }

  void _onItemTapped(BuildContext context, int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (_selectedIndex) {
      case 0:
        _goToHome(context);
        break;
      case 1:
        _goToCreate(context);
        break;
      case 2:
        _goToNotifications(context);
        break;
      case 3:
        _goToProfile(context);
        break;
      default:
        _goToHome(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider = Provider.of<UserProvider>(context, listen: false);
    _currUser = provider.currentUser;

    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Post',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: "Profile",
        )
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) => _onItemTapped(context, index),
    );
  }
}
