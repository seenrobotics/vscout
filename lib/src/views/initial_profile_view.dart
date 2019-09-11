import 'package:flutter/material.dart';
import '../widgets/banner_widget.dart';
import '../widgets/validator_widget.dart';
import '../widgets/text_field_widget.dart';
import '../widgets/button_widget.dart';

class CreateProfileView extends StatefulWidget {
  @override
  CreateProfileViewState createState() {
    return CreateProfileViewState();
  }
}

class CreateProfileViewState extends State<CreateProfileView> {
  final _formKey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: SafeArea(
                child: Column(children: <Widget>[
          BannerWidget(
            extraPadding: 48.0,
          ),
          Form(
              key: _formKey,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 48.0),
                  child: Column(
                    children: <Widget>[
                      TextFieldWidget(
                        fieldType: "text",
                        hintText: "John Doe",
                        labelText: "Name",
                        prefixIcon: Icon(Icons.face),
                        validator: validate_string_length_name,
                      ),
                      TextFieldWidget(
                        fieldType: "text",
                        hintText: "2381C",
                        labelText: "Team",
                        prefixIcon: Icon(Icons.supervisor_account),
                        validator: validate_string_length_team,
                      ),
                      ButtonWidget(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false
                          // otherwise.
                          if (_formKey.currentState.validate()) {
                            Navigator.pushNamed(context, '/');
                          }
                        },
                        buttonText: "Let's go",
                      ),
                      SizedBox(height: 48.0),
                    ],
                  )))
        ]))));
  }
}
