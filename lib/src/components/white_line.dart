import 'package:flutter/material.dart';

class WhiteLine extends StatelessWidget {
  const WhiteLine({
    Key key,
    @required this.height,
    @required this.width,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: height,
      width: width,
    );
  }
}
