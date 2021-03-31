import 'dart:async';
import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scannit/pages/dialogs/dialog_util.dart';
import 'package:scannit/pages/loading.dart';
import 'package:string_similarity/string_similarity.dart';

import '../../constants.dart';
import 'TextDetectorPainter.dart';

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
  List<String> words = [];
  String fullText;
  Size imageSize;
  List<TextBlock> elements = [];

  Future takeImage() async {
    var pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    var tempStore = File(pickedFile.path);

    FirebaseVisionImage processedImage = FirebaseVisionImage.fromFile(tempStore);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();

    setState(() {
      isImageLoaded = false;
      isLoading = true;
    });

    if (tempStore != null) {
      await _getImageSize(tempStore);
    }

    VisionText readText = await recognizeText.processImage(processedImage);
    List<String> tempWords = [];
    List<TextBlock> tempElements = [];
    recognizeText.close();

    RegExp regEx = RegExp("[^0-9]");

    if (readText.text != "") {
      readText.blocks.forEach((block) {
        tempElements.add(block);
        block.lines.forEach((line) {
          line.elements.forEach((element) {
            if(regEx.hasMatch(element.text)) {
              tempWords.add(
                  element.text.toLowerCase().replaceAll("[,.:\n]", ""));
            }
          });
        });
      });
    } else
      tempWords.add("No ingredients detected");

    setState(() {
      takenImage = tempStore;
      isImageLoaded = true;
      fullText = readText.text;
      words = tempWords;
      elements = tempElements;
      build(context);
    });
  }

  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    // Fetching image from path
    final Image image = Image.file(imageFile);

    // Retrieving its size
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size tmp = await completer.future;
    setState(() {
      imageSize = tmp;
    });
  }

  String scanResult(List<String> scanned, List<String> allergens) {
    print("SCANNED" + scanned.toString());
    print("ALLERGENS" + allergens.toString());

    String allergensFound = "";

    scanned.forEach((element) {
      allergens.forEach((allergen) {
        double similarity = element.similarityTo(allergen);
        //print(element + ": " + similarity.toString());
        if (similarity > 0.5) {
          allergensFound += " " + element;
          print(element + ": " + similarity.toString());
        }
      });
    });

    print("THESE ARE COMMON ALLERGENS: " + allergensFound);

    return allergensFound;
  }

  @override
  Widget build(BuildContext context) {
    print("hello scan");

    return Scaffold(
      body: isLoading
          ? isImageLoaded
              ? Column(
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: Container(
                        constraints: BoxConstraints.expand(),
                        child: CustomPaint(
                          foregroundPainter: TextDetectorPainter(imageSize, elements),
                          child: AspectRatio(
                            aspectRatio: imageSize.aspectRatio,
                            child: Image.file(
                              takenImage,
                            ),
                          ),
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
                )
              : LoadingIndicator()
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


