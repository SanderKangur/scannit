import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scannit/pages/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialHints extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                child: Text(
                  "3. Leia juhendist abi",
                  style: TextStyle(
                      fontSize: 36,
                      color: Theme.of(context).accentColor
                  ),
                )
            ),
            SizedBox(height: 16,),
            Container(height: 400,
              child: Image.asset('assets/tutorial/tutorial_hints.jpg',
                  fit: BoxFit.fitHeight),
            )
          ],
        ),
      ),
    );
  }
}