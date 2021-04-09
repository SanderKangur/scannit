import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PreviewScreen extends StatefulWidget {
  final XFile file;
  final Color color;
  final String allergens;
  PreviewScreen({this.file, this.color, this.allergens});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {

  Color resultColor;
  String resultHeader;
  String resultText;

  @override
  Widget build(BuildContext context) {

    int result = int.parse(widget.allergens.substring(0, 1));

    switch (result){
      case 0:
        resultColor = Colors.orange;
        resultHeader = "No text detected";
        resultText = "Oops! It seems that there were no words in your photo";
        break;
      case 1:
        resultColor = Colors.red;
        resultHeader = "Scan failed";
        resultText = "Found: " + widget.allergens.substring(1);
        break;
      case 2:
        resultColor = Colors.green;
        resultHeader = "Scan passed";
        resultText = "No unwanted allergens detected!";
        break;
    }
    print(resultColor.toString());


    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: resultColor,
          ),
          title: Text(
            resultHeader,
            style: TextStyle(
              color: resultColor
            ),
          ),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.all(10),
                  color: resultColor,
                  child: Image.file(File(widget.file.path),fit: BoxFit.cover,)
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    resultText,
                    style: TextStyle(
                      fontSize: 24
                    ),
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}