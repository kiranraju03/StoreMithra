import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './homepage.dart';
import './welcomepage.dart';

//StateManagement : Providers
import './providers/product_provider.dart';
import './providers/cart_items_provider.dart';
import './providers/cooridates_provider.dart';

//Screens
import './screens/product_navigation_screen.dart';
import './screens/user_registration.dart';
import './screens/user_logged_in.dart';
import './screens/shopping_cart.dart';
import './screens/product_overview_screen.dart';
import './screens/product_details_screen.dart';
import './screens/thanks_screen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartItemsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CoOrdinatesProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'StoreMithra',
        theme: new ThemeData(
          primarySwatch: Colors.lightBlue,
        ),
        // debugShowCheckedModeBanner: false,
        // home: new HomePageDialogflow(),
        initialRoute: '/',
        routes: {
          '/': (context) => WelcomePage(),
          '/chatbot': (context) => HomePageDialogflow(),
          '/productOverview': (context) => ProductOverviewScreen(),
          '/productDetailPage': (context) => ProductDetailScreen(),
          '/navigateProduct': (context) => ProductNavigationScreen(),
          '/userRegistration': (context) => UserRegistration(),
          '/userLoggedIn': (context) => UserLoggedInScreen(),
          '/cartScreen': (context) => ShoppingCart(),
          '/thanks': (context) => Thanks(),
        },
      ),
    );
  }
}
