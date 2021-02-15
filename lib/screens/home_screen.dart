import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: height * 0.265,
            child: Container(
              width: width,
              height: height * 0.5,
              child: Stack(
                children: [
                  GradientBackground(),
                  Positioned(
                    top: height * 0.24,
                    child: WhiteLine(height: height * 0.0039, width: width),
                  ),
                  Positioned(
                    top: height * 0.28,
                    child: WhiteLine(height: height * 0.01, width: width),
                  ),
                  Positioned(
                    top: height * 0.32,
                    child: WhiteLine(height: height * 0.017, width: width),
                  ),
                  Positioned(
                    top: height * 0.36,
                    child: WhiteLine(height: height * 0.028, width: width),
                  ),
                  Positioned(
                    top: height * 0.4,
                    child: WhiteLine(height: height * 0.035, width: width),
                  ),
                  Positioned(
                    top: height * 0.5,
                    child: WhiteLine(height: height * 0.034, width: width),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.white,
                BlendMode.srcOut,
              ), // This one will create the magic
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      backgroundBlendMode: BlendMode.dstOut,
                    ), // This one will handle background + difference out
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: AnimatedContainer(
                      curve: Curves.ease,
                      duration: const Duration(milliseconds: 4000),
                      height: isExpanded ? width * 0.95 : width * 0.655,
                      width: isExpanded ? width * 0.95 : width * 0.655,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(width * 0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        // shape: CircleBorder(),

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
