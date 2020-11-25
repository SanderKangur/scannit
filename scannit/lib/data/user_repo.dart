import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scannit/data/info_entity.dart';
import 'package:scannit/data/user.dart';

class UserRepo {
  final String uid;

  UserRepo({this.uid});

  // collection reference
  final CollectionReference userDataCollection =
      Firestore.instance.collection('user');

  Future<void> createUserData(
      String uid, String name, Map<String, bool> choice) async {
    return await userDataCollection
        .document(uid)
        .setData({'uid': uid, 'name': name, 'choice': choice});
  }

  Future<void> updateName(String name) async {
    return await userDataCollection.document(uid).updateData({
      'name': name,
    });
  }

  Stream<UserData> testUserDataStream(String uid) => Firestore.instance
      .collection('user')
      .document(uid)
      .snapshots()
      .map((dataDoc) =>
          UserData(uid: dataDoc.data['uid'], name: dataDoc.data['name']));

  Stream<UserData> getInfoByUid(String uid) => userDataCollection
      .where('uid', isEqualTo: uid)
      .snapshots()
      .map((snap) => snap.documents
          .map((dataDoc) => UserData(
                uid: dataDoc.data['uid'],
                name: dataDoc.data['name'],
              ))
          .first);

  // info list from snapshot
  List<Info> _infoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      //print(doc.data);
      return Info(
          name: doc.data['name'] ?? '',
          allergens: List<String>.from(doc.data['allergens']) ?? [],
          preferences: List<String>.from(doc.data['preferences']) ?? [],
          types: Map<String, Map<String, bool>>.from(doc.data['types']) ?? {});
    }).toList();
  }

  // get lists stream
  Stream<List<Info>> get info {
    return userDataCollection.snapshots().map(_infoListFromSnapshot);
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
    return userDataCollection
        .document(uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }
}
