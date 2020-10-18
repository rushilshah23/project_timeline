import 'package:flutter/material.dart';

import '../../UI/ColorTheme/Theme.dart';
import '../../constants.dart';

class Item1 extends StatelessWidget {
  const Item1({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Overlay(
        initialEntries: [
          OverlayEntry(builder: (BuildContext context) {
            return Stack(
              children: [
                Container(
                  decoration: carousel1,
                ),
                Center(
                    child: Text(
                  'Hello',
                  style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: corouseltextColor),
                ))
              ],
            );
          })
        ],
      ),
    );
  }
}

class Item2 extends StatelessWidget {
  const Item2({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Overlay(
        initialEntries: [
          OverlayEntry(builder: (BuildContext context) {
            return Stack(
              children: [
                Container(
                  decoration: carousel2,
                ),
                Center(
                    child: Text(
                  'Welcome ',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: corouseltextColor),
                ))
              ],
            );
          })
        ],
      ),
    );
  }
}
