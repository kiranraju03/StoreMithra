import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CoOrdinatesProvider with ChangeNotifier {
  FirebaseDatabase firebaseInst;
  DatabaseReference dbReferenceAiles;
  DatabaseReference userReference;
  List _aisleCoOrdinates = [];
  // List pathDrawCoOrdinates = [];
  String applianceType = '';
  List _preferenceList = [];
  String userPhoneNumber = '';
  List pathfetch = [];

  List layoutTextValues = [];

  Map _selectedPathMap = {};

  void setSelectedMapValue(Map mapSent) {
    _selectedPathMap = mapSent;
    // notifyListeners();
  }

  Map getSelectedMap() {
    return _selectedPathMap;
  }

  void setPreferenceList(List prefered) {
    _preferenceList = [...prefered];
  }

  List get preferenceList {
    return [..._preferenceList];
  }

  //Initializing the co-ordinates Layout
  List get aisleCoOrdinates {
    return [..._aisleCoOrdinates];
  }

  Future<List> preferenceFetcher() async {
    firebaseInst = FirebaseDatabase.instance;
    userReference = firebaseInst.reference().child("User");
    DataSnapshot userDetails =
        await userReference.child(userPhoneNumber).once();
    return userDetails.value['preferenceList'];
  }

  Future<bool> coOrdinatesFetcherHelper() async {
    firebaseInst = FirebaseDatabase.instance;

    // userReference = firebaseInst.reference().child("User");
    dbReferenceAiles = firebaseInst.reference().child("layout");

    // DataSnapshot userDetails =
    //     await userReference.child(userPhoneNumber).once();

    // Future.wait(futures)

    DataSnapshot as = await dbReferenceAiles.once();
    _aisleCoOrdinates = as.value['ailes'];
    //print("Co ordinate privder");
    //print(_aisleCoOrdinates);
    layoutTextValues = as.value['text'];

    //print("Appliance in CoOrdinates : " + applianceType);

    pathfetch = as.value['path'][applianceType];
    // print("Sleeping");
    // Future.wait([]);
    // await new Future.delayed(const Duration(seconds: 5));
    // print(userDetails.value['preferenceList']);
    // setPreferenceList(userDetails.value['preferenceList']);
    if ((pathfetch.isEmpty) &&
        (layoutTextValues.isEmpty) &&
        (_aisleCoOrdinates.isEmpty)) {
      return false;
    } else {
      return true;
    }
    // notifyListeners();
  }

  // static Future<DataSnapshot> ailesValues = dbReferenceAiles.once();

}
