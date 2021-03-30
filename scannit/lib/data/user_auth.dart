import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scannit/data/info_repo.dart';
import 'package:scannit/data/user.dart';

import '../allergens.dart';

class UserAuthenticationRepository {
  final FirebaseAuth _firebaseAuth;

  UserAuthenticationRepository({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  // create user obj based on firebase user
  LocalUser _userFromFirebaseUser(User user) {
    return user != null ? LocalUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<LocalUser> get user {
    return _firebaseAuth
        .userChanges()
        .map((event) => _userFromFirebaseUser(event));
    //.map((FirebaseUser user) => _userFromFirebaseUser(user));
    //.map(_userFromFirebaseUser);
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _firebaseAuth.signInAnonymously();
      User user = result.user;

      Map<String, Map<String, bool>> types = {
        "Additives": {},
        "Oils": {},
        "Herbs & spices": {},
        "Sweeteners": {},
        "Seeds": {},
        "Nuts": {},
        "Fruits & berries": {},
        "Vegetables": {},
        "Dairy": {},
        "Meat": {},
        "Seafood": {}
      };

      int i = -1;
      types.forEach((key, value) {
        i++;
        List<String> tmp = AllergensString.allergensString[i]
            .split(new RegExp("(?<!^)(?=[A-Z])"));
        tmp.sort();
        tmp.forEach((element) {
          value.putIfAbsent(
              element.replaceAll(new RegExp("[,\.:\n]"), ""), () => false);
        });
      });

      types.putIfAbsent("Custom", () => {});

      print("types at auth: " + types.toString());
      print("");

      await InfoRepo(uid: result.user.uid)
          .createUserInfo(result.user.uid, types);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<User> getUser() async {
    return (await _firebaseAuth.currentUser);
  }

  Future<bool> doesUserExists(String uid) async {
    final snapShot =
        await FirebaseFirestore.instance.collection('/users').doc(uid).get();
    return !(snapShot == null || !snapShot.exists);
  }
}
