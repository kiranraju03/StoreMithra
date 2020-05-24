import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_product.dart';

import '../providers/cart_items_provider.dart';

class ShoppingCart extends StatelessWidget {
  Widget cartProductCard(CartProduct cartProd, CartItemsProvider cartProvide,
      BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        padding: EdgeInsets.all(10),
        width: 200,
        height: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              child: Image.network(
                cartProd.imageURL,
                fit: BoxFit.contain,
              ),
              // onTap: Navigator.pushNamed(ctx, '/productDetailPage', arguments: cartProd.id),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  cartProd.brandName,
                  // textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                    height: MediaQuery.of(context).size.width * 0.2,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text(cartProd.title)),
                Center(
                  child: Text(
                    "\₹" + cartProd.price.toString(),
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {},
                    ),
                    Text(
                      cartProd.quantity.toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {},
                    ),
                  ],
                ),
                IconButton(
                  tooltip: 'Remove from Cart',
                  color: Colors.redAccent,
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    cartProvide.removeCartItem(cartProd.id);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget bottomNavigation(String priceDisplay, BuildContext context) {
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
                child: Text(
                  "\₹" + priceDisplay,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/thanks');
              },
              color: Colors.blue,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Checkout",
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(
                      Icons.chevron_right,
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
    final cartProviderInstance =
        Provider.of<CartItemsProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Cart",
          textAlign: TextAlign.center,
        ),
      ),
      body: cartProviderInstance.cartItems.isEmpty
          ? Center(
              child: Text(
                "Cart is Empty!",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.all(10),
              itemCount: cartProviderInstance.cartItems.length,
              itemBuilder: (BuildContext context, int index) {
                return cartProductCard(cartProviderInstance.cartItems[index],
                    cartProviderInstance, context);
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
      bottomNavigationBar:
          bottomNavigation(cartProviderInstance.price.toString(), context),
    );
  }
}
