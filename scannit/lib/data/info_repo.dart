import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scannit/constants.dart';
import 'package:scannit/data/info_entity.dart';
import 'package:scannit/data/user.dart';

class InfoRepo {
  final String uid;

  InfoRepo({this.uid});

  // collection reference
  final CollectionReference infoCollection =
      Firestore.instance.collection('info');

  Future<void> createUserInfo(String uid, List<String> allergens,
      List<String> preferences, Map<String, Map<String, bool>> types) async {
    return await infoCollection.document(uid).setData({
      'uid': uid,
      'allergens': allergens,
      'preferences': preferences,
      'types': types
    });
  }

  Future<void> addAllergens(String allergen) async {
    Constants.userAllergens.add(allergen);
    return await infoCollection.document(uid).updateData({
      'allergens': FieldValue.arrayUnion(List()..add(allergen)),
    });
  }

  Future<void> deleteAllergens(int index) async {
    Constants.userAllergens.removeAt(index);
    Firestore.instance.collection('info').document(uid).updateData({
      'allergens': Constants.userAllergens,
    });
  }

  Future<void> addPreferences(String preference) async {
    Constants.userPreferences.add(preference);
    return await infoCollection.document(uid).updateData({
      'preferences': FieldValue.arrayUnion(List()..add(preference)),
    });
  }

  Future<void> deletePreferences(int index) async {
    Constants.userPreferences.removeAt(index);
    Firestore.instance.collection('info').document(uid).updateData({
      'preferences': Constants.userPreferences,
    });
  }

  Stream<Info> infoStream(String uid) {
    return infoCollection.document(uid).snapshots().map((dataDoc) => Info(
        name: dataDoc.data['name'],
        allergens: List<String>.from(dataDoc.data['allergens']),
        preferences: List<String>.from(['preferences']),
        types: Map<String, dynamic>.from(dataDoc.data['types']).map(
            (key, value) =>
                MapEntry<String, Map<String, bool>>(key, Map.from(value)))));
  }

  Stream<Info> getScanResultByUid(
          String uid, List<String> scannedWords, String infoType) =>
      infoCollection.where('uid', isEqualTo: uid).snapshots().map((snap) => snap
          .documents
          .map((dataDoc) => Info(
              name: dataDoc.data['name'],
              allergens: List<String>.from(dataDoc.data['allergens']),
              preferences: List<String>.from(dataDoc.data['preferences'])))
          .first);

  Future<Info> testInfo(String uid) async {
    var dataDoc = await Firestore.instance
        .collection('info')
        .document(uid)
        .snapshots()
        .first;

    print('andmed siin' + dataDoc.data.toString());
    return Info(
        name: dataDoc.data['name'],
        allergens: List<String>.from(dataDoc.data['allergens']),
        preferences: List<String>.from(dataDoc.data['preferences']),
        types: Map<String, dynamic>.from(dataDoc.data['test']));
  }

  // info list from snapshot
  List<Info> _infoListFromSnapshot(QuerySnapshot snapshot) {
    print("infolist: " + snapshot.documents.toString());
    return snapshot.documents.map((doc) {
      return Info(
          name: doc.data['name'] ?? '',
          allergens: List<String>.from(doc.data['allergens']) ?? [],
          preferences: List<String>.from(doc.data['preferences']) ?? [],
          types: Map<String, Map<String, bool>>.from(doc.data['types']) ?? {});
    }).toList();
  }

  // get lists stream
  Stream<List<Info>> get info {
    return infoCollection.snapshots().map(_infoListFromSnapshot);
  }

  //user data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
    );
  }

  //get user info
  Stream<UserData> get userData {
    return infoCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}
