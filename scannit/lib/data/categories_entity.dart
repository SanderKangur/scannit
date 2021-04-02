import 'dart:collection';

class Categories {
  List<HashMap<String, String>>_categories;

  List<HashMap<String, String>> get categories => _categories;

  set categories(List<HashMap<String, String>> value) {
    _categories = value;
  }
}