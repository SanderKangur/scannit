class Categories {
  List<Category> categories = [];

  Categories(this.categories);

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
  
  List<Category> getSubCategories(){
    return categories.sublist(13);
  }

}

class Category {
  final String id;
  final String name;

  Category({this.id, this.name});

  factory Category.fromJson(Map<String, dynamic> parsedJson) {
    return new Category(
        id: parsedJson['Id'] ?? "", name: parsedJson['Name'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      "Id": this.id,
      "Name": this.name,
    };
  }
}
