import 'package:flutter/material.dart';

import '../models/cart_product.dart';

class CartItemsProvider with ChangeNotifier {
  List<CartProduct> _cartItems = [];
  int cartQuantity = 0;
  double price = 0.0;
  // double totalPrice = 0.0;

  List<CartProduct> get cartItems {
    return [..._cartItems];
  }

  void addCartItems(CartProduct addProduct) {
    print("Adding the cart Item");
    _cartItems.add(addProduct);
    cartQuantity += addProduct.quantity;
    print(cartQuantity);
    updatePriceValue(addProduct.price, addProduct.quantity);
  }

  void updatePriceValue(double addPrice, int quant) {
    price += addPrice * quant;
    if (price < 0.0) {
      price = 0.0;
    }
    print(price);
    notifyListeners();
  }

  //When using trash can
  void removeCartItem(String prodId) {
    var priceRef = _cartItems.firstWhere((element) => prodId == element.id);
    var removeFromSum = priceRef.price;
    var quantityRm = priceRef.quantity;
    _cartItems.removeWhere((element) => prodId == element.id);
    cartQuantity -= quantityRm;
    updatePriceValue(removeFromSum, -1);
    notifyListeners();
  }

  bool checkItemInCart(String prodId){
    
  }

  // void priceUpdatorPostDelete(String prodId) {
  //   _cartItems.map((CartProduct eachItem) {
  //     print(eachItem.price.toString());
  //     totalPrice += eachItem.price;
  //     print(totalPrice);

  //   });
  // }
}
