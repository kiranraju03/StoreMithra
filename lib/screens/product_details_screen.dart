import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_items_provider.dart';
import '../models/cart_product.dart';
import '../providers/product_provider.dart';
import '../providers/cooridates_provider.dart';

// import '../screens/shopping_cart.dart';

import '../models/products.dart';

// Future<DataSnapshot> _getPreferenceList(String phoneNumber) {
//   FirebaseDatabase firebaseInst = FirebaseDatabase.instance;
//   Future<DataSnapshot> userPreferenceListReference = firebaseInst
//       .reference()
//       .child("User")
//       .child(phoneNumber)
//       .child('preferenceList')
//       .once();
//   print(userPreferenceListReference);
//   return userPreferenceListReference;
// }

class ProductDetailScreen extends StatelessWidget {
  Future<DataSnapshot> getPrefered;

  Widget buttomNavigator(id, title, brandName, quant, price, processedImageUrl, cartProviderInstance, context) {
    // return FutureBuilder<DataSnapshot>(
    //     future: getPrefered,
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState != ConnectionState.done) {
    //         return Column(children: <Widget>[
    //           SizedBox(
    //             child: CircularProgressIndicator(),
    //             width: 30,
    //             height: 30,
    //           ),
    //           const Padding(
    //             padding: EdgeInsets.only(top: 16),
    //             child: Text('Searching...'),
    //           )
    //         ]);
    //       }
    //       print("GOIT DATA");
    //       print(snapshot.data);
    //       cOp.preferenceList = snapshot.data as List;
    return Container(
      width: double.infinity,
      height: 50.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: RaisedButton(
              onPressed: () {},
              color: Colors.grey,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    Text(
                      "  Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: RaisedButton(
              onPressed: () {
                
                CartProduct cartInstance = CartProduct(
                    id, title, brandName, quant, price, processedImageUrl);
                cartProviderInstance.addCartItems(cartInstance);
                // Scaffold.of(context)
                //     .showSnackBar(SnackBar(content: Text("Added to Cart!")));
              },
              color: Colors.blue,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      "Add to Cart",
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(
                      Icons.shopping_basket,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String itemDesc = ModalRoute.of(context).settings.arguments;

    final coOrdinates =
        Provider.of<CoOrdinatesProvider>(context, listen: false);
    // aisleCoods = coOrdinates.aisleCoOrdinates;
    coOrdinates.coOrdinatesFetcherHelper();

    final model = Provider.of<ProductProvider>(context, listen: false);
    Product prodMatchedDetails = model.getParticular(itemDesc);
    // print(prodMatchedDetails.id);
    // print("ApplianceType" + model.getApplicanceType());
    coOrdinates.applianceType = model.getApplicanceType().toLowerCase();
    // print(model.phoneNumber);

    final cartProviderInstance =
        Provider.of<CartItemsProvider>(context, listen: false);

    // FirebaseDatabase firebaseInst = FirebaseDatabase.instance;
    // Future<DataSnapshot> userPreferenceListReference = firebaseInst
    //     .reference()
    //     .child("User")
    //     .child(model.phoneNumber).child("preferenceList").once();
    // print("UserPrefers");
    // print(userPreferenceListReference.value);
    // getPrefered = _getPreferenceList(model.phoneNumber);

    coOrdinates.userPhoneNumber = model.phoneNumber;

    var processedImageUrl =
        prodMatchedDetails.imageURL.replaceAll(RegExp(r'<SIZE>'), '400');

    //Creating rows for product description
    //  DataRow(cells: [
    //                 DataCell(Text("Model Number")),
    //                 DataCell(Text(prodMatchedDetails.title)),
    //               ])
    List attributesList = prodMatchedDetails.itemAttributes;
    List<DataRow> tableRowValues = [];

    

    // attributesList.forEach((element) {
    //   tableRowValues.add(DataRow(cells: [
    //     DataCell(Text(element['name'])),
    //     DataCell(Text(element['attributeValues'][0]['attributeValue']))
    //   ]));
    // });

    for (var eachItem in attributesList) {
      var sv;
      var temp = eachItem['name'];
      // print(eachItem);
      // var processEachItem = jsonDecode(eachItem);
      // print(eachItem['name']);
      List attr = eachItem['attributeValues'];
      if (attr != null) {
        sv = attr[0];
        temp = sv['attributeValue'];
      }
      // print(sv['attributeValue']);
      tableRowValues.add(DataRow(
          cells: [DataCell(Text(eachItem['name'])), DataCell(Text(temp))]));
    }

    // attributesList.map((eachAttribute) {
    //   print(eachAttribute);
    //   tableRowValues.add(
    //   DataRow(cells: [
    //     DataCell(eachAttribute['name']),
    //     DataCell(eachAttribute['attributeValues']['attributeValue'])
    // ]));
    // });

    // print("attrri");
    // print(tableRowValues);
    // print(attributesList);

    return new Scaffold(
        appBar: AppBar(title: Text("Product Description"), actions: <Widget>[
          //Adding the search widget in AppBar
          IconButton(
            tooltip: 'Cart',
            icon: const Icon(Icons.shopping_cart),
            //Don't block the main thread
            onPressed: () {
              Navigator.pushNamed(context, '/cartScreen');
            },
          ),
        ]),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      prodMatchedDetails.brandName,
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    //Rating
                    Text(prodMatchedDetails.avgRating),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  prodMatchedDetails.description,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Center(
                child: Image.network(
                  processedImageUrl,
                  width: 300,
                  height: 300,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Text(
                    "\₹" + (prodMatchedDetails.price).toString(),
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              //Product Details Table
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 0, 10),
                child: Text(
                  "Product Description",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
              ),
              DataTable(
                columns: [
                  DataColumn(label: Text("Prop")),
                  DataColumn(label: Text("Values"))
                ],
                rows: tableRowValues,
                // [
                //   DataRow(cells: [
                //     DataCell(Text("Model Number")),
                //     DataCell(Text(prodMatchedDetails.title)),
                //   ]),
                //   // ...attributesList,
                //   DataRow(cells: [
                //     DataCell(Text("Model Number")),
                //     DataCell(Text(prodMatchedDetails.title)),
                //   ]),
                //   DataRow(cells: [
                //     DataCell(Text("Model Number")),
                //     DataCell(Text(prodMatchedDetails.title)),
                //   ]),
                //   DataRow(cells: [
                //     DataCell(Text("Model Number")),
                //     DataCell(Text(prodMatchedDetails.title)),
                //   ])
                // ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: buttomNavigator(
            itemDesc,
            prodMatchedDetails.title,
            prodMatchedDetails.brandName,
            1,
            prodMatchedDetails.price,
            processedImageUrl,
            cartProviderInstance,
            context),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Navigate to Product',
          // color: Colors.black,
          child: Icon(Icons.navigation),
          onPressed: () {
            Navigator.pushNamed(context, '/navigateProduct');
          },
        )

        // FloatingActionButton.extended(
        //   icon: const Icon(Icons.navigation),
        //   label: Text('Take Me There!'),
        //   onPressed: () {
        //     Navigator.pushNamed(context, '/navigateProduct');
        //   },
        // ),
        );
  }
}
