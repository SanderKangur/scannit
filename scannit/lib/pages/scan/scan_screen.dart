import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scannit/pages/dialogs/dialog_util.dart';
import 'package:scannit/pages/loading.dart';
import 'package:translator/translator.dart';

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
  bool isLoading = false;
  List<String> words = List<String>();
  String fullText;

  Future takeImage() async {

    var pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    var tempStore = File(pickedFile.path);
    FirebaseVisionImage processedImage =
        FirebaseVisionImage.fromFile(tempStore);

    setState(() {
      isImageLoaded = false;
      isLoading = true;
    });

    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(processedImage);
    List<String> tempWords = List<String>();


    if(readText.text != "") {
      final translator = GoogleTranslator();
      /*var translation = await translator.translate(readText.text, to: 'en');
      tempWords.add(translation.toString());*/


    String scannedString = "";

    readText.blocks.forEach((block) {
      block.lines.forEach((line) {
        line.elements.forEach((element) {
          scannedString += " " + element.text.toLowerCase().replaceAll(new RegExp("[,\.:]"), "");
          //tempWords.add(element.text.toLowerCase());
        });
      });
    });

    //print("SCANNED STRING" + scannedString);
    var translation = await translator.translate(scannedString, to: 'en');
    List<String> tmpList = translation.text.split(" ");
    tmpList.forEach((element) {
      String tmpString = element.toLowerCase();
      tempWords.add(tmpString);
    });

    }else tempWords.add("No ingredients detected");

    setState(() {
      takenImage = tempStore;
      isImageLoaded = true;
      fullText = readText.text;
      words = tempWords;
      build(context);
    });
  }

  String scanResult(List<String> scanned, List<String> allergens) {
    final allergensCheck = [scanned, allergens];

    print("SCANNED" + scanned.toString());
    print("ALLERGENS"  + allergens.toString());

    final allergensCommonSet = allergensCheck.fold<Set>(
        allergensCheck.first.toSet(), (a, b) => a.intersection(b.toSet())).toString();

    String allergensCommon = allergensCommonSet.substring(1, allergensCommonSet.length-1);

    print("THESE ARE COMMON ALLERGENS: " + allergensCommon);

    return allergensCommon;

    /*if (allergensCommon.length != 0)
      return allergensCommon;
    else
      return "1";*/
  }

  @override
  Widget build(BuildContext context) {
    print("hello scan");

    return Scaffold(
      body: isLoading ?
      isImageLoaded
          ? Column(
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
                    child: Builder(builder: (BuildContext context) {
                      List<String> tmp = Constants.userAllergens;
                      String result = scanResult(words, tmp);
                      print("scanResult: " + result.toString());
                      if (result.isNotEmpty) {
                        DialogUtil.showScanFailDialog(context, result);
                      } else {
                        DialogUtil.showScanSuccessDialog(context);
                      }
                      return ListView.builder(
                        itemCount: words.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(words.elementAt(index)),
                          );
                        },
                      );
                    })),
              ],
            ) : LoadingIndicator()
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
                      colors: [
                    Colors.lightGreen[100],
                    Colors.white
                  ])),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: Container(
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
              )),
      floatingActionButton: FloatingActionButton(
        onPressed: takeImage,
        backgroundColor: Colors.lightGreen[300],
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
