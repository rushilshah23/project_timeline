import 'package:flutter/material.dart';
import 'package:project_timeline/languages/setLanguageText.dart';

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
                Align(
                    alignment: FractionalOffset.bottomLeft,
                    child: Container(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          homePageTranslationText[10],
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: corouseltextColor),
                        )))
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
                Align(
                    alignment: FractionalOffset.bottomLeft,
                    child: Container(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          homePageTranslationText[11],
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: corouseltextColor),
                        )))
              ],
            );
          })
        ],
      ),
    );
  }
}
