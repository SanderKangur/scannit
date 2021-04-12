import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PreviewScreen extends StatefulWidget {
  final XFile file;
  final List<TextElement> elements;
  final String allergens;
  final Size imageSize;

  PreviewScreen({this.file, this.elements, this.allergens, this.imageSize});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  Color resultColor;
  String resultHeader;
  String resultText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Color(0xff324558),
          ),
          title: Text(
            resultHeader,
            style: TextStyle(color: Color(0xff324558)),
          ),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Image.file(
                    File(widget.file.path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    resultText,
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
