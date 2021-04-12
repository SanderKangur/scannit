import 'dart:collection';

import 'package:flutter/cupertino.dart';

class Allergens {

  final List<Allergen> allergens;

  Allergens(this.allergens);

  bool containsId(String id){
     for(int i = 0; i<allergens.length; i++){
       if(allergens[i].id == id) return true;
     }
     return false;
  }

  List<Allergen> chooseByCategory(String category){
     List<Allergen> result = [];
     allergens.forEach((element) {
       if(element.category == category) result.add(element);
     });
     return result;
  }

  List<String> filterChoiceByCategory(String category, List<String> choices){
    List<String> names = [];
    for (var value in chooseByCategory(category).where((value) => choices.contains(value.id))) {
      names.add(value.name);
    }
    //print("NAMES: " + names.toString());
    return names;
  }

  String chosenAllergensString(List<String> allergens){
    String result = "";
    if(allergens.isNotEmpty){
      allergens.forEach((element) {
        result += " " + element;
      });
    }
    return result;
  }

  String toString(){
    String result = "";
    allergens.forEach((element) {
      result += element.toJson().toString();
    });
    return result;
  }

  List<String> getNames(List<String> choices) {
    List<String> names = [];
    for (var value in allergens.where((element) =>
        choices.contains(element.id))) {
      names.add(value.name);
    }
    //print("NAMES: " + names.toString());
    return names;
  }
  
  void removeById(String id){
    Allergen removed;
    allergens.forEach((element) {
      if(element.id == id) {
        removed = element;
        return;
      };
    });
    allergens.remove(removed);
  }
}

class Allergen{
  final String id;
  final String name;
  final String category;

  Allergen({this.id, this.name, this.category});

  factory Allergen.fromJson(Map<String, dynamic> parsedJson) {
    return new Allergen(
        id: parsedJson['id'] ?? "",
        name: parsedJson['name'] ?? "",
        category: parsedJson['category'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "category": this.category,
    };
  }
}