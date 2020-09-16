import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'manager/master/petrolMaster/AddPetrolLocation.dart';

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

gradients()
{
  return LinearGradient(
        colors: [ Colors.orange[200],Colors.orange[400],Colors.orange[600],Colors.orange[800],Colors.deepOrange[600]],
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
    backgroundColor: Colors.orange,
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

titlestyles(double size, Color colorss)
{
  return TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: size,
    color: colorss
  );
}

Widget buttons(context, files, String text){
  return FlatButton(
    child: Container(
      height: 50,
      width: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: gradients()
      ),
        child: Center(
            child: Text(text,style: titlestyles(15, Colors.white))
        )
    ),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => files),
      );
    },
  );
}