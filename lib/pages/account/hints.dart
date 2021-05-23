import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:empty_widget/empty_widget.dart';


class Hints extends StatefulWidget {
  @override
  _HintsState createState() => _HintsState();
}

class _HintsState extends State<Hints> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Juhendid",
            style:
            TextStyle(fontSize: 24, color: Theme.of(context).accentColor),
          )),
      body: Container(
        alignment: Alignment.center,
        child: EmptyWidget(
          image: null,
          packageImage: PackageImage.Image_1,
          title: 'Oops!',
          subTitle: 'Juhendid tulevad varsti',
          titleTextStyle: TextStyle(
            fontSize: 24,
            color: Color(0xff9da9c7),
            fontWeight: FontWeight.w500,
          ),
          subtitleTextStyle: TextStyle(
            fontSize: 16,
            color: Color(0xffabb8d6),
          ),
        ),
      ),
    );
  }

  _resetChoices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('isFirstTime', true);
      prefs.setStringList('allergens', []);
    });
  }
}
