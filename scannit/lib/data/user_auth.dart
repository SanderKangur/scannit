import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scannit/constants.dart';
import 'package:scannit/data/info_repo.dart';
import 'package:scannit/data/user.dart';
import 'package:scannit/data/user_repo.dart';

import '../allergens.dart';

class UserAuthenticationRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  UserAuthenticationRepository(
      {FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();

  // create user obj based on firebase user
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _firebaseAuth.onAuthStateChanged
        //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser();
  }

  Future<void> signInWithCredentials(String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<void> signUp({String email, String password}) async {
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Map<String, Map<String, bool>> types = {
        "Additives": {},
        "Oils": {},
        "Herbs & spices": {},
        "Sweeteners": {},
        "Seeds": {},
        "Nuts": {},
        "Fruits": {},
        "Vegetables": {},
        "Dairy": {},
        "Meat": {},
        "Seafood": {},
        "Custom": {}
      };

      int i = -1;
      types.forEach((key, value) {
        i++;
        List<String> tmp = AllergensString.allergensString[i]
            .split(new RegExp("(?<!^)(?=[A-Z])"));
        tmp.sort();
        tmp.forEach((element) {
          value.putIfAbsent(element, () => false);
        });
      });

      print("types at auth: " + types.toString());
      print("");

      await InfoRepo(uid: result.user.uid)
          .createUserInfo(result.user.uid, [], [], types);
      await UserRepo(uid: result.user.uid).createUserData(
          result.user.uid, Constants.userName, Constants.userChoice);
      return result;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<FirebaseUser> getUser() async {
    return (await _firebaseAuth.currentUser());
  }

  Future<bool> doesUserExists(String uid) async {
    final snapShot =
        await Firestore.instance.collection('/users').document(uid).get();
    return !(snapShot == null || !snapShot.exists);
  }

  Future<void> deleteIngredient(String title) async {
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot snapshot = await tx.get(
          Firestore.instance.collection('users').document(Constants.userId));
      var doc = snapshot.data;
      if (doc['ingredients'].contains(title)) {
        await tx.update(snapshot.reference, <String, dynamic>{
          'ingredients': FieldValue.arrayRemove([title])
        });
      }
    });
  }

  void addIngredient(String value) {
    Firestore.instance
        .document(Constants.userId)
        .updateData({"ingredients": FieldValue.arrayUnion(List()..add(value))});
  }
}
