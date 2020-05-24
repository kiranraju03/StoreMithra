import 'package:flutter/material.dart';
// import 'package:voicetext/models/products.dart';
import '../models/products.dart';

class ProductProvider with ChangeNotifier{
  List<Product> _items = [];
  // bool _favValue = false;
  String _userphoneNumber = '';

  String applianceType = '';

  String getApplicanceType(){
    return applianceType;
  }

  void setApplianceType(String applianceName){
    print(applianceName);
    applianceType = applianceName;
  }

  // set setItems(List<Product> itemsList){
  //   _items = itemsList;
  // }
  String get phoneNumber{
    return _userphoneNumber;
  }

  void setPhoneNumber(String phoneText){
    _userphoneNumber = phoneText;
  }

  //Getter as the list is private and sending a copy, not a reference to
  List<Product> get items{
    return [..._items];
  }

  // bool get favValue{
  //   return _favValue;
  // }

  void setitems(List<Product> productsEndList) {
    _items = productsEndList;
    // notifyListeners();
  }

  void setfavvalue(String prodId){
    Product matchedOne = getParticular(prodId);
    matchedOne.isFavorite = !matchedOne.isFavorite;
    print(matchedOne.isFavorite);
    notifyListeners();
    // if(favValue){
    //   print("VAlue is true");
    // }
    // else{
    //   print("Value is false");
    // }
  }

  Product getParticular(String prodId){
    
    Product matchedIdProd = _items.firstWhere((element) => prodId == element.id);
    // print(matchedIdProd.title);
    // notifyListeners();
    return matchedIdProd;
  }
}