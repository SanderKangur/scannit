import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:scannit/data/allergens_entity.dart';
import '../../utils/loading.dart';
import 'package:scannit/pages/scan/preview_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_similarity/string_similarity.dart';

import '../../constants.dart';

class ScanScreen extends StatefulWidget {
  ScanScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  CameraController controller;

  File takenImage;
  bool isImageLoaded = false;
  bool isLoading;
  List<String> words = [];
  String fullText;
  Size imageSize;
  List<TextElement> scannedElements = [];
  List<TextElement> detectedElements = [];

  List<String> _choices = [];
  Allergens _allergens = Allergens([]);

  @override
  void initState() {
    super.initState();
    isLoading = false;
    _loadChoices();
    controller = CameraController(Constants.cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      controller.initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  Future takeImage(XFile file) async {
    var tempStore = File(file.path);

    FirebaseVisionImage processedImage =
        FirebaseVisionImage.fromFile(tempStore);
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
    List<TextElement> tempElements = [];
    recognizeText.close();

    RegExp regEx = RegExp("[^0-9]");

    if (readText.text != "") {
      readText.blocks.forEach((block) {
        block.lines.forEach((line) {
          line.elements.forEach((element) {
            if (regEx.hasMatch(element.text)) {
              tempElements.add(element);
              tempWords
                  .add(element.text.toLowerCase().replaceAll("[,.:\n]", ""));
            }
          });
        });
      });
    }

    setState(() {
      takenImage = tempStore;
      isImageLoaded = true;
      fullText = readText.text;
      words = tempWords;
      scannedElements = tempElements;
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

  String scanResult(List<String> scanned, List<String> choices) {
    print("SCANNED" + scanned.toString());
    print("ALLERGENS" + choices.toString());

    String allergensFound = "";

    if (scanned.length == 0) allergensFound += "0";

    bool foundMatch = false;
    scanned.forEach((element) {
      choices.forEach((choice) {
        double similarity = element.similarityTo(choice.toLowerCase());
        //print(element + ": " + similarity.toString());
        if (similarity > 0.5) {
          allergensFound += " " + choice;
          print(element + ": " + similarity.toString());

          if (!foundMatch) {
            allergensFound = "1" + allergensFound;
            foundMatch = true;
          }
        }
      });
    });

    for (TextElement element in scannedElements) {
      if (allergensFound
          .contains(element.text.toLowerCase().replaceAll("[,.:\n]", "")))
        detectedElements.add(element);
    }

    if (!foundMatch) allergensFound += "2";

    print("THESE ARE COMMON ALLERGENS: " + allergensFound);

    return allergensFound;
  }

  void _onCapturePressed(context) async {
    if (controller == null || !controller.value.isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: select a camera first.')));
      return null;
    }

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      XFile image;
      await controller.takePicture().then((value) => image = value);
      await takeImage(image);
      await _loadChoices();
      await _getAllergens();
      String allergens =
          scanResult(words, _allergens.getNames(_choices));
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PreviewScreen(
                    file: image,
                    elements: detectedElements,
                    allergens: allergens,
                    imageSize: imageSize,
                  ))).then((value) => isLoading = false);
      isLoading = false;
      print("isLoading: " + isLoading.toString());
      // 3
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    print(e.code + " " + e.description);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.code}\n${e.description}')));
  }

  Widget cameraPreview() {
    if (controller == null || !controller.value.isInitialized || isLoading) {
      return LoadingIndicator();
    }

    return CameraPreview(controller);
  }

  @override
  Widget build(BuildContext context) {
    print("hello scan");

    print("test" + "tomatipüree".similarityTo("tomat").toString());
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      body: cameraPreview(),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          _onCapturePressed(context);
        },
        child: const Icon(
          Icons.camera,
          color: Colors.white,
        ),
      ),
    );
    /*return Scaffold(
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
                          List<String> tmp = Constants.allergens.getNames(_choices);
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
                  */ /*Expanded(
                child: Container(
                  child: FloatingActionButton(
                    onPressed: takeImage,
                    backgroundColor: Colors.lightGreen[300],
                    child: Icon(Icons.add_a_photo),
                  )),
              ),*/ /*
                ],
              )),
      floatingActionButton: FloatingActionButton(
        onPressed: takeImage,
        backgroundColor: Colors.lightGreen[300],
        child: Icon(Icons.add_a_photo),
      ),
    );*/
  }

  _loadChoices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _choices = (prefs.getStringList('choices') ?? []);
    });
  }

  _getAllergens() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<dynamic> jsonList = prefs.getStringList('allergens') ?? [];

    _allergens.allergens = jsonList.map((json) => Allergen.fromJson(jsonDecode(json))).toList();
  }
}
