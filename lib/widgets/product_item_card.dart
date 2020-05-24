import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_items_provider.dart';

import '../providers/product_provider.dart';
import '../models/cart_product.dart';

class ProductItemCard extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String title;
  final String brandName;
  final double price;
  final bool isFav;

  ProductItemCard(this.id, this.title, this.imageUrl, this.brandName,
      this.price, this.isFav);

  @override
  Widget build(BuildContext context) {
    var processedImageUrl = imageUrl.replaceAll(RegExp(r'<SIZE>'), '400');

    //For adding items into the cart and wishlist
    FirebaseDatabase firebaseInst = FirebaseDatabase.instance;

    // Color colorChanger = Colors.grey;

    // return Column(
    //   children: <Widget>[
    // Text(brandName, textAlign: TextAlign.justify),
    final providerInstance =
        Provider.of<ProductProvider>(context, listen: true);
    // print("ProviderValue");
    // print(providerInstance.phoneNumber);

    final cartProviderInstance =
        Provider.of<CartItemsProvider>(context, listen: true);

    var userEntryReference = firebaseInst
        .reference()
        .child("User")
        .child(providerInstance.phoneNumber);
    // if(providerInstance.favValue){
    //   colorChanger = Colors.red;
    // }
  
    return Stack(children: <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(brandName,
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/productDetailPage', arguments: id);
            },
            child: Image.network(processedImageUrl, fit: BoxFit.contain),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text("\₹" + price.toString(),
                style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
          ),
        ],
      ),
      //Favorite
      Positioned(
        top: 0,
        bottom: 5,
        child: IconButton(
          // iconSize: 15,
          tooltip: 'Favorite',
          // color: Colors.grey,
          color: isFav ? Colors.red : Colors.grey,
          icon: const Icon(Icons.favorite),
          //Don't block the main thread
          onPressed: () {
            providerInstance.setfavvalue(id);
            var wLValue = userEntryReference.child("WishList");
            print(id);

            wLValue.child(id).set({
              "brand": brandName,
              "image": processedImageUrl,
              "price": price,
              "modelName": title
            });
            // colorChanger = Colors.red;
          },
        ),
      ),
      //Cart
      Positioned(
        right: 0,
        top: 0,
        bottom: 5,
        child: IconButton(
          // iconSize: 15,
          tooltip: 'Add to Cart',
          color: Colors.black,
          icon: const Icon(Icons.add_shopping_cart),
          //Don't block the main thread
          onPressed: () {
            CartProduct cartInstance =
                CartProduct(id, title, brandName, 1, price, processedImageUrl);
            cartProviderInstance.addCartItems(cartInstance);
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text("Added to Cart!")));
          },
        ),
      ),
    ]);

    // return GridTile(
    //   header: Text(
    //     title,
    //     textAlign: TextAlign.left,
    //     style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
    //   ),
    //   child: GestureDetector(
    //     onTap: () {
    //       Navigator.pushNamed(context, '/productDetailPage',
    //           arguments: id);
    //     },
    //     child: Image.network(processedImageUrl, fit: BoxFit.cover),

    //   ),
    //   footer: GridTileBar(
    //     backgroundColor: Colors.black54,
    //     leading: IconButton(
    //       icon: Icon(Icons.favorite),
    //       onPressed: () {},
    //     ),
    //     title: Text(
    //       "\$" + price.toString(),
    //       // "Price",
    //       textAlign: TextAlign.center,
    //     ),
    //     trailing: IconButton(
    //       icon: Icon(Icons.shopping_cart),
    //       onPressed: () {},
    //     ),
    //   ),
    // );
  }
}
