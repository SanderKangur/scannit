import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scannit/constants.dart';
import 'package:scannit/data/allergens_entity.dart';
import 'package:scannit/data/categories_entity.dart';
import 'package:scannit/pages/first_time/allergen_choice.dart';
import 'package:scannit/pages/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scannit/utils/stringValuesEST.dart';

import 'hints.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _choices = [];
  bool _isFirstTime = false;
  String _categories = "";
  List<String> _allergens = [];

  @override
  void initState() {
    super.initState();
    _createCategories();
    _loadAllergens();
    _loadChoices();
  }

  _createCategories() async {
    String data = await DefaultAssetBundle.of(context).loadString("assets/categories.json");

    //converts json string into list of allergens
    List<Category> categories;
    categories = await (json.decode(data) as List).map((i) =>
        Category.fromJson(i)).toList();

    categories.forEach((element) {
      print("CAT: " + element.toJson().toString());
    });

    print("LEN: " + categories.length.toString());

    Constants.categories = Categories(categories);
  }

  _createAllergens() async {
    Allergens allergens = new Allergens([]);

    int a = 0;
    for (int i = 0; i < stringValuesEST.categoriesString.length - 2; i++) {
      List<String> tmp =
          stringValuesEST.allergensString[i].split(new RegExp("(?<!^)(?=[A-Z])"));
      tmp.sort();
      tmp.forEach((element) {
        Allergen al = new Allergen(
            id: "A$a",
            name: element.replaceAll(new RegExp("[,.:\n]"), ""),
            category: "C${i+1}");
        allergens.allergens.add(al);
        a++;
      });
    }
    ;

    for (int i = 180; i < allergens.allergens.length; i++) {
      print("AL: " + allergens.allergens[i].toJson().toString());
    }
    ;

    /*allergens.allergens.forEach((element) {
      print("AL: " + element.toJson().toString());});*/

    //print("ALLERGENS CONTAINS: " + allergens.containsId("A21").toString());

    Constants.allergens = allergens;
  }

  _loadAllergens() async {
    //Creates the string version of json file, so it can be saved to local storage

    //reads json into json string
    String data = await DefaultAssetBundle.of(context).loadString("assets/allergens.json");

    //converts json string into list of allergens
    List<Allergen> allergens;
    allergens = await (json.decode(data) as List).map((i) =>
        Allergen.fromJson(i)).toList();

    //converts list of allergens into list of strings
    List<String> jsonList = allergens.map((allergen) => jsonEncode(allergen.toJson())).toList();

    //update global variable _allergens
    _allergens = jsonList;
  }

  _loadChoices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _isFirstTime = prefs.getBool('isFirstTime') ?? true;

      if (_isFirstTime) {
        print("First: " + _allergens.first);
        print("Last: " + _allergens.last);
        prefs.setStringList('allergens', _allergens);
        prefs.setStringList('choices', []);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isFirstTime ? Hints() : MainScreen();
  }
}
