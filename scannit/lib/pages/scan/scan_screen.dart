import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scannit/data/info_entity.dart';
import 'package:scannit/data/info_repo.dart';
import 'package:scannit/pages/dialogs/dialog_util.dart';

import '../../constants.dart';

class ScanScreen extends StatefulWidget {
  ScanScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  File takenImage;
  bool isImageLoaded = false;
  List<String> words = List<String>();
  String fullText;

  Future takeImage() async {
    var tempStore = await ImagePicker.pickImage(source: ImageSource.camera);
    FirebaseVisionImage processedImage = FirebaseVisionImage.fromFile(tempStore);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(processedImage);
    List<String> tempWords = List<String>();

    readText.blocks.forEach((block) {
      block.lines.forEach((line) {
        line.elements.forEach((element){
          tempWords.add(element.text.toLowerCase());
        });
      });
    });

    setState(() {
      takenImage = tempStore;
      isImageLoaded = true;
      fullText = readText.text;
      words = tempWords;
    });
  }

  Future readText() async {
    FirebaseVisionImage processedImage = FirebaseVisionImage.fromFile(takenImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(processedImage);

    /*fullText = readText.text;
    readText.blocks.forEach((block) {
      block.lines.forEach((line) {
        line.elements.forEach((element) {
          words.add(element.text);
        });
      });
    });*/
  }

  @override
  Widget build(BuildContext context) {

    print("hello scan");

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
            child: StreamBuilder<Info>(
                stream: InfoRepo(uid: Constants.userId).getScanResultByUid(Constants.userId, words, 'allergens'),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    DialogUtil.showScanSuccessDialog(context);
                    return Text("No bad allergens");
                  }
                  else {
                    DialogUtil.showScanFailDialog(context);
                    return ListView.builder(
                      itemCount: words.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(words.elementAt(index)),
                        );
                      },
                    );
                  }
                }
            ),
            /*ListView.builder(
              itemCount: words.length,
              itemBuilder: (context, index) { 
                return ListTile(
                  title: Text(words.elementAt(index).text),
                );
              },
            ),*/
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
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child:Container(
                  height: 1.0,
                  color: Colors.brown,
                ),
              ),
              /*Expanded(
                child: Container(
                  child: FloatingActionButton(
                    onPressed: takeImage,
                    backgroundColor: Colors.lightGreen[300],
                    child: Icon(Icons.add_a_photo),
                  )),
              ),*/
            ],
          )
      ),
      floatingActionButton: FloatingActionButton(
              onPressed: takeImage,
              backgroundColor: Colors.lightGreen[300],
              child: Icon(Icons.add_a_photo),

      ),
    );
  }
}