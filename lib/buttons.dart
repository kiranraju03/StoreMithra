import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function refClickFunc;
  final String textRecieved;

  Button(this.refClickFunc, this.textRecieved);

  @override
  Widget build(BuildContext context) {
    return Container(
        // width: double.infinity,
        margin: EdgeInsets.all(2),
        child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.lightBlue)),
          color: Colors.blueGrey[50],
          // padding: EdgeInsets.all(10),
          onPressed: refClickFunc,
          child: Text(
            textRecieved,
            style: TextStyle(fontSize: 15,
            color: Colors.blueAccent),
          ),
        ));
  }
}
