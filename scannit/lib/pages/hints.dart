import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scannit/pages/main_screen.dart';

import '../constants.dart';
import '../main.dart';

class Hints extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hints"),
      ),
      body: Center(
        child: Container(
          child: Text(
            "PLS good pic"
          )
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Constants.firstTime = false;
          print("hints " + Constants.firstTime.toString());
          return main();
        },
        backgroundColor: const Color(0xff303952),
        child: Icon(Icons.double_arrow),
      )
    );
  }
}

