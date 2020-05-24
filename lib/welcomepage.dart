import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/product_provider.dart';

// import './formdatahandler.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  //Initializing the DB
  static FirebaseDatabase firebaseInst = FirebaseDatabase.instance;
  var dbReference = firebaseInst.reference().child("User");
  final phoneNumController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //Creating a reference to the database
    // var dbReference = firebaseInst.reference().child("User");
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      // appBar: AppBar(
      //     title: Text(
      //   'Welcome to StoreMithra!',
      //   style: TextStyle(fontFamily: 'Samarkan'),
      // )),
      body: Builder(
        builder: (context) => Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Place StoreMithra Icon
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Store",
                      style: TextStyle(fontSize: 30),
                    ),
                    Text(
                      "Mithra",
                      style: TextStyle(fontSize: 30, fontFamily: 'Samarkan'),
                    ),
                  ],
                ),
              ),

              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
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
                        child: FloatingActionButton.extended(
                          icon: const Icon(Icons.fingerprint),
                          label: Text('Login'),
                          onPressed: () async {
                            //Keyboard collapse
                            FocusScope.of(context).unfocus();
                            //Fetch the entry and validate it
                            // dbReference.getValue()
                            // var eq = dbReference.equalTo(phoneNumController.text);
                            // print(eq.toString());
                            var entry = await dbReference
                                .orderByKey()
                                .equalTo(phoneNumController.text)
                                .once();
                            print(phoneNumController.text);
                            print(entry.value);
                            if (entry.value != null) {
                              var providerInstance =
                                  Provider.of<ProductProvider>(context,
                                      listen: false);
                              providerInstance
                                  .setPhoneNumber(phoneNumController.text);
                              Navigator.pushNamed(context, '/userLoggedIn',
                                  arguments: entry
                                      .value[phoneNumController.text] as Map);
                            } else {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                "Please, Register the user",
                                textAlign: TextAlign.center,
                              )));
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                          child: Text(
                            "Create new User",
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                          onPressed: () =>
                              Navigator.pushNamed(context, '/userRegistration'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
