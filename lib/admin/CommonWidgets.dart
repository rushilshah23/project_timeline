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
      color: Colors.indigo[300],
    ),
    title:  Text(title, style: TextStyle(
      color: Colors.blue[700],
    )),
    backgroundColor: Colors.white,
  );
}

gradients()
{
  return LinearGradient(
      colors: [ Color(0xff005c9d),Color(0xff018abd),Color(0xff93e1ed)],
      begin: Alignment.centerRight,
      end: Alignment(-1.0,-2.0)
  );
}

cards()
{
  return LinearGradient(
      colors: [ Colors.white,Colors.white,Colors.white],
      begin: Alignment.centerRight,
      end: Alignment(-1.0,-2.0)
  );
}

Widget floats(context, files)
{
  return FloatingActionButton(
    backgroundColor: Colors.blue[900],
    onPressed: () {
      showDialog(
        context: context,
        builder: (_) => files,
      );
    },
    child: Container(
        child: Icon(Icons.add)),
  );
}

titleStyles(String text, double size)
{
  return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: size,
        color: Colors.blue[900],
        fontStyle: FontStyle.italic,
      )
  );
}


Widget buttonContainers(double width,double padding,String text,double size){
  return Container(
    width: width,
    padding: EdgeInsets.all(padding),
    decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: gradients()
    ),
    child: Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic,
          fontSize: size,
          color: Colors.white
      ),
      textAlign: TextAlign.center,
    ),
  );
}