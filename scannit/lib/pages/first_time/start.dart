import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:scannit/constants.dart';
import 'package:scannit/data/allergens_entity.dart';
import 'package:scannit/data/categories_entity.dart';
import 'package:scannit/pages/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../stringValues.dart';

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<String> _choices = [];
  String _categories = "";
  String _allergens = "";

  @override
  void initState() {
    super.initState();
    _createCategories();
    _createAllergens();
    _loadChoices();
  }

  _createCategories() async {
    Categories categories = new Categories();

    for(int i = 0; i<stringValues.categoriesString.length; i++) {
      Category cat = new Category(id: "C$i", name: stringValues.categoriesString[i]);
      categories.categories.add(cat);
    };

    categories.categories.forEach((element) {
      print("CAT: " + element.toJson().toString());
    });

    Constants.categories = categories;
  }

  _createAllergens() async {
    Allergens allergens = new Allergens([]);

    int a = 0;
    for(int i = 0; i<stringValues.categoriesString.length-1; i++) {
      List<String> tmp = stringValues.allergensString[i]
          .split(new RegExp("(?<!^)(?=[A-Z])"));
      tmp.sort();
      tmp.forEach((element) {
        Allergen al = new Allergen(id: "A$a", name: element.replaceAll(new RegExp("[,.:\n]"), ""), category: "C$i");
        allergens.allergens.add(al);
        a++;
      });
    };

    for(int i = 180; i<allergens.allergens.length; i++){
      print("AL: " + allergens.allergens[i].toJson().toString());
    };

    /*allergens.allergens.forEach((element) {
      print("AL: " + element.toJson().toString());});*/

    //print("ALLERGENS CONTAINS: " + allergens.containsId("A21").toString());

    Constants.allergens = allergens;
  }

  _loadChoices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _choices = (prefs.getStringList('choices') ?? []);
      prefs.setStringList('choices', []);
    });
  }

  _loadCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _categories = (prefs.getString('categories') ?? "");
      _allergens = (prefs.getString('allergens') ?? "");
    });
  }


  @override
  Widget build(BuildContext context) {

    return MainScreen();
  }

}