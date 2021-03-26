import 'package:flutter/material.dart';

class DividerLine extends StatelessWidget {
  const DividerLine({
    Key key,
    @required this.height,
    @required this.width,
    this.isDark,
  }) : super(key: key);

  final double height;
  final double width;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark ? const Color(0xFF000000) : const Color(0xFFFFFFFF),
      height: height,
      width: width,
    );
  }
}
