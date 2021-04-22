class Allergens {
  List<Allergen> allergens;

  Allergens(this.allergens);

  bool containsId(String id) {
    for (int i = 0; i < allergens.length; i++) {
      if (allergens[i].id == id) return true;
    }
    return false;
  }

  List<Allergen> chooseByCategory(String category) {
    List<Allergen> result = [];
    allergens.forEach((element) {
      List<String> cats = element.category.split(", ");
      if (cats.contains(category)) result.add(element);
      //print("ELEMENT IN CAT: " + element);
    });
    return result;
  }

  List<String> filterChoiceByCategory(String category, List<String> choices) {
    List<String> names = [];
    for (var value in chooseByCategory(category)
        .where((value) => choices.contains(value.id))) {
      names.add(value.name);
    }
    //print("NAMES: " + names.toString());
    return names;
  }

  String chosenAllergensString(List<String> allergens) {
    String result = "";
    if (allergens.isNotEmpty) {
      allergens.forEach((element) {
        result += " " + element;
      });
    }
    return result;
  }

  List<String> getNames(List<String> choices) {
    List<String> names = [];
    for (var value
        in allergens.where((element) => choices.contains(element.id))) {
      names.add(value.name);
    }
    //print("NAMES: " + names.toString());
    return names;
  }

  void removeById(String id) {
    Allergen removed;
    allergens.remove(allergens.where((element) => element.id == id ).first);
  }
}

class Allergen {
  final String id;
  final String name;
  final String category;

  Allergen({this.id, this.name, this.category});

  factory Allergen.fromJson(Map<String, dynamic> parsedJson) {
    return new Allergen(
        id: parsedJson['Id'] ?? "",
        name: parsedJson['Name'] ?? "",
        category: parsedJson['Categories'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      "Id": this.id,
      "Name": this.name,
      "Categories": this.category,
    };
  }

  @override
  String toString() {
    return '{"Id": $id, "Name": $name, "Categories": $category}';
  }
}
