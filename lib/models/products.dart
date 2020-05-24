//To support the required keyword
// import 'package:flutter/foundation.dart';

class Product {
  String id;
  String title;
  String brandName;
  String description;
  double price;
  String imageURL;
  String secondImageURL;
  String avgRating;
  String totalReviews;
  List itemAttributes;
  bool isFavorite;

  // Product(this.id, this.title, this.brandName, this.description, this.price, this.imageURL, this.isFavorite);

  Product({Map body}) {
    id = body['itemId'];
    title = body['info']['modelNumber'];
    brandName = body['info']['brandName'];
    description = body['info']['productLabel'];
    price = body['storeSku']['pricing']['originalPrice'] * 70;
    imageURL = body['info']['imageUrl'];
    secondImageURL = body['info']['secondaryimageUrl'];
    avgRating = body['ratingsReviews']['averageRating'];
    totalReviews = body['ratingsReviews']['totalReviews'];
    itemAttributes = body['info']['topAttributes'];
    isFavorite = false;
  }
  
}
