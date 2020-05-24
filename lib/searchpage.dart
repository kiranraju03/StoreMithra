// import 'package:flutter/material.dart';


// // https://api.homedepot.com/SearchNav/v2/pages/search?keyword=french door refrigerator 26.2 cu.ft&key= E0HyOA0cUMawX7HbYEHBAx9SeI1J8cPk&consumergroup=store&storeId=0121&type=json

// Future<Product> fetchAlbum() async {
//   final response =
//       await http.get('https://jsonplaceholder.typicode.com/albums/1');

//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     return Album.fromJson(json.decode(response.body));
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load album');
//   }
// }








// class SearchPage extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     final String searchPattern = ModalRoute.of(context).settings.arguments;
//     print("SearchPGAEESHOUEWN");
//     print(searchPattern);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('SearchPage'),
//       ),
//       body: Center(
//         child: Text(searchPattern),
//       ),
//     );


//   }
// }
