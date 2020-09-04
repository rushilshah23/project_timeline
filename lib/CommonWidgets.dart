import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(String msg)
{
  return  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
      fontSize: 18.0
  );
}

Widget ThemeAppbar(String title)
{
  return new AppBar(
    iconTheme: IconThemeData(
      color: Colors.orange[800],
    ),
    title:  Text(title, style: TextStyle(
      color: Colors.orange[800],
    )),
    backgroundColor: Colors.white,
  );
}