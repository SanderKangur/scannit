import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scannit/pages/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialEnd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                child: Text(
                  "Alusta",
                  style: TextStyle(
                      fontSize: 36,
                      color: Theme.of(context).accentColor
                  ),
                )
            ),
            SizedBox(
              height: 32,
            ),
            RawMaterialButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('isFirstTime', false);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
              },
              fillColor: Theme.of(context).accentColor,
              elevation: 2,
              child: Icon(
                CupertinoIcons.square_arrow_right,
                size: 32,
                color: Colors.white,
              ),
              padding: EdgeInsets.all(15.0),
              shape: CircleBorder(),
            )
          ],
        ),
      ),
    );
  }
}