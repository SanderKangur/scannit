import 'package:flutter/material.dart';
import 'package:scannit/pages/allergens/allergen_categories.dart';
import 'package:scannit/pages/first_time/hints.dart';

class AllergenChoice extends StatefulWidget {
  @override
  _AllergenChoiceState createState() => _AllergenChoiceState();
}

class _AllergenChoiceState extends State<AllergenChoice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AllergenCategoriesScreen(),
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
        ));
  }
}
