import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scannit/constants.dart';
import 'package:scannit/pages/first_time/start.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Constants.cameras = await availableCameras();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(App());
  });
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Color(0xff324558),
      ),
    );
  }
}
