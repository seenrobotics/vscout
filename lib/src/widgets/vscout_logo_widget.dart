import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VscoutLogoWidget extends StatelessWidget {
  const VscoutLogoWidget({this.color, this.size});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final Widget vscoutLogo = SvgPicture.asset(
      'assets/vscout.svg',
      color: color,
      height: size,
      semanticsLabel: 'vscout logo',
    );
    return Container(child: vscoutLogo);
  }
}
