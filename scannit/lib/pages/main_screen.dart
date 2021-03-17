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
        child: StreamBuilder<Info>(
            stream: InfoRepo().infoStream(Constants.userId),
            //Firestore.instance.collection('info').document(Constants.userId).snapshots(),
            builder: (context, snapshot) {
              //print("Types " + snapshot.data.types.toString());
              if (snapshot.data == null) {
                return Scaffold(body: LoadingIndicator());
              } else
                Constants.userAllergens = snapshot.data.allergens;
              Constants.userPreferences = snapshot.data.preferences;
              Constants.userTypes = snapshot.data.types;
              return Scaffold(
                body: IndexedStack(
                  index: _selectedPage,
                  children: pageList,
                ),

                /*body: PageView(
                  scrollDirection: Axis.horizontal,
                  controller: PageController(initialPage: _selectedPage),
                  children: pageList,
                  onPageChanged: _onItemTapped
                ),*/

                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.shifting,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: Icon(Icons.inbox),
                        label: 'Blog',
                        backgroundColor: const Color(0xff303952)),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.settings_overscan),
                        label: 'Scan',
                        backgroundColor: const Color(0xff303952)),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.search),
                        label: 'Search',
                        backgroundColor: const Color(0xff303952)),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.settings),
                        label: 'Account',
                        backgroundColor: const Color(0xff303952)),
                  ],
                  currentIndex: _selectedPage,
                  unselectedItemColor: Colors.white.withOpacity(.50),
                  selectedItemColor: Colors.white,
                  onTap: _onItemTapped,
                ), //
              );
            }) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
  }
}
