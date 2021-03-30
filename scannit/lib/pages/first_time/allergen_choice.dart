import 'package:flutter/material.dart';
import 'package:scannit/pages/first_time/hints.dart';
import 'package:scannit/pages/search/allergen_types.dart';

import '../../main.dart';

class AllergenChoice extends StatefulWidget {
  @override
  _AllergenChoiceState createState() => _AllergenChoiceState();
}

class _AllergenChoiceState extends State<AllergenChoice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AllergenTypesScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Hints(),
              ));
        },
        backgroundColor: const Color(0xff303952),
        child: Icon(Icons.double_arrow),
      )
    );
  }
}
