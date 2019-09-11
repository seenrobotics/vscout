import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget(
      {this.fieldType,
      this.hintText,
      this.labelText,
      this.prefixIcon,
      this.validator});
  final String fieldType;
  final String hintText;
  final String labelText;
  final Icon prefixIcon;
  final FormFieldValidator validator;

  @override
  Widget build(BuildContext context) {
    bool obscureText;
    TextInputType keyboardType;

    if (fieldType == "password") {
      obscureText = true;
      keyboardType = TextInputType.text;
    } else if (fieldType == "email") {
      obscureText = false;
      keyboardType = TextInputType.emailAddress;
    } else if (fieldType == "number") {
      obscureText = false;
      keyboardType = TextInputType.number;
    } else {
      obscureText = false;
      keyboardType = TextInputType.text;
    }

    final contentPadding =
        EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0);

    TextStyle fieldStyle = TextStyle(fontSize: 18.0);

    TextStyle labelStyle = TextStyle(
        fontFamily: 'Proxima Nova', fontSize: 16.0, color: Colors.grey);

    final textField =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      SizedBox(height: 48.0),
      Text(
        labelText,
        style: labelStyle,
        textAlign: TextAlign.left,
      ),
      TextFormField(
          obscureText: obscureText,
          style: fieldStyle,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            contentPadding: contentPadding,
            hintText: hintText,
            prefixIcon: prefixIcon,
          ))
    ]);

    return Container(child: textField);
  }
}
