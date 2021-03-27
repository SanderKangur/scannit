import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scannit/data/info_entity.dart';
import 'package:scannit/data/user.dart';

class UserRepo {
  final String uid;

  UserRepo({this.uid});

  // collection reference
  final CollectionReference userDataCollection =
      FirebaseFirestore.instance.collection('user');

  Future<void> createUserData(
      String uid, String name, Map<String, bool> choice) async {
    return await userDataCollection
        .doc(uid)
        .set({'uid': uid, 'name': name, 'choice': choice});
  }

  Future<void> updateName(String name) async {
    return await userDataCollection.doc(uid).update({
      'name': name,
    });
  }

  Stream<UserData> testUserDataStream(String uid) => FirebaseFirestore.instance
      .collection('user')
      .doc(uid)
      .snapshots()
      .map((dataDoc) =>
          UserData(uid: dataDoc.data()['uid'], name: dataDoc.data()['name']));

  Stream<UserData> getInfoByUid(String uid) => userDataCollection
      .where('uid', isEqualTo: uid)
      .snapshots()
      .map((snap) => snap.docs
          .map((dataDoc) => UserData(
                uid: dataDoc.data()['uid'],
                name: dataDoc.data()['name'],
              ))
          .first);

  // info list from snapshot
  List<Info> _infoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      //print(doc.data);
      return Info(
          name: doc.data()['name'] ?? '',
          types: Map<String, Map<String, bool>>.from(doc.data()['types']) ?? {});
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
      name: snapshot.data()['name'],
    );
  }

  //get user info
  Stream<UserData> get userData {
    return userDataCollection
        .doc(uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }
}
