import 'package:cayci_server/SahredPreferences.dart';
import 'package:cayci_server/firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MusteriPage extends StatefulWidget {
  final String? id;

  const MusteriPage({Key? key, this.id}) : super(key: key);
  @override
  MusteriiPageState createState() => MusteriiPageState();
}

class MusteriiPageState extends State<MusteriPage> {
  FirestoreService _firestoreService = new FirestoreService();
  SharedPreference _sharedPreference = new SharedPreference();
  bool received = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<String>(
      future: _sharedPreference.getId(), // async work
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          default:
            if (snapshot.hasData) {
              String id = snapshot.data.toString();
              return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(id)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<DocumentSnapshot> snapshotStream) {
                    if (snapshotStream.hasData) {
                      var color = snapshotStream.data!['renk'];
                      var notificationStatus =
                          snapshotStream.data!['notification'];
                      var username = snapshotStream.data!['username'];

                      return Center(
                        child: ClipOval(
                            child: GestureDetector(
                          onTap: () async {
                            //bool sonuc=  await  bildirimGonder();,
                            if (notificationStatus == true) {
                            } else {
                              await _firestoreService.updateUserColor(id);
                              String? token =
                                  await _firestoreService.getToken();
                              await _firestoreService.updateUserNotification(
                                  id, true, token);
                              await _firestoreService.updateNotification(
                                  id, true, username);
                            }
                          },
                          child: Container(
                            width: 160.0,
                            height: 160.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: image(color),
                              ),
                            ),
                          ),
                        )),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  });
            } else
              return CircularProgressIndicator();
        }
      },
    ));
  }

  void _showDialog(String text) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text(text),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new ElevatedButton(
              child: new Text("Kapat"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String?> getSharedId() async {
    return await _sharedPreference.getId();
  }

  AssetImage image(int color) {
    if (color == 1)
      return AssetImage("assets/yesil.jpeg");
    else if (color == 2)
      return AssetImage("assets/mavi.jpeg");
    else if (color == 3)
      return AssetImage("assets/kirmizi.jpeg");
    else if (color == 4)
      return AssetImage("assets/yemyesil.jpeg");
    else {
      return AssetImage("assets/mavi.jpeg");
    }
  }
}
