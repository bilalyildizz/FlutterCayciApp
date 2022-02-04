import 'package:cayci_server/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    //'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class CayciPage extends StatefulWidget {
  @override
  _CayciPageState createState() => _CayciPageState();
}

class _CayciPageState extends State<CayciPage>
    with SingleTickerProviderStateMixin {
  FirestoreService _firestoreService = new FirestoreService();
  late AnimationController _animationController;
  @override
  void initState() {
    _animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);

    FirebaseMessaging.instance.getInitialMessage().then((message) {});
    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        var data = message.data["id"];
        final FirebaseFirestore _firestore = FirebaseFirestore.instance;

        _firestore.collection("users").doc(data).update({"renk": 1});

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
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id, channel.name,

                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.channel.description,
                icon: 'launch_background',
                importance: Importance.high,
              ),
            ));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {}
    });

    getToken().then((value) => {
          debugPrint(value),
          _firestoreService.updateFirebase(value.toString())
        });
  }

  int i = 5;
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("notification")
              .orderBy("notification", descending: true)
              .orderBy("timestap", descending: true)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshotStream) {
            if (snapshotStream.hasData) {
              return ListView(
                  children: snapshotStream.data!.docs
                      .map(
                        (doc) => Column(
                          children: [
                            if (doc["notification"] == true)
                              Column(children: [
                                if (doc["click"] == true)
                                  Dismissible(
                                    onDismissed: (direction) async {
                                      _firestoreService
                                          .updateCayciNotificationStatus(
                                              doc.id, false);
                                      _firestoreService
                                          .updateUserNotificationStatus(
                                              doc["id"], false);
                                      final FirebaseFirestore _firestore =
                                          FirebaseFirestore.instance;
                                      await _firestore
                                          .collection("notification")
                                          .doc(doc.id)
                                          .update(
                                              {"teslimSaati": DateTime.now()});
                                      await _firestore
                                          .collection("users")
                                          .doc(doc["id"])
                                          .update({"renk": 0});
                                    },
                                    key: UniqueKey(),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 10, 0, 10),
                                      child: Center(
                                        child: new GestureDetector(
                                            onTap: () async {},
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              width: 200,
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    13, 17, 0, 17),
                                                child: doc["click"] == false
                                                    ? FadeTransition(
                                                        opacity:
                                                            _animationController,
                                                        child: Text(
                                                          doc["username"]
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              color: Colors
                                                                      .lightGreen[
                                                                  700],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ))
                                                    : Text(
                                                        doc["username"]
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            color: Colors
                                                                    .lightGreen[
                                                                700],
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                              ),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,

                                                  //background color of box
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.4),
                                                      spreadRadius: 2,
                                                      blurRadius: 5,
                                                      offset: Offset(0,
                                                          3), // changes position of shadow
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          7.0),
                                                  border: Border.all(
                                                      width: 0.3,
                                                      color: Colors.black)),
                                            )),
                                      ),
                                    ),
                                  )
                                else
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    child: Center(
                                      child: new GestureDetector(
                                          onTap: () {
                                            final FirebaseFirestore _firestore =
                                                FirebaseFirestore.instance;
                                            _firestore
                                                .collection("notification")
                                                .doc(doc.id)
                                                .update({"click": true});
                                            _firestore
                                                .collection("users")
                                                .doc(doc["id"])
                                                .update({"renk": 4});
                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            width: 200,
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  13, 17, 0, 17),
                                              child: doc["click"] == false
                                                  ? FadeTransition(
                                                      opacity:
                                                          _animationController,
                                                      child: Text(
                                                        doc["username"]
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            color: Colors
                                                                    .lightGreen[
                                                                700],
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ))
                                                  : Text(
                                                      doc["username"]
                                                          .toString(),
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          color: Colors
                                                              .lightGreen[700],
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.white,

                                                //background color of box
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.4),
                                                    spreadRadius: 2,
                                                    blurRadius: 5,
                                                    offset: Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(7.0),
                                                border: Border.all(
                                                    width: 0.3,
                                                    color: Colors.black)),
                                          )),
                                    ),
                                  ),
                                SizedBox(
                                  height: 5,
                                  width: 20,
                                )
                              ])
                            else if (doc["teslimSaati"] != null)
                              Column(
                                children: [
                                  SizedBox(
                                    height: (queryData.size.height * 0.01),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: (queryData.size.width) * 0.12,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.green[50],

                                            //background color of box
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.4),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                            border: Border.all(
                                                width: 0.3,
                                                color: Colors.black)),
                                        child: Padding(
                                            padding: EdgeInsets.all(3),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width:
                                                      (queryData.size.width) *
                                                          0.45,
                                                  child: Text(doc["username"]
                                                      .toString()),
                                                ),
                                                SizedBox(
                                                  width:
                                                      (queryData.size.width) *
                                                          0.02,
                                                ),
                                                Container(
                                                    child: Text(DateFormat.Hm()
                                                        .format(doc["timestap"]
                                                            .toDate())
                                                        .toString())),
                                                SizedBox(
                                                  width:
                                                      (queryData.size.width) *
                                                          0.02,
                                                ),
                                                doc["ulasmaSaati"] != null
                                                    ? Container(
                                                        child: Text(DateFormat
                                                                .Hm()
                                                            .format(
                                                                doc["ulasmaSaati"]
                                                                    .toDate())
                                                            .toString()))
                                                    : Container(
                                                        child: Text("-")),
                                                SizedBox(
                                                  width:
                                                      (queryData.size.width) *
                                                          0.02,
                                                ),
                                                Container(
                                                    child: Text(DateFormat.Hm()
                                                        .format(
                                                            doc["teslimSaati"]
                                                                .toDate())
                                                        .toString())),
                                              ],
                                            )),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            else
                              Center(
                                child: CircularProgressIndicator(),
                              )
                          ],
                        ),
                      )
                      .toList());
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  Future<String?> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    return token;
  }
}
