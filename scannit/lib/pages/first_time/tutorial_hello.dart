import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scannit/pages/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialHello extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                child: Text(
                    "Tere tulemast",
                  style: TextStyle(
                    fontSize: 36,
                    color: Theme.of(context).accentColor
                  ),
                )
            )
        ),
    );
  }
}