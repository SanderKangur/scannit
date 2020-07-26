import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scannit/data/info_entity.dart';
import 'package:scannit/data/user.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference infoCollection = Firestore.instance.collection('info');

  Future<void> updateUserData(String name, List<String> allergens, List<String> preferences) async {
    return await infoCollection.document(uid).setData({
      'name': name,
      'allergens': allergens,
      'preferences': preferences,
    });
  }

  Future<void> updateAllergens(String allergen) async {
    return await infoCollection.document(uid).updateData({
      'allergens': FieldValue.arrayUnion(List()..add(allergen)),
    });
  }

  /*Future<void> updatePreferences(String preference) async {
    return await infoCollection.document(uid).updateData({
      'preferences': FieldValue.arrayUnion(List()..add(preference)),
    });
  }*/

  // info list from snapshot
  List<Info> _infoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      //print(doc.data);
      return Info(
          name: doc.data['name'] ?? '',
          allergens: List<String>.from(doc.data['allergens']) ?? [],
          preferences: List<String>.from(doc.data['preferences']) ?? []
      );
    }).toList();
  }

  // get lists stream
  Stream<List<Info>> get info {
    return infoCollection.snapshots()
        .map(_infoListFromSnapshot);
  }

  //user data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.data['name'],
        allergens: List<String>.from(snapshot.data['allergens']) ?? [],
        preferences: List<String>.from(snapshot.data['preferences']) ?? []
    );
  }

  //get user info
  Stream<UserData> get userData {
    return infoCollection.document(uid).snapshots()
        .map(_userDataFromSnapshot);
  }

}