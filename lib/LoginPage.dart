import 'package:cayci_server/SahredPreferences.dart';
import 'package:cayci_server/firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'musteriPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  SharedPreference _sharedPreferences = new SharedPreference();
  FirestoreService _firestoreService = new FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/arka.png"),
                        fit: BoxFit.cover)),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 60, 0, 5),
                      child: Container(
                          width: MediaQuery.of(context).size.width * 1,
                          height: MediaQuery.of(context).size.width * 1,
                          child: Image.asset(
                            "assets/NewLogoCayci.png",
                            fit: BoxFit.cover,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width * 0.15,
                          MediaQuery.of(context).size.height * 0,
                          MediaQuery.of(context).size.width * 0.15,
                          MediaQuery.of(context).size.height * 0.03),
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: "Ad",
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(221, 90, 68, 1),
                                  width: 2)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(221, 90, 68, 1))),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width * 0.45,
                          MediaQuery.of(context).size.height * 0.04,
                          MediaQuery.of(context).size.width * 0.10,
                          MediaQuery.of(context).size.height * 0.15),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: ElevatedButton(
                          onPressed: () async {
                            await _firestoreService
                                .addUser(nameController.text);
                            await _sharedPreferences
                                .setName(nameController.text);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MusteriPage()));
                          },
                          child: Text(
                            "Giriş",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Color.fromRGBO(221, 90, 68, 1),
                              ),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ))),
                        ),
                      ),
                    ),
                  ],
                )))));
  }
}
