import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
//For HTTP request/response
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
// import '../providers/cart_items_provider.dart';
import '../widgets/product_item_card.dart';
// import 'package:voicetext/models/products.dart';
import '../providers/product_provider.dart';

import '../models/products.dart';

Future<List<Product>> _fetchProducts(searchQuery) async {
  //Fetching the Products
  String requestHeader =
      'https://api.homedepot.com/SearchNav/v2/pages/search?keyword=';
  String requestTail =
      '&key= E0HyOA0cUMawX7HbYEHBAx9SeI1J8cPk&consumergroup=store&storeId=0121&type=json';
  String requestString = requestHeader + searchQuery + requestTail;
  final response = await http.get(requestString);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var prodJsonList = jsonDecode(response.body)['skus'];
    List<Product> productsEndList = [];

    productsEndList = [
      ...prodJsonList.map((eachProductDict) {
        return Product(body: eachProductDict);
      }).toList(),
    ];
    // print(productsEndList);
    // print(prodJsonList);
    return productsEndList;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Products');
  }
}

// class ProductOverviewScreen extends StatefulWidget {
//   ProductOverviewScreen({Key key}) : super(key: key);

//   @override
//   _ProductOverviewScreenState createState() =>
//       new _ProductOverviewScreenState();
// }

// class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
class ProductOverviewScreen extends StatelessWidget {
  Future<List<Product>> futureProductList;

  // @override
  // void initState() {
  //   super.initState();
  //   // future that allows us to access context. function is called inside the future
  //   // otherwise it would be skipped and args would return null
  //   Future.delayed(Duration.zero, () async {
  //     setState(() {
  //       args = ModalRoute.of(context).settings.arguments;
  //     });
  //     futureProduct = _fetchProducts(args);
  //   });
  // }

  Widget centerTextDisplay(displayElement) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: displayElement,
      ),
    );
  }

  Widget productCard() {
    return FutureBuilder<List<Product>>(
        future: futureProductList,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            // return: show loading widget
            // return CircularProgressIndicator();

            return centerTextDisplay(<Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 30,
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Searching...'),
              )
            ]);
          }
          if (snapshot.hasError) {
            // return: show error widget
            // return Text("${snapshot.error}");

            return centerTextDisplay(<Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ]);
          }
          final model = Provider.of<ProductProvider>(context);
          model.setitems(snapshot.data);
          return GridView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: snapshot.data.length,
            itemBuilder: (ctx, i) {
              Product prodDisplay = snapshot.data[i];
              return new ProductItemCard(
                  prodDisplay.id,
                  prodDisplay.title,
                  prodDisplay.imageURL,
                  prodDisplay.brandName,
                  prodDisplay.price,
                  prodDisplay.isFavorite);
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              //width / height
              childAspectRatio: 3 / 4,
              crossAxisSpacing: 5,
              mainAxisSpacing: 1,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments;
    futureProductList = _fetchProducts(args);

    return new Scaffold(
      appBar: new AppBar(title: new Text("Search Result"), actions: <Widget>[
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
      body: productCard(),
    );
  }
}
