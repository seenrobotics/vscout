import 'package:flutter/material.dart';
import '../widgets/vscout_logo_widget.dart';

class VscoutView extends StatefulWidget {
  @override
  VscoutViewState createState() {
    return VscoutViewState();
  }
}

class VscoutViewState extends State<VscoutView> {
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => true, //false
        child: Scaffold(
            appBar: AppBar(
              title: VscoutLogoWidget(color: Colors.white, size: 24.0),
              leading: null,
              automaticallyImplyLeading: false,
              centerTitle: true,
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
                child: SafeArea(
                    child: Column(children: <Widget>[
              TextField(),
            ])))));
  }
}
