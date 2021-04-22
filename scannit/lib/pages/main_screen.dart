import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:scannit/pages/first_time/test.dart';
import 'package:scannit/pages/scan/cam_test.dart';
import 'package:scannit/pages/scan/scan_screen.dart';
import 'package:scannit/pages/allergens/allergen_categories.dart';

import 'account/account_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller;

    _controller = PersistentTabController(initialIndex: 1);

    //print("hello main: " + Constants.categories.toString());
    //print("hello main: " + Constants.allergens.toString());

    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        body: TabBarView(
          children: _buildScreens()
        ),
        bottomNavigationBar: TabBar(
          unselectedLabelColor: Colors.grey[500],
          labelColor: Color(0xff324558),
          indicatorColor: Colors.transparent,
          tabs: [
            Tab(
              icon: Icon(CupertinoIcons.checkmark_rectangle),
              text: ("Allergeenid"),
            ),
            Tab(
              icon: Icon(CupertinoIcons.camera),
              text: ("Scan"),
            ),
            Tab(
              icon: Icon(CupertinoIcons.info),
              text: ("Info"),
            ),
          ],
        ),
      ),
    );

    /*return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      onItemSelected: () =>,
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      // Default is Colors.white.
      handleAndroidBackButtonPress: true,
      // Default is true.
      resizeToAvoidBottomInset: true,
      // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true,
      // Default is true.
      hideNavigationBarWhenKeyboardShows: true,
      // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style2, // Choose the nav bar style with this property.
    );*/
  }


  List<Widget> _buildScreens() {
    return [AllergenCategoriesScreen(), CameraPreviewScanner(), AccountScreen()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.checkmark_rectangle),
        title: ("Allergeenid"),
        activeColorPrimary: Color(0xff324558),
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.camera),
        title: ("Scan"),
        activeColorPrimary: Color(0xff324558),
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.info),
        title: ("Info"),
        activeColorPrimary: Color(0xff324558),
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }
}
