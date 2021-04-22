import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scannit/data/allergens_entity.dart';
import 'package:scannit/utils/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_similarity/string_similarity.dart';

import '../../constants.dart';
import 'detector_painters.dart';
import 'scanner_utils.dart';

class CameraPreviewScanner extends StatefulWidget {
  const CameraPreviewScanner({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CameraPreviewScannerState();
}

class _CameraPreviewScannerState extends State<CameraPreviewScanner> {
  dynamic _scanResults;
  CameraController _camera;
  Detector _currentDetector = Detector.text;
  bool _isDetecting = false;
  CameraLensDirection _direction = CameraLensDirection.back;

  List<String> _choices = [];
  Allergens _allergens = Allergens([]);
  List<String> _choicesNames = [];
  List<String> _allergensFound = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final CameraDescription description =
    await ScannerUtils.getCamera(_direction);

    await _loadChoices();
    await _getAllergens();
    _choicesNames = _allergens.getNames(_choices);

    _camera = CameraController(
      description,
      defaultTargetPlatform == TargetPlatform.iOS
          ? ResolutionPreset.low
          : ResolutionPreset.high,
      enableAudio: false,
    );
    await _camera.initialize();

    print("INITIALIZE CAM");

    await _camera.startImageStream((CameraImage image) {
      if (_isDetecting) return;

      _isDetecting = true;



      ScannerUtils.detect(
        image: image,
        imageRotation: description.sensorOrientation,
      ).then(
            (dynamic results) {
              if(!mounted) return;
            setState(() {
              _scanResults = results;
            });
          }
      ).whenComplete(() => _isDetecting = false);
    });
  }

  Widget _buildResults() {
    const Text noResultsText = Text('No results');

    if (_scanResults == null ||
        _camera == null ||
        !_camera.value.isInitialized) {
      return noResultsText;
    }

    CustomPainter painter;

    final Size imageSize = Size(
      _camera.value.previewSize.height,
      _camera.value.previewSize.width,
    );

    _currentDetector == Detector.text;
    if (_scanResults is! VisionText) return noResultsText;
    painter = TextDetectorPainter(imageSize, _scanResults, _allergens.getNames(_choices));

    return CustomPaint(
      painter: painter,
    );
  }

  Widget _buildImage() {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: _camera == null
          ? LoadingIndicator()
          : Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CameraPreview(_camera),
          _buildResults(),
        ],
      ),
    );
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


  @override
  Widget build(BuildContext context) {

    VisionText scannedText = _scanResults;
    ScanResult result = ScanResult();
    print(_choicesNames.toString());

    if(scannedText != null){
      if(scannedText.blocks.isEmpty && _allergensFound.isEmpty) {
        result.color = Colors.orange[300];
        result.text = "Suuna kaamera etiketi poole";
      }
      else {

        for (final TextBlock block in scannedText.blocks) {
          for (final TextLine line in block.lines) {
            for (final TextElement element in line.elements) {
              _choicesNames.forEach((choice) {
                String c = choice.toLowerCase();
                String e = element.text.toLowerCase();
                double threshold = 0;
                if(e.length>5) threshold = 0.6;
                else threshold = 0.8;
                double similarity = e.similarityTo(c);
                if ((similarity > threshold || e.contains(c)) && !_allergensFound.contains(choice)) {
                  print(element.text + ": " + similarity.toString());
                  _allergensFound.add(choice);
                };
              });
            }
          }
        }
        if(_allergensFound.isEmpty){
          result.color = Colors.green[300];
          result.text = "Ei tuvastatud ühtegi allergeeni pakendilt";
        } else{
          result.color = Colors.red[300];
          result.text = "Tuvastati: " + Constants.listToString(_allergensFound);
        }
      }
    }

    return _scanResults == null ? LoadingIndicator() : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                _allergensFound.clear();
              },
              child: Text("Tühjenda",
                style: TextStyle(
                    color: Color(0xff324558),
                ),
              )
            ),
          ],
        )
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Container(
                child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]
                    ),
                    child: _buildImage())
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: result.color,
                child: Center(
                  child: Text(
                    result.text,
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  @override
  void dispose() {
    _camera.dispose().then((_) {
      FirebaseVision.instance.textRecognizer().close();
    });

    super.dispose();
  }
}

class ScanResult {
    Color color = Colors.white;
    String text = "";
}