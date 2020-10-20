import 'package:AOL_localfeedback/main.dart';
import 'package:flutter/material.dart';
import 'package:AOL_localfeedback/ApiRazorPay.dart';

Drawer myDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Column(
            children: [
              Text(
                'WELCOME',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'dummy@gmail.com',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [const Color(0xFFFF8F00), const Color(0xFFFFc107)],
            ),
          ),
        ),
        ListTile(
            title: Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(
                            title: "Home Page",
                          )));
            }),
        ListTile(
          title: Text('Login'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
            title: Text('Project'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ApiRazorPay()));
            }),
        ListTile(
          title: Text('Donation'),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ApiRazorPay()));
          },
        ),
      ],
    ),
  );
}
