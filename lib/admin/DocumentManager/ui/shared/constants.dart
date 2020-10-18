import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

const Color appColor = Color(0xFF02DEED);

const BoxDecoration colorBox = BoxDecoration(color: Color(0xFF02DEED));

Color appBarColor = HexColor("#e2f3fb");
Color backgroundColor = HexColor("#e2f3fb");
Color cardColor = HexColor("#93e1ed");

bool isLoading = false;

enum documentType { folder, file }
