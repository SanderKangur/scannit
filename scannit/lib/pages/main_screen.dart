import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scannit/blocs/authentication_bloc/bloc.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scannit/data/info_repo.dart';
import 'package:scannit/data/info_entity.dart';
import 'package:scannit/pages/blog/blog_screen.dart';
import 'package:scannit/pages/scan/scan_screen.dart';
import 'package:scannit/pages/search/search_screen.dart';

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
      value: InfoRepo().info,
      //catchError: (_, err) => [Info(name: err.toString(), allergens: [], preferences: [])],
      child: Scaffold(
        body: IndexedStack(
          index: _selectedPage,
          children: pageList,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.inbox),
              title: Text('Blog'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_overscan),
              title: Text('Scan'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('Search'),
            ),BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Account'),
            ),
          ],
          currentIndex: _selectedPage,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.lightGreen[100],
          onTap: _onItemTapped,
          backgroundColor: Colors.lightGreen[300],
        ), //
      )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
  }
}


