import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scannit/pages/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Hints extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Hints"),
        ),
        body: Center(child: Container(child: Text("PLS good pic"))),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool('isFirstTime', false);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MainScreen(),
                ));
          },
          backgroundColor: const Color(0xff303952),
          child: Icon(Icons.double_arrow),
        ));
  }
}
