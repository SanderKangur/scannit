import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:scannit/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:scannit/blocs/authentication_bloc/authentication_event.dart';
import 'package:scannit/constants.dart';
import 'package:scannit/data/info_entity.dart';
import 'package:scannit/data/info_repo.dart';
import 'package:scannit/pages/blog/blog_screen.dart';
import 'package:scannit/pages/loading.dart';
import 'package:scannit/pages/scan/scan_screen.dart';
import 'package:scannit/pages/search/allergen_types.dart';

import 'account/account_screen.dart';

class MainScreen extends StatefulWidget {

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedPage = 0;
  List<Widget> pageList = [];

  @override
  void initState() {
    pageList.add(BlogScreen());
    pageList.add(ScanScreen());
    pageList.add(AllergenTypesScreen());
    pageList.add(AccountScreen());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("hello main");

    PersistentTabController _controller;

    _controller = PersistentTabController(initialIndex: 0);

    return StreamProvider<List<Info>>.value(
        value: InfoRepo(uid: Constants.userId).info,
        initialData: [],
        child: StreamBuilder<Info>(
            stream: InfoRepo().infoStream(Constants.userId),
            //Firestore.instance.collection('info').document(Constants.userId).snapshots(),
            builder: (context, snapshot) {
              //print("Types " + snapshot.data.types.toString());
              if (snapshot.data == null) {
                /*BlocProvider.of<AuthenticationBloc>(context).add(
                  AuthenticationLoggedOut(),
                );*/
                return Scaffold(body: LoadingIndicator());
              } else {
                print("ALLERGENS FROM DATABASE: " +
                    Constants.userAllergens.toString());
                if (Constants.userAllergens.length == 0) {
                  Constants.userTypes = snapshot.data.types;
                  Constants.userTypes.forEach((area, value) {
                    value.forEach((allergen, bool) {
                      if (bool)
                        Constants.userAllergens.add(
                            allergen.toLowerCase().replaceAll("[,\.:\n]", ""));
                    });
                  });
                }
              }
              return PersistentTabView(
                context,
                controller: _controller,
                screens: _buildScreens(),
                items: _navBarsItems(),
                confineInSafeArea: true,
                backgroundColor: Colors.white, // Default is Colors.white.
                handleAndroidBackButtonPress: true, // Default is true.
                resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
                stateManagement: true, // Default is true.
                hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
                decoration: NavBarDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  colorBehindNavBar: Colors.white,
                ),
                popAllScreensOnTapOfSelectedTab: true,
                popActionScreens: PopActionScreensType.all,
                itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
                  duration: Duration(milliseconds: 200),
                  curve: Curves.ease,
                ),
                screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
                  animateTabTransition: true,
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 200),
                ),
                navBarStyle: NavBarStyle.style2, // Choose the nav bar style with this property.
              );
            }) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  List<Widget> _buildScreens() {
    return [
      AllergenTypesScreen(),
      ScanScreen(),
      AccountScreen()
    ];
  }


  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.checkmark_rectangle),
        title: ("Home"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.camera),
        title: ("Scan"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.settings),
        title: ("Settings"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
  }
}
