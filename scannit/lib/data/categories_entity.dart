import 'dart:collection';

class Categories {
  List<Category> categories = [];

}

class Category{
  final String id;
  final String name;

  Category({this.id, this.name});

  factory Category.fromJson(Map<String, dynamic> parsedJson) {
    return new Category(
        id: parsedJson['id'] ?? "",
        name: parsedJson['name'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
    };
  }
}