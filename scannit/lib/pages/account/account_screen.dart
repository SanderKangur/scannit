import 'package:flutter/material.dart';
import 'package:scannit/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({Key key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [
              0.3,
              0.6,
            ],
                colors: [
              Colors.lightGreen[100],
              Colors.white
            ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Container(
                height: 1.0,
                color: Colors.brown,
              ),
            ),
            RawMaterialButton(
              onPressed: () {
                _resetChoices();
                return main();
              },
              elevation: 5.0,
              fillColor: Colors.white,
              child: Icon(
                Icons.exit_to_app,
                size: 30.0,
                color: Colors.black54,
              ),
            )
          ],
        ),
      ),
    );
  }

  _resetChoices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('isFirstTime', true);
    });
  }
}
