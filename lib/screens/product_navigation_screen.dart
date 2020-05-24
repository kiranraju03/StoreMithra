import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cooridates_provider.dart';
import '../providers/cart_items_provider.dart';

import '../models/cart_product.dart';

Map getProductLocation(pathList, preferenceList) {
  List rankValues = [];
  print("Got the product navigation call");
  print(pathList);
  print(preferenceList);
  pathList.forEach((element) {
    List pathValues = element['path'];
    rankValues
        .add(pathValues.toSet().intersection(preferenceList.toSet()).length);
  });
  int max = 0;
  int index = 0;
  print("New rank");
  print(rankValues);
  for (int i = 0; i < rankValues.length; i++) {
    if (rankValues[i] > max) {
      max = rankValues[i];
      index = i;
    }
  }
  Map selectedPath = pathList[index];
  // pathDrawCoOrdinates = selectedPath['coordinates'];
  // itemsPlot = selectedPath['Item'];
  print("SELECTED PATH");
  print(selectedPath);
  return selectedPath;
}

class ProductNavigationScreen extends StatefulWidget {
  @override
  _ProductNavigationScreenState createState() =>
      _ProductNavigationScreenState();
}

class _ProductNavigationScreenState extends State<ProductNavigationScreen> {
  // Future<Map> getLocation;
  Map selectedPathMap = {};
  static List<DataRow> tableRowValues = [];
  List aisleCoods = [];
  List prefList = [];
  List pathFetch = [];
  // static Map selectedPathMap = {};
  List pathDrawCoOrdinates = [];
  List itemsPlotLocation = [];
  List textValues = [];

  static void generateTableView(
      List items, BuildContext context, CartItemsProvider cip) {
    List<MaterialColor> cr = [
      Colors.red,
      Colors.green,
      Colors.yellow,
      Colors.blue,
      Colors.yellow,
      Colors.deepOrange
    ];
    int counter = 0;
    List<DataRow> temp = [];
    //Create the data rows
    print("Creating rows");
    items.forEach((element) {
      print("Plait places");
      print(element['name']);
      print(element['rate'].toString());
      temp.add(DataRow(cells: [
        DataCell(Container(
            color: cr[counter],
            width: MediaQuery.of(context).size.width * 0.2,
            child: Text(element['name']))),
        DataCell(Container(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Text(element['rate'].toString()))),
        DataCell(
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            child: IconButton(
              tooltip: 'Cart',
              icon: const Icon(Icons.shopping_cart),
              //Don't block the main thread
              onPressed: () {
                CartProduct cartInstance = CartProduct(counter.toString(),
                    element['name'], "", 1, element['rate'], "");
                cip.addCartItems(cartInstance);
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text("Added to Cart!")));
                // cip.addCartItems(addProduct)
              },
            ),
          ),
        ),
      ]));
      counter += 1;
    });
    print(temp);
    tableRowValues = temp;
    // setState(() {
    //   tableRowValues = tableRowValues;
    // });
  }

  // Widget navigationLayout(CoOrdinatesProvider Cop) {
  //   return FutureBuilder(
  //     future: Future.wait([
  //       // Cop.coOrdinatesFetcherHelper(),
  //       Cop.preferenceFetcher(),
  //     ]),
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData) {
  //         return Center(
  //           child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: <Widget>[
  //                 SizedBox(
  //                   child: CircularProgressIndicator(),
  //                   width: 30,
  //                   height: 30,
  //                 ),
  //                 const Padding(
  //                   padding: EdgeInsets.only(top: 16),
  //                   child: Text('Plotting...'),
  //                 )
  //               ]),
  //         );
  //       }
  //       print("SNAPSHOT");
  //       print(snapshot.data[0]);
  //       // Cop.setSelectedMapValue(snapshot.data[0]);
  //       // selectedPathMap = snapshot.data;
  //       // Map spm = Cop.getSelectedMap();

  //       selectedPathMap = getProductLocation(pathFetch, snapshot.data[0]);

  //       pathDrawCoOrdinates = selectedPathMap['coordinates'];
  //       itemsPlotLocation = selectedPathMap['Item'];
  //       //Calling to fill the table
  //       generateTableView(itemsPlotLocation);
  //       // print(tableRowValues);

  //       return CustomPaint(
  //         size: Size.infinite,
  //         painter: MyPainter(
  //             aisleCoods, pathDrawCoOrdinates, itemsPlotLocation, textValues),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final coOrdinates =
        Provider.of<CoOrdinatesProvider>(context, listen: false);

    final cart_provider =
        Provider.of<CartItemsProvider>(context, listen: false);

    setState(() {
      aisleCoods = coOrdinates.aisleCoOrdinates;
      textValues = coOrdinates.layoutTextValues;
      // prefList = coOrdinates.preferenceList;
      pathFetch = coOrdinates.pathfetch;
    });
    aisleCoods = coOrdinates.aisleCoOrdinates;
    // coOrdinates.coOrdinatesFetcherHelper();
    print("Co Ordinates Navigation Page");
    print(aisleCoods);

    // _ProductNavigationScreenState.prefList = coOrdinates.preferenceList;
    // _ProductNavigationScreenState.pathFetch = coOrdinates.pathfetch;

    // print(prefList);
    // print(pathFetch);

    // selectedPathMap = getProductLocation(pathFetch, prefList);
    // getLocation = getProductLocation(pathFetch, prefList);

    // pathDrawCoOrdinates = selectedPathMap['coordinates'];
    // itemsPlotLocation = selectedPathMap['Item'];

    // itemsPlotLocation.forEach((element) {
    //   print("Plait places");
    //   print(element['name']);
    //   print(element['rate'].toString());
    //   tableRowValues.add(DataRow(cells: [
    //     DataCell(Text(element['name'])),
    //     DataCell(Text(element['rate'].toString())),
    //     DataCell(
    //       IconButton(
    //         tooltip: 'Cart',
    //         icon: const Icon(Icons.shopping_cart),
    //         //Don't block the main thread
    //         onPressed: () {},
    //       ),
    //     ),
    //   ]));
    // });

    return Scaffold(
      appBar: AppBar(title: Text("Navigation"), actions: <Widget>[
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
      body: FutureBuilder(
          future: Future.wait([coOrdinates.preferenceFetcher()]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        child: CircularProgressIndicator(),
                        width: 30,
                        height: 30,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Plotting...'),
                      )
                    ]),
              );
            } else {
              print("Preferences SET");
              selectedPathMap = getProductLocation(pathFetch, snapshot.data[0]);
              pathDrawCoOrdinates = selectedPathMap['coordinates'];
              itemsPlotLocation = selectedPathMap['Item'];
              //Calling to fill the table
              generateTableView(itemsPlotLocation, context, cart_provider);
              return SingleChildScrollView(
                child: Column(children: <Widget>[
                  SizedBox(
                      height: MediaQuery.of(context).size.width,
                      child: CustomPaint(
                        size: Size.infinite,
                        painter: MyPainter(aisleCoods, pathDrawCoOrdinates,
                            itemsPlotLocation, textValues),
                      )),
                  SizedBox(
                      height: (MediaQuery.of(context).size.height) -
                          (MediaQuery.of(context).size.width),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                            child: Text(
                              "Products On The Way",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 20.0, 0),
                            child: DataTable(
                              columns: [
                                DataColumn(label: Text("Item Name")),
                                DataColumn(label: Text("Item Cost")),
                                DataColumn(label: Text("Purchase"))
                              ],
                              rows: tableRowValues,

                              //
                            ),
                          ),
                        ],
                      ))
                ]),
              );
            }
          }),
    );
  }
}

class MyPainter extends CustomPainter {
  List _ailes = [];
  List _pathDrawer = [];
  List _itemsLocation = [];
  List _textValuesPlot = [];
  Paint _paint = Paint();

  MyPainter(List aisleCoods, List pathDrawCoOrdinate, List itemsPlotLocation,
      List textValuesPlot) {
    _ailes = [...aisleCoods];
    _pathDrawer = [...pathDrawCoOrdinate];
    _itemsLocation = [...itemsPlotLocation];
    _textValuesPlot = [...textValuesPlot];
    // _ProductNavigationScreenState.generateTableView(itemsPlotLocation);
  }

  @override
  void paint(Canvas canvas, Size size) {
    print(size.width);
    print(size.height);
    print("Inside Paint");
    print(_ailes);
    // textReady =
    textCreator(String givenText, Color textColor, Offset off, Canvas canvas,
        double maxW) {
      var tp = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: givenText,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
      );
      tp.layout(minWidth: 0, maxWidth: maxW);
      tp.paint(canvas, off);
    }

    List<List<Offset>> pointsPlot = [];

    //Layout Ailes
    //Color style of the Ailes
    _paint.color = Colors.black;
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = 3;
    //Aile co-ordinates
    _ailes.forEach((element) {
      var recty = Rect.fromLTWH(
          element[0] * size.width,
          element[1] * size.width,
          element[2] * size.width,
          element[3] * size.width);
      canvas.drawRect(recty, _paint);
    });

    //Path to the product
    var pathDraw = Path();

    pathDraw.moveTo(
        _pathDrawer[0][0] * size.width, _pathDrawer[0][1] * size.width);
    _pathDrawer.forEach((element) {
      print(element);
      pathDraw.lineTo(element[0] * size.width, element[1] * size.width);
    });
    //Colors of the path
    _paint.color = Colors.black;
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = 4;

    canvas.drawPath(pathDraw, _paint);

    //Points plotter
    List pointColors = [Colors.red, Colors.blue, Colors.green];
    _itemsLocation.forEach((element) {
      var locCoOD = element['location'];
      pointsPlot
          .add([Offset(locCoOD[0] * size.width, locCoOD[1] * size.width)]);
    });

    var pointMode = PointMode.points;
    _paint.strokeWidth = 10;
    _paint.strokeCap = StrokeCap.round;
    List<MaterialColor> cr = [
      Colors.red,
      Colors.green,
      Colors.yellow,
      Colors.blue,
      Colors.yellow,
      Colors.deepOrange
    ];

    for (var i = 0; i < pointsPlot.length; i++) {
      _paint.color = cr[i];
      canvas.drawPoints(pointMode, pointsPlot[i], _paint);
    }

    //Text Display
    // textCreator(String givenText, Color textColor, Offset off, Canvas canvas) {
    // double x = 450;
    // _itemsLocation.forEach((element) {
    //   x = x + 50;
    //   var showText = element['name'] + "  #"+ element['rate'].toString();
    //   textCreator(showText, Colors.black, Offset(10,x), canvas);
    // });

    _textValuesPlot.forEach((element) {
      textCreator(
          element['text'],
          Colors.grey,
          Offset((element['location'][0] * size.width) + (size.width / 100),
              element['location'][1] * size.width),
          canvas,
          double.parse(element['maxWidth']) * size.width);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
