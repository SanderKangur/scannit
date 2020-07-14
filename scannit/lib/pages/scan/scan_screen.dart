import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ScanScreen extends StatefulWidget {
  ScanScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  File takenImage;
  bool isImageLoaded = false;
  List<TextLine> lines = List<TextLine>();
  String fullText;

  Future takeImage() async {
    var tempStore = await ImagePicker.pickImage(source: ImageSource.camera);
    FirebaseVisionImage processedImage = FirebaseVisionImage.fromFile(tempStore);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(processedImage);
    List<TextLine> tempLines = List<TextLine>();

    readText.blocks.forEach((block) {
      block.lines.forEach((line) {
        tempLines.add(line);
      });
    });

    setState(() {
      takenImage = tempStore;
      isImageLoaded = true;
      fullText = readText.text;
      lines = tempLines;
    });
  }

  Future readText() async {
    FirebaseVisionImage processedImage = FirebaseVisionImage.fromFile(takenImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(processedImage);

    fullText = readText.text;
    readText.blocks.forEach((block) {
      block.lines.forEach((line) {
        lines.add(line);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isImageLoaded ? Column(
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Container(
              constraints: BoxConstraints.expand(),
              child: Image.file(
                takenImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: ListView.builder(
              itemCount: lines.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(lines.elementAt(index).text),
                );
              },
            ),
          ),
        ],
      )
      //Image.asset('assets/andu.jpg')
          : Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [
                    0.3,
                    0.6,
                  ],
                  colors: [Colors.lightGreen[100], Colors.white
                  ]
              )
          ),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment(0, -0.9),
                child: Padding(
                  padding:EdgeInsets.symmetric(
                      horizontal: 10.0
                  ),
                  child:Container(
                    height: 1.0,
                    color: Colors.brown,),
                ),
              ),
              Center(
                  child: FloatingActionButton(
                    onPressed: (){},
                    backgroundColor: Colors.lightGreen[300],
                    child: Icon(Icons.add_a_photo),
                  )),
            ],
          )
      ),
    );
  }
}