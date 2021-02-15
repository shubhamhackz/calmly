import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final bool isCircle;
  const GradientBackground({
    Key key,
    this.isCircle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.all(10),
      decoration: ShapeDecoration(
        shape: isCircle ? CircleBorder() : RoundedRectangleBorder(),
        gradient: LinearGradient(
          transform: GradientRotation(1.5),
          // stops: [0.1, 0.3, 0.5, 0.6, 0.7, 0.8, 0.9, 0.95, 1.0],
          colors: <Color>[
            const Color(0xFFFEF800),
            const Color(0xFFFCE800),
            const Color(0xFFFFD100),
            const Color(0xFFFFA800),
            const Color(0xFFFF7B2A),
            const Color(0xFFFF5F43),
            const Color(0xFFFF3F58),
            const Color(0xFFFD007A),
            const Color(0xFFFB0086),
            const Color(0xFFFB0085),
          ],
        ),
      ),
    );
  }
}
