import 'package:flutter/material.dart';

class User {
  String userName;
  String userEmail;

  User(Map<dynamic, dynamic> userData) {
    userName = userData['Name'];
    userEmail = userData['Email'];
  }
}

class UserLoggedInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map userDecoded = ModalRoute.of(context).settings.arguments;
    // var userDecoded = jsonDecode(userDetails);
    print(userDecoded);
    User user = User(userDecoded);
    return Scaffold(
      drawer: Container(
        width: 250,
        child: Drawer(
          child: ListView(children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(user.userName),
              accountEmail: Text(user.userEmail),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  user.userName[0],
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              title: Text("WishList"),
              onTap: () {
                // Update the state of the app.
                // ...
                // Then close the drawer.
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Cart"),
              onTap: () {
                // Update the state of the app.
                Navigator.pushNamed(context, '/cartScreen');
                // Then close the drawer.
                // Navigator.pop(context);
              },
            )
          ]),
        ),
      ),
      appBar: AppBar(
        title: Text(
          'StoreMithra',
          style: TextStyle(fontFamily: 'Samarkan'),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Cart',
            icon: const Icon(Icons.shopping_cart),
            //Don't block the main thread
            onPressed: () {
              Navigator.pushNamed(context, '/cartScreen');
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Namasthe ",
                style: TextStyle(fontSize: 30, fontFamily: 'Samarkan'),
              ),
              Text(
                user.userName,
                style: TextStyle(fontSize: 30, fontFamily: 'Samarkan'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.assistant),
        label: Text('Let\'s Chat!'),
        onPressed: () =>
            Navigator.pushNamed(context, '/chatbot', arguments: user.userName),
      ),
    );
  }
}
