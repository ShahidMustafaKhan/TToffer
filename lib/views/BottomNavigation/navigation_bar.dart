import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Controller/image_provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/utils/utils.dart';
import 'package:tt_offer/views/ChatScreens/chat_screen.dart';
import 'package:tt_offer/views/Homepage/landing_screen.dart';
import 'package:tt_offer/views/Post%20screens/post_screen.dart';
import 'package:tt_offer/views/Profile%20Screen/profile_screen.dart';
import 'package:tt_offer/views/Sellings/selling_purchase.dart';

class BottomNavView extends StatefulWidget {
  const BottomNavView({super.key});

  @override
  _BottomNavViewState createState() => _BottomNavViewState();
}

class _BottomNavViewState extends State<BottomNavView> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const LandingScreen(),
    const ChatScreen(
      isProductChat: false,
    ),
    PostScreen(
      selling: null,
    ),
    const SellingPurchaseScreen(
      title: "Selling",
    ),
    const ProfileScreen()
  ];

  void _onItemTapped(int index) {
    final imageProvider =
        Provider.of<ImageNotifyProvider>(context, listen: false);
    imageProvider.vedioPath = "";
    imageProvider.imagePaths.clear();
    setState(() {
      _selectedIndex = index;
    });
  }

  int backPressCounter = 1;
  bool canPopScope = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPopScope,
      onPopInvoked: (didPop) {
        log("backPressCounter = $backPressCounter");

        if (backPressCounter < 2) {
          showSnackBar(context,
              "Are you sure you want to close the app? Press again to confirm");
          backPressCounter++;
          Future.delayed(const Duration(seconds: 2), () {
            backPressCounter--;
          });
        } else {
          // Navigator.pop(context);
          setState(() {
            canPopScope = true;
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.whiteColor,
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/home.png',
                width: 30,
                height: 30,
                color: _selectedIndex == 0 ? AppTheme.appColor : Colors.grey,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/messages.png',
                width: 30,
                color: _selectedIndex == 1 ? AppTheme.appColor : Colors.grey,
                height: 30,
              ),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/camera.png',
                width: 30,
                color: _selectedIndex == 2 ? AppTheme.appColor : Colors.grey,
                height: 30,
              ),
              label: 'Post',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/tag-2.png',
                width: 30,
                height: 30,
                color: _selectedIndex == 3 ? AppTheme.appColor : Colors.grey,
              ),
              label: 'Sellings',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/user.png',
                width: 30,
                color: _selectedIndex == 4 ? AppTheme.appColor : Colors.grey,
                height: 30,
              ),
              label: 'Me',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppTheme.appColor,
          unselectedItemColor: Colors.grey,
          // Change the selected item's color here
          showSelectedLabels: true,
          // Show labels for selected item
          showUnselectedLabels: true,
          // Show labels for unselected items
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
