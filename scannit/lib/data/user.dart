class User {

  final String uid;

  User({ this.uid });

}

class UserData {

  final String uid;
  final String name;
  final List<String> allergens;
  final List<String> preferences;

  UserData({ this.uid, this.name, this.allergens, this.preferences });
}