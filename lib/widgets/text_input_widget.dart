import 'package:flutter/material.dart';

class TextInputWidget extends StatelessWidget {

  final TextInputType editorType;
  final String textInputDescription;
  final TextEditingController editorController;

  TextInputWidget(this.editorType, this.textInputDescription, this.editorController);

  @override
  Widget build(BuildContext context) {
    var reEnterText = "Please Re-Enter "+ textInputDescription;
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: TextFormField(
        // inputFormatters: [LengthLimitingTextInputFormatter(10)],
        controller: TextEditingController(),
        keyboardType: editorType,
        decoration: InputDecoration(
          labelText: textInputDescription,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return reEnterText;
          } else {
            return null;
          }
        },
      ),
    );
  }
}
