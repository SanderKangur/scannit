import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scannit/pages/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialAllergens extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                child: Text(
                  "1. Vali allergeenid",
                  style: TextStyle(
                      fontSize: 36,
                      color: Theme.of(context).accentColor
                  ),
                )
            ),
            SizedBox(height: 16,),
            Container(height: 400,
              child: Image.asset('assets/tutorial/tutorial_allergens.jpg',
              fit: BoxFit.fitHeight),
            )
          ],
        ),
      ),
    );
  }
}