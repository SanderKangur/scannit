import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scannit/constants.dart';
import 'package:scannit/data/info_entity.dart';
import 'package:scannit/data/info_repo.dart';
import 'package:scannit/pages/blog/blog_screen.dart';
import 'package:scannit/pages/loading.dart';
import 'package:scannit/pages/scan/scan_screen.dart';
import 'package:scannit/pages/search/search_screen.dart';
import 'package:scannit/pages/splash_screen.dart';

import 'account/account_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.name}) : super(key: key);
  final String name;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedPage = 0;
  List<Widget> pageList = List<Widget>();

  @override
  void initState() {
    pageList.add(BlogScreen());
    pageList.add(ScanScreen());
    pageList.add(SearchScreen());
    pageList.add(AccountScreen());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("hello main");

    return StreamProvider<List<Info>>.value(
        value: InfoRepo(uid: Constants.userId).info,
        child: StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance.collection('info').document(Constants.userId).snapshots(), //InfoRepo().infoStream(Constants.userId),
            builder: (context, snapshot) {
              print("Data:" + snapshot.hasData.toString());
                if (snapshot.data == null) {
                  /*BlocProvider.of<AuthenticationBloc>(context).add(
                AuthenticationLoggedOut(),
              );*/
                  return Scaffold(body: LoadingIndicator());
                } else {
                  Constants.userAllergens = List<String>.from(snapshot.data.data['allergens']);
                  Constants.userPreferences = List<String>.from(snapshot.data.data['preferences']);
                  Map<String, dynamic>.from(snapshot.data.data['types']).forEach((key, value) {
                  Constants.userTypes.putIfAbsent(key, () => Map<String, bool>.from(value));});   //saves the nested map as a constant
                  print("Allergens " + Constants.userAllergens.toString());
                  print("Preferences " + Constants.userPreferences.toString());
                  //print("Types " + Constants.userTypes.toString());
                  return Scaffold(
                    body: IndexedStack(
                      index: _selectedPage,
                      children: pageList,
                    ),
                    bottomNavigationBar: BottomNavigationBar(
                      type: BottomNavigationBarType.shifting,
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                            icon: Icon(Icons.inbox),
                            label: 'Blog',
                            backgroundColor: Colors.lightGreen),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.settings_overscan),
                            label: 'Scan',
                            backgroundColor: Colors.lightGreen),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.search),
                            label: 'Search',
                            backgroundColor: Colors.lightGreen),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.settings),
                          label: 'Account',
                          backgroundColor: Colors.lightGreen,
                        ),
                      ],
                      currentIndex: _selectedPage,
                      unselectedItemColor: Colors.white.withOpacity(.50),
                      selectedItemColor: Colors.white,
                      onTap: _onItemTapped,
                    ), //
                  );
                }
            }) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
  }
}
