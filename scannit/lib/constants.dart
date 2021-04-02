import 'data/allergens_entity.dart';
import 'data/categories_entity.dart';
import '../../stringValues.dart';

class Constants {
  static String userId;
  static List<String> userAllergens = [];
  static bool firstTime = true;
  static Map<String, Map<String, bool>> userTypes = {};
  static Categories categories;
  static Allergens allergens;
}
