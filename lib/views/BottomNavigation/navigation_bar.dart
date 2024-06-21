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
  int selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const LandingScreen(),
    const ChatScreen(
      isProductChat: false,
    ),
    // PostScreen(),
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
      selectedIndex = index;
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
          body: _widgetOptions.elementAt(selectedIndex),
          // bottomNavigationBar: BottomNavigationBar(
          //   type: BottomNavigationBarType.fixed,
          //   items: <BottomNavigationBarItem>[
          //     BottomNavigationBarItem(
          //       icon: Image.asset(
          //         'assets/images/home.png',
          //         width: 30,
          //         height: 30,
          //         color: _selectedIndex == 0 ? AppTheme.appColor : Colors.grey,
          //       ),
          //       label: 'Home',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Image.asset(
          //         'assets/images/messages.png',
          //         width: 30,
          //         color: _selectedIndex == 1 ? AppTheme.appColor : Colors.grey,
          //         height: 30,
          //       ),
          //       label: 'Chat',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Image.asset(
          //         'assets/images/camera.png',
          //         width: 30,
          //         color: _selectedIndex == 2 ? AppTheme.appColor : Colors.grey,
          //         height: 30,
          //       ),
          //       label: 'Post',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Image.asset(
          //         'assets/images/tag-2.png',
          //         width: 30,
          //         height: 30,
          //         color: _selectedIndex == 3 ? AppTheme.appColor : Colors.grey,
          //       ),
          //       label: 'Sellings',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Image.asset(
          //         'assets/images/user.png',
          //         width: 30,
          //         color: _selectedIndex == 4 ? AppTheme.appColor : Colors.grey,
          //         height: 30,
          //       ),
          //       label: 'Me',
          //     ),
          //   ],
          //   currentIndex: _selectedIndex,
          //   selectedItemColor: AppTheme.appColor,
          //   unselectedItemColor: Colors.grey,
          //   // Change the selected item's color here
          //   showSelectedLabels: true,
          //   // Show labels for selected item
          //   showUnselectedLabels: true,
          //   // Show labels for unselected items
          //   onTap: _onItemTapped,
          // ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(top: 45.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PostScreen()));
                    },
                    child: Image.asset('assets/images/add.png')),
                const SizedBox(height: 3),
                const Text(
                  'SELL',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            elevation: 0,
            color: Colors.white,
            surfaceTintColor: Colors.white,
            padding: const EdgeInsets.all(0),
            child: Row(
              children: [
                BottomNavBarCard(
                  image1: 'assets/images/home-1.png',
                  image2: 'assets/images/home-2.png',
                  title: 'HOME',
                  changes: selectedIndex == 0 ? true : false,
                  onTap: () {
                    _onItemTapped(0);
                  },
                ),
                const Spacer(
                  flex: 1,
                ),
                BottomNavBarCard(
                  image1: 'assets/images/message-1.png',
                  image2: 'assets/images/message-2.png',
                  title: 'CHATS',
                  changes: selectedIndex == 1 ? true : false,
                  onTap: () {
                    _onItemTapped(1);
                  },
                ),
                const Spacer(
                  flex: 5,
                ),
                BottomNavBarCard(
                  image1: 'assets/images/tag-1.png',
                  image2: 'assets/images/tag-2.png',
                  title: 'My ADS',
                  changes: selectedIndex == 2 ? true : false,
                  onTap: () {
                    _onItemTapped(2);
                  },
                ),
                const Spacer(
                  flex: 1,
                ),
                BottomNavBarCard(
                  image1: 'assets/images/profile-1.png',
                  image2: 'assets/images/profile-2.png',
                  title: 'Accounts',
                  changes: selectedIndex == 3 ? true : false,
                  onTap: () {
                    _onItemTapped(3);
                  },
                ),
              ],
            ),
          )

          // BottomNavigationBar(
          //   items: [
          //     BottomNavigationBarItem(
          //       icon: Image.asset(
          //         'assets/images/home.png',
          //         width: 30,
          //         height: 30,
          //         color: _selectedIndex == 0 ? AppTheme.appColor : Colors.grey,
          //       ),
          //       label: 'Home',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Image.asset(
          //         'assets/images/messages.png',
          //         width: 30,
          //         color: _selectedIndex == 1 ? AppTheme.appColor : Colors.grey,
          //         height: 30,
          //       ),
          //       label: 'Chat',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Image.asset(
          //         'assets/images/camera.png',
          //         width: 30,
          //         color: _selectedIndex == 2 ? AppTheme.appColor : Colors.grey,
          //         height: 30,
          //       ),
          //       label: 'Post',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Image.asset(
          //         'assets/images/tag-2.png',
          //         width: 30,
          //         height: 30,
          //         color: _selectedIndex == 3 ? AppTheme.appColor : Colors.grey,
          //       ),
          //       label: 'Sellings',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Image.asset(
          //         'assets/images/user.png',
          //         width: 30,
          //         color: _selectedIndex == 4 ? AppTheme.appColor : Colors.grey,
          //         height: 30,
          //       ),
          //       label: 'Me',
          //     ),
          //   ],
          //   currentIndex: _selectedIndex,
          //   selectedItemColor: AppTheme.appColor,
          //   unselectedItemColor: Colors.grey,
          //   // Change the selected item's color here
          //   showSelectedLabels: true,
          //   // Show labels for selected item
          //   showUnselectedLabels: true,
          //   // Show labels for unselected items
          //   onTap: _onItemTapped,
          // ),
          ),
    );
  }
}

class BottomNavBarCard extends StatefulWidget {
  String? image1;
  String? image2;
  String? title;

  Function()? onTap;

  bool changes;

  BottomNavBarCard(
      {super.key,
      this.title,
      this.image1,
      this.onTap,
      required this.changes,
      this.image2});

  @override
  State<BottomNavBarCard> createState() => _BottomNavBarCardState();
}

class _BottomNavBarCardState extends State<BottomNavBarCard> {
  ValueNotifier valueNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (widget.onTap),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                children: [
                  const Spacer(),
                  const SizedBox(height: 12),
                  Image.asset(
                    fit: BoxFit.cover,
                    widget.changes == true ? widget.image2! : widget.image1!,
                    height: 22,
                    width: 22,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.title!,
                    style: TextStyle(
                        color: widget.changes
                            ? AppTheme.appColor
                            : Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                        fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Container(
              height: 2.5,
              width: 50,
              decoration: BoxDecoration(
                  color:
                      widget.changes ? AppTheme.appColor : Colors.transparent),
            )
          ],
        ),
      ),
    );
  }
}
