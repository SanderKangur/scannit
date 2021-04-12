class Categories {
  List<Category> categories = [];

  String getName(String id) {
    String name = "";
    categories.forEach((element) {
      if (element.id.compareTo(id) == 1) name = element.name;
    });
    return name;
  }

  String getId(String name) {
    String id = "";
    categories.forEach((element) {
      if (element.name.compareTo(name) == 0) id = element.id;
    });
    print(id);
    return id;
  }
}

class Category {
  final String id;
  final String name;

  Category({this.id, this.name});

  factory Category.fromJson(Map<String, dynamic> parsedJson) {
    return new Category(
        id: parsedJson['id'] ?? "", name: parsedJson['name'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
    };
  }
}
