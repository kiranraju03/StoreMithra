import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserRegistration extends StatefulWidget {
  @override
  _UserRegistrationState createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final firebaseInst = FirebaseDatabase.instance;

  final genderList = ["Select", "Male", "Female"];
  String dropdownValue = 'Select';

  final ailesList = [
    ["male costmetics", "health care", "baby care", "fabric care"],
    ["female costmetics", "baby care", "home care", "fabric care"],
    [
      "toys",
      "baby care",
      "home care",
      "snacks",
    ]
  ];

  // List<String> sendAileList = [];

  @override
  Widget build(BuildContext context) {
    final dbReference = firebaseInst.reference();
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "Please Share your Valuable Info",
                    style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: TextFormField(
                          // inputFormatters: [LengthLimitingTextInputFormatter(10)],
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "Name",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please Re-Enter your Name";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10)
                          ],
                          controller: phoneNumController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: "Enter Phone Number",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please Re-Enter Phone number";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: TextFormField(
                          // inputFormatters: [LengthLimitingTextInputFormatter(10)],
                          controller: emailController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "Email Address",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please Re-Enter your Name";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),

                      //Gender Drop-Down
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: DropdownButtonFormField(
                          value: dropdownValue,
                          icon: Icon(Icons.wc),
                          decoration: InputDecoration(
                            labelText: "Select Your Gender",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          items: genderList.map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue = newValue;
                            });
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Select a Gender';
                            }
                            return null;
                          },
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: FloatingActionButton.extended(
                          icon: const Icon(
                            Icons.touch_app,
                            color: Colors.white30,
                          ),
                          label: Text('Sign Up!'),
                          onPressed: () {
                            //Keyboard collapse
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState.validate()) {
                              print(nameController.text);
                              print(emailController.text);
                              print(phoneNumController.text);
                              var rand = new Random();
                              int min = 0;
                              int max = 3;

                              int r = min + rand.nextInt(max - min);
                              // ailesList_2

                              dbReference
                                  .child('User')
                                  .child(phoneNumController.text)
                                  .set({
                                "Name": nameController.text,
                                "Email": emailController.text,
                                "Gender": dropdownValue,
                                "preferenceList": ailesList[r]
                              }).then((_) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Successfully Created'),
                                ));
                                Navigator.pushNamed(context, './userLoggedIn');
                              }).catchError((onError) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(onError),
                                ));
                              });
                            }
                            //Fetch the entry and validate it
                            // var entry = dbReference
                            //     .orderByKey()
                            //     .equalTo(phoneNumController.text)
                            //     .once();
                            // print(phoneNumController.text);
                            // entry.then((DataSnapshot data) =>
                            //     (resultant = data.value));
                            // if (resultant != null) {
                            //   Navigator.pushNamed(context, '/chatbot',
                            //       arguments: entry);
                            // } else {
                            //   Scaffold.of(context).showSnackBar(SnackBar(
                            //       content: Text("Please, Register the user")));
                            // }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                            child: Text(
                              "Reset",
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                            onPressed: () {
                              nameController.clear();
                              emailController.clear();
                              phoneNumController.clear();
                              setState(() {
                                dropdownValue = "Select";
                              });
                            }),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
