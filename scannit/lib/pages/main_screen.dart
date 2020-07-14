import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scannit/blocs/authentication_bloc/bloc.dart';
import 'file:///C:/Users/Sander/AndroidStudioProjects/Flutter/scannit/lib/data/database.dart';
import 'file:///C:/Users/Sander/AndroidStudioProjects/Flutter/scannit/lib/pages/blog/blog_screen.dart';
import 'file:///C:/Users/Sander/AndroidStudioProjects/Flutter/scannit/lib/pages/account/account_screen.dart';
import 'file:///C:/Users/Sander/AndroidStudioProjects/Flutter/scannit/lib/pages/scan/scan_screen.dart';
import 'file:///C:/Users/Sander/AndroidStudioProjects/Flutter/scannit/lib/pages/search/search_screen.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scannit/data/info_entity.dart';



class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.name}) : super(key: key);
  final String name;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

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
    return StreamProvider<List<Info>>.value(
      value: DatabaseService().info,
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


