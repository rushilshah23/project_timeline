import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_timeline/admin/DocumentManager/core/services/authenticationService.dart';
import 'package:project_timeline/admin/DocumentManager/wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

Widget ThemeAppbar(String title, BuildContext context) {
  return new AppBar(
    actions: <Widget>[
      IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () async {
            await AuthenticationService().signoutEmailId();
            SharedPreferences _sharedpreferences =
                await SharedPreferences.getInstance();
            _sharedpreferences.clear();
            return Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              showToast("Logout Successful");
              return Wrapper();
            }));
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
