import 'package:cayci_server/SahredPreferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  SharedPreference _shared = new SharedPreference();
  Future<void> addStatus(String userName, String token) async {
    var ref = _firestore.collection("Users");
    var documentRef = await ref.add({'username': userName, 'token': token});
  }

  Future<String> getToken() async {
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc('ykpdEubxiKMAv75hzirN').get();
    Map<String, dynamic>? data = docSnapshot.data();
    return data!["token"].toString();
  }

  updateFirebase(
    String token,
  ) {
    _firestore
        .collection("users")
        .doc("ykpdEubxiKMAv75hzirN")
        .update({'token': token});
  }

  updateUserColor(String id) {
    _firestore.collection("users").doc(id).update({'renk': 3});
  }

  Future<void> updateCayciNotificationStatus(String id, bool status) async {
    await _firestore
        .collection("notification")
        .doc(id)
        .update({'notification': status});
  }

  Future<void> updateUserNotificationStatus(String id, bool status) async {
    await _firestore
        .collection("users")
        .doc(id)
        .update({'notification': status});
  }

  updateNotification(String id, bool status, String username) {
    _firestore.collection("notification").doc().set({
      'notification': status,
      "id": id,
      "username": username,
      "timestap": DateTime.now(),
      "ulasmaSaati": null,
      "teslimSaati": null,
      "click": false
    });
  }

  updateUserNotification(String id, bool status, String token) {
    _firestore
        .collection("users")
        .doc(id)
        .update({'notification': status, "notificationToken": token});
  }

  Future<void> addUser(String userName) async {
    await _firestore.collection("users").add({
      "username": userName,
      "renk": 0,
      "notification": false,
      "notificationToken": " ",
    }).then((value) => {_shared.setId(value.id.toString())});
  }
}

//https://www.youtube.com/watch?v=NMqQJTul71Y
