import 'package:cayci_server/SahredPreferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'LoginPage.dart';
import 'cayciPage.dart';
import 'musteriPage.dart';
//import 'deneme.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  var data = message.data["id"];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  await _firestore.collection("users").doc(data).update({"renk": 1});
  QuerySnapshot querySnapshot = await _firestore
      .collection("notification")
      .where("id", isEqualTo: data)
      .where("notification", isEqualTo: true)
      .get();
  List docs = querySnapshot.docs;
  docs.forEach((doc) {
    _firestore
        .collection("notification")
        .doc(doc.id)
        .update({"ulasmaSaati": DateTime.now()});
  });
  print(data);
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
  SharedPreference _sharedPreference = new SharedPreference();
  String? sonuc = await _sharedPreference.getName();

  //runApp(MaterialApp(debugShowCheckedModeBanner: false,home:CayciPage()));

  if (sonuc == null) {
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: LoginPage()));
  } else {
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MusteriPage()));
  }
}
