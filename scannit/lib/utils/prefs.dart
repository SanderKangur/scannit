import 'dart:convert';

import 'package:scannit/data/allergens_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {

  Future<List<String>> getChoices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getStringList('choices') ?? [];
  }

  Future<List<Allergen>> getAllergens() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> jsonList = prefs.getStringList('allergens') ?? [];

    return jsonList.map((json) => Allergen.fromJson(jsonDecode(json))).toList();
  }
}