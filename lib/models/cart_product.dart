//To support the required keyword
// import 'package:flutter/foundation.dart';

class CartProduct {
  String id;
  String title;
  String brandName;
  int quantity;
  double price;
  String imageURL;

  CartProduct(this.id, this.title, this.brandName, this.quantity, this.price,
      this.imageURL);

  // CartProduct() {
  //   id = body['itemId'];
  //   title = body['info']['modelNumber'];
  //   brandName = body['info']['brandName'];
  //   description = body['info']['productLabel'];
  //   price = body['storeSku']['pricing']['originalPrice'];
  //   imageURL = body['info']['imageUrl'];
  //   isFavorite = false;
  // }

}
