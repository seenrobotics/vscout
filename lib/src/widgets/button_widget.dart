import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({this.buttonText, this.onPressed});
  final String buttonText;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    TextStyle buttonStyle = TextStyle(fontSize: 20.0);

    final button = Column(children: <Widget>[
      SizedBox(height: 72.0),
      SizedBox(
          width: double.infinity,
          child: RaisedButton(
            elevation: 0.0,
            focusElevation: 0.0,
            hoverElevation: 0.0,
            highlightElevation: 0.0,
            disabledElevation: 0.0,
            onPressed: onPressed,
            child: Text(buttonText, style: buttonStyle),
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
          ))
    ]);
    return Container(child: button);
  }
}
