import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_timeline/admin/DocumentManager/core/services/authenticationService.dart';
import 'package:project_timeline/admin/DocumentManager/wrapper.dart';
import 'package:project_timeline/admin/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

String workerType = "Worker";
String managerType = "Manager";
String supervisorType = "Supervisor";
String userType = "";
showToast(String msg) {
  return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
      fontSize: 18.0);
}


 Future<bool> _onBackPressed(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () async{
              await AuthenticationService().signoutEmailId();
              SharedPreferences _sharedpreferences =
              await SharedPreferences.getInstance();
              _sharedpreferences.clear();
              Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation,
                  Animation secondaryAnimation) {
                return MyApp();
              }, transitionsBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation, Widget child) {
                return new SlideTransition(
                  position: new Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              }),
              (Route route) => false);
            },
            child: Text("YES"),
          ),
        ],
      ),
    ) ??
        false;
  }

Widget ThemeAppbar(String title, BuildContext context) {
  return new AppBar(
    actions: <Widget>[

      IconButton(
          icon: Icon(Icons.home),
          onPressed: () async {
          Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation,
                  Animation secondaryAnimation) {
                return MyApp();
              }, transitionsBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation, Widget child) {
                return new SlideTransition(
                  position: new Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              }),
              (Route route) => false);
        }),

      IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () async {
             _onBackPressed(context);
          })
    ],
    iconTheme: IconThemeData(
      color: Color(0xff005c9d),
    ),
    title: Text(title,
        style: TextStyle(
          color: Color(0xff005c9d),
        )),
    backgroundColor: Colors.white,
  );
}

gradients() {
  return LinearGradient(
      colors: [Color(0xff005c9d), Color(0xff018abd), Color(0xff93e1ed)],
      begin: Alignment.centerRight,
      end: Alignment(-1.0, -2.0));
}

cards() {
  return LinearGradient(
      colors: [Colors.white, Colors.white, Colors.white],
      begin: Alignment.centerRight,
      end: Alignment(-1.0, -2.0));
}

Widget floats(context, files) {
  return FloatingActionButton(
    backgroundColor: Color(0xff005f89),
    onPressed: () {
      showDialog(
        context: context,
        builder: (_) => files,
      );
    },
    child: Container(child: Icon(Icons.add)),
  );
}

titleStyles(String text, double size) {
  return Text(text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: size,
        color: Colors.blue[900],
        fontStyle: FontStyle.italic,
      ));
}

Widget buttonContainers(
    double width, double padding, String text, double size) {
  return Container(
    width: width,
    padding: EdgeInsets.all(padding),
    decoration: new BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Color(0xff018abd),
    ),
    child: Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic,
          fontSize: size,
          color: Colors.white),
      textAlign: TextAlign.center,
    ),
  );
}
