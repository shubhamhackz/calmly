import 'package:flutter/material.dart';

class SettingsBottomSheet extends StatefulWidget {
  const SettingsBottomSheet({
    Key key,
  }) : super(key: key);

  @override
  _SettingsBottomSheetState createState() => _SettingsBottomSheetState();
}

class _SettingsBottomSheetState extends State<SettingsBottomSheet> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: height * 0.025, horizontal: width * 0.05),
      width: width,
      height: height * 0.3,
      child: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Rock the 80s theme'),
                Switch(
                  value: false,
                  onChanged: (value) {},
                ),
              ],
            ),
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Container(
                          height: height * 0.3,
                          child: Column(
                            children: [
                              Text('Select Theme'),
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Theme'),
                  Text('Light'),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Vibration'),
                Switch(
                  value: false,
                  onChanged: (value) {},
                ),
              ],
            ),
            Text('About'),
          ],
        ),
      ),
    );
  }
}

enum Theme { system, dark, light }
