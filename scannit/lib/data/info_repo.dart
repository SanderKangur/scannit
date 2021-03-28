import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scannit/constants.dart';
import 'package:scannit/data/info_entity.dart';

class InfoRepo {
  final String uid;

  InfoRepo({this.uid});

  // collection reference
  final CollectionReference infoCollection =
      FirebaseFirestore.instance.collection('info');

  Future<void> createUserInfo(
      String uid, Map<String, Map<String, bool>> types) async {
    return await infoCollection.doc(uid).set({'uid': uid, 'types': types});
  }

  Future<void> updateTypes() async {
    await infoCollection.doc(uid).update({
      'types': Constants.userTypes,
    });
  }

  Future<void> addAllergens(String allergen) async {
    Constants.userAllergens.add(allergen);
    return await infoCollection.doc(uid).update({
      'allergens': FieldValue.arrayUnion([]..add(allergen)),
    });
  }

  Future<void> deleteAllergens(int index) async {
    Constants.userAllergens.removeAt(index);
    infoCollection.doc(uid).update({
      'allergens': Constants.userAllergens,
    });
  }

  Stream<Info> infoStream(String uid) {
    return infoCollection.doc(uid).snapshots().map((dataDoc) => Info(
        uid: dataDoc.data()['uid'],
        types: Map<String, dynamic>.from(dataDoc.data()['types']).map(
            (key, value) =>
                MapEntry<String, Map<String, bool>>(key, Map.from(value)))));
  }

  // info list from snapshot
  List<Info> _infoListFromSnapshot(QuerySnapshot snapshot) {
    print("infolist: " + snapshot.docs.toString());
    return snapshot.docs.map((doc) {
      return Info(
          uid: doc.data()['uid'] ?? '',
          types:
              Map<String, Map<String, bool>>.from(doc.data()['types']) ?? {});
    }).toList();
  }

  // get lists stream
  Stream<List<Info>> get info {
    return infoCollection.snapshots().map(_infoListFromSnapshot);
  }
}
