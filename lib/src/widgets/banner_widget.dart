import 'package:flutter/material.dart';
import './vscout_logo_widget.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({this.extraPadding});
  // Compensate for top padding of element below by subtracting extraPadding.
  final double extraPadding;

  @override
  Widget build(BuildContext context) {
    final double logoSize = 48.0;
    final double textSize = 14.0;
    final banner = FittedBox(
        child: Center(
            child: Container(
                child: Column(children: <Widget>[
      SizedBox(
          height: (MediaQuery.of(context).size.height * 0.20) -
              (logoSize / 2 + textSize / 2)),
      Text("vscout"),
      VscoutLogoWidget(size: 48.0, color: Theme.of(context).primaryColor),
      SizedBox(
          height: (MediaQuery.of(context).size.height * 0.20) -
              (logoSize / 2 + textSize / 2 + extraPadding)),
    ]))));
    return Container(child: banner);
  }
}
